# Whizpee Android ProGuard Rules
# Optimisé pour une release propre et sécurisée

#################################################
## Core Android and Flutter Rules              ##
#################################################
-keep class com.google.devtools.build.android.desugar.runtime.ThrowableExtension { *; }
-dontwarn com.google.devtools.build.android.desugar.runtime.ThrowableExtension

# Flutter specific rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

#################################################
## VChat SDK Rules (Critical for messaging)    ##
#################################################
-keep class com.hiennv.flutter_callkit_incoming.** { *; }
-keep class v_chat_sdk_core.** { *; }
-keep class com.pravera.flutter_foreground_task.** { *; }

#################################################
## Firebase Rules                              ##
#################################################
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# Firebase Messaging
-keep class com.google.firebase.messaging.** { *; }
-keep class com.google.firebase.auth.** { *; }

#################################################
## Agora Video Calling Rules                   ##
#################################################
-keep class io.agora.** { *; }
-dontwarn io.agora.**

#################################################
## Network and HTTP Libraries                  ##
#################################################
# Dio and HTTP client rules
-keep class dio.** { *; }
-keep class retrofit2.** { *; }
-keep class okhttp3.** { *; }
-dontwarn okhttp3.**
-dontwarn retrofit2.**

# Chopper HTTP client
-keep class chopper.** { *; }
-dontwarn chopper.**

#################################################
## JSON and Serialization                      ##
#################################################
-keep class com.fasterxml.jackson.databind.** { *; }
-keep class com.fasterxml.jackson.core.** { *; }
-dontwarn com.fasterxml.jackson.databind.**
-dontwarn com.fasterxml.jackson.core.**

# Keep all model classes (for JSON serialization)
-keep class com.whizpee.app.models.** { *; }
-keep class * extends java.lang.Enum { *; }

#################################################
## Java Standard Library Rules                 ##
#################################################
-keep class java.beans.** { *; }
-dontwarn java.beans.ConstructorProperties
-dontwarn java.beans.Transient

-keep class org.w3c.dom.** { *; }
-dontwarn org.w3c.dom.bootstrap.DOMImplementationRegistry

#################################################
## Google Services and Maps                    ##
#################################################
-keep class com.google.android.libraries.maps.** { *; }
-keep class com.google.maps.** { *; }
-dontwarn com.google.android.libraries.maps.**

# Google Ads
-keep class com.google.android.gms.ads.** { *; }

#################################################
## Media and Image Processing                  ##
#################################################
# Image picker and editor
-keep class com.yalantis.ucrop.** { *; }
-dontwarn com.yalantis.ucrop.**

# Background downloader
-keep class com.bbflight.background_downloader.** { *; }

#################################################
## Contacts and Permissions                    ##
#################################################
-keep class flutter_contacts.** { *; }
-keep class permission_handler_android.** { *; }

#################################################
## General Optimization Rules                  ##
#################################################
# Remove debug information but keep line numbers for crash reports
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile

# Keep native method names
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep custom application class
-keep public class com.whizpee.app.MainApplication { *; }

# Prevent obfuscation of classes with custom serialization
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    !static !transient <fields>;
    !private <fields>;
    !private <methods>;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

#################################################
## Security and Crash Prevention               ##
#################################################
# Don't warn about missing classes that might not be needed
-dontwarn javax.annotation.**
-dontwarn kotlin.**
-dontwarn kotlinx.**
-dontwarn org.jetbrains.annotations.**

# Google Play Core (for split compatibility)
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }
-keep class com.google.android.play.core.splitcompat.** { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }

# Flutter deferred components
-keep class io.flutter.embedding.engine.deferredcomponents.** { *; }
-dontwarn io.flutter.embedding.engine.deferredcomponents.**
