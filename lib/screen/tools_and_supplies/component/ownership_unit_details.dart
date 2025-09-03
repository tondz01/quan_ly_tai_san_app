import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/diagram/thread_lines.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/tools_and_supplies_dto.dart';

class OwnershipUnitDetails extends StatefulWidget {
  final String title;
  final ToolsAndSuppliesDto item;

  const OwnershipUnitDetails({
    super.key,
    required this.title,
    required this.item,
  });

  @override
  State<OwnershipUnitDetails> createState() => _OwnershipUnitDetailsState();
}

class _OwnershipUnitDetailsState extends State<OwnershipUnitDetails> {
  List<ThreadNode> listSignatoryDetail = [];

  
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
