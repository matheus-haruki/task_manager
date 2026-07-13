import 'package:flutter/material.dart';
import 'package:task_manager/src/theme/app_theme_extension.dart';

class AppBottomSheet extends StatelessWidget {
  final Widget child;

  const AppBottomSheet({super.key, required this.child});

  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    bool isScrollControlled = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      useSafeArea: true,
      builder: (_) => AppBottomSheet(child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      left: true,
      right: true,
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 16,
          left: 24,
          right: 24,
          top: 12,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [_Handle(), child],
          ),
        ),
      ),
    );
  }
}

class _Handle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 4,
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: context.appColors.divider,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
