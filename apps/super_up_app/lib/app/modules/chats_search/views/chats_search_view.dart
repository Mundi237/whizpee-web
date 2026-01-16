// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:v_chat_room_page/v_chat_room_page.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../controllers/chats_search_controller.dart';

class ChatsSearchView extends StatefulWidget {
  const ChatsSearchView({super.key});

  @override
  State<ChatsSearchView> createState() => _ChatsSearchViewState();
}

class _ChatsSearchViewState extends State<ChatsSearchView> {
  late final ChatsSearchController controller;

  @override
  void initState() {
    super.initState();
    controller = ChatsSearchController();
    controller.onInit();
  }

  @override
  void dispose() {
    controller.onClose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              S.of(context).cancel,
              style: const TextStyle(
                color: CupertinoColors.activeBlue,
              ),
            ),
          )
        ],
        title: CupertinoSearchTextField(
          placeholder: S.of(context).search,
          controller: controller.searchController,
          focusNode: controller.searchFocusNode,
          onChanged: (value) {
            controller.onSearch(value);
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filtres par type de room
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                children: [
                  _FilterChip(
                    label: 'Tous',
                    isSelected: controller.selectedRoomType == null,
                    onTap: () {
                      setState(() {
                        controller.setRoomTypeFilter(null);
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Contacts',
                    isSelected: controller.selectedRoomType == VRoomType.s,
                    onTap: () {
                      setState(() {
                        controller.setRoomTypeFilter(VRoomType.s);
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Annonces',
                    isSelected: controller.selectedRoomType == VRoomType.a,
                    onTap: () {
                      setState(() {
                        controller.setRoomTypeFilter(VRoomType.a);
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Groupes',
                    isSelected: controller.selectedRoomType == VRoomType.g,
                    onTap: () {
                      setState(() {
                        controller.setRoomTypeFilter(VRoomType.g);
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Diffusions',
                    isSelected: controller.selectedRoomType == VRoomType.b,
                    onTap: () {
                      setState(() {
                        controller.setRoomTypeFilter(VRoomType.b);
                      });
                    },
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: controller,
                builder: (context, value, child) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: controller.data.length,
                    itemBuilder: (context, index) {
                      final room = controller.data[index];
                      return VRoomItem(
                        room: room,
                        onRoomItemPress: (room) =>
                            controller.onRoomItemPress(room, context),
                        onRoomItemLongPress: (room) {},
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget pour les filtres
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? CupertinoColors.activeBlue
              : CupertinoColors.systemGrey5,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? CupertinoColors.white : CupertinoColors.label,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
