import 'package:flutter/material.dart';

import '../data/models.dart';
import '../data/portfolio_data.dart';
import '../pages/portfolio_page.dart';
import '../theme.dart';

class AwardsSection extends StatelessWidget {
  const AwardsSection({super.key, required this.mobile});

  final bool mobile;

  @override
  Widget build(BuildContext context) {
    return SectionShell(
      eyebrow: '03 · AWARDS',
      title: 'Recognition.',
      mobile: mobile,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < awards.length; i++)
            _AwardRow(awards[i], divider: i != awards.length - 1, mobile: mobile),
        ],
      ),
    );
  }
}

class _AwardRow extends StatelessWidget {
  const _AwardRow(this.award, {required this.divider, required this.mobile});

  final Award award;
  final bool divider;
  final bool mobile;

  @override
  Widget build(BuildContext context) {
    final v = mobile ? 18.0 : 26.0;
    return Container(
      padding: EdgeInsets.fromLTRB(0, v, 0, v),
      decoration: BoxDecoration(
        border: divider ? Border(bottom: BorderSide(color: Palette.border)) : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: mobile ? 70 : 110,
            child: Text(award.date, style: label(Palette.muted, 12, letterSpacing: 1)),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(award.event, style: label(Palette.ink, mobile ? 16 : 20, letterSpacing: -0.4, height: 1.3)),
                const SizedBox(height: 4),
                Text(award.title, style: label(Palette.muted, 13)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Icon(Icons.workspace_premium_outlined, color: Palette.accent, size: 22),
        ],
      ),
    );
  }
}
