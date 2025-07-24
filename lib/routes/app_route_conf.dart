import 'package:quan_ly_tai_san_app/screen/Category/project_manager/views/project_manager.dart';
import 'package:quan_ly_tai_san_app/screen/home/home.dart';

import 'routes.dart';

class AppRouteConf {
  GoRouter get router => _router;

  late final _router = GoRouter(
    initialLocation: AppRoute.projectManager.path,
    debugLogDiagnostics: true,
    errorBuilder: (context, state) => const NotFoundScreen(),
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return Home(child: child);
        },
        routes: [
          GoRoute(
            path: AppRoute.projectManager.path,
            name: AppRoute.projectManager.name,
            pageBuilder: (_, __) => const NoTransitionPage(child: ProjectManager()),
          ),
        ],
      ),
      // GoRoute(
      //   path: AppRoute.liveVideoVar.path,
      //   name: AppRoute.liveVideoVar.name,
      //   pageBuilder: (_, __) => const NoTransitionPage(child: LiveVideoV2Page()),
      // ),
    ],
  );
}
