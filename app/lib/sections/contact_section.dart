import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/common.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key, required this.mobile});

  final bool mobile;

  @override
  Widget build(BuildContext context) {
    final h = mobile ? 24.0 : 56.0;
    final v = mobile ? 100.0 : 180.0;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(h, v, h, v),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [Eyebrow('04 · CONTACT')]),
              SizedBox(height: mobile ? 36 : 56),
              Text(
                mobile ? "Let's\nbuild." : "Let's build\nsomething\ntogether.",
                style: label(Palette.ink, mobile ? 56 : 120, letterSpacing: -3, height: 0.95),
              ),
              SizedBox(height: mobile ? 36 : 56),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Text(
                  '백엔드와 데이터 플랫폼 관련 협업을 환영합니다. 메일로 연락 주시면 답신드리겠습니다.',
                  style: label(Palette.muted, mobile ? 16 : 18, height: 1.6),
                ),
              ),
              const SizedBox(height: 40),
              Wrap(
                spacing: 14,
                runSpacing: 14,
                children: [
                  PrimaryPillButton(email, onTap: openEmail),
                  SecondaryPillButton('82-10-9757-0148', onTap: openPhone),
                  SecondaryPillButton('GitHub', onTap: openGithub),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
