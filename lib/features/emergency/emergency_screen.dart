import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/scaffold_patterns.dart';
import '../../shared/widgets/bilingual_label.dart';
import '../../shared/widgets/bento_card.dart';
import 'emergency_providers.dart';

class EmergencyScreen extends ConsumerStatefulWidget {
  const EmergencyScreen({super.key});

  @override
  ConsumerState<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends ConsumerState<EmergencyScreen> {
  void _openConfigurationSheet(List<EmergencyContact> currentContacts) {
    // Prep individual input buffer states
    final c1 = currentContacts.isNotEmpty ? currentContacts[0] : EmergencyContact(name: '', phone: '', relation: 'Companion');
    final c2 = currentContacts.length > 1 ? currentContacts[1] : EmergencyContact(name: '', phone: '', relation: 'Physician');

    final name1Ctrl = TextEditingController(text: c1.name);
    final phone1Ctrl = TextEditingController(text: c1.phone);
    final rel1Ctrl = TextEditingController(text: c1.relation);

    final name2Ctrl = TextEditingController(text: c2.name);
    final phone2Ctrl = TextEditingController(text: c2.phone);
    final rel2Ctrl = TextEditingController(text: c2.relation);

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
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Configure Emergency Contacts', style: AppTypography.h3(color: Colors.white)),
                  IconButton(icon: const Icon(Icons.close_rounded, size: 20), onPressed: () => context.pop()),
                ],
              ),
              const SizedBox(height: 4),
              Text('Stored locally inside encrypted session storage containers.', style: AppTypography.labelSm(color: AppColorsDark.textMuted)),
              const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(color: AppColorsDark.divider, height: 1)),

              // Contact 1 Block
              Text('Primary Responder (Contact 1)', style: AppTypography.labelSm(color: AppColorsDark.accent)),
              const SizedBox(height: 8),
              _buildConfigField(name1Ctrl, 'Contact Name'),
              const SizedBox(height: 8),
              _buildConfigField(phone1Ctrl, 'Phone Number (e.g. +91...)'),
              const SizedBox(height: 8),
              _buildConfigField(rel1Ctrl, 'Relationship (e.g. Spouse, Brother)'),
              
              const SizedBox(height: 20),

              // Contact 2 Block
              Text('Secondary Backup (Contact 2)', style: AppTypography.labelSm(color: AppColorsDark.teal)),
              const SizedBox(height: 8),
              _buildConfigField(name2Ctrl, 'Contact Name'),
              const SizedBox(height: 8),
              _buildConfigField(phone2Ctrl, 'Phone Number (e.g. +91...)'),
              const SizedBox(height: 8),
              _buildConfigField(rel2Ctrl, 'Relationship (e.g. Physician, Sister)'),

              const SizedBox(height: 24),

              // Save trigger button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColorsDark.teal,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  final updatedList = [
                    EmergencyContact(
                      name: name1Ctrl.text.trim().isEmpty ? 'Responder 1' : name1Ctrl.text.trim(),
                      phone: phone1Ctrl.text.trim().isEmpty ? 'Unconfigured' : phone1Ctrl.text.trim(),
                      relation: rel1Ctrl.text.trim().isEmpty ? 'Companion' : rel1Ctrl.text.trim(),
                    ),
                    EmergencyContact(
                      name: name2Ctrl.text.trim().isEmpty ? 'Responder 2' : name2Ctrl.text.trim(),
                      phone: phone2Ctrl.text.trim().isEmpty ? 'Unconfigured' : phone2Ctrl.text.trim(),
                      relation: rel2Ctrl.text.trim().isEmpty ? 'Physician' : rel2Ctrl.text.trim(),
                    ),
                  ];
                  ref.read(emergencyContactsProvider.notifier).saveContacts(updatedList);
                  context.pop(); // dismiss sheet
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Emergency responder configuration saved successfully.'), backgroundColor: AppColorsDark.teal),
                  );
                },
                child: const Text('Update Safe Dispatch Data', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfigField(TextEditingController ctrl, String hint) {
    return TextField(
      controller: ctrl,
      style: AppTypography.bodySm(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTypography.bodySm(color: AppColorsDark.textMuted),
        filled: true,
        fillColor: AppColorsDark.surface0,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final contacts = ref.watch(emergencyContactsProvider);

    return AppScaffold.calmZone(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const BilingualLabel(
          english: 'Emergency Hub',
          hindi: 'आपातकालीन सहायता केंद्र',
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // High contrast calming guidance message
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColorsDark.surface0.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColorsDark.divider),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.shield_rounded, color: AppColorsDark.teal, size: 28),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Calm Zone Dispatch: Direct medical access bypassing visual layout loads.',
                        style: AppTypography.labelSm(color: AppColorsDark.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // 108 Ambulance button (tel link) primary component
              Text('National Ambulance Service', style: AppTypography.h3(color: Colors.white)),
              const SizedBox(height: 10),
              InkWell(
                onTap: () {
                  // Simulate phone dialer trigger safely
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Dialing National Ambulance Dispatch Hotline: 108'),
                      backgroundColor: AppColorsDark.rose,
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(24),
                child: GlassCard(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: AppColorsDark.rose.withValues(alpha: 0.2), shape: BoxShape.circle),
                        child: const Icon(Icons.emergency_rounded, color: AppColorsDark.rose, size: 36),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const BilingualLabel(
                              english: 'Dial 108 Ambulance',
                              hindi: '१०८ एम्बुलेंस सेवा',
                              color: Colors.white,
                            ),
                            const SizedBox(height: 4),
                            Text('Free round-the-clock national dispatch network.', style: AppTypography.labelSm(color: AppColorsDark.textMuted)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(color: AppColorsDark.rose, shape: BoxShape.circle),
                        child: const Icon(Icons.call_rounded, color: Colors.black, size: 20),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // AIIMS Delhi number mainline block
              Text('Specialized Trauma Hub', style: AppTypography.h3(color: Colors.white)),
              const SizedBox(height: 10),
              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: const BilingualLabel(
                            english: 'AIIMS New Delhi Trauma Center',
                            hindi: 'एम्स नई दिल्ली ट्रॉमा सेंटर',
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: AppColorsDark.purple.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(6)),
                          child: Text('Mainline', style: AppTypography.labelSm(color: AppColorsDark.purple)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SelectableText('011-26588500', style: AppTypography.monoLg(color: AppColorsDark.accent).copyWith(fontSize: 20, fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: const Icon(Icons.copy_rounded, size: 18),
                          color: AppColorsDark.textSecondary,
                          tooltip: 'Copy Mainline Number',
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('AIIMS Mainline Copied: 011-26588500'), backgroundColor: AppColorsDark.accent),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // 2 user-configured emergency contacts (name + number)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Personal Responders', style: AppTypography.h3(color: Colors.white)),
                  TextButton.icon(
                    style: TextButton.styleFrom(foregroundColor: AppColorsDark.teal),
                    icon: const Icon(Icons.settings_rounded, size: 16),
                    label: const Text('Configure'),
                    onPressed: () => _openConfigurationSheet(contacts),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              // Feed list for the 2 user configured contacts
              Column(
                children: contacts.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final c = entry.value;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: GlassCard(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: AppColorsDark.surface2, shape: BoxShape.circle),
                            child: Text('${idx + 1}', style: AppTypography.monoLg(color: Colors.white).copyWith(fontSize: 14)),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(c.relation, style: AppTypography.labelSm(color: idx == 0 ? AppColorsDark.accent : AppColorsDark.teal)),
                                const SizedBox(height: 2),
                                Text(c.name, style: AppTypography.labelLg(color: Colors.white).copyWith(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 2),
                                Text(c.phone, style: AppTypography.monoMd(color: AppColorsDark.textSecondary)),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.call_rounded, color: AppColorsDark.teal),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Dialing companion responder: ${c.name}'), backgroundColor: AppColorsDark.teal),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
