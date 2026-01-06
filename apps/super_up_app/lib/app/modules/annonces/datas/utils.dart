import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:flutter_svg/svg.dart';

class Utils {
  static void showButtomSheet(BuildContext context, {required Widget widget}) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return widget;
      },
    );
  }

  static void printLog(dynamic object) {
    if (kDebugMode) {
      log(object.toString());
    }
  }

  static void printer(dynamic object) {
    if (kDebugMode) {
      print(object.toString());
    }
  }

  static void logger(dynamic object, {Level? level}) {
    if (kDebugMode) {
      var logger = Logger(level: level);
      logger.d(object.toString());
    }
  }

  static void loggerError(dynamic object) {
    if (kDebugMode) {
      var logger = Logger(level: Level.error);
      logger.e(object.toString());
    }
  }

  static void loadDatas() {}

  static Future<File?> pickImage(BuildContext context) async {
    File? file;
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        var svgPicture = SvgPicture.asset(
          "assets/icons/arrow_forward.svg",
          width: 35,
          height: 35,
          colorFilter: ColorFilter.mode(
            Colors.white,
            BlendMode.srcIn,
          ),
        );
        return BottomSheetContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Choisir la source de l'image",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                // weight: FontWeight.w600,
                // size: 20.w,
              ),
              SizedBox(height: 15),
              ListTile(
                onTap: () async {
                  file = await pickImageFromSource(ImageSource.gallery);
                  if (context.mounted) {
                    Navigator.pop(context, file);
                  }
                },
                title: Text(
                  "Galerie",
                  // weight: FontWeight.w600,
                  // size: 16.w,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                trailing: svgPicture,
                leading: leadingIcon(context, "assets/icons/gallery_icon.svg"),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                child: Divider(),
              ),
              SizedBox(height: 5),
              ListTile(
                onTap: () async {
                  file = await pickImageFromSource(ImageSource.camera);
                  if (context.mounted) {
                    Navigator.pop(context, file);
                  }
                },
                title: Text(
                  "Appareil photo",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  // weight: FontWeight.w600,
                  // size: 16.w,
                ),
                trailing: svgPicture,
                leading: leadingIcon(context, "assets/icons/camera_icon.svg"),
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
    return file;
  }

  static Future<File?> pickImageFromSource(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  // static String getCode() {
  //   return Get.locale?.languageCode.toLowerCase() == "fr" ? "Fr_fr" : "En_Us";
  // }

  static Widget leadingIcon(BuildContext context, String icon) {
    return CircleAvatar(
      backgroundColor: Colors.grey.shade800,
      radius: 30,
      child: Center(
        child: SvgPicture.asset(
          icon,
          width: 35,
          height: 35,
          colorFilter: ColorFilter.mode(
            Colors.white,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}

class BottomSheetContainer extends StatelessWidget {
  final Widget child;
  const BottomSheetContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 12, right: 20, left: 20, bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 75,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          SizedBox(height: 15),
          child,
        ],
      ),
    );
  }
}

// extention string
extension StringCapatilize on String {
  String capitilizeFirstLetter() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}

extension ContextExtentions on BuildContext {
  Color? get body1TextColor => Theme.of(this).textTheme.bodyMedium?.color;
  Color? get title1TextColor => Theme.of(this).textTheme.titleMedium?.color;
  Color? get scaffoldColors => Theme.of(this).scaffoldBackgroundColor;
  Color? get iconsColors => Theme.of(this).iconTheme.color;
}
