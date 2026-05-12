import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/scaffold_patterns.dart';
import '../../shared/widgets/bento_card.dart';
import '../../shared/widgets/pro_gate.dart';
import 'social_providers.dart';

class SocialScreen extends StatelessWidget {
  const SocialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fulfills the explicit [ProGate wrapper] requirement
    return const ProGate(
      featureName: 'Private Social Clans & Leaderboards',
      child: _SocialContentScreen(),
    );
  }
}

class _SocialContentScreen extends ConsumerStatefulWidget {
  const _SocialContentScreen();

  @override
  ConsumerState<_SocialContentScreen> createState() => _SocialContentScreenState();
}

class _SocialContentScreenState extends ConsumerState<_SocialContentScreen> {
  final _groupNameController = TextEditingController();
  final _postController = TextEditingController();
  String? _selectedGroupId;

  @override
  void dispose() {
    _groupNameController.dispose();
    _postController.dispose();
    super.dispose();
  }

  void _showCreateGroupSheet() {
    _groupNameController.clear();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColorsDark.surface1,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Create Social Clan', style: AppTypography.h3(color: Colors.white)),
                IconButton(icon: const Icon(Icons.close_rounded, size: 20), onPressed: () => context.pop()),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _groupNameController,
              style: AppTypography.bodyLg(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Group Name (e.g. Fit Cousins)',
                labelStyle: AppTypography.labelSm(color: AppColorsDark.textMuted),
                filled: true,
                fillColor: AppColorsDark.surface0,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColorsDark.accent,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                final name = _groupNameController.text.trim();
                if (name.isNotEmpty) {
                  ref.read(socialGroupsProvider.notifier).createGroup(name);
                  context.pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Clan "$name" provisioned successfully.'), backgroundColor: AppColorsDark.accent),
                  );
                }
              },
              child: const Text('Provision Private Clan', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes <= 0 ? 1 : diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    }
    return '${d.day}/${d.month}';
  }

  @override
  Widget build(BuildContext context) {
    final groups = ref.watch(socialGroupsProvider);

    // Default to first group if none active selected
    if (_selectedGroupId == null && groups.isNotEmpty) {
      _selectedGroupId = groups.first.id;
    } else if (groups.isNotEmpty && !groups.any((g) => g.id == _selectedGroupId)) {
      _selectedGroupId = groups.first.id;
    }

    final activeGroup = groups.cast<SocialGroup?>().firstWhere((g) => g?.id == _selectedGroupId, orElse: () => null);

    return AppScaffold.patternA(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text('Social Connect', style: AppTypography.h2(color: Colors.white)),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Group Selectors horizontal bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('My Active Hubs', style: AppTypography.h3(color: Colors.white)),
              TextButton.icon(
                style: TextButton.styleFrom(foregroundColor: AppColorsDark.accent),
                icon: const Icon(Icons.add_circle_outline_rounded, size: 16),
                label: const Text('Create Group'),
                onPressed: _showCreateGroupSheet,
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Horizontal tabs representing group creation & active memberships
          if (groups.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text('No active clan memberships.\nCreate a new group to connect peers.', style: AppTypography.bodySm(color: AppColorsDark.textMuted), textAlign: TextAlign.center),
              ),
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: groups.map((grp) {
                  final bool isSelected = grp.id == _selectedGroupId;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: ChoiceChip(
                      label: Text(grp.name, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                      selected: isSelected,
                      selectedColor: AppColorsDark.accent,
                      labelStyle: TextStyle(color: isSelected ? Colors.black : Colors.white, fontSize: 13),
                      backgroundColor: AppColorsDark.surface1,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      side: BorderSide(color: isSelected ? AppColorsDark.accent : AppColorsDark.surface2),
                      onSelected: (_) => setState(() => _selectedGroupId = grp.id),
                    ),
                  );
                }).toList(),
              ),
            ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Divider(color: AppColorsDark.divider, height: 1)),

          // View renders for activeGroup content
          if (activeGroup != null) ...[
            // Leaderboard within group
            Row(
              children: [
                const Icon(Icons.emoji_events_rounded, color: AppColorsDark.secondary, size: 18),
                const SizedBox(width: 8),
                Text('Group XP Ranking', style: AppTypography.labelLg(color: Colors.white).copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 10),

            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: activeGroup.leaderboard.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final lb = entry.value;
                  final isMe = lb.name == 'You' || lb.memberId == 'u0';

                  Color badgeColor = AppColorsDark.textMuted;
                  if (idx == 0) badgeColor = AppColorsDark.accent; // Gold
                  if (idx == 1) badgeColor = AppColorsDark.secondary; // Silver
                  if (idx == 2) badgeColor = AppColorsDark.rose; // Bronze

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 24,
                          child: Text('#${idx + 1}', style: AppTypography.monoMd(color: badgeColor).copyWith(fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            lb.name,
                            style: AppTypography.bodySm(color: isMe ? AppColorsDark.accent : Colors.white).copyWith(fontWeight: isMe ? FontWeight.bold : FontWeight.normal),
                          ),
                        ),
                        Text(
                          '${lb.xpTotal} XP',
                          style: AppTypography.monoMd(color: isMe ? AppColorsDark.accent : AppColorsDark.textSecondary).copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Post creation bar
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _postController,
                    style: AppTypography.bodySm(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Share exercise updates or support...',
                      hintStyle: AppTypography.bodySm(color: AppColorsDark.textMuted),
                      filled: true,
                      fillColor: AppColorsDark.surface0,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  style: IconButton.styleFrom(backgroundColor: AppColorsDark.accent, foregroundColor: Colors.black),
                  icon: const Icon(Icons.send_rounded, size: 16),
                  onPressed: () {
                    final text = _postController.text.trim();
                    if (text.isNotEmpty) {
                      ref.read(socialGroupsProvider.notifier).addPost(activeGroup.id, text);
                      _postController.clear();
                      FocusScope.of(context).unfocus();
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Group feed (posts from members)
            Text('Clan Timeline Feed', style: AppTypography.labelLg(color: Colors.white).copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            if (activeGroup.feedPosts.isEmpty)
              Center(
                child: Padding(padding: EdgeInsets.all(24), child: Text('No posts recorded in clan timeline yet.', style: AppTypography.labelSm(color: AppColorsDark.textMuted))),
              )
            else
              Column(
                children: activeGroup.feedPosts.map((post) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: GlassCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 12,
                                    backgroundColor: AppColorsDark.surface2,
                                    child: Text(post.authorName.substring(0, 1).toUpperCase(), style: const TextStyle(fontSize: 10, color: Colors.white)),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(post.authorName, style: AppTypography.labelSm(color: Colors.white).copyWith(fontWeight: FontWeight.bold)),
                                ],
                              ),
                              Row(
                                children: [
                                  if (post.bonusKarma > 0) ...[
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(color: AppColorsDark.accent.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                                      child: Text('+${post.bonusKarma} XP', style: AppTypography.monoMd(color: AppColorsDark.accent).copyWith(fontSize: 9)),
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                  Text(_formatTime(post.timestamp), style: AppTypography.monoMd(color: AppColorsDark.textMuted).copyWith(fontSize: 10)),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(post.content, style: AppTypography.bodySm(color: AppColorsDark.textSecondary)),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}
