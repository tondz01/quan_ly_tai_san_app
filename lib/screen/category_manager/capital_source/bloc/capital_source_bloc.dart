import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/utils/check_status_code_done.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/capital_source/bloc/capital_source_event.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/capital_source/bloc/capital_source_state.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/capital_source/constants/capital_source_constants.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/capital_source/models/capital_source.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/capital_source/providers/capital_source_provider.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class CapitalSourceBloc extends Bloc<CapitalSourceEvent, CapitalSourceState> {
  List<NguonKinhPhi> _allCapitalSources = [];
  final provider = CapitalSourceProvider();
  CapitalSourceBloc() : super(CapitalSourceInitial()) {
    on<LoadCapitalSources>((event, emit) async {
      emit(CapitalSourceLoading());
      try {
        _allCapitalSources = await provider.fetchCapitalSources();
        emit(CapitalSourceLoaded(_allCapitalSources));
      } catch (e) {
        SGLog.error('CapitalSourceBloc', 'LoadCapitalSources error: $e');
        emit(CapitalSourceError(CapitalSourceConstants.errorLoadCapitalSources));
      }
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
      try {
        final result = await provider.addCapitalSource(event.capitalSource);
        if (checkStatusCodeDone(result)) {
          emit(AddCapitalSourceSuccess(CapitalSourceConstants.successAddCapitalSource));
          add(LoadCapitalSources());
        } else {
          emit(CapitalSourceError(result['message'] ?? CapitalSourceConstants.errorAddCapitalSource));
        }
      } catch (e) {
        SGLog.error('CapitalSourceBloc', 'AddCapitalSource error: $e');
        emit(CapitalSourceError(CapitalSourceConstants.errorAddCapitalSource));
      }
    });
    on<UpdateCapitalSource>((event, emit) async {
      try {
        final result = await provider.updateCapitalSource(event.capitalSource);
        if (checkStatusCodeDone(result)) {
          emit(UpdateCapitalSourceSuccess(CapitalSourceConstants.successUpdateCapitalSource));
          add(LoadCapitalSources());
        } else {
          emit(CapitalSourceError(result['message'] ?? CapitalSourceConstants.errorUpdateCapitalSource));
        }
      } catch (e) {
        SGLog.error('CapitalSourceBloc', 'UpdateCapitalSource error: $e');
        emit(CapitalSourceError(CapitalSourceConstants.errorUpdateCapitalSource));
      }
    });
    on<DeleteCapitalSource>((event, emit) async {
      try {
        final result = await provider.deleteCapitalSource(event.capitalSource.id ?? '');
        if (checkStatusCodeDone(result)) {
          emit(DeleteCapitalSourceSuccess(CapitalSourceConstants.successDeleteCapitalSource));
          add(LoadCapitalSources());
        } else {
          emit(CapitalSourceError(result['message'] ?? CapitalSourceConstants.errorDeleteCapitalSource));
        }
      } catch (e) {
        SGLog.error('CapitalSourceBloc', 'DeleteCapitalSource error: $e');
        emit(CapitalSourceError(CapitalSourceConstants.errorDeleteCapitalSource));
      }
    });
    on<DeleteCapitalSourceBatch>((event, emit) async {
      try {
        final result = await provider.deleteCapitalSourceBatch(event.data);
        if (checkStatusCodeDone(result)) {
          emit(DeleteCapitalSourceBatchSuccess());
          add(LoadCapitalSources());
        } else if (result['status_code'] == 207) {
          // Partial success - still reload data but show warning
          emit(DeleteCapitalSourceBatchSuccess());
          add(LoadCapitalSources());
        } else {
          emit(DeleteCapitalSourceBatchFailure(result['message'] ?? CapitalSourceConstants.errorDeleteCapitalSource));
        }
      } catch (e) {
        SGLog.error('CapitalSourceBloc', 'DeleteCapitalSourceBatch error: $e');
        emit(DeleteCapitalSourceBatchFailure(CapitalSourceConstants.errorDeleteCapitalSource));
      }
    });
  }
}
