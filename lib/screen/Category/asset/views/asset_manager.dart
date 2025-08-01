import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/screen/category/asset/models/asset.dart';
import 'package:quan_ly_tai_san_app/screen/category/asset/pages/asset_form_page.dart';
import 'package:quan_ly_tai_san_app/screen/category/asset/pages/asset_list_page.dart';

class AssetManager extends StatefulWidget {
  const AssetManager({super.key});

  @override
  State<AssetManager> createState() => _AssetManagerState();
}

class _AssetManagerState extends State<AssetManager> {
  bool showForm = false;
  AssetDTO? editingAsset;

  void _showForm([AssetDTO? asset]) {
    setState(() {
      showForm = true;
      editingAsset = asset;
    });
  }

  void _showList() {
    setState(() {
      showForm = false;
      editingAsset = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showForm) {
      return AssetFormPage(
        asset: editingAsset,
        key: ValueKey(editingAsset?.assetId ?? 'new'),
        onCancel: _showList,
        onSaved: _showList,
      );
    } else {
      return AssetListPage(
        onAdd: () => _showForm(),
        onEdit: (asset) => _showForm(asset),
      );
    }
  }
} 