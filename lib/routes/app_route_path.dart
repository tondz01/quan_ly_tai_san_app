enum AppRoute {
  projectManager(path: "/project-manager");

  final String path;
  const AppRoute({required this.path});
}
