import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();
  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    SGLog.error('Bloc', '${bloc.runtimeType} | $error | $stackTrace');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    SGLog.debug('AppBlocObserver', 'Bloc: ${bloc.runtimeType} | ${change.nextState}');
    super.onChange(bloc, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    SGLog.debug('AppBlocObserver', 'Bloc: ${bloc.runtimeType} | ${transition.event}');
    final buffer =
        StringBuffer()
          ..write('Bloc: ${bloc.runtimeType} | ')
          ..writeln('${transition.event.runtimeType}')
          ..write('Transition: ${transition.currentState.runtimeType}')
          ..writeln(' => ${transition.nextState.runtimeType}')
          ..write('New State: ${transition.nextState.toString()}');
    SGLog.debug('AppBlocObserver', buffer.toString());
    super.onTransition(bloc, transition);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    final buffer =
        StringBuffer()
          ..writeln('On Event :')
          ..writeln('Bloc: ${bloc.runtimeType}')
          ..write('Event: ${event.toString()}');
    SGLog.debug('AppBlocObserver', buffer.toString());
    super.onEvent(bloc, event);
  }

  @override
  void onCreate(BlocBase bloc) {
    SGLog.debug('AppBlocObserver', 'Bloc Created | ${bloc.runtimeType} ');
    super.onCreate(bloc);
  }
}