import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:se_gay_components/common/sg_text.dart';

class CommonPageView extends StatefulWidget {
  const CommonPageView({
    super.key,
    required this.childInput,
    required this.childTableView,
    required this.isShowInput,
    this.title = 'Tùy chọn tìm kiếm',
    this.isShowCollapse = true,
    this.onExpandedChanged,
  });
  final Widget childInput;
  final Widget childTableView;
  final bool isShowInput;
  final String title;
  final bool isShowCollapse;
  final Function(bool)? onExpandedChanged;
  @override
  State<CommonPageView> createState() => _CommonPageViewState();
}

class _CommonPageViewState extends State<CommonPageView> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isShowCollapse;
  }

  @override
  void didUpdateWidget(CommonPageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isShowCollapse != widget.isShowCollapse) {
      setState(() {
        _isExpanded = widget.isShowCollapse;
      });
    }
  }

  @override
  void dispose() {
    _isExpanded = false; // Move this line before super.dispose()
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        spacing: 10,
        children: [
          if (widget.isShowInput) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        _isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _isExpanded = !_isExpanded;
                          });
                          // Gọi callback nếu có
                          widget.onExpandedChanged?.call(_isExpanded);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: ColorValue.lightBlue),
                            borderRadius: BorderRadius.circular(5),
                            color:
                                _isExpanded
                                    ? ColorValue.teal
                                    : ColorValue.oceanBlue,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                _isExpanded
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              SGText(
                                text: _isExpanded ? 'Thu gọn' : 'Mở rộng',
                                size: 14,
                                color: Colors.white,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  AnimatedCrossFade(
                    firstChild: SizedBox.shrink(),
                    secondChild: _isExpanded ? widget.childInput : SizedBox.shrink(),
                    crossFadeState:
                        _isExpanded
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                    duration: Duration(milliseconds: 200),
                  ),
                ],
              ),
            ),
          ],
          widget.childTableView,
        ],
      ),
    );
  }
}
