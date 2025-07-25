// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quan_ly_tai_san_app/screen/note/component/popup_receiver_component.dart';
import 'package:se_gay_components/common/sg_colors.dart';
import 'package:se_gay_components/common/sg_input_text.dart';
import 'package:se_gay_components/common/sg_text.dart';

Widget buildInputField(
  BuildContext context, {
  String? avatar,
  required TextEditingController controller,
  required LayerLink layerLink,
  required OverlayEntry? overlayEntry,
  required Function() hidePopup,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        child: Image.asset(
          avatar ?? 'assets/images/avatar_goku.png',
          alignment: Alignment.center,
          fit: BoxFit.cover,
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            buildHeaderUser(
              context,
              layerLink: layerLink,
              overlayEntry: overlayEntry,
              hidePopup: hidePopup,
            ),
            const SizedBox(height: 5),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              constraints: const BoxConstraints(minHeight: 60),
              // height: 80,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: const BorderRadius.all(Radius.circular(5)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SGInputText(
                    // height: 50,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    controller: controller,
                    borderRadius: 10,
                    textAlign: TextAlign.left,
                    obscureText: true,
                    expandable: true,
                    showBorder: false,
                    color: Colors.black,
                    hintText: 'common.hint'.tr,
                    maxLines: 4,
                    padding: EdgeInsets.only(bottom: 8),
                  ),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.emoji_emotions_outlined,
                          color: Colors.grey[600],
                          size: 20,
                        ),
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        splashRadius: 20,
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: Icon(
                          Icons.attach_file,
                          color: Colors.grey[600],
                          size: 20,
                        ),
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        splashRadius: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget buildHeaderUser(
  BuildContext context, {
  String? userName,
  required LayerLink layerLink,
  required OverlayEntry? overlayEntry,
  required Function() hidePopup,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SGText(
        text: "Đến:",
        fontWeight: FontWeight.bold,
        size: 14,
        color: SGAppColors.neutral900.withOpacity(0.7),
      ),
      const SizedBox(width: 4),
      CompositedTransformTarget(
        link: layerLink,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SGText(
                text: userName ?? "namvh",
                fontWeight: FontWeight.bold,
                size: 14,
                color: SGAppColors.neutral800,
              ),
              const SizedBox(width: 4),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: InkWell(
                  borderRadius: BorderRadius.circular(4),
                  hoverColor: Colors.grey.withOpacity(0.1),
                  onTap: () {
                    if (overlayEntry == null) {
                      showPopupReceiver(
                        context,
                        overlayEntry: overlayEntry,
                        layerLink: layerLink,
                        filteredItems: ['namvh@sscdx.vn'],
                      );
                    } else {
                      hidePopup();
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(top: 2.2),
                    child: Icon(Icons.arrow_drop_down, size: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
