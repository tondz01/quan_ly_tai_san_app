import 'package:flutter/material.dart';

/// Shows a simple loading popup with a gray background overlay and a spinner.
Future<void> showLoadingPopup(
  BuildContext context, {
  bool barrierDismissible = false,
  Color barrierColor = const Color(0x99000000), // semi-transparent gray
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    useRootNavigator: true,
    builder: (context) => const _CommonLoadingDialog(),
  );
}

/// Hides the loading popup if it is currently shown.
void hideLoadingPopup(BuildContext context) {
  final navigator = Navigator.of(context, rootNavigator: true);
  if (navigator.canPop()) {
    navigator.pop();
  }
}

class _CommonLoadingDialog extends StatelessWidget {
  const _CommonLoadingDialog();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 56,
        height: 56,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
        ),
      ),
    );
  }
}
