import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/screen/home/scroll_controller.dart';

class FixedAssetTable extends StatelessWidget {
  const FixedAssetTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(color: Colors.black, width: 1.0),
      // Define 14 columns with equal flexible widths
      columnWidths: const <int, TableColumnWidth>{
        0: FlexColumnWidth(),
        1: FlexColumnWidth(),
        2: FlexColumnWidth(),
        3: FlexColumnWidth(),
        4: FlexColumnWidth(),
        5: FlexColumnWidth(),
        6: FlexColumnWidth(),
        7: FlexColumnWidth(),
        8: FlexColumnWidth(),
        9: FlexColumnWidth(),
        10: FlexColumnWidth(),
        11: FlexColumnWidth(),
        12: FlexColumnWidth(),
        13: FlexColumnWidth(),
      },
      children: [
        // Data Row with 14 cells
        const TableRow(
          children: [
            TableCell(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('STT'),
                ),
              ),
            ),
            TableCell(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Số hiệu'),
                ),
              ),
            ),
            TableCell(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Ngày tháng'),
                ),
              ),
            ),
            TableCell(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Đặc điểm ký hiệu TSCĐ'),
                ),
              ),
            ),
            TableCell(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Nước sản xuất'),
                ),
              ),
            ),
            TableCell(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Tháng năm đưa vào sử dụng'),
                ),
              ),
            ),
            TableCell(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Số hiệu TSCĐ'),
                ),
              ),
            ),
            TableCell(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Nguyên giá TSCĐ'),
                ),
              ),
            ),
            TableCell(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Tỉ  lệ % khấu hao'),
                ),
              ),
            ),
            TableCell(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Mức khấu hao'),
                ),
              ),
            ),
            TableCell(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Khấu hao đã tính khi giảm TSCĐ'),
                ),
              ),
            ),
            TableCell(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Chứng từ số hiệu'),
                ),
              ),
            ),
            TableCell(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Chứng từ ngày'),
                ),
              ),
            ),
            TableCell(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Lý do giảm TSCĐ'),
                ),
              ),
            ),
          ],
        ),

        const TableRow(
          children: [
            TableCell(
              child: Center(
                child: Padding(padding: EdgeInsets.all(8.0), child: Text('')),
              ),
            ),
            TableCell(
              child: Center(
                child: Padding(padding: EdgeInsets.all(8.0), child: Text('')),
              ),
            ),
            TableCell(
              child: Center(
                child: Padding(padding: EdgeInsets.all(8.0), child: Text('')),
              ),
            ),
            TableCell(
              child: Center(
                child: Padding(padding: EdgeInsets.all(8.0), child: Text('')),
              ),
            ),
            TableCell(
              child: Center(
                child: Padding(padding: EdgeInsets.all(8.0), child: Text('')),
              ),
            ),
            TableCell(
              child: Center(
                child: Padding(padding: EdgeInsets.all(8.0), child: Text('')),
              ),
            ),
            TableCell(
              child: Center(
                child: Padding(padding: EdgeInsets.all(8.0), child: Text('')),
              ),
            ),
            TableCell(
              child: Center(
                child: Padding(padding: EdgeInsets.all(8.0), child: Text('')),
              ),
            ),
            TableCell(
              child: Center(
                child: Padding(padding: EdgeInsets.all(8.0), child: Text('')),
              ),
            ),
            TableCell(
              child: Center(
                child: Padding(padding: EdgeInsets.all(8.0), child: Text('')),
              ),
            ),
            TableCell(
              child: Center(
                child: Padding(padding: EdgeInsets.all(8.0), child: Text('')),
              ),
            ),
            TableCell(
              child: Center(
                child: Padding(padding: EdgeInsets.all(8.0), child: Text('')),
              ),
            ),
            TableCell(
              child: Center(
                child: Padding(padding: EdgeInsets.all(8.0), child: Text('')),
              ),
            ),
            TableCell(
              child: Center(
                child: Padding(padding: EdgeInsets.all(8.0), child: Text('')),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class SoTaiSanCoDinh200 extends StatefulWidget {
  const SoTaiSanCoDinh200({super.key});

  @override
  State<SoTaiSanCoDinh200> createState() => _SoTaiSanCoDinh200State();
}

class _SoTaiSanCoDinh200State extends State<SoTaiSanCoDinh200> {
  late HomeScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = HomeScrollController();
    _scrollController.addListener((_onScrollStateChanged));
  }

  void _onScrollStateChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollStateChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics:
          _scrollController.isParentScrolling
              ? const NeverScrollableScrollPhysics() // Parent đang cuộn => ngăn child cuộn
              : const BouncingScrollPhysics(), // Parent đã cuộn hết => cho phép child cuộn
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Header Section
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Đơn vị: ...........................'),
                  Text('Địa chỉ: ............................'),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text('Mẫu số S21-DN'),
                  Text('(Ban hành theo Thông tư số 200/2014/TT-BTC'),
                  Text('Ngày 22/12/2014 của Bộ Tài chính)'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Title Section
          const Center(
            child: Column(
              children: <Widget>[
                Text(
                  'Sổ tài sản cố định',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text('Năm: .................'),
                Text('Loại tài sản: ..................'),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Main Table (using the more flexible Table widget)
          const FixedAssetTable(),
          const SizedBox(height: 20),

          // Footer Section
          const Text(
            '- Sổ này có ... trang, đánh số từ trang 01 đến trang ...',
          ),
          const Text('- Ngày mở sổ: ...'),
          const SizedBox(height: 40),

          // Signature Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Column(
                children: <Widget>[Text('Người ghi sổ'), Text('(Ký, họ tên)')],
              ),
              const Column(
                children: <Widget>[
                  Text('Kế toán trưởng'),
                  Text('(Ký, họ tên)'),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  const Text('Ngày ... tháng ... năm ...'),
                  const Text('Giám đốc'),
                  const Text('(Ký, họ tên, đóng dấu)'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
