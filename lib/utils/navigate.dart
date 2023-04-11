import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum TransitionType { slideLeft, slideRight, slideUp, slideDown }

PageRoute _buildPageRoute(Widget destination, TransitionType transitionType) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => destination,
    settings: RouteSettings(
      name: destination.toString(),
    ),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      switch (transitionType) {
        case TransitionType.slideLeft:
          return SlideTransition(
            position:
                Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero)
                    .animate(animation),
            child: child,
          );
        case TransitionType.slideRight:
          return SlideTransition(
            position:
                Tween<Offset>(begin: const Offset(-1.0, 0.0), end: Offset.zero)
                    .animate(animation),
            child: child,
          );
        case TransitionType.slideUp:
          return SlideTransition(
            position:
                Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero)
                    .animate(animation),
            child: child,
          );
        case TransitionType.slideDown:
          return SlideTransition(
            position:
                Tween<Offset>(begin: const Offset(0.0, -1.0), end: Offset.zero)
                    .animate(animation),
            child: child,
          );
      }
    },
  );
}

void navigateTo(
    BuildContext context, Widget destination, TransitionType transitionType) {
  Navigator.push(
    context,
    _buildPageRoute(destination, transitionType),
  );
}
