import 'package:bloc_concurrency/bloc_concurrency.dart' as bloc_concurrency;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/app.dart';
import 'package:quan_ly_tai_san_app/core/utils/app_bloc_observer.dart';
import 'package:quan_ly_tai_san_app/injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  Bloc.transformer = bloc_concurrency.sequential();
  Bloc.observer = const AppBlocObserver();
  runApp(App());
}