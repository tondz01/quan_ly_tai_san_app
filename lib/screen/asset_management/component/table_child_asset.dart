import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/table/sg_editable_table.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/asset_management_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/child_assets_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/provider/asset_management_provider.dart';
import 'package:se_gay_components/common/sg_text.dart';

Widget tableChildAsset({
  required BuildContext context,
  required List<ChildAssetDto> childAssets,
  required bool isEditing,
  required AssetManagementProvider provider,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: const SGText(
          text: 'Chi tiết tài sản điều chuyển: ',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          textAlign: TextAlign.start,
        ),
      ),
      table(childAssets, isEditing, provider),
    ],
  );
}

Widget table(
  List<ChildAssetDto> childAssets,
  bool isEditing,
  AssetManagementProvider provider,
) {
  List<AssetManagementDto> getAssetsByChildAssets(
    List<AssetManagementDto> allAssets,
    List<ChildAssetDto> childAssets,
  ) {
    // Map nhanh id -> Asset
    final Map<String, AssetManagementDto> idToAsset = {
      for (final a in allAssets)
        if (a.id != null) a.id!: a,
    };

    // Duyệt theo thứ tự child, loại trùng idTaiSan
    final result = <AssetManagementDto>[];
    final seen = <String>{};
    for (final c in childAssets) {
      final id = c.idTaiSan;
      if (id != null && seen.add(id)) {
        final asset = idToAsset[id];
        if (asset != null) result.add(asset);
      }
    }
    return result;
  }

  // String infoTaiSan(String assetId) {
  //   String nameTaiSan =
  //       provider.getInfoAssetByChildAsset(assetId)?.tenTaiSan ?? '';
  //   String maTaiSan = provider.getInfoAssetByChildAsset(assetId)?.id ?? '';
  //   return '$maTaiSan - $nameTaiSan';
  // }

  List<AssetManagementDto> listAsset = provider.data;
  return Container(
    decoration: BoxDecoration(
      // border: hasError ? Border.all(color: Colors.red) : null,
      borderRadius: BorderRadius.circular(4),
    ),
    padding: const EdgeInsets.only(left: 10, top: 15),
    child: SgEditableTable<AssetManagementDto>(
      initialData: getAssetsByChildAssets(listAsset, childAssets),
      createEmptyItem: AssetManagementDto.empty,
      rowHeight: 40.0,
      headerBackgroundColor: Colors.grey.shade50,
      oddRowBackgroundColor: Colors.white,
      evenRowBackgroundColor: Colors.white,
      showVerticalLines: false,
      showHorizontalLines: true,
      addRowText: 'Thêm một dòng',
      isEditing: isEditing, // Pass the editing state
      onDataChanged: (data) {
        // log('data: ${jsonEncode(data)}');
      },
      columns: [
      
        SgEditableColumn<AssetManagementDto>(
          field: 'asset',
          title: 'Tài sản',
          titleAlignment: TextAlign.center,
          width: 250,
          getValue: (item) => item,
          setValue: (item, value) {
            if (value is AssetManagementDto) {
              item.id = value.id;
              item.tenTaiSan = value.tenTaiSan;
              item.idDonViHienThoi = value.idDonViHienThoi;
            }
          },
          sortValueGetter: (item) => item.tenTaiSan,
          isCellEditableDecider: (item, rowIndex) => true,
          editor: EditableCellEditor.dropdown,
          dropdownItems: [
            for (var element in provider.data)
              DropdownMenuItem<AssetManagementDto>(
                value: element,
                child: Text(element.tenTaiSan ?? ''),
              ),
          ],
          // displayStringForOption: (item) => item.tenTaiSan ?? '',
          onValueChanged: (item, rowIndex, newValue, updateRow) {
            if (newValue is AssetManagementDto) {
              updateRow('id_child_asset', newValue.id);
              updateRow('asset', '${newValue.id} - ${newValue.tenTaiSan}');
              updateRow('donViHienThoi', newValue.idDonViHienThoi);
            }
          },
        ),
        SgEditableColumn<AssetManagementDto>(
          field: 'id_child_asset',
          title: 'Mã tài sản',
          titleAlignment: TextAlign.center,
          width: 130,
          getValue: (item) => item.id,
          setValue: (item, value) => item.id = value,
          sortValueGetter: (item) => item.id,
          isEditable: false,
        ),
        SgEditableColumn<AssetManagementDto>(
          field: 'asset',
          title: 'Tài sản',
          titleAlignment: TextAlign.center,
          width: 120,
          getValue: (item) => '${item.id} - ${item.tenTaiSan}',
          setValue: (item, value) {
            // Không làm gì khi giá trị được đặt, vì đây là trường readonly
          },
          sortValueGetter: (item) => '${item.id} - ${item.tenTaiSan}',
          isEditable: false,
        ),
        SgEditableColumn<AssetManagementDto>(
          field: 'donViHienThoi',
          title: 'Đơn vị hiện thời',
          titleAlignment: TextAlign.center,
          width: 190,
          getValue: (item) => item.idDonViHienThoi,
          setValue: (item, value) => item.idDonViHienThoi = value,
          sortValueGetter: (item) => item.idDonViHienThoi,
          isEditable: false,
        ),
      ],
    ),
  );
}
