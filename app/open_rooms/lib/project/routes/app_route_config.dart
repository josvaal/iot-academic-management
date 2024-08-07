import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:open_rooms/project/pages/calendar.dart';
import 'package:open_rooms/project/pages/door.dart';
import 'package:open_rooms/project/pages/error.dart';
import 'package:open_rooms/project/pages/home.dart';
import 'package:open_rooms/project/pages/labs.dart';
import 'package:open_rooms/project/pages/profile.dart';
import 'package:open_rooms/project/routes/app_route_constants.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  initialLocation: "/",
  navigatorKey: _rootNavigatorKey,
  routes: [
    GoRoute(
      path: "/",
      name: MyAppRouteConstants.homeRouteName,
      builder: (context, state) => Home(),
      routes: [
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: MyAppRouteConstants.profileRouteName,
          name: MyAppRouteConstants.profileRouteName,
          builder: (context, state) => Profile(),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: MyAppRouteConstants.doorRouteName,
          name: MyAppRouteConstants.doorRouteName,
          builder: (context, state) => Door(),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: MyAppRouteConstants.labsRouteName,
          name: MyAppRouteConstants.labsRouteName,
          builder: (context, state) => Labs(),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: MyAppRouteConstants.calendarRouteName,
          name: MyAppRouteConstants.calendarRouteName,
          builder: (context, state) {
            final roomId = state.pathParameters['rid']!;
            return Calendar(roomId: roomId);
          },
        )
      ],
    ),
  ],
  errorBuilder: (context, state) => ErrorPage(),
);
