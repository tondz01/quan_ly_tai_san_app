import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quan_ly_tai_san_app/core/constants/index.dart';
import 'package:se_gay_components/common/sg_button_v2.dart';
import 'package:se_gay_components/common/sg_input_text.dart';
import 'package:se_gay_components/common/sg_button_icon_with_popup.dart';
import 'package:se_gay_components/common/sg_popup_menu.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class Header extends StatefulWidget {
  final double height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Decoration? decoration;

  final String? imageLogoLeft;
  final String? imageLogoRight;

  const Header({super.key, this.height = 65, this.padding, this.margin, this.decoration, this.imageLogoLeft, this.imageLogoRight});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  // Helper method for time options in popup
  Widget _buildTimeOption(String title) {
    return InkWell(
      onTap: () {
        SGLog.debug('Header', '$title selected');
      },
      child: Padding(padding: const EdgeInsets.symmetric(vertical: 8.0), child: Text(title)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      margin: widget.margin,
      decoration: widget.decoration,
      child: Row(
        children: [
          widget.imageLogoLeft != null ? Image.asset(widget.imageLogoLeft!) : SvgPicture.asset(AppSvgs.iconLogo),
          const SizedBox(width: 24),
          Expanded(
            child: Row(
              children: [
                SGInputText(
                  height: 34,
                  width: 280,
                  prefixIcon: Padding(padding: const EdgeInsets.all(8.0), child: SvgPicture.asset(AppSvgs.iconSearch)),
                  controller: TextEditingController(),
                  borderRadius: 6,
                  padding: const EdgeInsets.all(1),
                  fontSize: 14,
                  hintText: 'Tìm kiếm ...',
                  onChanged: (value) {},
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    spacing: 10,
                    children: [
                      SGButtonV2(
                        width: 34,
                        height: 34,
                        buttonType: SGButtonType.icon,
                        padding: EdgeInsets.all(8),
                        iconChild: SvgPicture.asset(AppSvgs.iconSetting),
                        onclick: (_) {},
                      ),
                      SGButtonIconWithPopup(
                        colorBackgroundButton: Colors.grey.shade100,
                        widthButton: 34,
                        heightButton: 34,
                        buttonType: SGButtonType.icon,
                        paddingButton: EdgeInsets.all(8),
                        iconChildButton: SvgPicture.asset(AppSvgs.iconChat),
                        popupOffset: const Offset(-83, 10),
                        popupId: 'header_chat',
                        popupItems: [
                          SGPopupMenuItem(
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildTimeOption('Today'),
                                _buildTimeOption('Yesterday'),
                                _buildTimeOption('Last 7 days'),
                                _buildTimeOption('This month'),
                                _buildTimeOption('Custom range'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SGButtonIconWithPopup(
                        colorBackgroundButton: Colors.grey.shade100,
                        widthButton: 34,
                        heightButton: 34,
                        buttonType: SGButtonType.icon,
                        paddingButton: EdgeInsets.all(8),
                        iconChildButton: SvgPicture.asset(AppSvgs.iconTime),
                        popupOffset: const Offset(-83, 10),
                        popupId: 'header_time',
                        popupItems: [
                          SGPopupMenuItem(
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildTimeOption('Today'),
                                _buildTimeOption('Yesterday'),
                                _buildTimeOption('Last 7 days'),
                                _buildTimeOption('This month'),
                                _buildTimeOption('Custom range'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 5),
                      const CircleAvatar(
                        radius: 18,
                        backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=3'), // random avatar
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
