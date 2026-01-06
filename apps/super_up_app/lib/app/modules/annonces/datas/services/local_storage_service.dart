// import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  final SharedPreferences preferences;
  LocalStorageService(this.preferences);

  Future logoutUser() async {
    await preferences.remove(userStorageKey);
    await preferences.remove(orderList);
  }

  Future<bool> storeFirstOpenTime(bool status) async {
    return await preferences.setBool(firstTimeKey, status);
  }

  bool isfirstOpenTime() {
    return preferences.getBool(firstTimeKey) ?? true;
  }

  Future<void> logOut() async {
    await preferences.remove("USER_STORAGE_KEY");
  }

  Future<bool> storeBiometricStatus(bool status) async {
    return await preferences.setBool(biometricTypeStorageKey, status);
  }

  bool getBiometricStatus() {
    return preferences.getBool(biometricTypeStorageKey) ?? false;
  }

  Future<bool> storeAppTheme(String status) async {
    return await preferences.setString(appThemeStorageKey, status);
  }

  String getAppTheme() {
    return preferences.getString(appThemeStorageKey) ?? "light";
  }

  Future<bool> storeCurrentLocal(String status) async {
    return await preferences.setString(currentLocalStorageKey, status);
  }

  String? getCurrentLocal() {
    return preferences.getString(currentLocalStorageKey);
  }

  Future<void> lockApp() async {
    await preferences.setBool(appIsLockedKey, true);
  }

  Future<void> unlockApp() async {
    await preferences.setBool(appIsLockedKey, false);
  }

  bool isAppLocked() {
    return preferences.getBool(appIsLockedKey) ?? true;
  }
}

const String appIsLockedKey = "APP_IS_LOCKED_KEY";
const String pauseTimeKey = "PAUSE_TIME_KEY";
const String appThemeStorageKey = "APP_THEME_STORAGE_KEY";
const String userStorageKey = "USER_STORAGE_KEY";
const String biometricTypeStorageKey = "BIOMETRIC_TYPE_STORAGE_KEY";
const String firstTimeKey = "USER_FIRST_TIME_KEY";
const String countriesStorageList = "Countries_Storage_List";
const String orderList = "Order_List";
const String providersStorageKey = "PROVIDERS_STORAGE_KEY";
const String servicesStorageKey = "SERVICES_STORAGE_KEY";
const String serviceProvidersStorageKey = "SERVICE_PROVIDERS_STORAGE_KEY";
const String userTokenStorageKey = "USER_TOKEN_STORAGE_KEY";
const String currentAttachmentStorageKey = "CURRENT_ATTACHMENT_STORAGE_KEY";
const String currentLocalStorageKey = "CURRENT_LOCAL_STORAGE_KEY";
