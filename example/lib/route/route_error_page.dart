import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

class RouteErrorPage extends StatelessWidget {
  const RouteErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = GoRouterState.of(context);
    return Scaffold(body: Center(child: Text(state.error.toString())));
  }
}
