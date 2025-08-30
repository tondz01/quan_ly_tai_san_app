import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/capital_source/bloc/capital_source_event.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/capital_source/bloc/capital_source_state.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/capital_source/models/capital_source.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/capital_source/providers/capital_source_provider.dart';

class CapitalSourceBloc extends Bloc<CapitalSourceEvent, CapitalSourceState> {
  List<NguonKinhPhi> _allCapitalSources = [];
  final provider = CapitalSourceProvider();
  CapitalSourceBloc() : super(CapitalSourceInitial()) {
    on<LoadCapitalSources>((event, emit) async {
      _allCapitalSources = await provider.fetchCapitalSources();
      emit(CapitalSourceLoaded(_allCapitalSources));
    });
    on<SearchCapitalSource>((event, emit) {
      final searchLower = event.keyword.toLowerCase();
      final filtered =
          _allCapitalSources.where((item) {
            bool nameMatch = AppUtility.fuzzySearch(
              item.tenNguonKinhPhi?.toLowerCase() ?? '',
              searchLower,
            );

            bool staffIdMatch = item.id?.toLowerCase().contains(searchLower) ?? false;
            bool departmentGroup = item.ghiChu?.toLowerCase().contains(
              searchLower,
            ) ?? false;

            return nameMatch || staffIdMatch || departmentGroup;
          }).toList();
      emit(CapitalSourceLoaded(filtered));
    });
    on<AddCapitalSource>((event, emit) async {
      if (state is CapitalSourceLoaded) {
        await provider.addCapitalSource(event.capitalSource);
        add(LoadCapitalSources());
      } else {
        emit(CapitalSourceLoaded([event.capitalSource]));
      }
    });
    on<UpdateCapitalSource>((event, emit) async {
      if (state is CapitalSourceLoaded) {
        await provider.updateCapitalSource(event.capitalSource);
        add(LoadCapitalSources());
      }
    });
    on<DeleteCapitalSource>((event, emit) async {
      if (state is CapitalSourceLoaded) {
        await provider.deleteCapitalSource(event.capitalSource.id ?? '');
        add(LoadCapitalSources());
      }
    });
  }
}
