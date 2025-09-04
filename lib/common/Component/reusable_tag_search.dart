import 'package:flutter/material.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

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

  @override
  void initState() {
    super.initState();
    SGLog.debug(
      "TagSearch",
      '🚀 [TagSearch] Initializing with ${widget.data.length} items',
    );
    SGLog.debug(
      "TagSearch",
      '🔧 [TagSearch] Available getters: ${widget.getters?.map((g) => g.keys.first).toList()}',
    );
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
      SGLog.debug("TagSearch", '🗑️ [TagSearch] Deletion detected: "$_previousQuery" → "$newValue"');
      
      // Tìm tất cả tag patterns trong previous query
      final tagPattern = RegExp(r'@[^@\s]+:');
      final previousTags = tagPattern.allMatches(_previousQuery).map((m) => m.group(0)!).toList();
      
      for (var tagText in previousTags) {
        // Nếu tag này bị xóa incomplete (không còn hoàn chỉnh)
        if (_previousQuery.contains(tagText) && !newValue.contains(tagText)) {
          // Tìm phần còn lại của tag trong newValue
          final tagWithoutColon = tagText.substring(0, tagText.length - 1); // Remove ':'
          
          // Nếu newValue chứa phần đầu của tag (không có :) thì xóa luôn
          if (newValue.contains(tagWithoutColon)) {
            SGLog.debug("TagSearch", '🧹 [TagSearch] Removing incomplete tag: "$tagWithoutColon"');
            
            String result = newValue.replaceFirst(tagWithoutColon, '');
            result = result.replaceAll(RegExp(r'\s+'), ' ').trim();
            
            SGLog.debug("TagSearch", '✨ [TagSearch] Cleaned result: "$result"');
            return result;
          }
        }
      }
      
      // Kiểm tra tag incomplete patterns khác
      final incompleteTagPattern = RegExp(r'@[^@\s]*(?![:\s])');
      final matches = incompleteTagPattern.allMatches(newValue).toList();
      
      for (var match in matches) {
        final tagText = match.group(0)!;
        SGLog.debug("TagSearch", '🧹 [TagSearch] Removing incomplete tag: "$tagText"');
        
        String result = newValue.replaceFirst(tagText, '');
        result = result.replaceAll(RegExp(r'\s+'), ' ').trim();
        
        SGLog.debug("TagSearch", '✨ [TagSearch] Cleaned result: "$result"');
        return result;
      }
    }
    
    return newValue;
  }

  void _updateFilteredItems() {
    SGLog.debug(
      "TagSearch",
      '🔍 [TagSearch] Starting filter with query: "$query"',
    );
    List<T> results = widget.data;
    SGLog.debug(
      "TagSearch",
      '📊 [TagSearch] Initial data count: ${results.length}',
    );

    if (query.trim().isEmpty) {
      SGLog.debug("TagSearch", '✅ [TagSearch] Empty query, returning all data');
      _filteredItems = results;
      widget.onFilteredItemsChanged(results);
      return;
    }

    final parts = query.split(RegExp(r"\s+"));
    SGLog.debug("TagSearch", '🔤 [TagSearch] Query parts: $parts');
    List<String> textSearchTerms = [];

    // Phân tách tag filters và text search
    for (var part in parts) {
      if (part.startsWith("@")) {
        // Xử lý tag search (@tag:value)
        final clean = part.substring(1);
        final subParts = clean.split(":");
        if (subParts.length < 2) {
          SGLog.debug("TagSearch", '⚠️ [TagSearch] Invalid tag format: $part');
          continue;
        }

        final tag = subParts[0].trim().toLowerCase();
        final value = subParts.sublist(1).join(":").trim().toLowerCase();

        SGLog.debug(
          "TagSearch",
          '🏷️ [TagSearch] Processing tag filter - tag: "$tag", value: "$value"',
        );

        // Denormalize tag (convert underscore back to space) để tìm trong getters
        final originalTag = tag.replaceAll('_', ' ');
        
        if (widget.getters?.any((getter) => getter.containsKey(originalTag)) == true) {
          final beforeCount = results.length;
          results =
              results.where((item) {
                final itemValue =
                    widget.getters!
                        .firstWhere((getter) => getter.containsKey(originalTag))[originalTag]!(
                          item,
                        )
                        .toLowerCase();
                final matches = itemValue.contains(value);
                if (matches) {
                  SGLog.debug(
                    "TagSearch",
                    '✅ [TagSearch] Tag match found: "$itemValue" contains "$value"',
                  );
                }
                return matches;
              }).toList();
          SGLog.debug(
            "TagSearch",
            '📉 [TagSearch] Tag filter "$originalTag:$value" reduced results: $beforeCount → ${results.length}',
          );
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
      } else if (part.trim().isNotEmpty) {
        // Collect text search terms
        textSearchTerms.add(part.trim().toLowerCase());
        SGLog.debug(
          "TagSearch",
          '📝 [TagSearch] Added text search term: "${part.trim().toLowerCase()}"',
        );
      }
    }

    // Áp dụng text search cho tất cả các field
    if (textSearchTerms.isNotEmpty) {
      SGLog.debug(
        "TagSearch",
        '🔎 [TagSearch] Applying text search for terms: $textSearchTerms',
      );
      final beforeCount = results.length;

      results =
          results.where((item) {
            return textSearchTerms.every((term) {
              // Tìm kiếm trong tất cả các field được định nghĩa trong getters
              final hasMatch =
                  widget.getters?.any((getter) {
                    return getter.values.any((getterFunction) {
                      final fieldValue = getterFunction(item).toLowerCase();
                      final matches = fieldValue.contains(term);
                      if (matches) {
                        SGLog.debug(
                          "TagSearch",
                          '✅ [TagSearch] Text match found: "$fieldValue" contains "$term"',
                        );
                      }
                      return matches;
                    });
                  }) ==
                  true;

              if (!hasMatch) {
                SGLog.debug(
                  "TagSearch",
                  '❌ [TagSearch] No match found for term: "$term"',
                );
              }
              return hasMatch;
            });
          }).toList();

      SGLog.debug(
        "TagSearch",
        '📉 [TagSearch] Text search reduced results: $beforeCount → ${results.length}',
      );
    }

    SGLog.debug(
      "TagSearch",
      '🎯 [TagSearch] Final result count: ${results.length}',
    );
    _filteredItems = results;
    widget.onFilteredItemsChanged(results);
  }

  String _buildTagQuery(String currentQuery, String tag) {
    // Thay thế khoảng trắng trong tag bằng underscore để tránh parsing issue
    final normalizedTag = tag.replaceAll(' ', '_');
    
    if (currentQuery.endsWith("@")) {
      return "${currentQuery.substring(0, currentQuery.length - 1)}@$normalizedTag:";
    } else if (currentQuery.endsWith(" ") || currentQuery.isEmpty) {
      return "$currentQuery@$normalizedTag:";
    } else {
      return "$currentQuery @$normalizedTag:";
    }
  }

  List<TextSpan> _buildStyledText(String text) {
    List<TextSpan> spans = [];
    final tagPattern = RegExp(r'(@[^@\s]+:(?:[^@\s]+\s*)*)');
    
    int lastEnd = 0;
    
    for (var match in tagPattern.allMatches(text)) {
      // Add normal text before tag
      if (match.start > lastEnd) {
        spans.add(TextSpan(
          text: text.substring(lastEnd, match.start),
          style: const TextStyle(color: Colors.black),
        ));
      }
      
      // Add styled tag
      spans.add(TextSpan(
        text: match.group(0),
        style: const TextStyle(
          color: Color(0xFF5865F2),
          fontWeight: FontWeight.w600,
          backgroundColor: Color(0xFFE3F2FD),
        ),
      ));
      
      lastEnd = match.end;
    }
    
    // Add remaining normal text
    if (lastEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastEnd),
        style: const TextStyle(color: Colors.black),
      ));
    }
    
    return spans;
  }

  void _showTagSuggestionsPopup() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Stack(
          children: [
            Positioned(
              left: position.dx + 12,
              top: position.dy + 80, // Vị trí dưới search bar
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 300),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF202225),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Chọn tag:",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children:
                            widget.getters!
                                .where(
                                  (tag) {
                                    final normalizedTag = tag.keys.first.replaceAll(' ', '_');
                                    return !query.contains("@$normalizedTag:");
                                  },
                                )
                                .map(
                                  (tag) => ActionChip(
                                    label: Text(
                                      tag.keys.first,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                    backgroundColor: const Color(0xFF5865F2),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      insertTag(tag.keys.first);
                                    },
                                  ),
                                )
                                .toList(),
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

  void insertTag(String tag) {
    SGLog.debug("TagSearch", '🏷️ [TagSearch] Inserting tag: "$tag"');
    
    // Normalize tag để check existence
    final normalizedTag = tag.replaceAll(' ', '_');
    
    // Kiểm tra xem tag đã tồn tại chưa
    if (query.contains("@$normalizedTag:")) {
      SGLog.debug(
        "TagSearch",
        '⚠️ [TagSearch] Tag "$tag" already exists in query',
      );
      setState(() {
        showTagSuggestions = false;
      });
      return;
    }

    final newQuery = _buildTagQuery(query, tag);
    SGLog.debug(
      "TagSearch",
      '🔄 [TagSearch] Query changed: "$query" → "$newQuery"',
    );

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
                style: const TextStyle(color: Colors.transparent), // Hide default text
                decoration: InputDecoration(
                  icon: widget.leading ?? const Icon(Icons.search, color: Colors.black54),
                  border: InputBorder.none,
                  hintText: query.isEmpty ? widget.hintText : '',
                  hintStyle: const TextStyle(color: Colors.black54),
                ),
                onChanged: (value) {
                  SGLog.debug("TagSearch", '⌨️ [TagSearch] Input changed: "$value"');
                  
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
                    _previousQuery = query; // Store previous query before update
                    query = value;
                    showTagSuggestions = value.endsWith("@");
                  });

                  if (value.endsWith("@")) {
                    SGLog.debug("TagSearch", '🎯 [TagSearch] Showing tag suggestions popup');
                    _showTagSuggestionsPopup();
                  }

                  _updateFilteredItems();
                },
              ),
              
              // Styled text overlay
              if (query.isNotEmpty)
                Positioned(
                  left: 44, // Offset for search icon
                  top: 12,
                  child: IgnorePointer(
                    child: RichText(
                      text: TextSpan(
                        children: _buildStyledText(query),
                      ),
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
