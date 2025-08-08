import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quan_ly_tai_san_app/core/constants/index.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
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
      decoration: widget.decoration ?? BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: ColorValue.neutral200.withValues(alpha: .5),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          widget.imageLogoLeft != null ? Image.asset(widget.imageLogoLeft!) : SvgPicture.asset(AppSvgs.iconLogo),
          const SizedBox(width: 24),
          Expanded(
            child: Row(
              children: [
                // Search input with Material Design
                // MaterialSearchField(
                //   controller: TextEditingController(),
                //   hintText: 'Tìm kiếm ...',
                //   onChanged: (value) {},
                // ),
                // const SizedBox(width: 16),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Settings button
                      MaterialIconButton(
                        icon: Icons.settings,
                        onPressed: () {},
                        tooltip: 'Cài đặt',
                      ),
                      const SizedBox(width: 8),
                      // Chat button with popup
                      PopupMenuButton<String>(
                        offset: const Offset(-83, 10),
                        child: MaterialIconButton(
                          icon: Icons.chat_bubble_outline,
                          onPressed: null,
                          tooltip: 'Chat',
                        ),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'today',
                            child: _buildTimeOption('Today'),
                          ),
                          PopupMenuItem(
                            value: 'yesterday',
                            child: _buildTimeOption('Yesterday'),
                          ),
                          PopupMenuItem(
                            value: 'last7days',
                            child: _buildTimeOption('Last 7 days'),
                          ),
                          PopupMenuItem(
                            value: 'thismonth',
                            child: _buildTimeOption('This month'),
                          ),
                          PopupMenuItem(
                            value: 'custom',
                            child: _buildTimeOption('Custom range'),
                          ),
                        ],
                        onSelected: (value) {
                          SGLog.debug('Header', '$value selected');
                        },
                      ),
                      const SizedBox(width: 8),
                      // Time button with popup
                      PopupMenuButton<String>(
                        offset: const Offset(-83, 10),
                        child: MaterialIconButton(
                          icon: Icons.access_time,
                          onPressed: null,
                          tooltip: 'Thời gian',
                        ),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'today',
                            child: _buildTimeOption('Today'),
                          ),
                          PopupMenuItem(
                            value: 'yesterday',
                            child: _buildTimeOption('Yesterday'),
                          ),
                          PopupMenuItem(
                            value: 'last7days',
                            child: _buildTimeOption('Last 7 days'),
                          ),
                          PopupMenuItem(
                            value: 'thismonth',
                            child: _buildTimeOption('This month'),
                          ),
                          PopupMenuItem(
                            value: 'custom',
                            child: _buildTimeOption('Custom range'),
                          ),
                        ],
                        onSelected: (value) {
                          SGLog.debug('Header', '$value selected');
                        },
                      ),
                      const SizedBox(width: 16),
                      // User avatar
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: ColorValue.primaryLightBlue,
                        child: CircleAvatar(
                        radius: 18,
                          backgroundImage: const NetworkImage('https://i.pravatar.cc/150?img=3'),
                          backgroundColor: Colors.white,
                        ),
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
