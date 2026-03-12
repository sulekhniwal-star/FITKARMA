import 'package:flutter/material.dart';
import 'bilingual_label.dart';

class SectionHeader extends StatelessWidget {
  final String englishTitle;
  final String hindiSubtitle;
  final Widget? trailing;

  const SectionHeader({
    super.key,
    required this.englishTitle,
    required this.hindiSubtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BilingualLabel.sectionHeader(
            englishText: englishTitle,
            hindiText: hindiSubtitle,
          ),
          ?trailing,
        ],
      ),
    );
  }
}
