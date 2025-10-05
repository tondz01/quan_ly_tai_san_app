import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_image.dart';

class CustomAppHeader extends StatelessWidget {
  final String? currentUrl;
  final String? userAvatar;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onMenuTap;
  final List<NavigationItem> navigationItems;
  final int selectedIndex;
  final Function(int) onNavigationTap;

  const CustomAppHeader({
    super.key,
    this.currentUrl,
    this.userAvatar,
    this.onNotificationTap,
    this.onProfileTap,
    this.onMenuTap,
    required this.navigationItems,
    required this.selectedIndex,
    required this.onNavigationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Browser Address Bar
        _buildBrowserBar(),
        // Main Application Header
        _buildMainHeader(),
        // Navigation Bar
        _buildNavigationBar(),
      ],
    );
  }

  Widget _buildBrowserBar() {
    return Container(
      height: 40,
      color: Colors.grey[100],
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Browser controls
          Row(
            children: [
              _buildBrowserButton(Icons.arrow_back_ios, size: 16),
              const SizedBox(width: 8),
              _buildBrowserButton(Icons.arrow_forward_ios, size: 16),
              const SizedBox(width: 8),
              _buildBrowserButton(Icons.refresh, size: 16),
            ],
          ),
          const SizedBox(width: 16),
          // Security indicator and URL
          Expanded(
            child: Container(
              height: 28,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.grey[300]!),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Icon(Icons.lock, size: 16, color: Colors.red[600]),
                  const SizedBox(width: 4),
                  Text(
                    '▲ Not secure',
                    style: TextStyle(
                      color: Colors.red[600],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    currentUrl ?? '123.30.140.221:6068',
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Browser actions
          Row(
            children: [
              _buildBrowserButton(Icons.star_border, size: 20),
              const SizedBox(width: 8),
              _buildBrowserButton(Icons.download, size: 20),
              const SizedBox(width: 8),
              _buildBrowserButton(Icons.person, size: 20),
              const SizedBox(width: 8),
              _buildBrowserButton(Icons.more_vert, size: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBrowserButton(IconData icon, {double size = 20}) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: IconButton(
        onPressed: () {},
        icon: Icon(icon, size: size, color: Colors.grey[700]),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
      ),
    );
  }

  Widget _buildMainHeader() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF1E3A8A), // Dark blue
            Color(0xFF1E40AF), // Lighter blue
          ],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          // Company Logo
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: AppImage.imageLogo.isNotEmpty
                  ? Image.asset(
                      AppImage.imageLogo,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: Colors.red[600],
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: const Icon(
                        Icons.settings,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 16),
          // Company Info and Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Company Name
                Row(
                  children: [
                    Text(
                      'CÔNG TY THUẬN LỢI',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'CƠ KHÍ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Application Title
                Text(
                  'HỆ THỐNG QUẢN LÝ ĐIỀU PHỐI VÀ SỬ DỤNG MÁY MÓC THIẾT BỊ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationBar() {
    return Container(
      height: 48,
      color: const Color(0xFF1E40AF), // Blue background
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // Navigation Items
          Expanded(
            child: Row(
              children: navigationItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isSelected = selectedIndex == index;
                
                return GestureDetector(
                  onTap: () => onNavigationTap(index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      border: isSelected
                          ? const Border(
                              bottom: BorderSide(
                                color: Colors.red,
                                width: 2,
                              ),
                            )
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item.label,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          ),
                        ),
                        if (item.hasDropdown) ...[
                          const SizedBox(width: 4),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                            size: 16,
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          // Right side actions
          Row(
            children: [
              // Notification bell
              GestureDetector(
                onTap: onNotificationTap,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.notifications_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Profile picture
              GestureDetector(
                onTap: onProfileTap,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: userAvatar != null
                        ? Image.asset(
                            userAvatar!,
                            fit: BoxFit.cover,
                          )
                        : const Icon(
                            Icons.person,
                            color: Colors.grey,
                            size: 20,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NavigationItem {
  final String label;
  final bool hasDropdown;
  final VoidCallback? onTap;

  const NavigationItem({
    required this.label,
    this.hasDropdown = false,
    this.onTap,
  });
}
