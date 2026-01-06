// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

enum SStorageKeys {
  myProfile,
  vAccessToken,
  isLogin,
  phoneCountryKey,
  countryCode,
  appTheme,
  lastAcceptedCall,
  clintVersion,
  adminAccessPassword,
  isAskForContactPerm,
  isViewer,
  isFirstRun,
  appRootPath,
  appMetaData,
  appLanguageTitle,
  inAppAlerts,
  appLanguageCode,
  lastAppliedUpdate,
  lastSuccessFetchRoomsTime,
  vBaseUrl,
  appConfigModelData,
  mobileDataMediaDownloadOptions,
  wifiMediaDownloadOptions,
  roomWallpapers,
}

enum RegisterStatus {
  accepted,
  pending,
  notAccepted,
}

enum UserPrivacyType { forReq, public, none }

enum ApiI18nErrorRes {
  invalidLoginData,
  userEmailNotFound,
  yourAccountBlocked,
  yourAccountDeleted,
  userAlreadyRegister,
  codeHasBeenExpired,
  invalidCode,
  whileAuthCanFindYou,
  userRegisterStatusNotAcceptedYet,
  deviceHasBeenLogoutFromAllDevices,
  userDeviceSessionEndDeviceDeleted,
  noCodeHasBeenSendToYouToVerifyYourEmail,
  roomAlreadyInCall,
  peerUserInCallNow,
  callNotAllowed,
  peerUserDeviceOffline,
  emailMustBeValid,
  wait2MinutesToSendMail,
}

enum UserRoles { prime, admin, hasBadge, none }

enum ChatRequestStatus { accepted, refused, canceled, pending }

enum RegisterMethod { email, phone, apple, gmail, facebook,qrCode }
