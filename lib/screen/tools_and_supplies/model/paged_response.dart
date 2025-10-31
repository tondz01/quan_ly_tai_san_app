class PagedResponse<T> {
  final List<T> data;
  final int totalElements;
  final int totalPages;
  final int currentPage;
  final int size;
  final bool first;
  final bool last;

  PagedResponse({
    required this.data,
    required this.totalElements,
    required this.totalPages,
    required this.currentPage,
    required this.size,
    required this.first,
    required this.last,
  });

  factory PagedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    // Handle different response structures - prioritize 'items' (new API structure)
    List<T> dataList = [];

    if (json['items'] != null && json['items'] is List) {
      // New API structure: uses 'items'
      dataList =
          (json['items'] as List)
              .map((item) => fromJsonT(Map<String, dynamic>.from(item)))
              .toList();
    } else if (json['content'] != null && json['content'] is List) {
      // Spring Boot pagination structure: uses 'content'
      dataList =
          (json['content'] as List)
              .map((item) => fromJsonT(Map<String, dynamic>.from(item)))
              .toList();
    } else if (json['data'] != null && json['data'] is List) {
      // Alternative structure: uses 'data'
      dataList =
          (json['data'] as List)
              .map((item) => fromJsonT(Map<String, dynamic>.from(item)))
              .toList();
    }

    // Parse pagination info - prioritize new API structure
    final totalItems =
        json['totalItems'] ??
        json['totalElements'] ??
        json['total'] ??
        json['totalCount'] ??
        0;
    final page = json['page'] ?? json['number'] ?? json['currentPage'] ?? 0;
    final pageSize = json['size'] ?? json['pageSize'] ?? 20;
    final totalPageCount = json['totalPages'] ?? json['totalPage'] ?? 1;

    return PagedResponse<T>(
      data: dataList,
      totalElements: totalItems,
      totalPages: totalPageCount,
      currentPage: page,
      size: pageSize,
      first: json['first'] ?? (page == 0),
      last: json['last'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'totalElements': totalElements,
      'totalPages': totalPages,
      'currentPage': currentPage,
      'size': size,
      'first': first,
      'last': last,
    };
  }
}
