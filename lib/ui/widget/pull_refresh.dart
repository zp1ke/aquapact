import 'package:flutter/material.dart';

class PullToRefresh extends StatelessWidget {
  final Widget child;
  final VoidCallback onRefresh;
  final bool withBottomPadding;

  const PullToRefresh({
    super.key,
    required this.child,
    required this.onRefresh,
    this.withBottomPadding = true,
  });

  @override
  Widget build(BuildContext context) {
    var bottomHeight = kBottomNavigationBarHeight;
    if (!withBottomPadding) {
      bottomHeight /= 2.5;
    }
    return RefreshIndicator(
      onRefresh: () async {
        onRefresh();
      },
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height -
              kToolbarHeight -
              bottomHeight,
          child: child,
        ),
      ),
    );
  }
}
