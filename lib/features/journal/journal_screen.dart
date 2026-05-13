import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/scaffold_patterns.dart';
import '../../shared/widgets/bento_card.dart';
import '../../shared/widgets/encryption_badge.dart';
import 'journal_providers.dart';
import '../../core/security/security_service.dart';

class JournalScreen extends ConsumerStatefulWidget {
  const JournalScreen({super.key});

  @override
  ConsumerState<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends ConsumerState<JournalScreen> {
  final _contentController = TextEditingController();
  final _tagsController = TextEditingController();
  String _selectedMood = '🙂'; // default level 4 serene

  final List<Map<String, dynamic>> _moods = [
    {'emoji': '😢', 'label': 'Anxious', 'score': 1},
    {'emoji': '🙁', 'label': 'Tense', 'score': 2},
    {'emoji': '😐', 'label': 'Balanced', 'score': 3},
    {'emoji': '🙂', 'label': 'Serene', 'score': 4},
    {'emoji': '🤩', 'label': 'Thriving', 'score': 5},
  ];

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _contentController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _insertMarkdown(String prefix, String suffix) {
    final text = _contentController.text;
    final selection = _contentController.selection;

    if (selection.isValid && selection.start >= 0 && selection.end >= 0) {
      final selectedText = selection.textInside(text);
      final newText = text.replaceRange(selection.start, selection.end, '$prefix$selectedText$suffix');
      
      _contentController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(
          offset: selection.start + prefix.length + selectedText.length + suffix.length,
        ),
      );
    } else {
      // Append at end if no valid selection focus
      final currentOffset = _contentController.selection.baseOffset;
      final insertPos = currentOffset >= 0 ? currentOffset : text.length;
      
      final newText = text.replaceRange(insertPos, insertPos, '$prefix$suffix');
      _contentController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: insertPos + prefix.length),
      );
    }
  }

  void _insertBulletList() {
    final text = _contentController.text;
    final selection = _contentController.selection;
    final currentOffset = selection.isValid ? selection.baseOffset : text.length;
    final insertPos = currentOffset >= 0 ? currentOffset : text.length;

    // Check if start of line or needs newline
    final needsNewline = insertPos > 0 && text[insertPos - 1] != '\n';
    final injection = needsNewline ? '\n- ' : '- ';

    final newText = text.replaceRange(insertPos, insertPos, injection);
    _contentController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: insertPos + injection.length),
    );
  }

  Future<void> _saveEntry() async {
    final content = _contentController.text.trim();
    if (content.isEmpty) {
      setState(() => _errorMessage = 'Please type a reflection before saving.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final rawTagsStr = _tagsController.text.trim();
      final List<String> tags = rawTagsStr.isEmpty
          ? []
          : rawTagsStr.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

      await saveJournalEntry(
        ref,
        content: content,
        moodEmoji: _selectedMood,
        tags: tags,
      );

      if (mounted) {
        // Clear composition workspace
        _contentController.clear();
        _tagsController.clear();
        setState(() {
          _isLoading = false;
          _selectedMood = '🙂';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reflection safely encrypted locally.'),
            backgroundColor: AppColorsDark.teal,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to securely encrypt journal payload.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final entriesAsync = ref.watch(journalEntriesStreamProvider);
    final tagsMap = ref.watch(journalMetadataCacheProvider);

    // Watch side-load caching
    ref.listen(journalEntriesStreamProvider, (prev, next) {
      next.whenData((list) {
        ref.read(journalMetadataCacheProvider.notifier).loadForEntries(list);
      });
    });

    return SensitiveScreenGuard(
      screenName: 'Reflective Personal Journal',
      child: AppScaffold.calmZone(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () => context.pop(),
          ),
          title: Text('Reflective Journal', style: AppTypography.h2(color: Colors.white)),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Security status tag
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColorsDark.surface0.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColorsDark.teal.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.lock_rounded, size: 14, color: AppColorsDark.teal),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'SQLCipher Local Storage: Biometrically locked & isolated per OS session.',
                          style: AppTypography.labelSm(color: AppColorsDark.textSecondary),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Composition Canvas Card
                GlassCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('How is your internal state right now?', style: AppTypography.h3(color: Colors.white)),
                      const SizedBox(height: 12),

                      // Mood selector (emoji 1–5 scale)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: _moods.map((m) {
                          final isSelected = _selectedMood == m['emoji'];
                          return InkWell(
                            onTap: () => setState(() => _selectedMood = m['emoji'] as String),
                            borderRadius: BorderRadius.circular(12),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColorsDark.teal.withValues(alpha: 0.2) : AppColorsDark.surface1,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected ? AppColorsDark.teal : AppColorsDark.surface2,
                                  width: isSelected ? 1.5 : 1.0,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(m['emoji'] as String, style: const TextStyle(fontSize: 24)),
                                  const SizedBox(height: 4),
                                  Text(
                                    m['label'] as String,
                                    style: AppTypography.labelSm(
                                      color: isSelected ? AppColorsDark.teal : AppColorsDark.textMuted,
                                    ).copyWith(fontSize: 10, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),

                      if (_errorMessage != null) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: AppColorsDark.rose.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                          child: Text(_errorMessage!, style: AppTypography.bodySm(color: AppColorsDark.rose)),
                        ),
                        const SizedBox(height: 12),
                      ],

                      // Rich Text Editor Toolbar
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColorsDark.surface1,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Text('Format:', style: AppTypography.labelSm(color: AppColorsDark.textMuted)),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.format_bold_rounded, size: 18),
                              tooltip: 'Bold (**text**)',
                              color: Colors.white,
                              onPressed: () => _insertMarkdown('**', '**'),
                            ),
                            IconButton(
                              icon: const Icon(Icons.format_italic_rounded, size: 18),
                              tooltip: 'Italic (*text*)',
                              color: Colors.white,
                              onPressed: () => _insertMarkdown('*', '*'),
                            ),
                            IconButton(
                              icon: const Icon(Icons.format_list_bulleted_rounded, size: 18),
                              tooltip: 'Bullet List (- item)',
                              color: Colors.white,
                              onPressed: _insertBulletList,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Multi-line rich content input
                      TextField(
                        controller: _contentController,
                        style: AppTypography.bodyLg(color: Colors.white),
                        maxLines: 5,
                        minLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Pour your thoughts safely here. Use toolbar to format rich emphasis...',
                          hintStyle: AppTypography.bodyLg(color: AppColorsDark.textMuted),
                          filled: true,
                          fillColor: AppColorsDark.surface1.withValues(alpha: 0.5),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Tags field
                      Text('Tags (comma-separated)', style: AppTypography.labelSm(color: AppColorsDark.textSecondary)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _tagsController,
                        style: AppTypography.labelSm(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'e.g., gratitude, heavy workout, fasting clarity',
                          hintStyle: AppTypography.labelSm(color: AppColorsDark.textMuted),
                          prefixIcon: const Icon(Icons.tag_rounded, size: 14, color: AppColorsDark.textMuted),
                          filled: true,
                          fillColor: AppColorsDark.surface1.withValues(alpha: 0.5),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Save CTA button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColorsDark.teal,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _isLoading ? null : _saveEntry,
                        child: _isLoading
                            ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                            : Text('Encrypt Reflection Payload', style: AppTypography.labelLg(color: Colors.black).copyWith(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 36),

                // Entry list sorted by date feed
                Text('Encrypted Time Vault', style: AppTypography.h3(color: Colors.white)),
                const SizedBox(height: 12),

                entriesAsync.when(
                  loading: () => const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator())),
                  error: (err, stack) => const SizedBox(),
                  data: (list) {
                    if (list.isEmpty) {
                      return GlassCard(
                        padding: const EdgeInsets.symmetric(vertical: 36),
                        child: Column(
                          children: [
                            const Icon(Icons.history_edu_rounded, size: 48, color: AppColorsDark.surface2),
                            const SizedBox(height: 12),
                            Text('Vault idle. Logs await secure seeding.', style: AppTypography.bodySm(color: AppColorsDark.textMuted)),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: list.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final item = list[index];
                        final tags = tagsMap[item.id] ?? [];
                        final moodStr = item.mood ?? '😐';

                        return GlassCard(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(moodStr, style: const TextStyle(fontSize: 20)),
                                      const SizedBox(width: 8),
                                      Text(
                                        DateFormat('EEEE, MMM d').format(item.createdAt),
                                        style: AppTypography.labelLg(color: Colors.white).copyWith(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    DateFormat('h:mm a').format(item.createdAt),
                                    style: AppTypography.labelSm(color: AppColorsDark.textMuted),
                                  ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.0),
                                child: Divider(color: AppColorsDark.divider, height: 1),
                              ),
                              // Markdown inline rendered spans
                              _buildRichTextView(item.content),

                              if (tags.isNotEmpty) ...[
                                const SizedBox(height: 14),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  children: tags.map((t) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: AppColorsDark.surface1,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: AppColorsDark.surface2),
                                      ),
                                      child: Text('#$t', style: AppTypography.labelSm(color: AppColorsDark.textSecondary).copyWith(fontSize: 11)),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 36),

                // Bottom encryption signature tag
                const Center(child: EncryptionBadge()),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Parses basic inline markdown markup logic dynamically into precise rich TextSpans
  Widget _buildRichTextView(String text) {
    final lines = text.split('\n');
    final List<Widget> blockWidgets = [];

    for (final line in lines) {
      final lTrimmed = line.trim();
      if (lTrimmed.startsWith('- ')) {
        // Render bullet list line item
        blockWidgets.add(
          Padding(
            padding: const EdgeInsets.only(left: 12.0, top: 2.0, bottom: 2.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(color: AppColorsDark.teal, fontWeight: FontWeight.bold)),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: _parseInlineSpans(line.substring(line.indexOf('- ') + 2)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        // Standard text line
        blockWidgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: RichText(
              text: TextSpan(
                children: _parseInlineSpans(line),
              ),
            ),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: blockWidgets,
    );
  }

  List<TextSpan> _parseInlineSpans(String input) {
    final List<TextSpan> spans = [];
    final baseStyle = AppTypography.bodyLg(color: AppColorsDark.textPrimary).copyWith(height: 1.4);

    // Naive string split strategy parsing consecutive segments sequentially
    // Look for ** bold tags first
    final boldParts = input.split('**');
    for (int i = 0; i < boldParts.length; i++) {
      final part = boldParts[i];
      final isBoldSegment = (i % 2 == 1);

      if (isBoldSegment) {
        spans.add(TextSpan(text: part, style: baseStyle.copyWith(fontWeight: FontWeight.bold, color: Colors.white)));
      } else {
        // Check for * italic substrings within un-bolded segments
        final italicParts = part.split('*');
        for (int j = 0; j < italicParts.length; j++) {
          final subPart = italicParts[j];
          final isItalicSegment = (j % 2 == 1);

          if (isItalicSegment) {
            spans.add(TextSpan(text: subPart, style: baseStyle.copyWith(fontStyle: FontStyle.italic, color: AppColorsDark.textSecondary)));
          } else {
            spans.add(TextSpan(text: subPart, style: baseStyle));
          }
        }
      }
    }

    return spans;
  }
}
