// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class MessageComposeForm extends StatefulWidget {
  final Function(String recipient, String message)? onSend;
  final VoidCallback? onCancel;

  const MessageComposeForm({
    super.key,
    this.onSend,
    this.onCancel,
  });

  @override
  State<MessageComposeForm> createState() => _MessageComposeFormState();
}

class _MessageComposeFormState extends State<MessageComposeForm> {
  String _selectedRecipient = 'namvh';
  final TextEditingController _messageController = TextEditingController();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  
  void _hidePopup() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
  
  @override
  void dispose() {
    _hidePopup();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: MediaQuery.of(context).size.width * 0.9,
      // constraints: const BoxConstraints(maxWidth: 500),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRecipientField(),
          _buildMessageField(),
          const Divider(height: 1),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Soạn tin nhắn mới',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: widget.onCancel,
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(Icons.close, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipientField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Text(
            'Đến:',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: CompositedTransformTarget(
              link: _layerLink,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: InkWell(
                  borderRadius: BorderRadius.circular(4),
                  hoverColor: Colors.grey.withOpacity(0.1),
                  onTap: () {
                    if (_overlayEntry == null) {
                      _showRecipientPopup();
                    } else {
                      _hidePopup();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    child: Row(
                      children: [
                        Text(
                          _selectedRecipient,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_drop_down, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRecipientPopup() {
    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Layer phủ toàn màn hình để bắt sự kiện nhấp chuột
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _hidePopup,
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          // Popup thực tế
          Positioned(
            width: 150,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: const Offset(0, 30),
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(4),
                color: Colors.white,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildRecipientItem('namvh'),
                      const Divider(height: 1),
                      _buildRecipientItem('admin'),
                      const Divider(height: 1),
                      _buildRecipientItem('user1'),
                      const Divider(height: 1),
                      _buildRecipientItem('user2'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    
    Overlay.of(context).insert(_overlayEntry!);
  }

  Widget _buildRecipientItem(String name) {
    final bool isSelected = name == _selectedRecipient;
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedRecipient = name;
        });
        _hidePopup();
      },
      hoverColor: Colors.grey.withOpacity(0.1),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        color: isSelected ? Colors.grey.withOpacity(0.1) : null,
        child: Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 14, 
                  color: Colors.grey[800],
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check,
                size: 16,
                color: Colors.green[700],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            margin: const EdgeInsets.only(right: 10, top: 4),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Center(
              child: Text(
                'E',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              maxLines: 6,
              decoration: const InputDecoration(
                hintText: 'Gửi tin nhắn cho người theo dõi...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            icon: Icon(Icons.emoji_emotions_outlined, color: Colors.grey[600], size: 20),
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            splashRadius: 20,
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: Icon(Icons.attach_file, color: Colors.grey[600], size: 20),
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            splashRadius: 20,
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              if (_messageController.text.isNotEmpty) {
                widget.onSend?.call(_selectedRecipient, _messageController.text);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB19CB1), // Màu tím nhạt
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text('Gửi'),
          ),
        ],
      ),
    );
  }
} 