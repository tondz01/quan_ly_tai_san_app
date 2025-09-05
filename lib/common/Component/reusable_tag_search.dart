import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class ReusableTagSearch<T> extends StatefulWidget {
  final List<T> data;
  final List<Map<String, Function(T)>>? getters;
  final String hintText;
  final Widget? leading;
  final String emptyMessage;
  final Function(List<T>) onFilteredItemsChanged;

  const ReusableTagSearch({
    super.key,
    required this.data,
    required this.getters,
    required this.onFilteredItemsChanged,
    this.hintText = "Nhập @tag để lọc",
    this.leading,
    this.emptyMessage = "Không tìm thấy kết quả",
  });

  @override
  State<ReusableTagSearch<T>> createState() => _ReusableTagSearchState<T>();
}

class _ReusableTagSearchState<T> extends State<ReusableTagSearch<T>> {
  String query = "";
  bool showTagSuggestions = false;
  List<T> _filteredItems = [];
  late TextEditingController _controller;
  int _selectedTagIndex = 0;
  late FocusNode _textFieldFocusNode;

  // Chia sẻ text style để đảm bảo nhất quán giữa TextField và TextSpan
  static const TextStyle _baseTextStyle = TextStyle(
    color: Colors.black87,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0.53,
  );

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: query);
    _textFieldFocusNode = FocusNode();
    _filteredItems = widget.data;

    // Gọi callback sau khi build hoàn tất để tránh setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onFilteredItemsChanged(_filteredItems);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _textFieldFocusNode.dispose();
    super.dispose();
  }

  // Kiểm tra xem có nên hiển thị popup tag suggestions hay không
  bool _shouldShowTagSuggestions(String value) {
    if (!value.endsWith("@")) return false;

    // Nếu @ ở đầu chuỗi thì OK
    if (value == "@") return true;

    // Nếu @ có khoảng trắng phía trước thì OK
    if (value.length >= 2 && value[value.length - 2] == ' ') {
      return true;
    }

    return false;
  }

  List<T> searchObjects(
    List<T> list,
    String pattern,
    List<String Function(T)> getters,
  ) {
    // Chuyển pattern sang regex, đồng thời bỏ dấu
    String regexPattern = removeDiacritics(
      pattern,
    ).replaceAll('%', '.*').replaceAll('_', '.');

    final regex = RegExp('^$regexPattern\$', caseSensitive: false);

    return list.where((item) {
      // Nếu ít nhất một getter match thì giữ lại
      return getters.any((getter) {
        String normalized = removeDiacritics(getter(item));
        return regex.hasMatch(normalized);
      });
    }).toList();
  }

  void _updateFilteredItems() {
    List<T> results = widget.data;
    if (query.trim().isEmpty) {
      _filteredItems = results;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onFilteredItemsChanged(_filteredItems);
      });
      return;
    }

    List<String> textSearchTerms = [];
    String remainingQuery = query;

    // Đầu tiên, trích xuất tất cả các tag (cả có dấu ngoặc kép và không)
    // Pattern mới: khớp với tag value có thể chứa nhiều từ, kết thúc bằng khoảng trắng + @ hoặc cuối chuỗi
    final tagPattern = RegExp(r'@(?:"[^"]+"|[^\s]+):(?:[^@]*?)(?=\s*@|$)');
    final tagMatches = tagPattern.allMatches(query).toList();

    // Xử lý từng tag
    for (var tagMatch in tagMatches) {
      final fullTag = tagMatch.group(0)!;

      // Xóa tag này khỏi query còn lại để tìm kiếm text
      remainingQuery = remainingQuery.replaceFirst(fullTag, ' ');

      // Phân tích tag
      final tagPart = fullTag.substring(1); // Xóa @
      final colonIndex = tagPart.indexOf(':');
      if (colonIndex == -1) continue;

      final tagName = tagPart.substring(0, colonIndex).trim();
      final tagValue = tagPart.substring(colonIndex + 1).trim().toLowerCase();

      // Xóa dấu ngoặc kép nếu có
      final originalTag =
          tagName.startsWith('"') && tagName.endsWith('"')
              ? tagName.substring(1, tagName.length - 1)
              : tagName;

      if (widget.getters?.any((getter) => getter.containsKey(originalTag)) ==
          true) {
        // Lấy function getter cho field cụ thể
        final targetGetter =
            widget.getters!.firstWhere(
              (getter) => getter.containsKey(originalTag),
            )[originalTag]!;

        results = searchObjects(results, "%$tagValue%", [
          (item) => targetGetter(item).toString(),
        ]);
      }
    }

    // Xử lý phần text còn lại như các từ khóa tìm kiếm
    final parts = remainingQuery.split(RegExp(r'\s+'));
    for (var part in parts) {
      if (part.trim().isNotEmpty) {
        textSearchTerms.add(part.trim().toLowerCase());
      }
    }

    // Áp dụng tìm kiếm text cho tất cả các trường
    if (textSearchTerms.isNotEmpty) {
      results =
          results.where((item) {
            return textSearchTerms.every((term) {
              final hasMatch =
                  widget.getters?.any((getter) {
                    return getter.values.any((getterFunction) {
                      final fieldValue = getterFunction(item).toLowerCase();
                      return fieldValue.contains(term);
                    });
                  }) ==
                  true;
              return hasMatch;
            });
          }).toList();
    }

    _filteredItems = results;

    // Gọi callback sau khi build hoàn tất để tránh setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onFilteredItemsChanged(results);
    });
  }

  String _buildTagQuery(String currentQuery, String tag) {
    // Bọc tag với dấu ngoặc kép nếu nó chứa khoảng trắng để tránh lỗi phân tích
    final tagToUse = tag.contains(' ') ? '"$tag"' : tag;

    if (currentQuery.endsWith("@")) {
      return "${currentQuery.substring(0, currentQuery.length - 1)}@$tagToUse:";
    } else if (currentQuery.endsWith(" ") || currentQuery.isEmpty) {
      return "$currentQuery@$tagToUse:";
    } else {
      return "$currentQuery @$tagToUse:";
    }
  }

  List<TextSpan> _buildStyledText(String text) {
    List<TextSpan> spans = [];
    // Pattern cập nhật để xử lý tag có dấu ngoặc kép: @"tên tag":giá trị hoặc @tag:giá trị
    final tagPattern = RegExp(r'(@(?:"[^"]+"|[^@\s]+):(?:[^@\s]+\s*)*)');

    int lastEnd = 0;

    for (var match in tagPattern.allMatches(text)) {
      // Thêm text thường trước tag
      if (match.start > lastEnd) {
        spans.add(
          TextSpan(
            text: text.substring(lastEnd, match.start),
            style: _baseTextStyle,
          ),
        );
      }

      // Thêm tag được tạo kiểu với màu khác
      spans.add(TextSpan(text: match.group(0), style: _baseTextStyle));

      lastEnd = match.end;
    }

    // Thêm phần text thường còn lại
    if (lastEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastEnd), style: _baseTextStyle));
    }

    return spans;
  }

  void _showTagSuggestionsPopup() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final screenSize = MediaQuery.of(context).size;

    // Reset selected index
    _selectedTagIndex = 0;

    // Lấy danh sách tags có sẵn
    final availableTags =
        widget.getters!
            .where((tag) {
              return !query.contains("@\"${tag.keys.first}\":");
            })
            .map((tag) => tag.keys.first)
            .toList();

    if (availableTags.isEmpty) return;

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Focus(
              autofocus: true,
              onKeyEvent: (node, event) {
                if (event is KeyDownEvent) {
                  if (event.logicalKey == LogicalKeyboardKey.arrowDown ||
                      event.logicalKey == LogicalKeyboardKey.tab) {
                    setDialogState(() {
                      _selectedTagIndex =
                          (_selectedTagIndex + 1) % availableTags.length;
                    });
                    return KeyEventResult.handled;
                  } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                    setDialogState(() {
                      _selectedTagIndex =
                          (_selectedTagIndex - 1 + availableTags.length) %
                          availableTags.length;
                    });
                    return KeyEventResult.handled;
                  } else if (event.logicalKey == LogicalKeyboardKey.enter) {
                    if (Navigator.canPop(dialogContext)) {
                      Navigator.of(dialogContext).pop();
                    }
                    Future.microtask(
                      () => insertTag(availableTags[_selectedTagIndex]),
                    );
                    return KeyEventResult.handled;
                  } else if (event.logicalKey == LogicalKeyboardKey.escape) {
                    if (Navigator.canPop(dialogContext)) {
                      Navigator.of(dialogContext).pop();
                    }
                    return KeyEventResult.handled;
                  }
                }
                return KeyEventResult.ignored;
              },
              child: Stack(
                children: [
                  // Rào chắn vô hình để đóng popup
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: () {
                        if (Navigator.canPop(dialogContext)) {
                          Navigator.of(dialogContext).pop();
                        }
                      },
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                  // Popup gợi ý tag
                  Positioned(
                    left: math.max(12, position.dx),
                    top: math.min(screenSize.height - 200, position.dy + 52),
                    child: Material(
                      elevation: 8,
                      borderRadius: BorderRadius.circular(12),
                      shadowColor: Colors.black26,
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: math.min(300, screenSize.width - 24),
                          maxHeight: 240,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header
                            Container(
                              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color(0xFF40444B),
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.tag,
                                    color: Color(0xFF5865F2),
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    "Chọn tag để lọc:",
                                    style: TextStyle(
                                      color: Color(0xFF5865F2),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Spacer(),
                                  const Text(
                                    "↑↓ Tab Enter",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 11,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Tags
                            Flexible(
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Wrap(
                                    spacing: 6,
                                    runSpacing: 6,
                                    children:
                                        availableTags.asMap().entries.map((
                                          entry,
                                        ) {
                                          final index = entry.key;
                                          final tag = entry.value;
                                          return _buildTagChip(
                                            tag,
                                            dialogContext,
                                            isSelected:
                                                index == _selectedTagIndex,
                                          );
                                        }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTagChip(
    String tag,
    BuildContext dialogContext, {
    bool isSelected = false,
  }) {
    return InkWell(
      onTap: () {
        // Đóng dialog một cách an toàn
        if (Navigator.canPop(dialogContext)) {
          Navigator.of(dialogContext).pop();
        }
        // Chèn tag sau khi dialog đã đóng
        Future.microtask(() => insertTag(tag));
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4752C4) : const Color(0xFF5865F2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? Icons.label_important : Icons.label,
              color: Colors.white,
              size: 14,
            ),
            const SizedBox(width: 4),
            Text(
              tag,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void insertTag(String tag) {
    // Kiểm tra xem tag đã tồn tại chưa
    if (query.contains("@\"$tag\":")) {
      setState(() {
        showTagSuggestions = false;
      });
      return;
    }

    final newQuery = _buildTagQuery(query, tag);
    setState(() {
      query = newQuery;
      _controller.text = newQuery;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: newQuery.length),
      );
      showTagSuggestions = false;
    });

    _updateFilteredItems();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        border: Border.all(color: Colors.black12, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withValues(alpha: 0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Icon(Icons.search, color: Colors.black38, size: 20),
          ),
          Expanded(
            child: Stack(
              children: [
                TextField(
                  controller: _controller,
                  focusNode: _textFieldFocusNode,
                  style: _baseTextStyle.copyWith(color: Colors.transparent),
                  cursorWidth: 0.5,
                  cursorHeight: 14,
                  cursorColor: Colors.black87,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) {
                    _updateFilteredItems();
                  },
                  decoration: InputDecoration(
                    hintText: query.isEmpty ? widget.hintText : '',
                    hintStyle: _baseTextStyle.copyWith(color: Colors.black38),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    border: InputBorder.none,
                    fillColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 12,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      query = value;
                      // Chỉ hiện popup khi @ ở đầu hoặc có khoảng trắng trước @
                      showTagSuggestions = _shouldShowTagSuggestions(value);
                    });

                    if (_shouldShowTagSuggestions(value)) {
                      _showTagSuggestionsPopup();
                    }

                    _updateFilteredItems();
                  },
                ),

                // Lớp phủ text có kiểu
                if (query.isNotEmpty)
                  Positioned(
                    left: 4,
                    top: 9,
                    child: IgnorePointer(
                      child: RichText(
                        text: TextSpan(children: _buildStyledText(query)),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (query.isNotEmpty)
            InkWell(
              onTap: () {
                setState(() {
                  query = "";
                  _controller.clear();
                  _filteredItems = widget.data;
                });

                // Gọi callback sau khi setState hoàn tất
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  widget.onFilteredItemsChanged(_filteredItems);
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.close, color: Colors.black38, size: 18),
              ),
            ),

          InkWell(
            highlightColor: Colors.transparent,
            onTap: () {
              _updateFilteredItems();
            },
            child: Container(
              padding: const EdgeInsets.all(7.0),
              margin: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "Tìm kiếm",
                style: _baseTextStyle.copyWith(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
