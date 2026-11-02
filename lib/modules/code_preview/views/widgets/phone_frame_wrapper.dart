import 'package:flutter/material.dart';

class PhoneFrameWrapper extends StatelessWidget {
  final Widget child;
  final bool showFrame;

  const PhoneFrameWrapper({
    super.key,
    required this.child,
    this.showFrame = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!showFrame) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: child,
      );
    }

    return Center(
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 390,
          maxHeight: 780,
        ),
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(44),
          border: Border.all(color: const Color(0xFF475569), width: 8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 28,
              spreadRadius: 2,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(36),
          child: Column(
            children: [
              // Phone Notch / Dynamic Island bar
              Container(
                height: 32,
                color: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '9:41',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      width: 90,
                      height: 16,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    const Row(
                      children: [
                        Icon(Icons.signal_cellular_alt, size: 12, color: Colors.white),
                        SizedBox(width: 4),
                        Icon(Icons.wifi, size: 12, color: Colors.white),
                        SizedBox(width: 4),
                        Icon(Icons.battery_full, size: 14, color: Colors.white),
                      ],
                    ),
                  ],
                ),
              ),

              // The rendered screen body
              Expanded(child: child),

              // Home Indicator bar
              Container(
                height: 18,
                color: Colors.black,
                alignment: Alignment.center,
                child: Container(
                  width: 120,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
