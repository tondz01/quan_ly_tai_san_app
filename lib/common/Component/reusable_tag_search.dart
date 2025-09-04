import 'package:flutter/material.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';
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
  String _previousQuery = "";
  bool showTagSuggestions = false;
  List<T> _filteredItems = [];
  late TextEditingController _controller;

  // Shared text style for consistency between TextField and TextSpan
  static const TextStyle _baseTextStyle = TextStyle(
    color: Colors.black87,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: 0.53,
  );

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: query);
    _filteredItems = widget.data;
    widget.onFilteredItemsChanged(_filteredItems);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _handleTagDeletion(String newValue) {
    // Nếu query mới ngắn hơn query cũ (đang xóa)
    if (newValue.length < _previousQuery.length) {
      // Updated pattern to handle quoted tags
      final tagPattern = RegExp(r'@(?:"[^"]+"|[^\s]+):');
      final previousTags = tagPattern
          .allMatches(_previousQuery)
          .map((m) => m.group(0)!)
          .toList();

      for (var tagText in previousTags) {
        // Nếu tag này bị xóa incomplete (không còn hoàn chỉnh)
        if (_previousQuery.contains(tagText) && !newValue.contains(tagText)) {
          // Tìm phần còn lại của tag trong newValue
          final tagWithoutColon = tagText.substring(0, tagText.length - 1); // Remove ':'

          // Nếu newValue chứa phần đầu của tag (không có :) thì xóa luôn
          if (newValue.contains(tagWithoutColon)) {
            String result = newValue.replaceFirst(tagWithoutColon, '');
            result = result.replaceAll(RegExp(r'\s+'), ' ').trim();
            return result;
          }
        }
      }

      // Kiểm tra tag incomplete patterns khác (including quoted tags)
      final incompleteTagPattern = RegExp(r'@(?:"[^"]*"?|[^\s]*)(?![:\s])');
      final matches = incompleteTagPattern.allMatches(newValue).toList();

      for (var match in matches) {
        final tagText = match.group(0)!;
        String result = newValue.replaceFirst(tagText, '');
        result = result.replaceAll(RegExp(r'\s+'), ' ').trim();
        return result;
      }
    }

    return newValue;
  }

  void _updateFilteredItems() {
    List<T> results = widget.data;
    if (query.trim().isEmpty) {
      _filteredItems = results;
      widget.onFilteredItemsChanged(results);
      return;
    }

    List<String> textSearchTerms = [];
    String remainingQuery = query;

    // First, extract all tags (both quoted and unquoted)
    final tagPattern = RegExp(r'@(?:"[^"]+"|[^\s]+):[^\s]*');
    final tagMatches = tagPattern.allMatches(query).toList();

    // Process each tag
    for (var tagMatch in tagMatches) {
      final fullTag = tagMatch.group(0)!;
      
      // Remove this tag from remaining query for text search
      remainingQuery = remainingQuery.replaceFirst(fullTag, ' ');
      
      // Parse the tag
      final tagPart = fullTag.substring(1); // Remove @
      final colonIndex = tagPart.indexOf(':');
      if (colonIndex == -1) continue;
      
      final tagName = tagPart.substring(0, colonIndex).trim();
      final tagValue = tagPart.substring(colonIndex + 1).trim().toLowerCase();
      
      // Remove quotes if present
      final originalTag = tagName.startsWith('"') && tagName.endsWith('"')
          ? tagName.substring(1, tagName.length - 1)
          : tagName;

      if (widget.getters?.any((getter) => getter.containsKey(originalTag)) == true) {
        results = results.where((item) {
          final itemValue = widget.getters!
              .firstWhere((getter) => getter.containsKey(originalTag))[originalTag]!(item)
              .toLowerCase();
          return itemValue.contains(tagValue);
        }).toList();
      } else {
        SGLog.debug(
          "TagSearch",
          '❌ [TagSearch] Tag "$originalTag" not found in getters',
        );
        SGLog.debug(
          "TagSearch",
          '🔧 [TagSearch] Available tags: ${widget.getters?.map((g) => g.keys.first).toList()}',
        );
      }
    }

    // Process remaining text as search terms
    final parts = remainingQuery.split(RegExp(r'\s+'));
    for (var part in parts) {
      if (part.trim().isNotEmpty) {
        textSearchTerms.add(part.trim().toLowerCase());
        SGLog.debug(
          "TagSearch",
          '📝 [TagSearch] Added text search term: "${part.trim().toLowerCase()}"',
        );
      }
    }

    // Apply text search to all fields
    if (textSearchTerms.isNotEmpty) {
      results = results.where((item) {
        return textSearchTerms.every((term) {
          final hasMatch = widget.getters?.any((getter) {
            return getter.values.any((getterFunction) {
              final fieldValue = getterFunction(item).toLowerCase();
              return fieldValue.contains(term);
            });
          }) == true;
          return hasMatch;
        });
      }).toList();
    }
    
    _filteredItems = results;
    widget.onFilteredItemsChanged(results);
  }

  String _buildTagQuery(String currentQuery, String tag) {
    // Wrap tag with quotes if it contains spaces to avoid parsing issues
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
    // Updated pattern to handle quoted tags: @"tag name":value or @tag:value
    final tagPattern = RegExp(r'(@(?:"[^"]+"|[^@\s]+):(?:[^@\s]+\s*)*)');

    int lastEnd = 0;

    for (var match in tagPattern.allMatches(text)) {
      // Add normal text before tag
      if (match.start > lastEnd) {
        spans.add(
          TextSpan(
            text: text.substring(lastEnd, match.start),
            style: _baseTextStyle,
          ),
        );
      }

      // Add styled tag with different color
      spans.add(TextSpan(text: match.group(0), style: _baseTextStyle));

      lastEnd = match.end;
    }

    // Add remaining normal text
    if (lastEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastEnd), style: _baseTextStyle));
    }

    return spans;
  }

  void _showTagSuggestionsPopup() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final screenSize = MediaQuery.of(context).size;

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      builder: (BuildContext dialogContext) {
        return Stack(
          children: [
            // Invisible barrier to close popup
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
            // Tag suggestions popup
            Positioned(
              left: math.max(12, position.dx + 12),
              top: math.min(screenSize.height - 200, position.dy + 60),
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(12),
                shadowColor: Colors.black26,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: math.min(300, screenSize.width - 24),
                    maxHeight: 200,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2F3136),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF40444B),
                      width: 1,
                    ),
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
                                color: Color(0xFFDCDDDE),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Tags
                      Flexible(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(12),
                          child: Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children:
                                widget.getters!
                                    .where((tag) {
                                      final tagName = tag.keys.first;
                                      final tagToCheck =
                                          tagName.contains(' ')
                                              ? '"$tagName"'
                                              : tagName;
                                      return !query.contains("@$tagToCheck:");
                                    })
                                    .map(
                                      (tag) => _buildTagChip(
                                        tag.keys.first,
                                        dialogContext,
                                      ),
                                    )
                                    .toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTagChip(String tag, BuildContext dialogContext) {
    return InkWell(
      onTap: () {
        // Safely close dialog
        if (Navigator.canPop(dialogContext)) {
          Navigator.of(dialogContext).pop();
        }
        // Insert tag after dialog is closed
        Future.microtask(() => insertTag(tag));
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF5865F2),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF5865F2).withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.label, color: Colors.white, size: 14),
            const SizedBox(width: 4),
            Text(
              tag,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void insertTag(String tag) {
    // Check existence using the same format as _buildTagQuery
    final tagToCheck = tag.contains(' ') ? '"$tag"' : tag;

    // Kiểm tra xem tag đã tồn tại chưa
    if (query.contains("@$tagToCheck:")) {
      setState(() {
        showTagSuggestions = false;
      });
      return;
    }

    final newQuery = _buildTagQuery(query, tag);
    setState(() {
      _previousQuery = query; // Store previous query before update
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
    return Column(
      children: [
        // Search Bar
        Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: [
              // Base TextField
              TextField(
                controller: _controller,
                style: _baseTextStyle.copyWith(color: Colors.red),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: query.isEmpty ? widget.hintText : '',
                  hintStyle: _baseTextStyle.copyWith(color: Colors.black12),
                ),
                onChanged: (value) {
                  // Handle tag deletion
                  final cleanedValue = _handleTagDeletion(value);
                  if (cleanedValue != value) {
                    // Update controller if value was cleaned
                    _controller.text = cleanedValue;
                    _controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: cleanedValue.length),
                    );
                    value = cleanedValue;
                  }

                  setState(() {
                    _previousQuery =
                        query; // Store previous query before update
                    query = value;
                    showTagSuggestions = value.endsWith("@");
                  });

                  if (value.endsWith("@")) {
                    _showTagSuggestionsPopup();
                  }

                  _updateFilteredItems();
                },
              ),

              // Styled text overlay
              if (query.isNotEmpty)
                Positioned(
                  left: 15.6, // Offset for search icon
                  top: 15,
                  child: IgnorePointer(
                    child: RichText(
                      text: TextSpan(children: _buildStyledText(query)),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
