import 'package:super_up_core/super_up_core.dart';

enum MediaDownloadOptions { images, videos, files }

class AutoDownloadMediaService {
  Future<void> updateMediaDownloadOptionsForData({
    required List<MediaDownloadOptions> options,
  }) async {
    await VAppPref.setList(
      SStorageKeys.mobileDataMediaDownloadOptions.name,
      options.map((e) => "mobile-${e.name}").toList(),
    );
  }

  List<MediaDownloadOptions> getMediaDownloadOptionsForData() {
    final list = VAppPref.getList(
      SStorageKeys.mobileDataMediaDownloadOptions.name,
    );
    if (list == null) return [MediaDownloadOptions.images];
    return list
        .map((e) => MediaDownloadOptions.values.byName(e.split("mobile-").last))
        .toList();
  }

  bool get mobileImage =>
      getMediaDownloadOptionsForData().contains(MediaDownloadOptions.images);

  bool get wifiImage =>
      getMediaDownloadOptionsForWifi().contains(MediaDownloadOptions.images);

  bool get mobileFile =>
      getMediaDownloadOptionsForData().contains(MediaDownloadOptions.files);

  bool get wifiFile =>
      getMediaDownloadOptionsForWifi().contains(MediaDownloadOptions.files);

  bool get mobileVideo =>
      getMediaDownloadOptionsForData().contains(MediaDownloadOptions.videos);

  bool get wifiVideo =>
      getMediaDownloadOptionsForWifi().contains(MediaDownloadOptions.videos);

  Future<void> updateMediaDownloadOptionsForWifi({
    required List<MediaDownloadOptions> options,
  }) async {
    await VAppPref.setList(
      SStorageKeys.wifiMediaDownloadOptions.name,
      options.map((e) => "wifi-${e.name}").toList(),
    );
  }

  List<MediaDownloadOptions> getMediaDownloadOptionsForWifi() {
    final list = VAppPref.getList(
      SStorageKeys.wifiMediaDownloadOptions.name,
    );
    if (list == null) return MediaDownloadOptions.values;

    return list
        .map((e) => MediaDownloadOptions.values.byName(e.split("wifi-").last))
        .toList();
  }
}
