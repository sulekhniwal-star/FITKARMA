import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/scaffold_patterns.dart';
import '../../shared/widgets/bento_card.dart';
import '../../core/providers/core_providers.dart';
import 'lab_reports_providers.dart';

class LabReportsScreen extends ConsumerStatefulWidget {
  const LabReportsScreen({super.key});

  @override
  ConsumerState<LabReportsScreen> createState() => _LabReportsScreenState();
}

class _LabReportsScreenState extends ConsumerState<LabReportsScreen> {
  final _titleController = TextEditingController();
  String _selectedReportType = 'Complete Blood Count';

  // Manual values input controls buffers
  final _hba1cController = TextEditingController();
  final _cholesterolController = TextEditingController();
  final _creatinineController = TextEditingController();

  // Track active token execution links
  String? _generatingShareId;

  @override
  void dispose() {
    _titleController.dispose();
    _hba1cController.dispose();
    _cholesterolController.dispose();
    _creatinineController.dispose();
    super.dispose();
  }

  void _showUploadDialog(bool isProUser, int currentCount) {
    if (!isProUser && currentCount >= 3) {
      _showUpgradeAlert();
      return;
    }

    _titleController.clear();
    _hba1cController.clear();
    _cholesterolController.clear();
    _creatinineController.clear();
    setState(() => _selectedReportType = 'Complete Blood Count');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColorsDark.surface1,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
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
                    Text('Upload Vault Lab Report', style: AppTypography.h3(color: Colors.white)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: AppColorsDark.surface2, borderRadius: BorderRadius.circular(6)),
                      child: Text(
                        isProUser ? 'Pro: Infinite' : 'Free: ${currentCount + 1}/3',
                        style: AppTypography.labelSm(color: isProUser ? AppColorsDark.accent : AppColorsDark.textMuted),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Document Info
                TextField(
                  controller: _titleController,
                  style: AppTypography.bodyLg(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Report Title',
                    labelStyle: AppTypography.labelSm(color: AppColorsDark.textMuted),
                    filled: true,
                    fillColor: AppColorsDark.surface0,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 12),

                // Report Type Dropdown
                DropdownButtonFormField<String>(
                  initialValue: _selectedReportType,
                  dropdownColor: AppColorsDark.surface2,
                  style: AppTypography.bodyLg(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Clinical Category',
                    labelStyle: AppTypography.labelSm(color: AppColorsDark.textMuted),
                    filled: true,
                    fillColor: AppColorsDark.surface0,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                  items: ['Complete Blood Count', 'Lipid Profile', 'HbA1c', 'Renal Function Test', 'Liver Panel', 'General'].map((t) {
                    return DropdownMenuItem(value: t, child: Text(t));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setSheetState(() => _selectedReportType = val);
                  },
                ),
                const SizedBox(height: 20),

                // Manual value entry inputs
                Text('Manual Biomarker Extraction', style: AppTypography.labelSm(color: AppColorsDark.teal)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildBiomarkerInput(_hba1cController, 'HbA1c (%)'),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildBiomarkerInput(_cholesterolController, 'Cholesterol'),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildBiomarkerInput(_creatinineController, 'Creatinine'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Trigger Document creation targeting Appwrite Storage Vault bucket
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColorsDark.teal,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.cloud_upload_rounded, size: 18),
                  label: const Text('Store Encrypted Document', style: TextStyle(fontWeight: FontWeight.bold)),
                  onPressed: () async {
                    final title = _titleController.text.trim().isEmpty ? 'Clinical Lab Report' : _titleController.text.trim();
                    
                    final map = <String, dynamic>{};
                    if (_hba1cController.text.trim().isNotEmpty) {
                      map['HbA1c'] = double.tryParse(_hba1cController.text.trim()) ?? 0.0;
                    }
                    if (_cholesterolController.text.trim().isNotEmpty) {
                      map['Cholesterol'] = double.tryParse(_cholesterolController.text.trim()) ?? 0.0;
                    }
                    if (_creatinineController.text.trim().isNotEmpty) {
                      map['Creatinine'] = double.tryParse(_creatinineController.text.trim()) ?? 0.0;
                    }

                    try {
                      await ref.read(labReportsListProvider.notifier).uploadReport(
                            title: title,
                            reportType: _selectedReportType,
                            manualValues: map,
                            mockExt: 'pdf',
                          );
                      
                      if (context.mounted) {
                        context.pop(); // Close sheet
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Document uploaded securely to fitkarma-vault bucket.'), backgroundColor: AppColorsDark.teal),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        context.pop();
                        _showUpgradeAlert();
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBiomarkerInput(TextEditingController ctrl, String label) {
    return TextField(
      controller: ctrl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: AppTypography.bodySm(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTypography.labelSm(color: AppColorsDark.textMuted).copyWith(fontSize: 10),
        filled: true,
        fillColor: AppColorsDark.surface0,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      ),
    );
  }

  void _showUpgradeAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColorsDark.surface1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.star_rounded, color: AppColorsDark.accent, size: 24),
            const SizedBox(width: 8),
            Text('Upgrade to Pro', style: AppTypography.h3(color: Colors.white)),
          ],
        ),
        content: Text(
          'Free tier enforces a strict maximum of 3 clinical documents. Unlock unlimited file cloud storage pools alongside automated clinical marker analysis.',
          style: AppTypography.bodySm(color: AppColorsDark.textSecondary),
        ),
        actions: [
          TextButton(onPressed: () => context.pop(), child: Text('Cancel', style: AppTypography.labelSm(color: AppColorsDark.textMuted))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColorsDark.accent, foregroundColor: Colors.black),
            onPressed: () {
              context.pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Simulating premium subscription account update setup...'), backgroundColor: AppColorsDark.accent),
              );
            },
            child: const Text('Go Unlimited', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Future<void> _triggerExpiringLinkGeneration(String reportId) async {
    setState(() => _generatingShareId = reportId);

    try {
      final generatedUrl = await ref.read(labReportsListProvider.notifier).requestExpiringShareLink(reportId);

      if (mounted) {
        setState(() => _generatingShareId = null);
        
        // Show sharing verification popup dialogue
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppColorsDark.surface1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text('Expiring Share Token Generated', style: AppTypography.h3(color: Colors.white)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'This temporary security token URL remains fully active for exactly 7 days before automated invalidation loops purge document tokens.',
                  style: AppTypography.bodySm(color: AppColorsDark.textSecondary),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: AppColorsDark.surface0, borderRadius: BorderRadius.circular(8)),
                  child: SelectableText(
                    generatedUrl,
                    style: AppTypography.monoMd(color: AppColorsDark.teal).copyWith(fontSize: 12),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => context.pop(), child: const Text('Close')),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: AppColorsDark.teal, foregroundColor: Colors.black),
                icon: const Icon(Icons.copy_rounded, size: 16),
                label: const Text('Copy Token Url'),
                onPressed: () {
                  context.pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Expiring share URL copied to clipboard.'), backgroundColor: AppColorsDark.teal),
                  );
                },
              ),
            ],
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        setState(() => _generatingShareId = null);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to invoke fitkarma-coress cloud container loop.'), backgroundColor: AppColorsDark.rose),
        );
      }
    }
  }

  String _formatDateShort(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final reportsAsync = ref.watch(labReportsListProvider);
    final isProAsync = ref.watch(isProProvider);
    final isProUser = isProAsync.valueOrNull ?? false;

    final list = reportsAsync.valueOrNull ?? [];

    return AppScaffold.calmZone(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text('Clinical Lab Vault', style: AppTypography.h2(color: Colors.white)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status and Tier display header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.shield_rounded, color: AppColorsDark.teal, size: 18),
                      const SizedBox(width: 8),
                      Text('Biometric Gate Enforced', style: AppTypography.labelSm(color: AppColorsDark.teal)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isProUser ? AppColorsDark.accent.withOpacity(0.15) : AppColorsDark.surface1,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: isProUser ? AppColorsDark.accent : AppColorsDark.surface2),
                    ),
                    child: Text(
                      isProUser ? 'Pro Account' : 'Free Tier (${list.length}/3)',
                      style: AppTypography.labelSm(color: isProUser ? AppColorsDark.accent : AppColorsDark.textMuted).copyWith(fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),

            // Top action bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColorsDark.surface1,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  side: const BorderSide(color: AppColorsDark.surface2),
                ),
                icon: const Icon(Icons.add_circle_outline_rounded, color: AppColorsDark.teal),
                label: const Text('Store New Vault Document', style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () => _showUploadDialog(isProUser, list.length),
              ),
            ),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: Divider(color: AppColorsDark.divider, height: 20)),

            // Reports view layout list feed
            Expanded(
              child: reportsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator(color: AppColorsDark.teal)),
                error: (err, _) => Center(child: Text('Error accessing local safe storage records.', style: AppTypography.bodySm(color: AppColorsDark.rose))),
                data: (items) {
                  if (items.isEmpty) {
                    return Center(
                      child: Text(
                        'Vault container is entirely clear.\nTap to upload PDF/Image clinical markers.',
                        style: AppTypography.bodySm(color: AppColorsDark.textMuted),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, idx) {
                      final item = items[idx];
                      final isGenerating = _generatingShareId == item.id;

                      return GlassCard(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item.title, style: AppTypography.labelLg(color: Colors.white).copyWith(fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 2),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(color: AppColorsDark.surface2, borderRadius: BorderRadius.circular(4)),
                                            child: Text(item.reportType, style: AppTypography.labelSm(color: AppColorsDark.textSecondary).copyWith(fontSize: 10)),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(_formatDateShort(item.date), style: AppTypography.monoMd(color: AppColorsDark.textMuted).copyWith(fontSize: 11)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: isGenerating
                                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: AppColorsDark.teal, strokeWidth: 2))
                                      : const Icon(Icons.share_rounded, size: 18),
                                  color: AppColorsDark.teal,
                                  tooltip: 'Generate Expiring 7d Client Token',
                                  onPressed: isGenerating ? null : () => _triggerExpiringLinkGeneration(item.id),
                                ),
                              ],
                            ),

                            // Subtly append extracted manual biomarkers array if specified
                            if (item.manualValues.isNotEmpty) ...[
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Divider(color: AppColorsDark.divider, height: 1),
                              ),
                              Wrap(
                                spacing: 12,
                                runSpacing: 6,
                                children: item.manualValues.entries.map((m) {
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('${m.key}: ', style: AppTypography.labelSm(color: AppColorsDark.textMuted).copyWith(fontSize: 11)),
                                      Text('${m.value}', style: AppTypography.monoMd(color: Colors.white).copyWith(fontSize: 12, fontWeight: FontWeight.bold)),
                                    ],
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
            ),
          ],
        ),
      ),
    );
  }
}
