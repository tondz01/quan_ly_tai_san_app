import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/diagram/thread_lines.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/component/department_tree_demo.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/ownership_unit_detail_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/tools_and_supplies_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/provider/tools_and_supplies_provide.dart';
import 'package:se_gay_components/common/sg_text.dart';

class OwnershipUnitDetails extends StatefulWidget {
  final String title;
  final ToolsAndSuppliesDto item;
  final ToolsAndSuppliesProvider provider;
  final Function()? onHiden;

  const OwnershipUnitDetails({
    super.key,
    required this.title,
    required this.item,
    required this.provider,
    this.onHiden,
  });

  @override
  State<OwnershipUnitDetails> createState() => _OwnershipUnitDetailsState();
}

class _OwnershipUnitDetailsState extends State<OwnershipUnitDetails> {
  List<ThreadNode> listSignatoryDetail = [];

  @override
  void initState() {
    super.initState();
    listSignatoryDetail = _buildThreadNodes();
  }

  @override
  void didUpdateWidget(OwnershipUnitDetails oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.item != oldWidget.item) {
      listSignatoryDetail = _buildThreadNodes();
    }
  }

  List<ThreadNode> _buildThreadNodes() {
    List<ThreadNode> nodes = [];

    // Tạo danh sách ThreadNode theo từng cụm chiTietTaiSanList
    for (var chiTiet in widget.item.chiTietTaiSanList) {
      // Thêm ThreadNode cho chiTietTaiSanList
      nodes.add(
        ThreadNode(
          header: '${chiTiet.id} -- NSX: ${chiTiet.namSanXuat}',
          colorHeader: ColorValue.brightRed,
          depth: 0,
          child: Container(),
        ),
      );

      // Tìm các detailOwnershipUnit tương ứng với chiTietTaiSanList này
      var relatedOwnershipUnits =
          widget.item.detailOwnershipUnit
              .where((e) => e.idTsCon == chiTiet.id)
              .toList();

      // Thêm các ThreadNode cho detailOwnershipUnit tương ứng
      for (var ownershipUnit in relatedOwnershipUnits) {
        nodes.add(
          ThreadNode(
            header:
                widget.provider
                    .getPhongBanByID(ownershipUnit.idDonViSoHuu)
                    .tenPhongBan
                    .toString(),
            depth: 1,
            child: _buildInfoOwnershipUnit(ownershipUnit),
          ),
        );
      }
    }

    // Nếu không có chiTietTaiSanList, hiển thị tất cả detailOwnershipUnit
    if (widget.item.chiTietTaiSanList.isEmpty &&
        widget.item.detailOwnershipUnit.isNotEmpty) {
      for (var ownershipUnit in widget.item.detailOwnershipUnit) {
        nodes.add(
          ThreadNode(
            header:
                widget.provider
                    .getPhongBanByID(ownershipUnit.idDonViSoHuu)
                    .tenPhongBan
                    .toString(),
            depth: 1,
            child: _buildInfoOwnershipUnit(ownershipUnit),
          ),
        );
      }
    }

    return nodes;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: Colors.grey.shade600, width: 1)),
      ),
      child: DetailedDiagram(
        title: widget.title,
        sample: listSignatoryDetail,
        onHiden: widget.onHiden,
      ),
    );
  }

  Widget _buildInfoOwnershipUnit(OwnershipUnitDetailDto item) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 3,
        children: [
          SGText(
            text: 'Mã chi tiết CCDC - Vật tư: ${item.idTsCon}',
            size: 13,
            color: ColorValue.primaryBlue,
          ),
          SGText(
            text: 'Số lượng đang sở hữu: ${item.soLuong}',
            size: 13,
            color: ColorValue.mediumGreen
          ),
          SGText(
            text: 'Thời gian ban giao: ${item.thoiGianBanGiao}',
            size: 13,
            color: ColorValue.darkGrey,
          ),
        ],
      ),
    );
  }
}
