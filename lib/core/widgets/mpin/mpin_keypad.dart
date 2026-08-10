import 'package:flutter/material.dart';

class PremiumMpinKeypad extends StatelessWidget {
  final Function(String) onKeyPress;
  final VoidCallback onBackspace;

  const PremiumMpinKeypad({
    super.key,
    required this.onKeyPress,
    required this.onBackspace,
  });

  Widget _buildKey(String val) {
    return _DialButton(
      content: Text(
        val,
        style: const TextStyle(
          fontFamily: 'Geist Sans',
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1F1F1F),
        ),
      ),
      onTap: () => onKeyPress(val),
    );
  }

  Widget _buildDeleteKey() {
    return _DialButton(
      content: const Icon(
        Icons.backspace_outlined,
        color: Color(0xFF3F37C9),
        size: 24,
      ),
      onTap: onBackspace,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildKey('1'),
              _buildKey('2'),
              _buildKey('3'),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildKey('4'),
              _buildKey('5'),
              _buildKey('6'),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildKey('7'),
              _buildKey('8'),
              _buildKey('9'),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 58, height: 58), // Empty space
              _buildKey('0'),
              _buildDeleteKey(),
            ],
          ),
        ],
      ),
    );
  }
}

class _DialButton extends StatefulWidget {
  final Widget content;
  final VoidCallback onTap;

  const _DialButton({
    required this.content,
    required this.onTap,
  });

  @override
  State<_DialButton> createState() => _DialButtonState();
}

class _DialButtonState extends State<_DialButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF002E6E).withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: widget.content,
        ),
      ),
    );
  }
}
