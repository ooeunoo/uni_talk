import 'package:flutter/material.dart';

class SnackBar extends StatelessWidget {
  final Widget content;

  const SnackBar({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: IntrinsicWidth(
            child: Material(
              color: Colors.grey[800],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: const BorderSide(color: Colors.white, width: 1),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: content,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void showTopSnackBar(BuildContext context, Widget content) {
  OverlayState? overlayState = Overlay.of(context);
  OverlayEntry? overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (BuildContext context) {
      return SnackBar(content: content);
    },
  );

  overlayState.insert(overlayEntry);

  Future.delayed(const Duration(seconds: 3)).then((value) {
    overlayEntry?.remove();
  });
}
