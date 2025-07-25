// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/message_compose_form.dart';
import 'package:quan_ly_tai_san_app/screen/note/component/popup_receiver_component.dart';
import 'package:quan_ly_tai_san_app/screen/note/component/send_message_component.dart';
import 'package:se_gay_components/common/sg_colors.dart';
import 'package:se_gay_components/common/sg_text.dart';

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
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: buildInputField(
                    context,
                    controller: _contentSendController,
                    layerLink: _layerLink,
                    overlayEntry: _overlayEntry,
                    hidePopup: _hidePopup,
                  ),
                ),
                const Divider(height: 1),
                _buildTabBar(),
                const Divider(height: 1),
                _buildDateHeader(),
                const Divider(height: 1),
                Expanded(child: _buildNotesList()),
              ],
            ),
            if (_showComposeForm)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  setState(() {
                    _showComposeForm = false;
                  });
                },
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap:
                            () {}, // Ngăn chặn việc đóng form khi nhấn vào form
                        child: MessageComposeForm(
                          onSend: _sendMessage,
                          onCancel: () {
                            setState(() {
                              _showComposeForm = false;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
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
        children: [
          Row(
            children: List.generate(_tabTitles.length, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedTabIndex = index;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _selectedTabIndex == index
                            ? const Color(0xFF703070)
                            : Colors.grey[200],
                    foregroundColor:
                        _selectedTabIndex == index
                            ? Colors.white
                            : Colors.black87,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Text(
                    _tabTitles[index],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          _selectedTabIndex == index
                              ? FontWeight.w500
                              : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }),
          ),
          _buildActionBar(),
        ],
      ),
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
