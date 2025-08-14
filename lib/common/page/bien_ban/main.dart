
import 'bien_ban_doi_chieu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hợp Đồng Web',
      debugShowCheckedModeBanner: false,
      home: const Scaffold(body: AssetTableSwitcher()),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: ThemeData.light().textTheme.apply(
          bodyColor: Colors.black,
          displayColor: Colors.black,
        ),
      ),
    );
  }
}

class AssetTableSwitcher extends StatefulWidget {
  const AssetTableSwitcher({super.key});

  @override
  State<AssetTableSwitcher> createState() => _AssetTableSwitcherState();
}

class _AssetTableSwitcherState extends State<AssetTableSwitcher> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    Widget? currentTable;
    switch (_selected) {
      case 0:
        currentTable = bienBanDoiChieuKiemKe();
        break;
      case 1:
        currentTable = bienBanKiemKe();
        break;
      case 2:
        currentTable = soTaiSanCoDinh();
        break;
      case 3:
        currentTable = soTaiSanCoDinhThongTu200();
        break;
      case 4:
        currentTable = soTheoDoi();
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dropdown chọn bảng
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton<int>(
            value: _selected,
            items: const [
              DropdownMenuItem(
                value: 0,
                child: Text('Biên bản đối chiếu kiểm kê'),
              ),
              DropdownMenuItem(
                value: 1,
                child: Text('Biên bản kiẻm kê'),
              ),
              DropdownMenuItem(
                value: 2,
                child: Text('Sổ tài sản cố định'),
              ),
              DropdownMenuItem(
                value: 3,
                child: Text('Sổ tài sản cố định thông tư 200'),
              ),
              DropdownMenuItem(
                value: 4,
                child: Text('Sổ theo dõi'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selected = value;
                });
              }
            },
          ),
        ),

        // Hiển thị bảng
        Expanded(child: SingleChildScrollView(child: currentTable)),
      ],
    );
  }
}
