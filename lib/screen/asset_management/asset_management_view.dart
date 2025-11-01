import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart' as provider;
import 'package:quan_ly_tai_san_app/common/components/loading_overlay.dart';
import 'package:quan_ly_tai_san_app/common/page/common_page_view.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/bloc/asset_management_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/bloc/asset_management_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/bloc/asset_management_state.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/component/optimized_validation_asset.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/provider/asset_management_provider.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/repository/asset_management_repository.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/widget/asset_depreciation_detail.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/widget/asset_depreciation_list.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/widget/asset_detail.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/widget/asset_management_list.dart';
import 'package:quan_ly_tai_san_app/common/components/header_component.dart';
import 'package:quan_ly_tai_san_app/screen/home/scroll_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AssetManagementView extends StatefulWidget {
  const AssetManagementView({super.key});

  @override
  State<AssetManagementView> createState() => _AssetManagementViewState();
}

class _AssetManagementViewState extends State<AssetManagementView> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _searchKhauHaoController =
      TextEditingController();
  String searchTerm = "";
  bool isShowKhauHao = false;

  String loadingMessage = 'Đang tải dữ liệu...';

  late HomeScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = HomeScrollController();
    _scrollController.addListener((_onScrollStateChanged));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.Provider.of<AssetManagementProvider>(
        context,
        listen: false,
      ).onInit(context);
    });
  }

  void _onScrollStateChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_onScrollStateChanged);
    _searchController.dispose();
    _searchKhauHaoController.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.Provider.of<AssetManagementProvider>(
        context,
        listen: false,
      ).onInit(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: BlocConsumer<AssetManagementBloc, AssetManagementState>(
        builder: (context, state) {
          return provider.ChangeNotifierProvider.value(
            value: context.read<AssetManagementProvider>(),
            child: provider.Consumer<AssetManagementProvider>(
              builder: (context, provider, child) {
                // if (provider.isLoading) {
                //   return const Center(child: CircularProgressIndicator());
                // }
                // if (provider.data == null) {
                //   return const Center(child: Text('Đang tải dữ liệu ...'));
                // }

                return LoadingOverlay(
                  isLoading: provider.isLoadingImport,
                  message: loadingMessage,
                  child: Scaffold(
                    backgroundColor: ColorValue.neutral50,
                    appBar: AppBar(
                      title: HeaderComponent(
                        isBlockInput: provider.isLoadingImport,
                        controller:
                            provider.typeBody == ShowBody.taiSan
                                ? _searchController
                                : _searchKhauHaoController,
                        onSearchChanged: (value) {},
                        isShowSearch: false,
                        onTap: () {
                          // provider.onChangeDetailAssetManagement(null);
                          provider.onChangeBody(ShowBody.taiSan, context);
                        },
                        onNew: () {
                          // provider.onChangeDetailAssetManagement(null);
                          if (!provider.isCanCreate) {
                            AppUtility.showSnackBar(
                              context,
                              'Bạn không có quyền tạo tài sản',
                            );
                            return;
                          }
                          if (provider.typeBody == ShowBody.taiSan) {
                            provider.onChangeDetail(null, isNew: true);
                          }
                        },
                        mainScreen: "Quản lý tài sản",
                        subScreen: provider.subScreen,
                        onFileSelected: (fileName, filePath, fileBytes) async {
                          loadingMessage = 'Đang import dữ liệu...';
                          provider.onLoadingImport(true);
                          
                          try {
                            // Optimized single-pass import: validate and convert in one go
                            final (success, assets, _) = await importAssetsOptimized(
                              bytes: fileBytes,
                              filePath: filePath,
                              context: context,
                              onProgress: (current, total) {
                                // Update loading message with import progress
                                setState(() {
                                  loadingMessage = 'Đang import dữ liệu... ($current/$total)';
                                });
                              },
                            );
                            
                            if (!success) {
                              provider.onLoadingImport(false);
                              return;
                            }
                            
                            // Process assets in batches to avoid blocking UI
                            final batchSize = 100; // Upload 100 assets per batch
                            final totalBatches = (assets.length / batchSize).ceil();
                            
                            for (int batchIndex = 0; batchIndex < totalBatches; batchIndex++) {
                              final start = batchIndex * batchSize;
                              final end = (start + batchSize).clamp(0, assets.length);
                              final batch = assets.sublist(start, end);
                              
                              // Update progress message
                              setState(() {
                                loadingMessage = 'Đang lưu dữ liệu... Batch ${batchIndex + 1}/$totalBatches (${end}/${assets.length})';
                              });
                              
                              // Upload batch via repository
                              final repository = AssetManagementRepository();
                              final result = await repository.createAssetBatch(batch);
                              
                              // Check if batch upload succeeded
                              if (result['status_code'] != 200 && result['status_code'] != 201) {
                                // If one batch fails, show error but continue
                                AppUtility.showSnackBar(
                                  context,
                                  'Batch ${batchIndex + 1} thất bại: ${result['message'] ?? 'Lỗi không xác định'}',
                                  isError: true,
                                );
                              }
                              
                              // Small delay between batches
                              await Future.delayed(Duration(milliseconds: 100));
                            }
                            
                            // Refresh data after successful import
                            final assetBloc = context.read<AssetManagementBloc>();
                            final idCongTy = 'ct001'; // Get from context/provider
                            assetBloc.add(GetListAssetManagementEvent(context, idCongTy));
                            
                            AppUtility.showSnackBar(
                              context,
                              'Import thành công ${assets.length} tài sản',
                              isError: false,
                            );
                            
                          } catch (e) {
                            AppUtility.showSnackBar(
                              context,
                              'Lỗi khi import dữ liệu: $e',
                              isError: true,
                            );
                          } finally {
                            provider.onLoadingImport(false);
                          }
                        },
                        onExportData: () {
                          loadingMessage = 'Đang xuất dữ liệu...';
                          provider.onLoadingImport(true);
                          AppUtility.exportData(
                            context,
                            "tai_san",
                            provider.data
                                    ?.map((e) => e.toExportJson())
                                    .toList() ??
                                [],
                          );
                          provider.onLoadingImport(false);
                        },
                        isShowInput:
                            provider.typeBody == ShowBody.taiSan ? true : false,
                        isShownew:
                            provider.typeBody == ShowBody.taiSan ? true : false,
                      ),
                    ),
                    body: Column(
                      children: [
                        provider.typeBody == ShowBody.taiSan
                            ? Flexible(
                              child: NotificationListener<ScrollNotification>(
                                onNotification: (notification) {
                                  return true; // Xử lý scroll event bình thường
                                },
                                child: SingleChildScrollView(
                                  // padding: const EdgeInsets.all(24),
                                  physics:
                                      _scrollController.isParentScrolling
                                          ? const NeverScrollableScrollPhysics() // Parent đang cuộn => ngăn child cuộn
                                          : const BouncingScrollPhysics(), // Parent đã cuộn hết => cho phép child cuộn
                                  scrollDirection: Axis.vertical,
                                  child: CommonPageView(
                                    childInput: AssetDetail(provider: provider),
                                    childTableView: AssetManagementList(
                                      provider: provider,
                                    ),
                                    title: "Tạo tài sản",
                                    isShowInput: provider.isShowInput,
                                    isShowCollapse: provider.isShowCollapse,
                                    onExpandedChanged: (isExpanded) {
                                      provider.isShowCollapse = isExpanded;
                                    },
                                  ),
                                ),
                              ),
                            )
                            : Flexible(
                              child: NotificationListener<ScrollNotification>(
                                onNotification: (notification) {
                                  return true; // Xử lý scroll event bình thường
                                },
                                child: SingleChildScrollView(
                                  physics:
                                      _scrollController.isParentScrolling
                                          ? const NeverScrollableScrollPhysics() // Parent đang cuộn => ngăn child cuộn
                                          : const BouncingScrollPhysics(), // Parent đã cuộn hết => cho phép child cuộn
                                  scrollDirection: Axis.vertical,
                                  child: CommonPageView(
                                    childInput: AssetDepreciationDetail(
                                      provider: provider,
                                    ),
                                    childTableView: AssetDepreciationList(
                                      provider: provider,
                                    ),
                                    title: "Chi tiết khấu hao tài sản",
                                    isShowInput: provider.isShowInputKhauHao,
                                    isShowCollapse:
                                        provider.isShowCollapseKhauHao,
                                    onExpandedChanged: (isExpanded) {
                                      provider.isShowCollapseKhauHao =
                                          isExpanded;
                                    },
                                  ),
                                ),
                              ),
                            ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
        listener: (context, state) {
          if (state is AssetManagementLoadingState) {
            // Mostrar loading
          }
          if (state is GetListAssetManagementSuccessState) {
            context
                .read<AssetManagementProvider>()
                .getListAssetManagementSuccess(context, state);
          }
          if (state is GetListAssetManagementFailedState) {
            // Manejar error
            log('GetListAssetManagementFailedState');
            // context.read<AssetManagementProvider>().getListAssetManagementFailed(
            //   context,
            //   state,
            // );
          }
          if (state is GetListChildAssetsSuccessState) {
            context.read<AssetManagementProvider>().getListChildAssetsSuccess(
              context,
              state,
            );
          }
          if (state is GetListChildAssetsFailedState) {
            log('GetListChildAssetsFailedState');
          }
          if (state is GetListKhauHaoSuccessState) {
            context.read<AssetManagementProvider>().getListKhauHaoSuccess(
              context,
              state,
            );
          }
          if (state is GetListKhauHaoFailedState) {
            log('GetListChildAssetsFailedState');
          }
          if (state is GetListAssetGroupFailedState) {
            log('GetListAssetGroupFailedState');
          }
          if (state is GetListProjectSuccessState) {
            context.read<AssetManagementProvider>().getListProjectSuccess(
              context,
              state,
            );
          }
          if (state is GetListKhauHaoFailedState) {
            log('GetListProjectFailedState');
          }
          if (state is GetListCapitalSourceSuccessState) {
            context.read<AssetManagementProvider>().getListCapitalSourceSuccess(
              context,
              state,
            );
          }
          if (state is GetListCapitalSourceFailedState) {
            log('GetListCapitalSourceFailedState');
          }
          if (state is GetListDepartmentSuccessState) {
            context.read<AssetManagementProvider>().getListDepartmentSuccess(
              context,
              state,
            );
          }
          if (state is GetListDepartmentFailedState) {
            log('Error at GetListDepartmentFailedState: ${state.message}');
          }
          if (state is GetAllChildAssetsSuccessState) {
            context.read<AssetManagementProvider>().getAllChildAssetsSuccess(
              context,
              state,
            );
          }
          if (state is CreateAssetFailedState) {
            log('CreateAssetFailedState');
            context.read<AssetManagementProvider>().createAssetError(
              context,
              state,
            );
          }
          if (state is GetAllChildAssetsFailedState) {
            log('GetAllChildAssetsFailedState');
          }
          if (state is CreateAssetSuccessState) {
            context.read<AssetManagementProvider>().createAssetSuccess(
              context,
              state,
            );
          }
          if (state is DeleteAssetSuccessState) {
            log('DeleteAssetSuccessState');
            context.read<AssetManagementProvider>().deleteAssetSuccess(
              context,
              state,
            );
          }
          if (state is UpdateAssetSuccessState) {
            context.read<AssetManagementProvider>().updateAssetSuccess(
              context,
              state,
            );
          }
          if (state is UpdateAndDeleteAssetFailedState) {
            log('DeleteAssetFailedState');
            AppUtility.showSnackBar(context, state.message);
          }
        },
      ),
    );
  }
}
