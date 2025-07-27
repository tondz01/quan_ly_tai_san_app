// ignore_for_file: deprecated_member_use
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/note/component/send_message_component.dart';
import 'package:se_gay_components/common/sg_button_icon.dart';
import 'package:se_gay_components/common/sg_colors.dart';

class NoteItem {
  final String avatar;
  final String title;
  final String time;
  final String content;
  final Color color;
  final int type; // 0 = Gửi tin, 1 = Ghi chú, 2 = Hoạt động

  NoteItem({
    required this.avatar,
    required this.title,
    required this.time,
    required this.content,
    required this.color,
    required this.type,
  });
}

class NoteView extends StatefulWidget {
  const NoteView({super.key});

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  int _selectedTabIndex = 0;
  final List<String> _tabTitles = ['Gửi tin', 'Ghi chú', 'Hoạt động'];
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _contentSendController = TextEditingController();
  bool _showComposeForm = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool isSendMessage = false;
  bool isNote = false;
  bool isActivity = false;
  void _hidePopup() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  final List<NoteItem> _notes = [
    NoteItem(
      avatar: 'E',
      title: 'Ecotel',
      time: '42 phút trước',
      content: 'Đang tạo hồ sơ mới...',
      color: const Color(0xFF4CAF50),
      type: 0, // Gửi tin
    ),
    NoteItem(
      avatar: 'T',
      title: 'Techcom',
      time: '2 giờ trước',
      content: 'Đã cập nhật thông tin khách hàng',
      color: const Color(0xFF2196F3),
      type: 0, // Gửi tin
    ),
    NoteItem(
      avatar: 'N',
      title: 'Người dùng',
      time: '3 giờ trước',
      content: 'Cần kiểm tra lại thông tin liên hệ',
      color: const Color(0xFFFF9800),
      type: 1, // Ghi chú
    ),
    NoteItem(
      avatar: 'H',
      title: 'Hệ thống',
      time: 'Hôm qua',
      content: 'Tài liệu đã được cập nhật bởi người quản trị',
      color: const Color(0xFF9C27B0),
      type: 2, // Hoạt động
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _hidePopup();
    _noteController.dispose();
    super.dispose();
  }

  void _addNewNote(String content) {
    if (content.isEmpty) return;

    setState(() {
      _notes.insert(
        0,
        NoteItem(
          avatar: 'U', // User
          title: 'Người dùng',
          time: 'Vừa xong',
          content: content,
          color: const Color(0xFF9C27B0),
          type: _selectedTabIndex, // Thêm vào tab hiện tại
        ),
      );
    });

    _noteController.clear();
  }

  void _sendMessage(String recipient, String message) {
    setState(() {
      _notes.insert(
        0,
        NoteItem(
          avatar: 'U', // User
          title: 'Bạn → $recipient',
          time: 'Vừa xong',
          content: message,
          color: const Color(0xFF9C27B0),
          type: 0, // Gửi tin
        ),
      );
      _showComposeForm = false;
    });
  }

  List<NoteItem> get _filteredNotes {
    return _notes.where((note) => note.type == _selectedTabIndex).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildTabBar(),
                const Divider(height: 1),
                if (isSendMessage)
                  FormInputSendMessage(
                    controller: _contentSendController,
                    layerLink: _layerLink,
                    overlayEntry: _overlayEntry,
                    hidePopup: _hidePopup,
                    onClickSendMessage: () {
                      _sendMessage('namvh', _contentSendController.text);
                      _contentSendController.clear();
                      isSendMessage = false;
                    },
                  ),
                // const Divider(height: 1),
                _buildDateHeader(),
                const Divider(height: 1),
                Expanded(child: _buildNotesList()),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton:
          _selectedTabIndex == 0 && !_showComposeForm
              ? FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _showComposeForm = true;
                  });
                },
                backgroundColor: const Color(0xFF703070),
                child: const Icon(Icons.edit),
              )
              : null,
    );
  }

  Widget _buildTabBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      //   color: Colors.grey[100],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_buildHeaderActionLeft(), _buildActionBar()],
      ),
    );
  }

  Widget _buildHeaderActionLeft() {
    return Row(
      children: [
        SGButtonIcon(
          width: 60,
          height: 35,
          text: 'Gửi tin',
          sizeText: 12,
          colorText: isSendMessage ? ColorValue.oldLavender : Colors.white,
          borderRadius: 5,
          defaultBGColor: isSendMessage ? Colors.white : ColorValue.oldLavender,
          isBorder: false,
          isOutlined: false,
          isHover: false,
          decoration:
              isSendMessage
                  ? BoxDecoration(
                    color:
                        isSendMessage ? Colors.white : ColorValue.oldLavender,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: ColorValue.oldLavender, width: 2),
                  )
                  : null,
          onPressed: () {
            setState(() {
              isSendMessage = !isSendMessage;
              log('isSendMessage: $isSendMessage');
            });
          },
        ),
        const SizedBox(width: 5),
        SGButtonIcon(
          width: 70,
          height: 35,
          text: 'Ghi chú',
          sizeText: 12,
          colorText: !isNote ? SGAppColors.neutral900 : ColorValue.oldLavender,
          borderRadius: 5,
          defaultBGColor:
              isNote
                  ? ColorValue.oldLavender.withOpacity(0.5)
                  : SGAppColors.colorC0C0C0,
          isBorder: false,
          isOutlined: false,
          isHover: false,
          decoration:
              isNote
                  ? BoxDecoration(
                    color:
                        isNote
                            ? ColorValue.oldLavender.withOpacity(0.2)
                            : ColorValue.oldLavender,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: ColorValue.oldLavender, width: 2),
                  )
                  : null,
          onPressed: () {
            setState(() {
              isNote = !isNote;
              log('isNote: $isNote');
            });
          },
        ),

        const SizedBox(width: 5),
        SGButtonIcon(
          width: 80,
          height: 35,
          text: 'Hoạt động',
          sizeText: 12,
          colorText:
              !isActivity ? SGAppColors.neutral900 : ColorValue.oldLavender,
          borderRadius: 5,
          defaultBGColor:
              isActivity
                  ? ColorValue.oldLavender.withOpacity(0.5)
                  : SGAppColors.colorC0C0C0,
          isBorder: false,
          isOutlined: false,
          isHover: false,
          decoration:
              isActivity
                  ? BoxDecoration(
                    color:
                        isActivity
                            ? ColorValue.oldLavender.withOpacity(0.2)
                            : ColorValue.oldLavender,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: ColorValue.oldLavender, width: 2),
                  )
                  : null,
          onPressed: () {
            setState(() {
              isActivity = !isActivity;
              log('isActivity: $isActivity');
            });
          },
        ),
      ],
    );
  }

  Widget _buildActionBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 40), // Placeholder for left side
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.search, color: Colors.grey[600], size: 22),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                splashRadius: 20,
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: Icon(Icons.link, color: Colors.grey[600], size: 22),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                splashRadius: 20,
              ),
              const SizedBox(width: 16),
              Stack(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.person_outline,
                      color: Colors.grey[600],
                      size: 22,
                    ),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    splashRadius: 20,
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: const Center(
                        child: Text(
                          '0',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Text(
                'Theo dõi',
                style: TextStyle(color: Colors.grey[700], fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Text(
          'Hôm nay',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildNotesList() {
    final notes = _filteredNotes;

    if (notes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.note_alt_outlined, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Không có ${_tabTitles[_selectedTabIndex].toLowerCase()}',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 10),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return _buildNoteItem(
          note.avatar,
          note.title,
          note.time,
          note.content,
          note.color,
        );
      },
    );
  }

  Widget _buildNoteItem(
    String avatarText,
    String title,
    String time,
    String content,
    Color avatarColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: avatarColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                avatarText,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '- $time',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(content, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
