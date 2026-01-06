import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:super_up/app/core/theme/app_theme_manager.dart';
import 'package:super_up/app/modules/annonces/presentation/announcement_detail_page.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart' show Annonces;

class AnnoncmentComponent extends StatelessWidget {
  final Annonces announcement;
  const AnnoncmentComponent({
    super.key,
    required this.announcement,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: () {
          context.toPage(
            AnnouncementDetailPage(announcement: announcement),
          );
        },
        child: Card(
          color: Colors.transparent,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
                // color: white.withOpacity(0.2)
                ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 200 * 9 / 16,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(10),
                    image: kIsWeb
                        ? DecorationImage(
                            image: NetworkImage(
                                announcement.images?.firstOrNull ?? ''),
                            fit: BoxFit.cover,
                          )
                        : DecorationImage(
                            image: CachedNetworkImageProvider(
                              announcement.images?.firstOrNull ?? "",
                            ),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          announcement.title,
                          style: const TextStyle(
                              // color: white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          announcement.description,
                          // style: TextStyle(color: white.withOpacity(0.7)),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // const Spacer(),
                            Icon(Icons.location_on,
                                // color: white.withOpacity(0.5),
                                size: 16),
                            const SizedBox(width: 2),
                            Expanded(
                              child: Text(
                                announcement.ville ?? "Unknown",
                                style: TextStyle(
                                    // color: white.withOpacity(0.5)
                                    ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Publié le: ${DateFormat('MMMM d, yyyy').format(announcement.createdAt)}',
                          style: TextStyle(
                              // color: white.withOpacity(0.5),
                              fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
