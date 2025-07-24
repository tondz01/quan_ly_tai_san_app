import 'package:get/get_navigation/get_navigation.dart';

class MyLocale implements Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    "vn": {
      ...en["COMMON"]!,
      ...vn["TOOLS_AND_SUPPLIES"]!,
    },
    "en": {
      ...en["COMMON"]!,
      ...en["TOOLS_AND_SUPPLIES"]!,
    }
  };

  Map<String, Map<String, String>> vn = {
    "COMMON": {
      "common.search": "Tìm kiếm",
      "common.add": "Thêm mới",
      "common.edit": "Sửa",
      "common.delete": "Xóa",
      "common.detail": "Chi tiết",
      "common.export": "Xuất",
      "common.hint": "Nhập dữ liệu",
    },    
    "TOOLS_AND_SUPPLIES": {
      // "tas.title": "Công cụ và dụng cụ",
      "tas.import_unit": "Đơn vị nhập",
      "tas.name": "Tên Công cụ dụng cụ",
      "tas.code": "Mã công cụ dụng cụ",
      "tas.import_date": "Ngày nhập",
      "tas.unit": "Đơn vị tính",
      "tas.quantity": "Số lượng",
      "tas.value": "Giá trị",
      "tas.reference_number": "Số ký hiệu",
      "tas.symbol": "Ký hiệu",
      "tas.capacity": "Công suất",
      "tas.country_of_origin": "Nước sản xuất",
      "tas.year_of_manufacture": "Năm sản xuất",
      "tas.note": "Ghi chú",
      "tas.info_tools_supplies": "Thông tin công cụ dụng cụ - Vật tư",
    }
  };
  Map<String, Map<String, String>> en = {
    "COMMON": {
      "common.search": "Search",
      "common.add": "Add",
      "common.edit": "Edit",
      "common.delete": "Delete",
      "common.detail": "Detail",
      "common.export": "Export",
      "common.hint": "Enter data",
    },
    "TOOLS_AND_SUPPLIES": {
      // "tas.title": "Tools and Supplies",
      "tas.import_unit": "Import Unit",
      "tas.name": "Tool Name",
      "tas.code": "Tool Code",
      "tas.import_date": "Import Date",
      "tas.unit": "Unit",
      "tas.quantity": "Quantity",
      "tas.value": "Value",
      "tas.reference_number": "Reference Number",
      "tas.symbol": "Symbol",
      "tas.capacity": "Capacity",
      "tas.country_of_origin": "Country of Origin",
      "tas.year_of_manufacture": "Year of Manufacture",
      "tas.note": "Note",
      "tas.info_tools_supplies": "Tools and Supplies Information",
    }
  };
}
