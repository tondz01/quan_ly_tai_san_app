// ignore_for_file: constant_identifier_names

abstract class FunctionType {
  static const int ASSET_TRANSFER = 1;
  static const int ASSET_HANDOVER = 2;
  static const int TOOL_AND_MATERIAL_TRANSFER = 3;
  static const int TOOL_AND_SUPPLIES_HANDOVER = 4;
  static const int ALL_FUNCTION = 5;
}

abstract class ActionType {
  static const int CREATE = 1;
  static const int UPDATE = 2;
  static const int DELETE = 3;
}