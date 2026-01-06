import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class LinkPreviewLoader extends StatefulWidget {
  const LinkPreviewLoader({
    super.key,
    required this.onGetData,
    required this.uri,
    required this.roomId,
  });

  final Uri uri;
  final String roomId;
  final Function(VLinkPreviewData? data) onGetData;

  @override
  State<LinkPreviewLoader> createState() => _LinkPreviewLoaderState();
}

Uri? _currentLoadedUrl;
List<Uri> _failureUrls = [];

class _LinkPreviewLoaderState extends State<LinkPreviewLoader> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: FutureBuilder<WebMetadata>(
        future: _currentLoadedUrl == widget.uri
            ? null
            : _failureUrls.contains(widget.uri)
                ? null
                : fetchUrlContent(widget.uri.toString()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: CupertinoActivityIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            widget.onGetData(null);
            _failureUrls.add(widget.uri);
            return const SizedBox.shrink();
          } else {
            _currentLoadedUrl = widget.uri;
            final data = snapshot.data;
            if (data == null) {
              return const SizedBox.shrink();
            }
            widget.onGetData(
              VLinkPreviewData(
                link: data.url,
                title: data.title,
                description: data.description ?? data.url,
                image: data.images.isEmpty
                    ? data.favicons.first
                    : data.images.first,
              ),
            );
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: CachedNetworkImage(
                  imageUrl: data.images.isEmpty
                      ? data.favicons.first
                      : data.images.first,
                  width: 70,
                  fit: BoxFit.cover,
                ),
                title: Text(data.title),
                subtitle: Text(
                  data.description ?? data.url,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                  maxLines: 3,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<WebMetadata> fetchUrlContent(String url) async {
    return VChatController.I.nativeApi.remote.room.getUrlPreview(
      roomId: widget.roomId,
      url: ensureHttpPrefix(url),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _currentLoadedUrl = null;
  }

  String ensureHttpPrefix(String url) {
    if (!url.startsWith(RegExp(r'https?:\/\/'))) {
      return 'https://$url';
    }
    return url;
  }
}
