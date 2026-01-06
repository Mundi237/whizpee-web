import 'dart:io';

import 'package:file_sizes/file_sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up_core/super_up_core.dart';

import '../widgets/settings_list_item_tile.dart';

class MediaStorageSettings extends StatefulWidget {
  const MediaStorageSettings({super.key});

  @override
  State<MediaStorageSettings> createState() => _MediaStorageSettingsState();
}

class _MediaStorageSettingsState extends State<MediaStorageSettings> {
  final _service = AutoDownloadMediaService();
  int dirSize = -1;

  Future<void> getDirSize() async {
    final dir = Directory(VFileUtils.downloadPath());
    final files = await dir.list(recursive: true).toList();
    dirSize = files.fold(
      0,
      (int sum, file) {
        return sum + file.statSync().size;
      },
    );
    setState(() {});
  }

  @override
  void initState() {
    getDirSize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          CupertinoSliverNavigationBar(
            largeTitle: Text(S.of(context).storageAndData),
          )
        ],
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    S
                        .of(context)
                        .chooseHowAutomaticDownloadWorks
                        .text
                        .color(Colors.grey),
                    Row(
                      children: [
                        "${S.of(context).appStorageSizeIs} ".text,
                        Text(
                          FileSize.getSize(dirSize),
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.green),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              CupertinoListSection(
                dividerMargin: 0,
                topMargin: 10,
                additionalDividerMargin: 0,
                margin: EdgeInsets.zero,
                hasLeading: false,
                children: [
                  SettingsListItemTile(
                    color: Colors.amber,
                    title: S.of(context).whenUsingMobileData,
                    subtitle: _service
                        .getMediaDownloadOptionsForData()
                        .map((e) => _getTrans(e))
                        .toList()
                        .toString()
                        .replaceAll("[", "")
                        .replaceAll("]", "")
                        .text,
                    onTap: () => _onUpdateMobileData(
                      _service.getMediaDownloadOptionsForData(),
                    ),
                    icon: Icons.four_g_mobiledata,
                  ),
                  SettingsListItemTile(
                    color: Colors.green,
                    title: S.of(context).whenUsingWifi,
                    subtitle: _service
                        .getMediaDownloadOptionsForWifi()
                        .map((e) => _getTrans(e))
                        .toList()
                        .toString()
                        .replaceAll("[", "")
                        .replaceAll("]", "")
                        .text,
                    onTap: () => _onUpdateWifiData(
                      _service.getMediaDownloadOptionsForWifi(),
                    ),
                    icon: CupertinoIcons.wifi,
                  ),
                  SettingsListItemTile(
                    color: Colors.red,
                    title: S.of(context).clearAllCache,
                    subtitle:
                        S.of(context).clickThisOptionWillClearAppStorage.text,
                    onTap: _onDeleteCache,
                    icon: CupertinoIcons.delete,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTrans(MediaDownloadOptions data) {
    switch (data) {
      case MediaDownloadOptions.images:
        return S.of(context).image;
      case MediaDownloadOptions.videos:
        return S.of(context).video;
      case MediaDownloadOptions.files:
        return S.of(context).files;
    }
  }

  Future _onUpdateMobileData(
      List<MediaDownloadOptions> mediaDownloadOptionsForData) async {
    final res = await VAppAlert.chooseAlertDialog(
      context: context,
      inChoose: mediaDownloadOptionsForData,
    );
    await _service.updateMediaDownloadOptionsForData(options: res);
    setState(() {});
  }

  Future _onUpdateWifiData(
      List<MediaDownloadOptions> mediaDownloadOptionsForWifi) async {
    final res = await VAppAlert.chooseAlertDialog(
      context: context,
      inChoose: mediaDownloadOptionsForWifi,
    );
    await _service.updateMediaDownloadOptionsForWifi(options: res);
    setState(() {});
  }

  Future<void> _onDeleteCache() async {
    final res = await VAppAlert.showAskYesNoDialog(
      context: context,
      title: S.of(context).areYouSure,
      content: S.of(context).deleteAppCache,
    );
    if (res != 1) return;
    final dir = Directory(VFileUtils.downloadPath());
    await dir.delete(recursive: true);
    await dir.create(recursive: true);
    getDirSize();
  }
}
