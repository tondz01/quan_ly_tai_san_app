import 'package:get/get_navigation/get_navigation.dart';

class MyLocale implements Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    "vi_VN": {
      ...vn["COMMON"]!,
      ...vn["TOOLS_AND_SUPPLIES"]!,
      ...vn["ASSET_TRANSFER"]!,
    },
    "en_US": {
      ...en["COMMON"]!,
      ...en["TOOLS_AND_SUPPLIES"]!,
      ...en["ASSET_TRANSFER"]!,
    }
  };

  Map<String, Map<String, String>> vn = {
    "COMMON": {
      "common.search": "Tìm kiếm",
      "common.add": "Thêm mới",
      "common.edit": "Sửa thông tin",
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
      "tas.create_ccdc": "Tạo phiếu nhập ccdc",
    },
    "ASSET_TRANSFER": {
      "at.decision_number": "Số quyết định",
      "at.document_name": "Tên phiếu",
      "at.delivering_unit": "Đơn vị giao",
      "at.receiving_unit": "Đơn vị nhận",
      "at.requester": "Người đề nghị",
      "at.proposing_unit": "Đơn vị đề nghị",
      "at.preparer_initialed": "Người lập phiếu ký nháy",
      "at.require_manager_approval": "Quan trọng, cần TP xác nhận",
      "at.deputy_confirmed": "Phó phòng xác nhận",
      "at.department_approval": "Trình duyệt cấp phòng",
      "at.effective_date": "TGCN từ Ngày",
      "at.effective_date_to": "TGCN đến Ngày",
      "at.approver": "Trình duyệt Ban giám đốc",
      "at.delivery_location": "Địa điểm Giao Nhận",
      "at.rejection_reason": "Lý do từ chối",
      "at.status": "Trạng thái",
      "at.viewer_departments": "Phòng ban được xem phiếu",
      "at.viewerUsers": "Nhân sự được xem phiếu",
    }

  };
  Map<String, Map<String, String>> en = {
    "COMMON": {
      "common.search": "Search",
      "common.add": "Add",
      "common.edit": "Edit information",
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
      "tas.create_ccdc": "Create CCDC",
    },
    "ASSET_TRANSFER": {
      "at.decision_number": "Decision Number",
      "at.document_name": "Document Name",
      "at.delivering_unit": "Delivering Unit",
      "at.requester": "Requester",
      "at.preparer_initialed": "Preparer Initialed",
      "at.require_manager_approval": "Important, need TP confirmation",
      "at.deputy_confirmed": "Deputy confirmed",
      "at.receiving_unit": "Requesting Unit",
      "at.department_approval": "Department Approval",
      "at.effective_date": "Effective Date",
      "at.effective_date_to": "Effective Date to",
      "at.approver": "Approver",
      "at.delivery_location": "Delivery Location",
      "at.rejection_reason": "Rejection Reason",
      "at.status": "Status",
      "at.viewer_departments": "Viewer Departments",
      "at.viewerUsers": "Viewer Users",
      "at.is_effective": "Effective",
    }
  };
}
