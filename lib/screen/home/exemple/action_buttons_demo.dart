import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/widgets/table_action_buttons.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';

class ActionButtonsDemo extends StatefulWidget {
  const ActionButtonsDemo({super.key});

  @override
  State<ActionButtonsDemo> createState() => _ActionButtonsDemoState();
}

class _ActionButtonsDemoState extends State<ActionButtonsDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Action Buttons Demo'),
        backgroundColor: Colors.white,
        foregroundColor: ColorValue.neutral900,
        elevation: 0,
      ),
      body: Container(
        color: ColorValue.neutral50,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: ColorValue.neutral200.withOpacity(0.3),
                    spreadRadius: 0,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: ColorValue.primaryLightBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.touch_app,
                      color: ColorValue.primaryBlue,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Action Buttons với Icon',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: ColorValue.neutral900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Các button với màu sắc semantic và icon đẹp mắt',
                          style: TextStyle(
                            fontSize: 14,
                            color: ColorValue.neutral600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Individual Buttons
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSection(
                      title: 'Các Button Đơn Lẻ',
                      children: [
                        _buildButtonRow('View Button', TableActionButtons.viewButton(
                          onPressed: () => _showSnackBar('View clicked'),
                        )),
                        _buildButtonRow('Edit Button', TableActionButtons.editButton(
                          onPressed: () => _showSnackBar('Edit clicked'),
                        )),
                        _buildButtonRow('Delete Button', TableActionButtons.deleteButton(
                          onPressed: () => _showSnackBar('Delete clicked'),
                        )),
                        _buildButtonRow('Download Button', TableActionButtons.downloadButton(
                          onPressed: () => _showSnackBar('Download clicked'),
                        )),
                        _buildButtonRow('Print Button', TableActionButtons.printButton(
                          onPressed: () => _showSnackBar('Print clicked'),
                        )),
                        _buildButtonRow('Share Button', TableActionButtons.shareButton(
                          onPressed: () => _showSnackBar('Share clicked'),
                        )),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    _buildSection(
                      title: 'Button Rows',
                      children: [
                        _buildButtonRow('View + Edit + Delete', TableActionButtons.commonActionButtons(
                          onView: () => _showSnackBar('View clicked'),
                          onEdit: () => _showSnackBar('Edit clicked'),
                          onDelete: () => _showSnackBar('Delete clicked'),
                        )),
                        _buildButtonRow('View + Edit + Download', TableActionButtons.commonActionButtons(
                          onView: () => _showSnackBar('View clicked'),
                          onEdit: () => _showSnackBar('Edit clicked'),
                          onDownload: () => _showSnackBar('Download clicked'),
                        )),
                        _buildButtonRow('Edit + Print + Share', TableActionButtons.commonActionButtons(
                          onEdit: () => _showSnackBar('Edit clicked'),
                          onPrint: () => _showSnackBar('Print clicked'),
                          onShare: () => _showSnackBar('Share clicked'),
                        )),
                        _buildButtonRow('Tất cả Actions', TableActionButtons.commonActionButtons(
                          onView: () => _showSnackBar('View clicked'),
                          onEdit: () => _showSnackBar('Edit clicked'),
                          onDelete: () => _showSnackBar('Delete clicked'),
                          onDownload: () => _showSnackBar('Download clicked'),
                          onPrint: () => _showSnackBar('Print clicked'),
                          onShare: () => _showSnackBar('Share clicked'),
                        )),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    _buildSection(
                      title: 'Button Sizes',
                      children: [
                        _buildButtonRow('Small (24px)', TableActionButtons.commonActionButtons(
                          onView: () => _showSnackBar('View clicked'),
                          onEdit: () => _showSnackBar('Edit clicked'),
                          onDelete: () => _showSnackBar('Delete clicked'),
                          buttonSize: 24,
                        )),
                        _buildButtonRow('Medium (32px)', TableActionButtons.commonActionButtons(
                          onView: () => _showSnackBar('View clicked'),
                          onEdit: () => _showSnackBar('Edit clicked'),
                          onDelete: () => _showSnackBar('Delete clicked'),
                          buttonSize: 32,
                        )),
                        _buildButtonRow('Large (40px)', TableActionButtons.commonActionButtons(
                          onView: () => _showSnackBar('View clicked'),
                          onEdit: () => _showSnackBar('Edit clicked'),
                          onDelete: () => _showSnackBar('Delete clicked'),
                          buttonSize: 40,
                        )),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    _buildSection(
                      title: 'Spacing Options',
                      children: [
                        _buildButtonRow('Tight Spacing (4px)', TableActionButtons.commonActionButtons(
                          onView: () => _showSnackBar('View clicked'),
                          onEdit: () => _showSnackBar('Edit clicked'),
                          onDelete: () => _showSnackBar('Delete clicked'),
                          spacing: 4,
                        )),
                        _buildButtonRow('Normal Spacing (8px)', TableActionButtons.commonActionButtons(
                          onView: () => _showSnackBar('View clicked'),
                          onEdit: () => _showSnackBar('Edit clicked'),
                          onDelete: () => _showSnackBar('Delete clicked'),
                          spacing: 8,
                        )),
                        _buildButtonRow('Wide Spacing (16px)', TableActionButtons.commonActionButtons(
                          onView: () => _showSnackBar('View clicked'),
                          onEdit: () => _showSnackBar('Edit clicked'),
                          onDelete: () => _showSnackBar('Delete clicked'),
                          spacing: 16,
                        )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: ColorValue.neutral200.withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: ColorValue.neutral900,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildButtonRow(String label, Widget buttons) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: ColorValue.neutral700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 16),
          buttons,
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: ColorValue.primaryBlue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
} 