import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/bento_card.dart';
import '../../shared/widgets/pro_gate.dart';
import '../../core/providers/feature_flags_provider.dart';
import 'ai_coach_provider.dart';

class AiCoachScreen extends ConsumerWidget {
  const AiCoachScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Feature flag verification constraint check
    final flagsAsync = ref.watch(featureFlagsProvider);

    return flagsAsync.when(
      loading: () => const Scaffold(
        backgroundColor: AppColorsDark.surface0,
        body: Center(child: CircularProgressIndicator(color: AppColorsDark.primary)),
      ),
      error: (_, __) => const Scaffold(
        backgroundColor: AppColorsDark.surface0,
        body: Center(child: Text('Error loading features', style: TextStyle(color: AppColorsDark.error))),
      ),
      data: (flags) {
        if (!flags.aiInsights) {
          return Scaffold(
            backgroundColor: AppColorsDark.surface0,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => context.pop(),
              ),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.auto_awesome_outlined, size: 64, color: AppColorsDark.textMuted),
                  const SizedBox(height: 16),
                  Text('AI Coach is Currently Disabled', style: AppTypography.h2()),
                  const SizedBox(height: 8),
                  Text('This capability is temporarily gated by system settings.', style: AppTypography.bodySm(color: AppColorsDark.textMuted)),
                ],
              ),
            ),
          );
        }

        // ProGate premium authorization layer constraint check
        return const ProGate(
          featureName: 'FitKarma AI Health Coach',
          child: _AiCoachChatView(),
        );
      },
    );
  }
}

class _AiCoachChatView extends ConsumerStatefulWidget {
  const _AiCoachChatView();

  @override
  ConsumerState<_AiCoachChatView> createState() => _AiCoachChatViewState();
}

class _AiCoachChatViewState extends ConsumerState<_AiCoachChatView> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSending = false;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _handleSend() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isSending) return;

    _controller.clear();
    setState(() => _isSending = true);
    _scrollToBottom();

    await ref.read(aiCoachProvider.notifier).sendMessage(text);

    if (mounted) {
      setState(() => _isSending = false);
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(aiCoachProvider);

    return Scaffold(
      backgroundColor: AppColorsDark.surface0,
      appBar: AppBar(
        backgroundColor: AppColorsDark.surface1,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: AppColorsDark.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: const Icon(Icons.auto_awesome_rounded, color: AppColorsDark.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI Health Coach', style: AppTypography.h2(color: Colors.white)),
                Text('Empathetic Ayurvedic Wellness Guide', style: AppTypography.labelSm(color: AppColorsDark.primary)),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: messagesAsync.when(
                data: (messages) {
                  if (messages.isEmpty && !_isSending) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.question_answer_rounded, size: 64, color: AppColorsDark.surface2),
                            const SizedBox(height: 16),
                            Text('Ask your AI Coach anything', style: AppTypography.h3()),
                            const SizedBox(height: 8),
                            Text(
                              'Try asking about adjusting carbs to lower blood sugar, managing post-workout exhaustion, or syncing sleep metrics.',
                              style: AppTypography.bodySm(color: AppColorsDark.textMuted),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              alignment: WrapAlignment.center,
                              children: [
                                _SuggestionChip(
                                  label: 'How can I lower my BP?',
                                  onTap: () {
                                    _controller.text = 'How can I lower my blood pressure naturally?';
                                  },
                                ),
                                _SuggestionChip(
                                  label: 'Suggest a healthy snack',
                                  onTap: () {
                                    _controller.text = 'Suggest a healthy Indian snack high in protein.';
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length + (_isSending ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == messages.length) {
                        return _buildTypingIndicator();
                      }

                      final msg = messages[index];
                      final isUser = msg['role'] == 'user';
                      return _buildMessageBubble(msg['content'] ?? '', isUser);
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator(color: AppColorsDark.primary)),
                error: (e, __) => Center(child: Text('Error: $e', style: const TextStyle(color: AppColorsDark.error))),
              ),
            ),

            // Input frame
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: AppColorsDark.surface1,
                border: Border(top: BorderSide(color: AppColorsDark.surface2, width: 1)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        hintStyle: AppTypography.bodyMd(color: AppColorsDark.textMuted),
                        filled: true,
                        fillColor: AppColorsDark.surface0,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                      ),
                      onSubmitted: (_) => _handleSend(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(color: AppColorsDark.primary, shape: BoxShape.circle),
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded, color: Colors.white),
                      onPressed: _isSending ? null : _handleSend,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(String content, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        child: isUser
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColorsDark.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(content, style: AppTypography.bodyMd(color: Colors.white)),
              )
            : GlassCard(
                customRadius: 20.0,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.auto_awesome_rounded, size: 14, color: AppColorsDark.primary),
                        const SizedBox(width: 6),
                        Text('COACH', style: AppTypography.labelSm(color: AppColorsDark.primary)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(content, style: AppTypography.bodyMd(color: Colors.white)),
                  ],
                ),
              ),
      ).animate().fadeIn(duration: 200.ms).slideY(begin: 0.1, end: 0),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: GlassCard(
          customRadius: 20.0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2, color: AppColorsDark.primary),
              ),
              const SizedBox(width: 12),
              Text('Coach is thinking...', style: AppTypography.labelSm(color: AppColorsDark.textMuted)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SuggestionChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      labelStyle: AppTypography.labelSm(color: AppColorsDark.textSecondary),
      backgroundColor: AppColorsDark.surface1,
      side: const BorderSide(color: AppColorsDark.surface2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      onPressed: onTap,
    );
  }
}
