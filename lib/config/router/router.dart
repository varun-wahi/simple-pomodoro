import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_pomodoro/config/router/route_constants.dart';
import 'package:simple_pomodoro/features/auth/presentation/pages/login_screen.dart';
import 'package:simple_pomodoro/features/home%20/presentation/pages/analytics_screen.dart';
import 'package:simple_pomodoro/features/home%20/presentation/pages/home_screen.dart';
import 'package:simple_pomodoro/features/settings/presentation/pages/settings_page.dart';

class AppRouter {
  // Make the router a singleton instance
  final GoRouter router;

  AppRouter({required bool isAuthenticated})
      : router = GoRouter(
          routes: [
            GoRoute(
              name: RouteConstants.home,
              path: '/',
              pageBuilder: (context, state) {
                return const MaterialPage(child: HomeScreen());
              },
            ),
            GoRoute(
              name: RouteConstants.login,
              path: '/login',
              pageBuilder: (context, state) {
                return const MaterialPage(child: LoginScreen());
              },
            ),
            GoRoute(
              name: RouteConstants.settings,
              path: '/settings',
              pageBuilder: (context, state) {
                return const MaterialPage(child: MoreOptionsPage());
              },
            ),

            GoRoute(
              name: RouteConstants.analytics,
              path: '/analytics',
              pageBuilder: (context, state) {
                return const MaterialPage(child: AnalyticsScreen());
              },
            ),
          ],
          redirect: (context, state) {
            // Check if the user is authenticated before accessing the home route
            if (!isAuthenticated && state.matchedLocation == '/') {
              return '/login';
            }
            return null; // no redirection needed
          },
        );
}