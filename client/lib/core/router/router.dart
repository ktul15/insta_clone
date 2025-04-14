import 'package:client/core/router/route_paths.dart';
import 'package:client/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:client/features/auth/presentation/bloc/auth_state.dart';
import 'package:client/features/auth/presentation/pages/login_page.dart';
import 'package:client/features/auth/presentation/pages/register_page.dart';
import 'package:client/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final gorouter = GoRouter(
  initialLocation: RoutePaths.login,
  redirect: (context, state) {
    final authBloc = context.read<AuthBloc>();
    final authState = authBloc.state;

    final isAuthPage =
        state.matchedLocation == RoutePaths.login ||
        state.matchedLocation == RoutePaths.register;

    if (authState.status == AuthStatus.initial) {
      return null;
    }

    if (authState.status == AuthStatus.authenticated && isAuthPage) {
      return RoutePaths.home;
    }

    if (authState.status == AuthStatus.unauthenticated && !isAuthPage) {
      return RoutePaths.login;
    }

    return null;
  },
  routes: [
    GoRoute(
      path: RoutePaths.home,
      name: RoutePaths.home,
      builder: (_, _) {
        return HomePage();
      },
    ),
    GoRoute(
      path: RoutePaths.login,
      name: RoutePaths.login,
      builder: (_, _) {
        return LoginPage();
      },
    ),
    GoRoute(
      path: RoutePaths.register,
      name: RoutePaths.register,
      builder: (_, _) {
        return RegisterPage();
      },
    ),
  ],
);
