import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'lib/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('bn'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('id'),
    Locale('ja'),
    Locale('ko'),
    Locale('ml'),
    Locale('pt'),
    Locale('ru'),
    Locale('tr'),
    Locale('vi'),
    Locale('zh')
  ];

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading ...'**
  String get loading;

  /// No description provided for @messageHasBeenDeleted.
  ///
  /// In en, this message translates to:
  /// **'Message has been deleted'**
  String get messageHasBeenDeleted;

  /// No description provided for @mute.
  ///
  /// In en, this message translates to:
  /// **'Mute'**
  String get mute;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @typing.
  ///
  /// In en, this message translates to:
  /// **'Typing...'**
  String get typing;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @recording.
  ///
  /// In en, this message translates to:
  /// **'Recording...'**
  String get recording;

  /// No description provided for @connecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting...'**
  String get connecting;

  /// No description provided for @deleteYouCopy.
  ///
  /// In en, this message translates to:
  /// **'Delete your copy'**
  String get deleteYouCopy;

  /// No description provided for @unMute.
  ///
  /// In en, this message translates to:
  /// **'Un mute'**
  String get unMute;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// No description provided for @leaveGroup.
  ///
  /// In en, this message translates to:
  /// **'Leave group'**
  String get leaveGroup;

  /// No description provided for @areYouSureToPermitYourCopyThisActionCantUndo.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to permit your copy? This action can\'t undo'**
  String get areYouSureToPermitYourCopyThisActionCantUndo;

  /// No description provided for @areYouSureToLeaveThisGroupThisActionCantUndo.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to leave this group? This action can\'t undo'**
  String get areYouSureToLeaveThisGroupThisActionCantUndo;

  /// No description provided for @leaveGroupAndDeleteYourMessageCopy.
  ///
  /// In en, this message translates to:
  /// **'Leave group and delete your message copy'**
  String get leaveGroupAndDeleteYourMessageCopy;

  /// No description provided for @vMessageInfoTrans.
  ///
  /// In en, this message translates to:
  /// **'Message info'**
  String get vMessageInfoTrans;

  /// No description provided for @updateTitleTo.
  ///
  /// In en, this message translates to:
  /// **'Update title to'**
  String get updateTitleTo;

  /// No description provided for @updateImage.
  ///
  /// In en, this message translates to:
  /// **'Update image'**
  String get updateImage;

  /// No description provided for @joinedBy.
  ///
  /// In en, this message translates to:
  /// **'Joined by'**
  String get joinedBy;

  /// No description provided for @promotedToAdminBy.
  ///
  /// In en, this message translates to:
  /// **'Promoted to admin by'**
  String get promotedToAdminBy;

  /// No description provided for @dismissedToMemberBy.
  ///
  /// In en, this message translates to:
  /// **'Dismissed to member by'**
  String get dismissedToMemberBy;

  /// No description provided for @leftTheGroup.
  ///
  /// In en, this message translates to:
  /// **'Left the group'**
  String get leftTheGroup;

  /// No description provided for @you.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get you;

  /// No description provided for @kickedBy.
  ///
  /// In en, this message translates to:
  /// **'Kicked by'**
  String get kickedBy;

  /// No description provided for @groupCreatedBy.
  ///
  /// In en, this message translates to:
  /// **'Group created by'**
  String get groupCreatedBy;

  /// No description provided for @addedYouToNewBroadcast.
  ///
  /// In en, this message translates to:
  /// **'Added you to new broadcast'**
  String get addedYouToNewBroadcast;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @forward.
  ///
  /// In en, this message translates to:
  /// **'Forward'**
  String get forward;

  /// No description provided for @reply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reply;

  /// No description provided for @deleteFromAll.
  ///
  /// In en, this message translates to:
  /// **'Delete from all'**
  String get deleteFromAll;

  /// No description provided for @deleteFromMe.
  ///
  /// In en, this message translates to:
  /// **'Delete from me'**
  String get deleteFromMe;

  /// No description provided for @downloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading...'**
  String get downloading;

  /// No description provided for @fileHasBeenSavedTo.
  ///
  /// In en, this message translates to:
  /// **'File has been saved to'**
  String get fileHasBeenSavedTo;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @youDontHaveAccess.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have access'**
  String get youDontHaveAccess;

  /// No description provided for @replyToYourSelf.
  ///
  /// In en, this message translates to:
  /// **'Reply to your self'**
  String get replyToYourSelf;

  /// No description provided for @repliedToYourSelf.
  ///
  /// In en, this message translates to:
  /// **'Replied to your self'**
  String get repliedToYourSelf;

  /// No description provided for @audioCall.
  ///
  /// In en, this message translates to:
  /// **'Audio call'**
  String get audioCall;

  /// No description provided for @ring.
  ///
  /// In en, this message translates to:
  /// **'Ring'**
  String get ring;

  /// No description provided for @canceled.
  ///
  /// In en, this message translates to:
  /// **'Canceled'**
  String get canceled;

  /// No description provided for @timeout.
  ///
  /// In en, this message translates to:
  /// **'Timeout'**
  String get timeout;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @finished.
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get finished;

  /// No description provided for @inCall.
  ///
  /// In en, this message translates to:
  /// **'In call'**
  String get inCall;

  /// No description provided for @sessionEnd.
  ///
  /// In en, this message translates to:
  /// **'Session end'**
  String get sessionEnd;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @textFieldHint.
  ///
  /// In en, this message translates to:
  /// **'Type a message ...'**
  String get textFieldHint;

  /// No description provided for @files.
  ///
  /// In en, this message translates to:
  /// **'Files'**
  String get files;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @shareMediaAndLocation.
  ///
  /// In en, this message translates to:
  /// **'Share media and location'**
  String get shareMediaAndLocation;

  /// No description provided for @thereIsVideoSizeBiggerThanAllowedSize.
  ///
  /// In en, this message translates to:
  /// **'There is video size bigger than allowed size'**
  String get thereIsVideoSizeBiggerThanAllowedSize;

  /// No description provided for @thereIsFileHasSizeBiggerThanAllowedSize.
  ///
  /// In en, this message translates to:
  /// **'There is file has size bigger than allowed size'**
  String get thereIsFileHasSizeBiggerThanAllowedSize;

  /// No description provided for @makeCall.
  ///
  /// In en, this message translates to:
  /// **'Make call'**
  String get makeCall;

  /// No description provided for @areYouWantToMakeVideoCall.
  ///
  /// In en, this message translates to:
  /// **'Are you want to make video call?'**
  String get areYouWantToMakeVideoCall;

  /// No description provided for @areYouWantToMakeVoiceCall.
  ///
  /// In en, this message translates to:
  /// **'Are you want to make voice call?'**
  String get areYouWantToMakeVoiceCall;

  /// No description provided for @vMessagesInfoTrans.
  ///
  /// In en, this message translates to:
  /// **'Messages info'**
  String get vMessagesInfoTrans;

  /// No description provided for @star.
  ///
  /// In en, this message translates to:
  /// **'Star'**
  String get star;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutes;

  /// No description provided for @sendMessage.
  ///
  /// In en, this message translates to:
  /// **'Send message'**
  String get sendMessage;

  /// No description provided for @deleteUser.
  ///
  /// In en, this message translates to:
  /// **'Delete user'**
  String get deleteUser;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// No description provided for @youAreAboutToDeleteThisUserFromYourList.
  ///
  /// In en, this message translates to:
  /// **'You are about to delete this user from your list'**
  String get youAreAboutToDeleteThisUserFromYourList;

  /// No description provided for @updateBroadcastTitle.
  ///
  /// In en, this message translates to:
  /// **'Update broadcast title'**
  String get updateBroadcastTitle;

  /// No description provided for @usersAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Users added successfully'**
  String get usersAddedSuccessfully;

  /// No description provided for @broadcastSettings.
  ///
  /// In en, this message translates to:
  /// **'Broadcast settings'**
  String get broadcastSettings;

  /// No description provided for @addParticipants.
  ///
  /// In en, this message translates to:
  /// **'Add Participants'**
  String get addParticipants;

  /// No description provided for @broadcastParticipants.
  ///
  /// In en, this message translates to:
  /// **'Broadcast Participants'**
  String get broadcastParticipants;

  /// No description provided for @updateGroupDescription.
  ///
  /// In en, this message translates to:
  /// **'Update group description'**
  String get updateGroupDescription;

  /// No description provided for @updateGroupTitle.
  ///
  /// In en, this message translates to:
  /// **'Update group title'**
  String get updateGroupTitle;

  /// No description provided for @groupSettings.
  ///
  /// In en, this message translates to:
  /// **'Group settings'**
  String get groupSettings;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @muteNotifications.
  ///
  /// In en, this message translates to:
  /// **'Mute notifications'**
  String get muteNotifications;

  /// No description provided for @groupParticipants.
  ///
  /// In en, this message translates to:
  /// **'Group Participants'**
  String get groupParticipants;

  /// No description provided for @blockUser.
  ///
  /// In en, this message translates to:
  /// **'Block user'**
  String get blockUser;

  /// No description provided for @areYouSureToBlock.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to block'**
  String get areYouSureToBlock;

  /// No description provided for @userPage.
  ///
  /// In en, this message translates to:
  /// **'User page'**
  String get userPage;

  /// No description provided for @starMessage.
  ///
  /// In en, this message translates to:
  /// **'Star message'**
  String get starMessage;

  /// No description provided for @showMedia.
  ///
  /// In en, this message translates to:
  /// **'Show media'**
  String get showMedia;

  /// No description provided for @reportUser.
  ///
  /// In en, this message translates to:
  /// **'Report user'**
  String get reportUser;

  /// No description provided for @groupName.
  ///
  /// In en, this message translates to:
  /// **'group name'**
  String get groupName;

  /// No description provided for @changeSubject.
  ///
  /// In en, this message translates to:
  /// **'Change subject'**
  String get changeSubject;

  /// No description provided for @titleIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get titleIsRequired;

  /// No description provided for @createBroadcast.
  ///
  /// In en, this message translates to:
  /// **'Create Broadcast'**
  String get createBroadcast;

  /// No description provided for @broadcastName.
  ///
  /// In en, this message translates to:
  /// **'Broadcast name'**
  String get broadcastName;

  /// No description provided for @createGroup.
  ///
  /// In en, this message translates to:
  /// **'Create Group'**
  String get createGroup;

  /// No description provided for @forgetPassword.
  ///
  /// In en, this message translates to:
  /// **'Forget Password?'**
  String get forgetPassword;

  /// No description provided for @globalSearch.
  ///
  /// In en, this message translates to:
  /// **'Global Search'**
  String get globalSearch;

  /// No description provided for @dismissesToMember.
  ///
  /// In en, this message translates to:
  /// **'Dismisses to member'**
  String get dismissesToMember;

  /// No description provided for @setToAdmin.
  ///
  /// In en, this message translates to:
  /// **'Set to admin'**
  String get setToAdmin;

  /// No description provided for @kickMember.
  ///
  /// In en, this message translates to:
  /// **'Kick member'**
  String get kickMember;

  /// No description provided for @youAreAboutToDismissesToMember.
  ///
  /// In en, this message translates to:
  /// **'You are about to dismisses to member'**
  String get youAreAboutToDismissesToMember;

  /// No description provided for @youAreAboutToKick.
  ///
  /// In en, this message translates to:
  /// **'You are about to kick'**
  String get youAreAboutToKick;

  /// No description provided for @groupMembers.
  ///
  /// In en, this message translates to:
  /// **'Group Members'**
  String get groupMembers;

  /// No description provided for @tapForPhoto.
  ///
  /// In en, this message translates to:
  /// **'Tap for photo'**
  String get tapForPhoto;

  /// No description provided for @weHighRecommendToDownloadThisUpdate.
  ///
  /// In en, this message translates to:
  /// **'We high recommend to download this update'**
  String get weHighRecommendToDownloadThisUpdate;

  /// No description provided for @newGroup.
  ///
  /// In en, this message translates to:
  /// **'New group'**
  String get newGroup;

  /// No description provided for @newBroadcast.
  ///
  /// In en, this message translates to:
  /// **'New broadcast'**
  String get newBroadcast;

  /// No description provided for @starredMessage.
  ///
  /// In en, this message translates to:
  /// **'Starred message'**
  String get starredMessage;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @chats.
  ///
  /// In en, this message translates to:
  /// **'CHATS'**
  String get chats;

  /// No description provided for @recentUpdates.
  ///
  /// In en, this message translates to:
  /// **'Recent updates'**
  String get recentUpdates;

  /// No description provided for @startChat.
  ///
  /// In en, this message translates to:
  /// **'Start chat'**
  String get startChat;

  /// No description provided for @newUpdateIsAvailable.
  ///
  /// In en, this message translates to:
  /// **'New update is available'**
  String get newUpdateIsAvailable;

  /// No description provided for @emailNotValid.
  ///
  /// In en, this message translates to:
  /// **'Email not valid'**
  String get emailNotValid;

  /// No description provided for @passwordMustHaveValue.
  ///
  /// In en, this message translates to:
  /// **'Password must have value'**
  String get passwordMustHaveValue;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @needNewAccount.
  ///
  /// In en, this message translates to:
  /// **'Need new account?'**
  String get needNewAccount;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @nameMustHaveValue.
  ///
  /// In en, this message translates to:
  /// **'Name must have value'**
  String get nameMustHaveValue;

  /// No description provided for @passwordNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Password not match'**
  String get passwordNotMatch;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @alreadyHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAnAccount;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @sendCodeToMyEmail.
  ///
  /// In en, this message translates to:
  /// **'Send code to my email'**
  String get sendCodeToMyEmail;

  /// No description provided for @invalidLoginData.
  ///
  /// In en, this message translates to:
  /// **'Invalid login data'**
  String get invalidLoginData;

  /// No description provided for @userEmailNotFound.
  ///
  /// In en, this message translates to:
  /// **'User email not found'**
  String get userEmailNotFound;

  /// No description provided for @yourAccountBlocked.
  ///
  /// In en, this message translates to:
  /// **'Your account has been baned'**
  String get yourAccountBlocked;

  /// No description provided for @yourAccountDeleted.
  ///
  /// In en, this message translates to:
  /// **'Your account has been deleted'**
  String get yourAccountDeleted;

  /// No description provided for @userAlreadyRegister.
  ///
  /// In en, this message translates to:
  /// **'User already register'**
  String get userAlreadyRegister;

  /// No description provided for @codeHasBeenExpired.
  ///
  /// In en, this message translates to:
  /// **'Code has been expired'**
  String get codeHasBeenExpired;

  /// No description provided for @invalidCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid code'**
  String get invalidCode;

  /// No description provided for @whileAuthCanFindYou.
  ///
  /// In en, this message translates to:
  /// **'While authentication cannot find you'**
  String get whileAuthCanFindYou;

  /// No description provided for @userRegisterStatusNotAcceptedYet.
  ///
  /// In en, this message translates to:
  /// **'User register status not accepted yet'**
  String get userRegisterStatusNotAcceptedYet;

  /// No description provided for @deviceHasBeenLogoutFromAllDevices.
  ///
  /// In en, this message translates to:
  /// **'Device has been logout from all devices'**
  String get deviceHasBeenLogoutFromAllDevices;

  /// No description provided for @userDeviceSessionEndDeviceDeleted.
  ///
  /// In en, this message translates to:
  /// **'User device session end device deleted'**
  String get userDeviceSessionEndDeviceDeleted;

  /// No description provided for @noCodeHasBeenSendToYouToVerifyYourEmail.
  ///
  /// In en, this message translates to:
  /// **'No code has been send to you to verify your email'**
  String get noCodeHasBeenSendToYouToVerifyYourEmail;

  /// No description provided for @roomAlreadyInCall.
  ///
  /// In en, this message translates to:
  /// **'Room already in call'**
  String get roomAlreadyInCall;

  /// No description provided for @peerUserInCallNow.
  ///
  /// In en, this message translates to:
  /// **'User in call now'**
  String get peerUserInCallNow;

  /// No description provided for @callNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'Call not allowed'**
  String get callNotAllowed;

  /// No description provided for @peerUserDeviceOffline.
  ///
  /// In en, this message translates to:
  /// **'Peer user device offline'**
  String get peerUserDeviceOffline;

  /// No description provided for @emailMustBeValid.
  ///
  /// In en, this message translates to:
  /// **'Email must be valid'**
  String get emailMustBeValid;

  /// No description provided for @wait2MinutesToSendMail.
  ///
  /// In en, this message translates to:
  /// **'Wait 2 minutes to send mail'**
  String get wait2MinutesToSendMail;

  /// No description provided for @codeMustEqualToSixNumbers.
  ///
  /// In en, this message translates to:
  /// **'Code must equal to six numbers'**
  String get codeMustEqualToSixNumbers;

  /// No description provided for @newPasswordMustHaveValue.
  ///
  /// In en, this message translates to:
  /// **'New password must have value'**
  String get newPasswordMustHaveValue;

  /// No description provided for @confirmPasswordMustHaveValue.
  ///
  /// In en, this message translates to:
  /// **'Confirm password must have value'**
  String get confirmPasswordMustHaveValue;

  /// No description provided for @congregationsYourAccountHasBeenAccepted.
  ///
  /// In en, this message translates to:
  /// **'Congregations your account has been accepted'**
  String get congregationsYourAccountHasBeenAccepted;

  /// No description provided for @yourAccountIsUnderReview.
  ///
  /// In en, this message translates to:
  /// **'Your account is under review'**
  String get yourAccountIsUnderReview;

  /// No description provided for @waitingList.
  ///
  /// In en, this message translates to:
  /// **'Waiting List'**
  String get waitingList;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @deleteMember.
  ///
  /// In en, this message translates to:
  /// **'Delete member'**
  String get deleteMember;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @broadcastInfo.
  ///
  /// In en, this message translates to:
  /// **'Broadcast info'**
  String get broadcastInfo;

  /// No description provided for @updateTitle.
  ///
  /// In en, this message translates to:
  /// **'Update title'**
  String get updateTitle;

  /// No description provided for @members.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get members;

  /// No description provided for @addMembers.
  ///
  /// In en, this message translates to:
  /// **'Add Members'**
  String get addMembers;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @media.
  ///
  /// In en, this message translates to:
  /// **'Media'**
  String get media;

  /// No description provided for @docs.
  ///
  /// In en, this message translates to:
  /// **'Docs'**
  String get docs;

  /// No description provided for @links.
  ///
  /// In en, this message translates to:
  /// **'Links'**
  String get links;

  /// No description provided for @soon.
  ///
  /// In en, this message translates to:
  /// **'Soon'**
  String get soon;

  /// No description provided for @unStar.
  ///
  /// In en, this message translates to:
  /// **'Un star'**
  String get unStar;

  /// No description provided for @updateGroupDescriptionWillUpdateAllGroupMembers.
  ///
  /// In en, this message translates to:
  /// **'Update group description will update all group members'**
  String get updateGroupDescriptionWillUpdateAllGroupMembers;

  /// No description provided for @updateNickname.
  ///
  /// In en, this message translates to:
  /// **'Update nickname'**
  String get updateNickname;

  /// No description provided for @groupInfo.
  ///
  /// In en, this message translates to:
  /// **'Group info'**
  String get groupInfo;

  /// No description provided for @youNotParticipantInThisGroup.
  ///
  /// In en, this message translates to:
  /// **'You not participant in this group'**
  String get youNotParticipantInThisGroup;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @mediaLinksAndDocs.
  ///
  /// In en, this message translates to:
  /// **'Media, Links, and Docs'**
  String get mediaLinksAndDocs;

  /// No description provided for @starredMessages.
  ///
  /// In en, this message translates to:
  /// **'Starred Messages'**
  String get starredMessages;

  /// No description provided for @nickname.
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get nickname;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @exitGroup.
  ///
  /// In en, this message translates to:
  /// **'Exit Group'**
  String get exitGroup;

  /// No description provided for @clickToAddGroupDescription.
  ///
  /// In en, this message translates to:
  /// **'Click to add group description'**
  String get clickToAddGroupDescription;

  /// No description provided for @unBlockUser.
  ///
  /// In en, this message translates to:
  /// **'Un block user'**
  String get unBlockUser;

  /// No description provided for @areYouSureToUnBlock.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to un block'**
  String get areYouSureToUnBlock;

  /// No description provided for @contactInfo.
  ///
  /// In en, this message translates to:
  /// **'Contact info'**
  String get contactInfo;

  /// No description provided for @audio.
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get audio;

  /// No description provided for @video.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get video;

  /// No description provided for @hiIamUse.
  ///
  /// In en, this message translates to:
  /// **'Hi iam using'**
  String get hiIamUse;

  /// No description provided for @on.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get on;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get off;

  /// No description provided for @unBlock.
  ///
  /// In en, this message translates to:
  /// **'Un Block'**
  String get unBlock;

  /// No description provided for @block.
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get block;

  /// No description provided for @chooseAtLestOneMember.
  ///
  /// In en, this message translates to:
  /// **'Choose at lest one member'**
  String get chooseAtLestOneMember;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @appMembers.
  ///
  /// In en, this message translates to:
  /// **'App members'**
  String get appMembers;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @upgradeToAdmin.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to admin'**
  String get upgradeToAdmin;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @deleteChat.
  ///
  /// In en, this message translates to:
  /// **'Delete chat'**
  String get deleteChat;

  /// No description provided for @clearChat.
  ///
  /// In en, this message translates to:
  /// **'Clear chat'**
  String get clearChat;

  /// No description provided for @showHistory.
  ///
  /// In en, this message translates to:
  /// **'Show history'**
  String get showHistory;

  /// No description provided for @groupIcon.
  ///
  /// In en, this message translates to:
  /// **'Group icon'**
  String get groupIcon;

  /// No description provided for @tapToSelectAnIcon.
  ///
  /// In en, this message translates to:
  /// **'Tap to select an icon'**
  String get tapToSelectAnIcon;

  /// No description provided for @groupDescription.
  ///
  /// In en, this message translates to:
  /// **'Group description'**
  String get groupDescription;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @messageInfo.
  ///
  /// In en, this message translates to:
  /// **'Message info'**
  String get messageInfo;

  /// No description provided for @successfullyDownloadedIn.
  ///
  /// In en, this message translates to:
  /// **'Successfully downloaded in'**
  String get successfullyDownloadedIn;

  /// No description provided for @delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get delivered;

  /// No description provided for @read.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get read;

  /// No description provided for @orLoginWith.
  ///
  /// In en, this message translates to:
  /// **'or login with'**
  String get orLoginWith;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPassword;

  /// No description provided for @otpCode.
  ///
  /// In en, this message translates to:
  /// **'OTP Code'**
  String get otpCode;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @areYouSure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get areYouSure;

  /// No description provided for @broadcastMembers.
  ///
  /// In en, this message translates to:
  /// **'Broadcast Members'**
  String get broadcastMembers;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// No description provided for @calls.
  ///
  /// In en, this message translates to:
  /// **'Calls'**
  String get calls;

  /// No description provided for @yourAreAboutToLogoutFromThisAccount.
  ///
  /// In en, this message translates to:
  /// **'Your are about to logout from this account'**
  String get yourAreAboutToLogoutFromThisAccount;

  /// No description provided for @noUpdatesAvailableNow.
  ///
  /// In en, this message translates to:
  /// **'No updates available now'**
  String get noUpdatesAvailableNow;

  /// No description provided for @dataPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Data privacy'**
  String get dataPrivacy;

  /// No description provided for @allDataHasBeenBackupYouDontNeedToManageSaveTheDataByYourself.
  ///
  /// In en, this message translates to:
  /// **'All data has been backup you don\\\'t want need to manage save the data by your self! if you logout and login again you will see all chats same for web version'**
  String get allDataHasBeenBackupYouDontNeedToManageSaveTheDataByYourself;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @linkedDevices.
  ///
  /// In en, this message translates to:
  /// **'Linked Devices'**
  String get linkedDevices;

  /// No description provided for @storageAndData.
  ///
  /// In en, this message translates to:
  /// **'Storage and Data'**
  String get storageAndData;

  /// No description provided for @tellAFriend.
  ///
  /// In en, this message translates to:
  /// **'Tell a friend'**
  String get tellAFriend;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @blockedUsers.
  ///
  /// In en, this message translates to:
  /// **'Blocked users'**
  String get blockedUsers;

  /// No description provided for @inAppAlerts.
  ///
  /// In en, this message translates to:
  /// **'In app alerts'**
  String get inAppAlerts;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @adminNotification.
  ///
  /// In en, this message translates to:
  /// **'Admin notification'**
  String get adminNotification;

  /// No description provided for @checkForUpdates.
  ///
  /// In en, this message translates to:
  /// **'Check for updates'**
  String get checkForUpdates;

  /// No description provided for @linkByQrCode.
  ///
  /// In en, this message translates to:
  /// **'Link By Qr Code'**
  String get linkByQrCode;

  /// No description provided for @deviceStatus.
  ///
  /// In en, this message translates to:
  /// **'Device status'**
  String get deviceStatus;

  /// No description provided for @desktopAndOtherDevices.
  ///
  /// In en, this message translates to:
  /// **'Desktop, and other devices'**
  String get desktopAndOtherDevices;

  /// No description provided for @linkADeviceSoon.
  ///
  /// In en, this message translates to:
  /// **'Link a Device (Soon)'**
  String get linkADeviceSoon;

  /// No description provided for @lastActiveFrom.
  ///
  /// In en, this message translates to:
  /// **'Last active from'**
  String get lastActiveFrom;

  /// No description provided for @tapADeviceToEditOrLogOut.
  ///
  /// In en, this message translates to:
  /// **'Tap a device to edit or log out.'**
  String get tapADeviceToEditOrLogOut;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @supportChatSoon.
  ///
  /// In en, this message translates to:
  /// **'Support chat (Soon)'**
  String get supportChatSoon;

  /// No description provided for @updateYourName.
  ///
  /// In en, this message translates to:
  /// **'Update your name'**
  String get updateYourName;

  /// No description provided for @updateYourBio.
  ///
  /// In en, this message translates to:
  /// **'Update your bio'**
  String get updateYourBio;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @oldPassword.
  ///
  /// In en, this message translates to:
  /// **'Old password'**
  String get oldPassword;

  /// No description provided for @deleteMyAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete my account'**
  String get deleteMyAccount;

  /// No description provided for @passwordHasBeenChanged.
  ///
  /// In en, this message translates to:
  /// **'Password has been changed'**
  String get passwordHasBeenChanged;

  /// No description provided for @logoutFromAllDevices.
  ///
  /// In en, this message translates to:
  /// **'Logout from all devices?'**
  String get logoutFromAllDevices;

  /// No description provided for @updateYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Update your password'**
  String get updateYourPassword;

  /// No description provided for @enterNameAndAddOptionalProfilePicture.
  ///
  /// In en, this message translates to:
  /// **'Enter your name and add an optional profile picture'**
  String get enterNameAndAddOptionalProfilePicture;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @reportHasBeenSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Your report has been submitted'**
  String get reportHasBeenSubmitted;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @harassmentOrBullyingDescription.
  ///
  /// In en, this message translates to:
  /// **'Harassment or Bullying: This option allows users to report individuals who are targeting them or others with harassing messages, threats, or other forms of bullying.'**
  String get harassmentOrBullyingDescription;

  /// No description provided for @spamOrScamDescription.
  ///
  /// In en, this message translates to:
  /// **'Spam or Scam: This option would be for users to report accounts that are sending spam messages, unsolicited advertisements, or are attempting to scam others.'**
  String get spamOrScamDescription;

  /// No description provided for @areYouSureToReportUserToAdmin.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to submit report about this user to the admin?'**
  String get areYouSureToReportUserToAdmin;

  /// No description provided for @groupWith.
  ///
  /// In en, this message translates to:
  /// **'Group with'**
  String get groupWith;

  /// No description provided for @inappropriateContentDescription.
  ///
  /// In en, this message translates to:
  /// **'Inappropriate Content: Users can select this option to report any sexually explicit material, hate speech, or other content that violates community standards.'**
  String get inappropriateContentDescription;

  /// No description provided for @otherCategoryDescription.
  ///
  /// In en, this message translates to:
  /// **'Other: This catch-all category can be used for violations that don\'t easily fit into the above categories. It might be helpful to include a text box for users to provide additional details.'**
  String get otherCategoryDescription;

  /// No description provided for @explainWhatHappens.
  ///
  /// In en, this message translates to:
  /// **'Explain here what happens'**
  String get explainWhatHappens;

  /// No description provided for @loginAgain.
  ///
  /// In en, this message translates to:
  /// **'Login again!'**
  String get loginAgain;

  /// No description provided for @yourSessionIsEndedPleaseLoginAgain.
  ///
  /// In en, this message translates to:
  /// **'Your session is ended please login again!'**
  String get yourSessionIsEndedPleaseLoginAgain;

  /// No description provided for @aboutToBlockUserWithConsequences.
  ///
  /// In en, this message translates to:
  /// **'You are about to block this user. You can\'t send him chats and can\'t add him to groups or broadcast!'**
  String get aboutToBlockUserWithConsequences;

  /// No description provided for @youAreAboutToDeleteYourAccountYourAccountWillNotAppearAgainInUsersList.
  ///
  /// In en, this message translates to:
  /// **'You are about to delete your account your account will not appears again in the users list'**
  String
      get youAreAboutToDeleteYourAccountYourAccountWillNotAppearAgainInUsersList;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @member.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get member;

  /// No description provided for @creator.
  ///
  /// In en, this message translates to:
  /// **'Creator'**
  String get creator;

  /// No description provided for @currentDevice.
  ///
  /// In en, this message translates to:
  /// **'Current device'**
  String get currentDevice;

  /// No description provided for @visits.
  ///
  /// In en, this message translates to:
  /// **'Visits'**
  String get visits;

  /// No description provided for @chooseRoom.
  ///
  /// In en, this message translates to:
  /// **'Choose room'**
  String get chooseRoom;

  /// No description provided for @deleteThisDeviceDesc.
  ///
  /// In en, this message translates to:
  /// **'Deleting this device means instantly logout this device'**
  String get deleteThisDeviceDesc;

  /// No description provided for @youAreAboutToUpgradeToAdmin.
  ///
  /// In en, this message translates to:
  /// **'You are about to upgrade to admin'**
  String get youAreAboutToUpgradeToAdmin;

  /// No description provided for @microphonePermissionMustBeAccepted.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission must be accepted'**
  String get microphonePermissionMustBeAccepted;

  /// No description provided for @microphoneAndCameraPermissionMustBeAccepted.
  ///
  /// In en, this message translates to:
  /// **'Microphone and camera permission must be accepted'**
  String get microphoneAndCameraPermissionMustBeAccepted;

  /// No description provided for @loginNowAllowedNowPleaseTryAgainLater.
  ///
  /// In en, this message translates to:
  /// **'Login now allowed. Please try again later.'**
  String get loginNowAllowedNowPleaseTryAgainLater;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notification;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @blocked.
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get blocked;

  /// No description provided for @deleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get deleted;

  /// No description provided for @accepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get accepted;

  /// No description provided for @notAccepted.
  ///
  /// In en, this message translates to:
  /// **'Not Accepted'**
  String get notAccepted;

  /// No description provided for @web.
  ///
  /// In en, this message translates to:
  /// **'Web'**
  String get web;

  /// No description provided for @android.
  ///
  /// In en, this message translates to:
  /// **'Android'**
  String get android;

  /// No description provided for @macOs.
  ///
  /// In en, this message translates to:
  /// **'macOS'**
  String get macOs;

  /// No description provided for @windows.
  ///
  /// In en, this message translates to:
  /// **'Windows'**
  String get windows;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @totalVisits.
  ///
  /// In en, this message translates to:
  /// **'Total Visits'**
  String get totalVisits;

  /// No description provided for @totalMessages.
  ///
  /// In en, this message translates to:
  /// **'Total Messages'**
  String get totalMessages;

  /// No description provided for @textMessages.
  ///
  /// In en, this message translates to:
  /// **'Text Messages'**
  String get textMessages;

  /// No description provided for @imageMessages.
  ///
  /// In en, this message translates to:
  /// **'Image Messages'**
  String get imageMessages;

  /// No description provided for @videoMessages.
  ///
  /// In en, this message translates to:
  /// **'Video Messages'**
  String get videoMessages;

  /// No description provided for @voiceMessages.
  ///
  /// In en, this message translates to:
  /// **'Voice Messages'**
  String get voiceMessages;

  /// No description provided for @fileMessages.
  ///
  /// In en, this message translates to:
  /// **'File Messages'**
  String get fileMessages;

  /// No description provided for @infoMessages.
  ///
  /// In en, this message translates to:
  /// **'Info Messages'**
  String get infoMessages;

  /// No description provided for @voiceCallMessages.
  ///
  /// In en, this message translates to:
  /// **'Voice Call Messages'**
  String get voiceCallMessages;

  /// No description provided for @videoCallMessages.
  ///
  /// In en, this message translates to:
  /// **'Video Call Messages'**
  String get videoCallMessages;

  /// No description provided for @locationMessages.
  ///
  /// In en, this message translates to:
  /// **'Location Messages'**
  String get locationMessages;

  /// No description provided for @directChat.
  ///
  /// In en, this message translates to:
  /// **'Direct Chat'**
  String get directChat;

  /// No description provided for @group.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get group;

  /// No description provided for @broadcast.
  ///
  /// In en, this message translates to:
  /// **'Broadcast'**
  String get broadcast;

  /// No description provided for @messageCounter.
  ///
  /// In en, this message translates to:
  /// **'Message Counter'**
  String get messageCounter;

  /// No description provided for @roomCounter.
  ///
  /// In en, this message translates to:
  /// **'Room Counter'**
  String get roomCounter;

  /// No description provided for @countries.
  ///
  /// In en, this message translates to:
  /// **'Countries'**
  String get countries;

  /// No description provided for @devices.
  ///
  /// In en, this message translates to:
  /// **'Devices'**
  String get devices;

  /// No description provided for @notificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification Title'**
  String get notificationTitle;

  /// No description provided for @notificationDescription.
  ///
  /// In en, this message translates to:
  /// **'Notification Description'**
  String get notificationDescription;

  /// No description provided for @notificationsPage.
  ///
  /// In en, this message translates to:
  /// **'Notifications Page'**
  String get notificationsPage;

  /// No description provided for @updateFeedBackEmail.
  ///
  /// In en, this message translates to:
  /// **'Update Feedback Email'**
  String get updateFeedBackEmail;

  /// No description provided for @setMaxMessageForwardAndShare.
  ///
  /// In en, this message translates to:
  /// **'Set Max Message Forward and Share'**
  String get setMaxMessageForwardAndShare;

  /// No description provided for @setNewPrivacyPolicyUrl.
  ///
  /// In en, this message translates to:
  /// **'Set New Privacy Policy URL'**
  String get setNewPrivacyPolicyUrl;

  /// No description provided for @forgetPasswordExpireTime.
  ///
  /// In en, this message translates to:
  /// **'Forget Password Expire Time'**
  String get forgetPasswordExpireTime;

  /// No description provided for @callTimeoutInSeconds.
  ///
  /// In en, this message translates to:
  /// **'Call Timeout in Seconds'**
  String get callTimeoutInSeconds;

  /// No description provided for @setMaxGroupMembers.
  ///
  /// In en, this message translates to:
  /// **'Set Max Group Members'**
  String get setMaxGroupMembers;

  /// No description provided for @setMaxBroadcastMembers.
  ///
  /// In en, this message translates to:
  /// **'Set Max Broadcast Members'**
  String get setMaxBroadcastMembers;

  /// No description provided for @allowCalls.
  ///
  /// In en, this message translates to:
  /// **'Allow Calls'**
  String get allowCalls;

  /// No description provided for @ifThisOptionEnabledTheVideoAndVoiceCallWillBeAllowed.
  ///
  /// In en, this message translates to:
  /// **'If this option is enabled, the video and voice call will be allowed.'**
  String get ifThisOptionEnabledTheVideoAndVoiceCallWillBeAllowed;

  /// No description provided for @allowAds.
  ///
  /// In en, this message translates to:
  /// **'Allow Ads'**
  String get allowAds;

  /// No description provided for @allowMobileLogin.
  ///
  /// In en, this message translates to:
  /// **'Allow Mobile Login'**
  String get allowMobileLogin;

  /// No description provided for @allowWebLogin.
  ///
  /// In en, this message translates to:
  /// **'Allow Web Login'**
  String get allowWebLogin;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @appleStoreAppUrl.
  ///
  /// In en, this message translates to:
  /// **'Apple Store App URL'**
  String get appleStoreAppUrl;

  /// No description provided for @googlePlayAppUrl.
  ///
  /// In en, this message translates to:
  /// **'Google Play App URL'**
  String get googlePlayAppUrl;

  /// No description provided for @privacyUrl.
  ///
  /// In en, this message translates to:
  /// **'Privacy URL'**
  String get privacyUrl;

  /// No description provided for @feedBackEmail.
  ///
  /// In en, this message translates to:
  /// **'Feedback Email'**
  String get feedBackEmail;

  /// No description provided for @ifThisOptionDisabledTheSendChatFilesImageVideosAndLocationWillBeBlocked.
  ///
  /// In en, this message translates to:
  /// **'If this option is disabled, sending chat files, images, videos, and location will be blocked.'**
  String
      get ifThisOptionDisabledTheSendChatFilesImageVideosAndLocationWillBeBlocked;

  /// No description provided for @allowSendMedia.
  ///
  /// In en, this message translates to:
  /// **'Allow Send Media'**
  String get allowSendMedia;

  /// No description provided for @ifThisOptionDisabledTheCreateChatBroadcastWillBeBlocked.
  ///
  /// In en, this message translates to:
  /// **'If this option is disabled, creating chat broadcast will be blocked.'**
  String get ifThisOptionDisabledTheCreateChatBroadcastWillBeBlocked;

  /// No description provided for @allowCreateBroadcast.
  ///
  /// In en, this message translates to:
  /// **'Allow Create Broadcast'**
  String get allowCreateBroadcast;

  /// No description provided for @ifThisOptionDisabledTheCreateChatGroupsWillBeBlocked.
  ///
  /// In en, this message translates to:
  /// **'If this option is disabled, creating chat groups will be blocked.'**
  String get ifThisOptionDisabledTheCreateChatGroupsWillBeBlocked;

  /// No description provided for @allowCreateGroups.
  ///
  /// In en, this message translates to:
  /// **'Allow Create Groups'**
  String get allowCreateGroups;

  /// No description provided for @ifThisOptionDisabledTheDesktopLoginOrRegisterWindowsMacWillBeBlocked.
  ///
  /// In en, this message translates to:
  /// **'If this option is disabled, the desktop login or register (Windows, Mac) will be blocked.'**
  String
      get ifThisOptionDisabledTheDesktopLoginOrRegisterWindowsMacWillBeBlocked;

  /// No description provided for @allowDesktopLogin.
  ///
  /// In en, this message translates to:
  /// **'Allow Desktop Login'**
  String get allowDesktopLogin;

  /// No description provided for @ifThisOptionDisabledTheWebLoginOrRegisterWillBeBlocked.
  ///
  /// In en, this message translates to:
  /// **'If this option is disabled, the web login or register will be blocked.'**
  String get ifThisOptionDisabledTheWebLoginOrRegisterWillBeBlocked;

  /// No description provided for @ifThisOptionDisabledTheMobileLoginOrRegisterWillBeBlockedOnAndroidIosOnly.
  ///
  /// In en, this message translates to:
  /// **'If this option is disabled, the mobile login or register will be blocked on Android and iOS only.'**
  String
      get ifThisOptionDisabledTheMobileLoginOrRegisterWillBeBlockedOnAndroidIosOnly;

  /// No description provided for @ifThisOptionEnabledTheGoogleAdsBannerWillAppearInChats.
  ///
  /// In en, this message translates to:
  /// **'If this option is enabled, the Google Ads banner will appear in chats.'**
  String get ifThisOptionEnabledTheGoogleAdsBannerWillAppearInChats;

  /// No description provided for @userProfile.
  ///
  /// In en, this message translates to:
  /// **'User Profile'**
  String get userProfile;

  /// No description provided for @userInfo.
  ///
  /// In en, this message translates to:
  /// **'User Info'**
  String get userInfo;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @bio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bio;

  /// No description provided for @noBio.
  ///
  /// In en, this message translates to:
  /// **'No Bio'**
  String get noBio;

  /// No description provided for @verifiedAt.
  ///
  /// In en, this message translates to:
  /// **'Verified At'**
  String get verifiedAt;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @registerStatus.
  ///
  /// In en, this message translates to:
  /// **'Register Status'**
  String get registerStatus;

  /// No description provided for @registerMethod.
  ///
  /// In en, this message translates to:
  /// **'Register Method'**
  String get registerMethod;

  /// No description provided for @banTo.
  ///
  /// In en, this message translates to:
  /// **'Ban To'**
  String get banTo;

  /// No description provided for @deletedAt.
  ///
  /// In en, this message translates to:
  /// **'Deleted At'**
  String get deletedAt;

  /// No description provided for @createdAt.
  ///
  /// In en, this message translates to:
  /// **'Created At'**
  String get createdAt;

  /// No description provided for @updatedAt.
  ///
  /// In en, this message translates to:
  /// **'Updated At'**
  String get updatedAt;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @clickToSeeAllUserDevicesDetails.
  ///
  /// In en, this message translates to:
  /// **'Click to see all user devices details'**
  String get clickToSeeAllUserDevicesDetails;

  /// No description provided for @allDeletedMessages.
  ///
  /// In en, this message translates to:
  /// **'All Deleted Messages'**
  String get allDeletedMessages;

  /// No description provided for @voiceCallMessage.
  ///
  /// In en, this message translates to:
  /// **'Voice Call Message'**
  String get voiceCallMessage;

  /// No description provided for @totalRooms.
  ///
  /// In en, this message translates to:
  /// **'Total Rooms'**
  String get totalRooms;

  /// No description provided for @directRooms.
  ///
  /// In en, this message translates to:
  /// **'Direct Rooms'**
  String get directRooms;

  /// No description provided for @userAction.
  ///
  /// In en, this message translates to:
  /// **'User Action'**
  String get userAction;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @joinedAt.
  ///
  /// In en, this message translates to:
  /// **'Joined At'**
  String get joinedAt;

  /// No description provided for @saveLogin.
  ///
  /// In en, this message translates to:
  /// **'Save Login'**
  String get saveLogin;

  /// No description provided for @passwordIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordIsRequired;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @ios.
  ///
  /// In en, this message translates to:
  /// **'iOS'**
  String get ios;

  /// No description provided for @descriptionIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Description is required'**
  String get descriptionIsRequired;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'Seconds'**
  String get seconds;

  /// No description provided for @clickToSeeAllUserInformations.
  ///
  /// In en, this message translates to:
  /// **'Click to see all user information'**
  String get clickToSeeAllUserInformations;

  /// No description provided for @clickToSeeAllUserCountries.
  ///
  /// In en, this message translates to:
  /// **'Click to see all user countries'**
  String get clickToSeeAllUserCountries;

  /// No description provided for @clickToSeeAllUserMessagesDetails.
  ///
  /// In en, this message translates to:
  /// **'Click to see all user messages details'**
  String get clickToSeeAllUserMessagesDetails;

  /// No description provided for @clickToSeeAllUserRoomsDetails.
  ///
  /// In en, this message translates to:
  /// **'Click to see all user rooms details'**
  String get clickToSeeAllUserRoomsDetails;

  /// No description provided for @clickToSeeAllUserReports.
  ///
  /// In en, this message translates to:
  /// **'Click to see all user reports'**
  String get clickToSeeAllUserReports;

  /// No description provided for @banAt.
  ///
  /// In en, this message translates to:
  /// **'Ban at'**
  String get banAt;

  /// No description provided for @nowYouLoginAsReadOnlyAdminAllEditYouDoneWillNotAppliedDueToThisIsTestVersion.
  ///
  /// In en, this message translates to:
  /// **'Now you login as read-only admin. All edits you make will not be applied due to this being a test version.'**
  String
      get nowYouLoginAsReadOnlyAdminAllEditYouDoneWillNotAppliedDueToThisIsTestVersion;

  /// No description provided for @createStory.
  ///
  /// In en, this message translates to:
  /// **'Create Story'**
  String get createStory;

  /// No description provided for @writeACaption.
  ///
  /// In en, this message translates to:
  /// **'Write a caption...'**
  String get writeACaption;

  /// No description provided for @storyCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Story Created Successfully'**
  String get storyCreatedSuccessfully;

  /// No description provided for @stories.
  ///
  /// In en, this message translates to:
  /// **'Stories'**
  String get stories;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @clearCallsConfirm.
  ///
  /// In en, this message translates to:
  /// **'Clear calls confirm'**
  String get clearCallsConfirm;

  /// No description provided for @chooseHowAutomaticDownloadWorks.
  ///
  /// In en, this message translates to:
  /// **'Choose how automatic download works'**
  String get chooseHowAutomaticDownloadWorks;

  /// No description provided for @whenUsingMobileData.
  ///
  /// In en, this message translates to:
  /// **'When using mobile data'**
  String get whenUsingMobileData;

  /// No description provided for @whenUsingWifi.
  ///
  /// In en, this message translates to:
  /// **'When using Wi-Fi'**
  String get whenUsingWifi;

  /// No description provided for @image.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get image;

  /// No description provided for @myPrivacy.
  ///
  /// In en, this message translates to:
  /// **'My Privacy'**
  String get myPrivacy;

  /// No description provided for @createTextStory.
  ///
  /// In en, this message translates to:
  /// **'Create Text Story'**
  String get createTextStory;

  /// No description provided for @createMediaStory.
  ///
  /// In en, this message translates to:
  /// **'Create Media Story'**
  String get createMediaStory;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @recentUpdate.
  ///
  /// In en, this message translates to:
  /// **'Recent update'**
  String get recentUpdate;

  /// No description provided for @addNewStory.
  ///
  /// In en, this message translates to:
  /// **'Add new story'**
  String get addNewStory;

  /// No description provided for @updateYourProfile.
  ///
  /// In en, this message translates to:
  /// **'Update your profile'**
  String get updateYourProfile;

  /// No description provided for @configureYourAccountPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Configure your account privacy'**
  String get configureYourAccountPrivacy;

  /// No description provided for @youInPublicSearch.
  ///
  /// In en, this message translates to:
  /// **'You in public search'**
  String get youInPublicSearch;

  /// No description provided for @yourProfileAppearsInPublicSearchAndAddingForGroups.
  ///
  /// In en, this message translates to:
  /// **'Your profile appears in public search and adding for groups'**
  String get yourProfileAppearsInPublicSearchAndAddingForGroups;

  /// No description provided for @yourLastSeen.
  ///
  /// In en, this message translates to:
  /// **'Your last seen'**
  String get yourLastSeen;

  /// No description provided for @yourLastSeenInChats.
  ///
  /// In en, this message translates to:
  /// **'Your last seen in chats'**
  String get yourLastSeenInChats;

  /// No description provided for @startNewChatWithYou.
  ///
  /// In en, this message translates to:
  /// **'Start new chat with you'**
  String get startNewChatWithYou;

  /// No description provided for @yourStory.
  ///
  /// In en, this message translates to:
  /// **'Your story'**
  String get yourStory;

  /// No description provided for @forRequest.
  ///
  /// In en, this message translates to:
  /// **'For request'**
  String get forRequest;

  /// No description provided for @public.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get public;

  /// No description provided for @createYourStory.
  ///
  /// In en, this message translates to:
  /// **'Create your story'**
  String get createYourStory;

  /// No description provided for @shareYourStatus.
  ///
  /// In en, this message translates to:
  /// **'Share your status'**
  String get shareYourStatus;

  /// No description provided for @oneSeenMessage.
  ///
  /// In en, this message translates to:
  /// **'One seen message'**
  String get oneSeenMessage;

  /// No description provided for @oneTimeSeen.
  ///
  /// In en, this message translates to:
  /// **'One time seen'**
  String get oneTimeSeen;

  /// No description provided for @messageHasBeenViewed.
  ///
  /// In en, this message translates to:
  /// **'Message has been viewed'**
  String get messageHasBeenViewed;

  /// No description provided for @clickToSee.
  ///
  /// In en, this message translates to:
  /// **'Click to see'**
  String get clickToSee;

  /// No description provided for @images.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get images;

  /// No description provided for @userName.
  ///
  /// In en, this message translates to:
  /// **'userName'**
  String get userName;

  /// No description provided for @contactsHasBeenSynced.
  ///
  /// In en, this message translates to:
  /// **'Contacts has been synced'**
  String get contactsHasBeenSynced;

  /// No description provided for @syncContacts.
  ///
  /// In en, this message translates to:
  /// **'Sync contacts'**
  String get syncContacts;

  /// No description provided for @enableSearchByUserName.
  ///
  /// In en, this message translates to:
  /// **'enableSearchByUserName'**
  String get enableSearchByUserName;

  /// No description provided for @acceptContactsPermissionDescription.
  ///
  /// In en, this message translates to:
  /// **'If you want to see you contacts which use the app then you need to accept the permission of contacts'**
  String get acceptContactsPermissionDescription;

  /// No description provided for @contactPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Contact permission denied'**
  String get contactPermissionDenied;

  /// No description provided for @searchByUserNameOrFullUserEmail.
  ///
  /// In en, this message translates to:
  /// **'Search by user name or full user Email'**
  String get searchByUserNameOrFullUserEmail;

  /// No description provided for @searchByUserFullEmail.
  ///
  /// In en, this message translates to:
  /// **'Search by user full Email'**
  String get searchByUserFullEmail;

  /// No description provided for @clearAppStorageDescription.
  ///
  /// In en, this message translates to:
  /// **'This option will clear app storage don\'t worry you can still any time download it if auto download enable the message will auto download'**
  String get clearAppStorageDescription;

  /// No description provided for @acceptCallsFromUsers.
  ///
  /// In en, this message translates to:
  /// **'Accept calls from users'**
  String get acceptCallsFromUsers;

  /// No description provided for @translate.
  ///
  /// In en, this message translates to:
  /// **'Translate'**
  String get translate;

  /// No description provided for @codePage.
  ///
  /// In en, this message translates to:
  /// **'Code page'**
  String get codePage;

  /// No description provided for @messagePrivatelyWithFriendsAndFamily.
  ///
  /// In en, this message translates to:
  /// **'Message privately with friends and family using on your browser.'**
  String get messagePrivatelyWithFriendsAndFamily;

  /// No description provided for @openAppOnYourPhoneInstructions.
  ///
  /// In en, this message translates to:
  /// **'1. Open the app on your phone. Tap Settings on Android, or on iPhone. Tap Linked devices and then Link a device. Point your phone at this screen to scan the QR code'**
  String get openAppOnYourPhoneInstructions;

  /// No description provided for @completeYourProfile.
  ///
  /// In en, this message translates to:
  /// **'Complete Your Profile'**
  String get completeYourProfile;

  /// No description provided for @pleaseProvideYourNameToContinue.
  ///
  /// In en, this message translates to:
  /// **'Please provide your name to continue'**
  String get pleaseProvideYourNameToContinue;

  /// No description provided for @enterYourFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterYourFullName;

  /// No description provided for @pleaseEnterYourName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get pleaseEnterYourName;

  /// No description provided for @enableSearchByEmail.
  ///
  /// In en, this message translates to:
  /// **'Enable search by email'**
  String get enableSearchByEmail;

  /// No description provided for @phoneNumberNotValid.
  ///
  /// In en, this message translates to:
  /// **'phone number not valid'**
  String get phoneNumberNotValid;

  /// No description provided for @enterVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Enter Verification Code'**
  String get enterVerificationCode;

  /// No description provided for @sentSixDigitCode.
  ///
  /// In en, this message translates to:
  /// **'We have sent a 6-digit code to {phone}'**
  String sentSixDigitCode(Object phone);

  /// No description provided for @resendInSeconds.
  ///
  /// In en, this message translates to:
  /// **'Resend in {seconds} s'**
  String resendInSeconds(int seconds);

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @pleaseEnterVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter verification code'**
  String get pleaseEnterVerificationCode;

  /// No description provided for @pleaseEnterValid6DigitCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid 6-digit code'**
  String get pleaseEnterValid6DigitCode;

  /// No description provided for @invalidVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'The verification code you entered is invalid. Please check and try again.'**
  String get invalidVerificationCode;

  /// No description provided for @verificationSessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your verification session has expired. Please request a new code.'**
  String get verificationSessionExpired;

  /// No description provided for @tooManyAttempts.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please try again later.'**
  String get tooManyAttempts;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection and try again.'**
  String get networkError;

  /// No description provided for @verificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Verification failed: {message}'**
  String verificationFailed(Object message);

  /// No description provided for @verificationTimedOut.
  ///
  /// In en, this message translates to:
  /// **'Verification timed out. Please try again.'**
  String get verificationTimedOut;

  /// No description provided for @enterYourPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enterYourPhoneNumber;

  /// No description provided for @weWillSendYouAVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'We will send you a verification code'**
  String get weWillSendYouAVerificationCode;

  /// No description provided for @sendVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Send verification code'**
  String get sendVerificationCode;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'phone number'**
  String get phoneNumber;

  /// No description provided for @voiceCall.
  ///
  /// In en, this message translates to:
  /// **'Voice call'**
  String get voiceCall;

  /// No description provided for @x.
  ///
  /// In en, this message translates to:
  /// **'x'**
  String get x;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// No description provided for @enterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPassword;

  /// No description provided for @confirmYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirmYourPassword;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get invalidEmail;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordTooShort;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get confirmPasswordRequired;

  /// No description provided for @passwordsDontMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords don\'t match'**
  String get passwordsDontMatch;

  /// No description provided for @registrationSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Registration successful!'**
  String get registrationSuccessful;

  /// No description provided for @loginSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Login successful!'**
  String get loginSuccessful;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @forgotPasswordNavigating.
  ///
  /// In en, this message translates to:
  /// **'Navigating to forgot password page'**
  String get forgotPasswordNavigating;

  /// No description provided for @dontHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAnAccount;

  /// No description provided for @enterTheCodeAndNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter the verification code sent to your email and create a new password'**
  String get enterTheCodeAndNewPassword;

  /// No description provided for @enterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter new password'**
  String get enterNewPassword;

  /// No description provided for @reenterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Re-enter new password'**
  String get reenterNewPassword;

  /// No description provided for @pleaseEnterValidCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid 6-digit code'**
  String get pleaseEnterValidCode;

  /// No description provided for @didntReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code?'**
  String get didntReceiveCode;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @codeSentAgain.
  ///
  /// In en, this message translates to:
  /// **'Code has been sent again to your email'**
  String get codeSentAgain;

  /// No description provided for @clickToJoin.
  ///
  /// In en, this message translates to:
  /// **'Click to join'**
  String get clickToJoin;

  /// No description provided for @storeUrls.
  ///
  /// In en, this message translates to:
  /// **'Store Urls'**
  String get storeUrls;

  /// No description provided for @clearAllCache.
  ///
  /// In en, this message translates to:
  /// **'Clear all cache'**
  String get clearAllCache;

  /// No description provided for @clickThisOptionWillClearAppStorage.
  ///
  /// In en, this message translates to:
  /// **'This option will clear app storage don\'t worry you can still any time download it if auto download enable the message will auto download'**
  String get clickThisOptionWillClearAppStorage;

  /// No description provided for @deleteAppCache.
  ///
  /// In en, this message translates to:
  /// **'Delete app cache ?'**
  String get deleteAppCache;

  /// No description provided for @userRegisterStatus.
  ///
  /// In en, this message translates to:
  /// **'User Register Status'**
  String get userRegisterStatus;

  /// No description provided for @isPrime.
  ///
  /// In en, this message translates to:
  /// **'Is prime'**
  String get isPrime;

  /// No description provided for @videoCompression.
  ///
  /// In en, this message translates to:
  /// **'Video Compression'**
  String get videoCompression;

  /// No description provided for @chooseQualityForYourVideo.
  ///
  /// In en, this message translates to:
  /// **'Choose quality for your video'**
  String get chooseQualityForYourVideo;

  /// No description provided for @ultraLowQuality.
  ///
  /// In en, this message translates to:
  /// **'Ultra Low Quality'**
  String get ultraLowQuality;

  /// No description provided for @veryLowQuality.
  ///
  /// In en, this message translates to:
  /// **'Very Low Quality'**
  String get veryLowQuality;

  /// No description provided for @lowQuality.
  ///
  /// In en, this message translates to:
  /// **'Low Quality'**
  String get lowQuality;

  /// No description provided for @mediumQuality.
  ///
  /// In en, this message translates to:
  /// **'Medium Quality'**
  String get mediumQuality;

  /// No description provided for @highQuality.
  ///
  /// In en, this message translates to:
  /// **'High Quality'**
  String get highQuality;

  /// No description provided for @smallestFileSizeFasterUpload.
  ///
  /// In en, this message translates to:
  /// **'Smallest file size, faster upload'**
  String get smallestFileSizeFasterUpload;

  /// No description provided for @verySmallFileSize.
  ///
  /// In en, this message translates to:
  /// **'Very small file size'**
  String get verySmallFileSize;

  /// No description provided for @smallFileSizeFasterUploadLow.
  ///
  /// In en, this message translates to:
  /// **'Small file size, faster upload'**
  String get smallFileSizeFasterUploadLow;

  /// No description provided for @balancedQualityAndFileSize.
  ///
  /// In en, this message translates to:
  /// **'Balanced quality and file size'**
  String get balancedQualityAndFileSize;

  /// No description provided for @betterQualityLargerFileSize.
  ///
  /// In en, this message translates to:
  /// **'Better quality, larger file size'**
  String get betterQualityLargerFileSize;

  /// No description provided for @skipCompression.
  ///
  /// In en, this message translates to:
  /// **'Skip Compression'**
  String get skipCompression;

  /// No description provided for @sendOriginalVideoWithoutCompression.
  ///
  /// In en, this message translates to:
  /// **'Send original video without compression'**
  String get sendOriginalVideoWithoutCompression;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @compressingVideo.
  ///
  /// In en, this message translates to:
  /// **'Compressing Video'**
  String get compressingVideo;

  /// No description provided for @analyzingVideoAndPreparingCompression.
  ///
  /// In en, this message translates to:
  /// **'Analyzing video and preparing compression...'**
  String get analyzingVideoAndPreparingCompression;

  /// No description provided for @compressingVideoThisMayTakeAFewMoments.
  ///
  /// In en, this message translates to:
  /// **'Compressing video, this may take a few moments...'**
  String get compressingVideoThisMayTakeAFewMoments;

  /// No description provided for @processingVideoDataAndOptimizingQuality.
  ///
  /// In en, this message translates to:
  /// **'Processing video data and optimizing quality...'**
  String get processingVideoDataAndOptimizingQuality;

  /// No description provided for @finalizingCompressionAndSavingFile.
  ///
  /// In en, this message translates to:
  /// **'Finalizing compression and saving file...'**
  String get finalizingCompressionAndSavingFile;

  /// No description provided for @almostDoneJustAFewMoreSeconds.
  ///
  /// In en, this message translates to:
  /// **'Almost done, just a few more seconds...'**
  String get almostDoneJustAFewMoreSeconds;

  /// No description provided for @calculating.
  ///
  /// In en, this message translates to:
  /// **'Calculating...'**
  String get calculating;

  /// No description provided for @finishing.
  ///
  /// In en, this message translates to:
  /// **'Finishing...'**
  String get finishing;

  /// No description provided for @estimating.
  ///
  /// In en, this message translates to:
  /// **'Estimating...'**
  String get estimating;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'remaining'**
  String get remaining;

  /// No description provided for @left.
  ///
  /// In en, this message translates to:
  /// **'left'**
  String get left;

  /// No description provided for @cancelCompression.
  ///
  /// In en, this message translates to:
  /// **'Cancel Compression'**
  String get cancelCompression;

  /// No description provided for @compressionSettings.
  ///
  /// In en, this message translates to:
  /// **'Compression Settings'**
  String get compressionSettings;

  /// No description provided for @deleteVideo.
  ///
  /// In en, this message translates to:
  /// **'Delete Video'**
  String get deleteVideo;

  /// No description provided for @compressionQualitySetTo.
  ///
  /// In en, this message translates to:
  /// **'Compression quality set to {quality}. Video will be compressed when you submit.'**
  String compressionQualitySetTo(String quality);

  /// No description provided for @errorProcessingMedia.
  ///
  /// In en, this message translates to:
  /// **'Error processing media: {error}'**
  String errorProcessingMedia(String error);

  /// No description provided for @videoCompressionFailed.
  ///
  /// In en, this message translates to:
  /// **'Video compression failed for {fileName}: {error}'**
  String videoCompressionFailed(String fileName, String error);

  /// No description provided for @connectionQuality.
  ///
  /// In en, this message translates to:
  /// **'Connection Quality'**
  String get connectionQuality;

  /// No description provided for @excellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get excellent;

  /// No description provided for @good.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get good;

  /// No description provided for @poor.
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get poor;

  /// No description provided for @bad.
  ///
  /// In en, this message translates to:
  /// **'Bad'**
  String get bad;

  /// No description provided for @veryBad.
  ///
  /// In en, this message translates to:
  /// **'Very Bad'**
  String get veryBad;

  /// No description provided for @disconnected.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get disconnected;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @cameraOff.
  ///
  /// In en, this message translates to:
  /// **'Camera Off'**
  String get cameraOff;

  /// No description provided for @cameraOn.
  ///
  /// In en, this message translates to:
  /// **'Camera On'**
  String get cameraOn;

  /// No description provided for @microphoneOff.
  ///
  /// In en, this message translates to:
  /// **'Microphone Off'**
  String get microphoneOff;

  /// No description provided for @microphoneOn.
  ///
  /// In en, this message translates to:
  /// **'Microphone On'**
  String get microphoneOn;

  /// No description provided for @speakerOff.
  ///
  /// In en, this message translates to:
  /// **'Speaker Off'**
  String get speakerOff;

  /// No description provided for @speakerOn.
  ///
  /// In en, this message translates to:
  /// **'Speaker On'**
  String get speakerOn;

  /// No description provided for @switchCamera.
  ///
  /// In en, this message translates to:
  /// **'Switch Camera'**
  String get switchCamera;

  /// No description provided for @endCall.
  ///
  /// In en, this message translates to:
  /// **'End Call'**
  String get endCall;

  /// No description provided for @callDuration.
  ///
  /// In en, this message translates to:
  /// **'Call Duration'**
  String get callDuration;

  /// No description provided for @reconnecting.
  ///
  /// In en, this message translates to:
  /// **'Reconnecting...'**
  String get reconnecting;

  /// No description provided for @callFailed.
  ///
  /// In en, this message translates to:
  /// **'Call Failed'**
  String get callFailed;

  /// No description provided for @callEnded.
  ///
  /// In en, this message translates to:
  /// **'Call Ended'**
  String get callEnded;

  /// No description provided for @networkPoor.
  ///
  /// In en, this message translates to:
  /// **'Network connection is poor'**
  String get networkPoor;

  /// No description provided for @joinCall.
  ///
  /// In en, this message translates to:
  /// **'Join Call'**
  String get joinCall;

  /// No description provided for @leaveCall.
  ///
  /// In en, this message translates to:
  /// **'Leave Call'**
  String get leaveCall;

  /// No description provided for @tapToSwapVideo.
  ///
  /// In en, this message translates to:
  /// **'Tap to swap video positions'**
  String get tapToSwapVideo;

  /// No description provided for @userJoined.
  ///
  /// In en, this message translates to:
  /// **'User joined the call'**
  String get userJoined;

  /// No description provided for @userLeft.
  ///
  /// In en, this message translates to:
  /// **'User left the call'**
  String get userLeft;

  /// No description provided for @audioOnlyMode.
  ///
  /// In en, this message translates to:
  /// **'Audio Only Mode'**
  String get audioOnlyMode;

  /// No description provided for @videoCallMode.
  ///
  /// In en, this message translates to:
  /// **'Video Call Mode'**
  String get videoCallMode;

  /// No description provided for @callQuality.
  ///
  /// In en, this message translates to:
  /// **'Call Quality'**
  String get callQuality;

  /// No description provided for @participantCount.
  ///
  /// In en, this message translates to:
  /// **'{count} participants'**
  String participantCount(int count);

  /// No description provided for @chooseCompressionQualityForYourVideo.
  ///
  /// In en, this message translates to:
  /// **'Choose compression quality for your video:'**
  String get chooseCompressionQualityForYourVideo;

  /// No description provided for @originalFileSize.
  ///
  /// In en, this message translates to:
  /// **'Original'**
  String get originalFileSize;

  /// No description provided for @estimatedFileSize.
  ///
  /// In en, this message translates to:
  /// **'Estimated'**
  String get estimatedFileSize;

  /// No description provided for @fileMustBeVideo.
  ///
  /// In en, this message translates to:
  /// **'The file must be a video file'**
  String get fileMustBeVideo;

  /// No description provided for @fileMustBeImage.
  ///
  /// In en, this message translates to:
  /// **'The file must be an image file'**
  String get fileMustBeImage;

  /// No description provided for @appStorageSizeIs.
  ///
  /// In en, this message translates to:
  /// **'App storage size is'**
  String get appStorageSizeIs;

  /// No description provided for @activity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activity;

  /// No description provided for @serverRestart.
  ///
  /// In en, this message translates to:
  /// **'Server restart'**
  String get serverRestart;

  /// No description provided for @adminDashboard.
  ///
  /// In en, this message translates to:
  /// **'Admin Dashboard'**
  String get adminDashboard;

  /// No description provided for @secureAdminAccess.
  ///
  /// In en, this message translates to:
  /// **'Secure Admin Access'**
  String get secureAdminAccess;

  /// No description provided for @userAnalytics.
  ///
  /// In en, this message translates to:
  /// **'User Analytics'**
  String get userAnalytics;

  /// No description provided for @systemConfiguration.
  ///
  /// In en, this message translates to:
  /// **'System Configuration'**
  String get systemConfiguration;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @enterCredentialsToAccessDashboard.
  ///
  /// In en, this message translates to:
  /// **'Enter your credentials to access dashboard'**
  String get enterCredentialsToAccessDashboard;

  /// No description provided for @enterAdminPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your admin password'**
  String get enterAdminPassword;

  /// No description provided for @needHelp.
  ///
  /// In en, this message translates to:
  /// **'Need help?'**
  String get needHelp;

  /// No description provided for @appleIos.
  ///
  /// In en, this message translates to:
  /// **'Apple iOS'**
  String get appleIos;

  /// No description provided for @googleAndroid.
  ///
  /// In en, this message translates to:
  /// **'Google Android'**
  String get googleAndroid;

  /// No description provided for @microsoftWindows.
  ///
  /// In en, this message translates to:
  /// **'Microsoft Windows'**
  String get microsoftWindows;

  /// No description provided for @appleMacStoreUrl.
  ///
  /// In en, this message translates to:
  /// **'Apple Mac Store URL'**
  String get appleMacStoreUrl;

  /// No description provided for @webChat.
  ///
  /// In en, this message translates to:
  /// **'Web Chat'**
  String get webChat;

  /// No description provided for @id.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get id;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get noData;

  /// No description provided for @videoTrimmer.
  ///
  /// In en, this message translates to:
  /// **'Video Trimmer'**
  String get videoTrimmer;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @deleteImage.
  ///
  /// In en, this message translates to:
  /// **'Delete Image'**
  String get deleteImage;

  /// No description provided for @cropImage.
  ///
  /// In en, this message translates to:
  /// **'Crop Image'**
  String get cropImage;

  /// No description provided for @cropNotAvailableOnWeb.
  ///
  /// In en, this message translates to:
  /// **'Crop not available on web'**
  String get cropNotAvailableOnWeb;

  /// No description provided for @editImage.
  ///
  /// In en, this message translates to:
  /// **'Edit Image'**
  String get editImage;

  /// No description provided for @editVideo.
  ///
  /// In en, this message translates to:
  /// **'Edit Video'**
  String get editVideo;

  /// No description provided for @resetTrim.
  ///
  /// In en, this message translates to:
  /// **'Reset Trim'**
  String get resetTrim;

  /// No description provided for @original.
  ///
  /// In en, this message translates to:
  /// **'Original'**
  String get original;

  /// No description provided for @trimmed.
  ///
  /// In en, this message translates to:
  /// **'Trimmed'**
  String get trimmed;

  /// No description provided for @failedToSaveTrimmedVideo.
  ///
  /// In en, this message translates to:
  /// **'Failed to save trimmed video'**
  String get failedToSaveTrimmedVideo;

  /// No description provided for @loadingVideo.
  ///
  /// In en, this message translates to:
  /// **'Loading video...'**
  String get loadingVideo;

  /// No description provided for @failedToLoadVideo.
  ///
  /// In en, this message translates to:
  /// **'Failed to load video'**
  String get failedToLoadVideo;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @gifIndicator.
  ///
  /// In en, this message translates to:
  /// **'GIF'**
  String get gifIndicator;

  /// No description provided for @loadFailed.
  ///
  /// In en, this message translates to:
  /// **'Load failed'**
  String get loadFailed;

  /// No description provided for @preview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @emptyList.
  ///
  /// In en, this message translates to:
  /// **'No media found'**
  String get emptyList;

  /// No description provided for @unSupportedAssetType.
  ///
  /// In en, this message translates to:
  /// **'Unsupported file type'**
  String get unSupportedAssetType;

  /// No description provided for @unableToAccessAll.
  ///
  /// In en, this message translates to:
  /// **'Unable to access all photos'**
  String get unableToAccessAll;

  /// No description provided for @viewingLimitedAssetsTip.
  ///
  /// In en, this message translates to:
  /// **'Only showing photos and videos accessible to the app.'**
  String get viewingLimitedAssetsTip;

  /// No description provided for @changeAccessibleLimitedAssets.
  ///
  /// In en, this message translates to:
  /// **'Change accessible limited assets'**
  String get changeAccessibleLimitedAssets;

  /// No description provided for @accessAllTip.
  ///
  /// In en, this message translates to:
  /// **'App can only access limited assets on the device. Go to system settings and allow the app to access all photos on the device.'**
  String get accessAllTip;

  /// No description provided for @goToSystemSettings.
  ///
  /// In en, this message translates to:
  /// **'Go to system settings'**
  String get goToSystemSettings;

  /// No description provided for @accessLimitedAssets.
  ///
  /// In en, this message translates to:
  /// **'Continue with limited access'**
  String get accessLimitedAssets;

  /// No description provided for @accessiblePathName.
  ///
  /// In en, this message translates to:
  /// **'Accessible assets'**
  String get accessiblePathName;

  /// No description provided for @sTypeAudioLabel.
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get sTypeAudioLabel;

  /// No description provided for @sTypeImageLabel.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get sTypeImageLabel;

  /// No description provided for @sTypeVideoLabel.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get sTypeVideoLabel;

  /// No description provided for @sTypeOtherLabel.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get sTypeOtherLabel;

  /// No description provided for @sActionPlayHint.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get sActionPlayHint;

  /// No description provided for @sActionPreviewHint.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get sActionPreviewHint;

  /// No description provided for @sActionSelectHint.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get sActionSelectHint;

  /// No description provided for @sActionSwitchPathLabel.
  ///
  /// In en, this message translates to:
  /// **'Switch path'**
  String get sActionSwitchPathLabel;

  /// No description provided for @sActionUseCameraHint.
  ///
  /// In en, this message translates to:
  /// **'Use camera'**
  String get sActionUseCameraHint;

  /// No description provided for @sNameDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get sNameDurationLabel;

  /// No description provided for @sUnitAssetCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Count'**
  String get sUnitAssetCountLabel;

  /// No description provided for @selectMedia.
  ///
  /// In en, this message translates to:
  /// **'Select media'**
  String get selectMedia;

  /// No description provided for @selectPhotos.
  ///
  /// In en, this message translates to:
  /// **'Select photos'**
  String get selectPhotos;

  /// No description provided for @selectVideos.
  ///
  /// In en, this message translates to:
  /// **'Select videos'**
  String get selectVideos;

  /// No description provided for @recent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get recent;

  /// No description provided for @allPhotos.
  ///
  /// In en, this message translates to:
  /// **'All Photos'**
  String get allPhotos;

  /// No description provided for @allVideos.
  ///
  /// In en, this message translates to:
  /// **'All Videos'**
  String get allVideos;

  /// No description provided for @noMediaFound.
  ///
  /// In en, this message translates to:
  /// **'No media found'**
  String get noMediaFound;

  /// No description provided for @permissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Permission denied'**
  String get permissionDenied;

  /// No description provided for @pleaseGrantCameraPermission.
  ///
  /// In en, this message translates to:
  /// **'Please grant camera permission'**
  String get pleaseGrantCameraPermission;

  /// No description provided for @pleaseGrantStoragePermission.
  ///
  /// In en, this message translates to:
  /// **'Please grant storage permission'**
  String get pleaseGrantStoragePermission;

  /// No description provided for @errorLoadingImage.
  ///
  /// In en, this message translates to:
  /// **'Error loading image'**
  String get errorLoadingImage;

  /// No description provided for @downloadImage.
  ///
  /// In en, this message translates to:
  /// **'Download image'**
  String get downloadImage;

  /// No description provided for @shareImage.
  ///
  /// In en, this message translates to:
  /// **'Share image'**
  String get shareImage;

  /// No description provided for @imageInfo.
  ///
  /// In en, this message translates to:
  /// **'Image info'**
  String get imageInfo;

  /// No description provided for @errorDownloadingImage.
  ///
  /// In en, this message translates to:
  /// **'Error downloading image'**
  String get errorDownloadingImage;

  /// No description provided for @errorSharingImage.
  ///
  /// In en, this message translates to:
  /// **'Error sharing image'**
  String get errorSharingImage;

  /// No description provided for @fileName.
  ///
  /// In en, this message translates to:
  /// **'File name'**
  String get fileName;

  /// No description provided for @fileSize.
  ///
  /// In en, this message translates to:
  /// **'File size'**
  String get fileSize;

  /// No description provided for @fileType.
  ///
  /// In en, this message translates to:
  /// **'File type'**
  String get fileType;

  /// No description provided for @storyViewers.
  ///
  /// In en, this message translates to:
  /// **'Story Viewers'**
  String get storyViewers;

  /// No description provided for @noViewersYet.
  ///
  /// In en, this message translates to:
  /// **'No viewers yet'**
  String get noViewersYet;

  /// No description provided for @locationFallback.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationFallback;

  /// No description provided for @gpsLabel.
  ///
  /// In en, this message translates to:
  /// **'GPS'**
  String get gpsLabel;

  /// No description provided for @tapToOpenInMaps.
  ///
  /// In en, this message translates to:
  /// **'Tap to open in Maps'**
  String get tapToOpenInMaps;

  /// No description provided for @selectedLocation.
  ///
  /// In en, this message translates to:
  /// **'Selected Location'**
  String get selectedLocation;

  /// No description provided for @analyzingVideo.
  ///
  /// In en, this message translates to:
  /// **'Analyzing video and preparing compression...'**
  String get analyzingVideo;

  /// No description provided for @compressingVideoWait.
  ///
  /// In en, this message translates to:
  /// **'Compressing video, please wait...'**
  String get compressingVideoWait;

  /// No description provided for @finalizingCompression.
  ///
  /// In en, this message translates to:
  /// **'Finalizing compression...'**
  String get finalizingCompression;

  /// No description provided for @almostDone.
  ///
  /// In en, this message translates to:
  /// **'Almost done...'**
  String get almostDone;

  /// No description provided for @failedToLoadViewers.
  ///
  /// In en, this message translates to:
  /// **'Failed to load viewers'**
  String get failedToLoadViewers;

  /// No description provided for @loadingViewers.
  ///
  /// In en, this message translates to:
  /// **'Loading viewers...'**
  String get loadingViewers;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @toggleTheme.
  ///
  /// In en, this message translates to:
  /// **'Toggle Theme'**
  String get toggleTheme;

  /// No description provided for @noCustomSettings.
  ///
  /// In en, this message translates to:
  /// **'No custom settings'**
  String get noCustomSettings;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// No description provided for @searchUsers.
  ///
  /// In en, this message translates to:
  /// **'Search users...'**
  String get searchUsers;

  /// No description provided for @searching.
  ///
  /// In en, this message translates to:
  /// **'Searching...'**
  String get searching;

  /// No description provided for @noUsersFound.
  ///
  /// In en, this message translates to:
  /// **'No users found'**
  String get noUsersFound;

  /// No description provided for @noUsers.
  ///
  /// In en, this message translates to:
  /// **'No users'**
  String get noUsers;

  /// No description provided for @tryDifferentSearch.
  ///
  /// In en, this message translates to:
  /// **'Try a different search term'**
  String get tryDifferentSearch;

  /// No description provided for @usersWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Users will appear here when available'**
  String get usersWillAppearHere;

  /// No description provided for @updateRequired.
  ///
  /// In en, this message translates to:
  /// **'Update Required'**
  String get updateRequired;

  /// No description provided for @updateRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'A new version of the app is available. Please update to continue using the app.'**
  String get updateRequiredMessage;

  /// No description provided for @updateNow.
  ///
  /// In en, this message translates to:
  /// **'Update Now'**
  String get updateNow;

  /// No description provided for @laterButton.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get laterButton;

  /// No description provided for @ignoreButton.
  ///
  /// In en, this message translates to:
  /// **'Ignore'**
  String get ignoreButton;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'bn',
        'de',
        'en',
        'es',
        'fr',
        'hi',
        'id',
        'ja',
        'ko',
        'ml',
        'pt',
        'ru',
        'tr',
        'vi',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'bn':
      return AppLocalizationsBn();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'id':
      return AppLocalizationsId();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'ml':
      return AppLocalizationsMl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'tr':
      return AppLocalizationsTr();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
