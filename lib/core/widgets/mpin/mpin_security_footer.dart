import 'package:flutter/material.dart';

class MpinSecurityFooter extends StatelessWidget {
  const MpinSecurityFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.verified_user_rounded,
            color: Color(0xFF3F37C9),
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            'Your MPIN is encrypted and secure.\nWe never store or share your PIN.',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: 'Geist Sans',
              fontSize: 12,
              color: const Color(0xFF1F1F1F).withValues(alpha: 0.5),
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
