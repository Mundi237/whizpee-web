// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Done`
  String get done {
    return Intl.message('Done', name: 'done', desc: '', args: []);
  }

  /// `Loading ...`
  String get loading {
    return Intl.message('Loading ...', name: 'loading', desc: '', args: []);
  }

  /// `Message has been deleted`
  String get messageHasBeenDeleted {
    return Intl.message(
      'Message has been deleted',
      name: 'messageHasBeenDeleted',
      desc: '',
      args: [],
    );
  }

  /// `Mute`
  String get mute {
    return Intl.message('Mute', name: 'mute', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Typing...`
  String get typing {
    return Intl.message('Typing...', name: 'typing', desc: '', args: []);
  }

  /// `OK`
  String get ok {
    return Intl.message('OK', name: 'ok', desc: '', args: []);
  }

  /// `Recording...`
  String get recording {
    return Intl.message('Recording...', name: 'recording', desc: '', args: []);
  }

  /// `Connecting...`
  String get connecting {
    return Intl.message(
      'Connecting...',
      name: 'connecting',
      desc: '',
      args: [],
    );
  }

  /// `Delete your copy`
  String get deleteYouCopy {
    return Intl.message(
      'Delete your copy',
      name: 'deleteYouCopy',
      desc: '',
      args: [],
    );
  }

  /// `Un mute`
  String get unMute {
    return Intl.message('Un mute', name: 'unMute', desc: '', args: []);
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Report`
  String get report {
    return Intl.message('Report', name: 'report', desc: '', args: []);
  }

  /// `Leave group`
  String get leaveGroup {
    return Intl.message('Leave group', name: 'leaveGroup', desc: '', args: []);
  }

  /// `Are you sure to permit your copy? This action can't undo`
  String get areYouSureToPermitYourCopyThisActionCantUndo {
    return Intl.message(
      'Are you sure to permit your copy? This action can\'t undo',
      name: 'areYouSureToPermitYourCopyThisActionCantUndo',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to leave this group? This action can't undo`
  String get areYouSureToLeaveThisGroupThisActionCantUndo {
    return Intl.message(
      'Are you sure to leave this group? This action can\'t undo',
      name: 'areYouSureToLeaveThisGroupThisActionCantUndo',
      desc: '',
      args: [],
    );
  }

  /// `Leave group and delete your message copy`
  String get leaveGroupAndDeleteYourMessageCopy {
    return Intl.message(
      'Leave group and delete your message copy',
      name: 'leaveGroupAndDeleteYourMessageCopy',
      desc: '',
      args: [],
    );
  }

  /// `Message info`
  String get vMessageInfoTrans {
    return Intl.message(
      'Message info',
      name: 'vMessageInfoTrans',
      desc: '',
      args: [],
    );
  }

  /// `Update title to`
  String get updateTitleTo {
    return Intl.message(
      'Update title to',
      name: 'updateTitleTo',
      desc: '',
      args: [],
    );
  }

  /// `Update image`
  String get updateImage {
    return Intl.message(
      'Update image',
      name: 'updateImage',
      desc: '',
      args: [],
    );
  }

  /// `Joined by`
  String get joinedBy {
    return Intl.message('Joined by', name: 'joinedBy', desc: '', args: []);
  }

  /// `Promoted to admin by`
  String get promotedToAdminBy {
    return Intl.message(
      'Promoted to admin by',
      name: 'promotedToAdminBy',
      desc: '',
      args: [],
    );
  }

  /// `Dismissed to member by`
  String get dismissedToMemberBy {
    return Intl.message(
      'Dismissed to member by',
      name: 'dismissedToMemberBy',
      desc: '',
      args: [],
    );
  }

  /// `Left the group`
  String get leftTheGroup {
    return Intl.message(
      'Left the group',
      name: 'leftTheGroup',
      desc: '',
      args: [],
    );
  }

  /// `You`
  String get you {
    return Intl.message('You', name: 'you', desc: '', args: []);
  }

  /// `Kicked by`
  String get kickedBy {
    return Intl.message('Kicked by', name: 'kickedBy', desc: '', args: []);
  }

  /// `Group created by`
  String get groupCreatedBy {
    return Intl.message(
      'Group created by',
      name: 'groupCreatedBy',
      desc: '',
      args: [],
    );
  }

  /// `Added you to new broadcast`
  String get addedYouToNewBroadcast {
    return Intl.message(
      'Added you to new broadcast',
      name: 'addedYouToNewBroadcast',
      desc: '',
      args: [],
    );
  }

  /// `Download`
  String get download {
    return Intl.message('Download', name: 'download', desc: '', args: []);
  }

  /// `Copy`
  String get copy {
    return Intl.message('Copy', name: 'copy', desc: '', args: []);
  }

  /// `Info`
  String get info {
    return Intl.message('Info', name: 'info', desc: '', args: []);
  }

  /// `Share`
  String get share {
    return Intl.message('Share', name: 'share', desc: '', args: []);
  }

  /// `Forward`
  String get forward {
    return Intl.message('Forward', name: 'forward', desc: '', args: []);
  }

  /// `Reply`
  String get reply {
    return Intl.message('Reply', name: 'reply', desc: '', args: []);
  }

  /// `Delete from all`
  String get deleteFromAll {
    return Intl.message(
      'Delete from all',
      name: 'deleteFromAll',
      desc: '',
      args: [],
    );
  }

  /// `Delete from me`
  String get deleteFromMe {
    return Intl.message(
      'Delete from me',
      name: 'deleteFromMe',
      desc: '',
      args: [],
    );
  }

  /// `Downloading...`
  String get downloading {
    return Intl.message(
      'Downloading...',
      name: 'downloading',
      desc: '',
      args: [],
    );
  }

  /// `File has been saved to`
  String get fileHasBeenSavedTo {
    return Intl.message(
      'File has been saved to',
      name: 'fileHasBeenSavedTo',
      desc: '',
      args: [],
    );
  }

  /// `Online`
  String get online {
    return Intl.message('Online', name: 'online', desc: '', args: []);
  }

  /// `You don't have access`
  String get youDontHaveAccess {
    return Intl.message(
      'You don\'t have access',
      name: 'youDontHaveAccess',
      desc: '',
      args: [],
    );
  }

  /// `Reply to your self`
  String get replyToYourSelf {
    return Intl.message(
      'Reply to your self',
      name: 'replyToYourSelf',
      desc: '',
      args: [],
    );
  }

  /// `Replied to your self`
  String get repliedToYourSelf {
    return Intl.message(
      'Replied to your self',
      name: 'repliedToYourSelf',
      desc: '',
      args: [],
    );
  }

  /// `Audio call`
  String get audioCall {
    return Intl.message('Audio call', name: 'audioCall', desc: '', args: []);
  }

  /// `Ring`
  String get ring {
    return Intl.message('Ring', name: 'ring', desc: '', args: []);
  }

  /// `Canceled`
  String get canceled {
    return Intl.message('Canceled', name: 'canceled', desc: '', args: []);
  }

  /// `Timeout`
  String get timeout {
    return Intl.message('Timeout', name: 'timeout', desc: '', args: []);
  }

  /// `Rejected`
  String get rejected {
    return Intl.message('Rejected', name: 'rejected', desc: '', args: []);
  }

  /// `Finished`
  String get finished {
    return Intl.message('Finished', name: 'finished', desc: '', args: []);
  }

  /// `In call`
  String get inCall {
    return Intl.message('In call', name: 'inCall', desc: '', args: []);
  }

  /// `Session end`
  String get sessionEnd {
    return Intl.message('Session end', name: 'sessionEnd', desc: '', args: []);
  }

  /// `Yesterday`
  String get yesterday {
    return Intl.message('Yesterday', name: 'yesterday', desc: '', args: []);
  }

  /// `Today`
  String get today {
    return Intl.message('Today', name: 'today', desc: '', args: []);
  }

  /// `Type a message ...`
  String get textFieldHint {
    return Intl.message(
      'Type a message ...',
      name: 'textFieldHint',
      desc: '',
      args: [],
    );
  }

  /// `Files`
  String get files {
    return Intl.message('Files', name: 'files', desc: '', args: []);
  }

  /// `Location`
  String get location {
    return Intl.message('Location', name: 'location', desc: '', args: []);
  }

  /// `Share media and location`
  String get shareMediaAndLocation {
    return Intl.message(
      'Share media and location',
      name: 'shareMediaAndLocation',
      desc: '',
      args: [],
    );
  }

  /// `There is video size bigger than allowed size`
  String get thereIsVideoSizeBiggerThanAllowedSize {
    return Intl.message(
      'There is video size bigger than allowed size',
      name: 'thereIsVideoSizeBiggerThanAllowedSize',
      desc: '',
      args: [],
    );
  }

  /// `There is file has size bigger than allowed size`
  String get thereIsFileHasSizeBiggerThanAllowedSize {
    return Intl.message(
      'There is file has size bigger than allowed size',
      name: 'thereIsFileHasSizeBiggerThanAllowedSize',
      desc: '',
      args: [],
    );
  }

  /// `Make call`
  String get makeCall {
    return Intl.message('Make call', name: 'makeCall', desc: '', args: []);
  }

  /// `Are you want to make video call?`
  String get areYouWantToMakeVideoCall {
    return Intl.message(
      'Are you want to make video call?',
      name: 'areYouWantToMakeVideoCall',
      desc: '',
      args: [],
    );
  }

  /// `Are you want to make voice call?`
  String get areYouWantToMakeVoiceCall {
    return Intl.message(
      'Are you want to make voice call?',
      name: 'areYouWantToMakeVoiceCall',
      desc: '',
      args: [],
    );
  }

  /// `Messages info`
  String get vMessagesInfoTrans {
    return Intl.message(
      'Messages info',
      name: 'vMessagesInfoTrans',
      desc: '',
      args: [],
    );
  }

  /// `Star`
  String get star {
    return Intl.message('Star', name: 'star', desc: '', args: []);
  }

  /// `Minutes`
  String get minutes {
    return Intl.message('Minutes', name: 'minutes', desc: '', args: []);
  }

  /// `Send message`
  String get sendMessage {
    return Intl.message(
      'Send message',
      name: 'sendMessage',
      desc: '',
      args: [],
    );
  }

  /// `Delete user`
  String get deleteUser {
    return Intl.message('Delete user', name: 'deleteUser', desc: '', args: []);
  }

  /// `Actions`
  String get actions {
    return Intl.message('Actions', name: 'actions', desc: '', args: []);
  }

  /// `You are about to delete this user from your list`
  String get youAreAboutToDeleteThisUserFromYourList {
    return Intl.message(
      'You are about to delete this user from your list',
      name: 'youAreAboutToDeleteThisUserFromYourList',
      desc: '',
      args: [],
    );
  }

  /// `Update broadcast title`
  String get updateBroadcastTitle {
    return Intl.message(
      'Update broadcast title',
      name: 'updateBroadcastTitle',
      desc: '',
      args: [],
    );
  }

  /// `Users added successfully`
  String get usersAddedSuccessfully {
    return Intl.message(
      'Users added successfully',
      name: 'usersAddedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Broadcast settings`
  String get broadcastSettings {
    return Intl.message(
      'Broadcast settings',
      name: 'broadcastSettings',
      desc: '',
      args: [],
    );
  }

  /// `Add Participants`
  String get addParticipants {
    return Intl.message(
      'Add Participants',
      name: 'addParticipants',
      desc: '',
      args: [],
    );
  }

  /// `Broadcast Participants`
  String get broadcastParticipants {
    return Intl.message(
      'Broadcast Participants',
      name: 'broadcastParticipants',
      desc: '',
      args: [],
    );
  }

  /// `Update group description`
  String get updateGroupDescription {
    return Intl.message(
      'Update group description',
      name: 'updateGroupDescription',
      desc: '',
      args: [],
    );
  }

  /// `Update group title`
  String get updateGroupTitle {
    return Intl.message(
      'Update group title',
      name: 'updateGroupTitle',
      desc: '',
      args: [],
    );
  }

  /// `Group settings`
  String get groupSettings {
    return Intl.message(
      'Group settings',
      name: 'groupSettings',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message('Description', name: 'description', desc: '', args: []);
  }

  /// `Mute notifications`
  String get muteNotifications {
    return Intl.message(
      'Mute notifications',
      name: 'muteNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Group Participants`
  String get groupParticipants {
    return Intl.message(
      'Group Participants',
      name: 'groupParticipants',
      desc: '',
      args: [],
    );
  }

  /// `Block user`
  String get blockUser {
    return Intl.message('Block user', name: 'blockUser', desc: '', args: []);
  }

  /// `Are you sure to block`
  String get areYouSureToBlock {
    return Intl.message(
      'Are you sure to block',
      name: 'areYouSureToBlock',
      desc: '',
      args: [],
    );
  }

  /// `User page`
  String get userPage {
    return Intl.message('User page', name: 'userPage', desc: '', args: []);
  }

  /// `Star message`
  String get starMessage {
    return Intl.message(
      'Star message',
      name: 'starMessage',
      desc: '',
      args: [],
    );
  }

  /// `Show media`
  String get showMedia {
    return Intl.message('Show media', name: 'showMedia', desc: '', args: []);
  }

  /// `Report user`
  String get reportUser {
    return Intl.message('Report user', name: 'reportUser', desc: '', args: []);
  }

  /// `group name`
  String get groupName {
    return Intl.message('group name', name: 'groupName', desc: '', args: []);
  }

  /// `Change subject`
  String get changeSubject {
    return Intl.message(
      'Change subject',
      name: 'changeSubject',
      desc: '',
      args: [],
    );
  }

  /// `Title is required`
  String get titleIsRequired {
    return Intl.message(
      'Title is required',
      name: 'titleIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Create Broadcast`
  String get createBroadcast {
    return Intl.message(
      'Create Broadcast',
      name: 'createBroadcast',
      desc: '',
      args: [],
    );
  }

  /// `Broadcast name`
  String get broadcastName {
    return Intl.message(
      'Broadcast name',
      name: 'broadcastName',
      desc: '',
      args: [],
    );
  }

  /// `Create Group`
  String get createGroup {
    return Intl.message(
      'Create Group',
      name: 'createGroup',
      desc: '',
      args: [],
    );
  }

  /// `Forget Password?`
  String get forgetPassword {
    return Intl.message(
      'Forget Password?',
      name: 'forgetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Global Search`
  String get globalSearch {
    return Intl.message(
      'Global Search',
      name: 'globalSearch',
      desc: '',
      args: [],
    );
  }

  /// `Dismisses to member`
  String get dismissesToMember {
    return Intl.message(
      'Dismisses to member',
      name: 'dismissesToMember',
      desc: '',
      args: [],
    );
  }

  /// `Set to admin`
  String get setToAdmin {
    return Intl.message('Set to admin', name: 'setToAdmin', desc: '', args: []);
  }

  /// `Kick member`
  String get kickMember {
    return Intl.message('Kick member', name: 'kickMember', desc: '', args: []);
  }

  /// `You are about to dismisses to member`
  String get youAreAboutToDismissesToMember {
    return Intl.message(
      'You are about to dismisses to member',
      name: 'youAreAboutToDismissesToMember',
      desc: '',
      args: [],
    );
  }

  /// `You are about to kick`
  String get youAreAboutToKick {
    return Intl.message(
      'You are about to kick',
      name: 'youAreAboutToKick',
      desc: '',
      args: [],
    );
  }

  /// `Group Members`
  String get groupMembers {
    return Intl.message(
      'Group Members',
      name: 'groupMembers',
      desc: '',
      args: [],
    );
  }

  /// `Tap for photo`
  String get tapForPhoto {
    return Intl.message(
      'Tap for photo',
      name: 'tapForPhoto',
      desc: '',
      args: [],
    );
  }

  /// `We high recommend to download this update`
  String get weHighRecommendToDownloadThisUpdate {
    return Intl.message(
      'We high recommend to download this update',
      name: 'weHighRecommendToDownloadThisUpdate',
      desc: '',
      args: [],
    );
  }

  /// `New group`
  String get newGroup {
    return Intl.message('New group', name: 'newGroup', desc: '', args: []);
  }

  /// `New broadcast`
  String get newBroadcast {
    return Intl.message(
      'New broadcast',
      name: 'newBroadcast',
      desc: '',
      args: [],
    );
  }

  /// `Starred message`
  String get starredMessage {
    return Intl.message(
      'Starred message',
      name: 'starredMessage',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `CHATS`
  String get chats {
    return Intl.message('CHATS', name: 'chats', desc: '', args: []);
  }

  // Annoncement
  String get annonces {
    return Intl.message('Annonces', name: 'annonces', desc: '', args: []);
  }

  /// `Recent updates`
  String get recentUpdates {
    return Intl.message(
      'Recent updates',
      name: 'recentUpdates',
      desc: '',
      args: [],
    );
  }

  /// `Start chat`
  String get startChat {
    return Intl.message('Start chat', name: 'startChat', desc: '', args: []);
  }

  /// `New update is available`
  String get newUpdateIsAvailable {
    return Intl.message(
      'New update is available',
      name: 'newUpdateIsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Email not valid`
  String get emailNotValid {
    return Intl.message(
      'Email not valid',
      name: 'emailNotValid',
      desc: '',
      args: [],
    );
  }

  /// `Password must have value`
  String get passwordMustHaveValue {
    return Intl.message(
      'Password must have value',
      name: 'passwordMustHaveValue',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message('Error', name: 'error', desc: '', args: []);
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Need new account?`
  String get needNewAccount {
    return Intl.message(
      'Need new account?',
      name: 'needNewAccount',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message('Register', name: 'register', desc: '', args: []);
  }

  /// `Name must have value`
  String get nameMustHaveValue {
    return Intl.message(
      'Name must have value',
      name: 'nameMustHaveValue',
      desc: '',
      args: [],
    );
  }

  /// `Password not match`
  String get passwordNotMatch {
    return Intl.message(
      'Password not match',
      name: 'passwordNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Confirm password`
  String get confirmPassword {
    return Intl.message(
      'Confirm password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get alreadyHaveAnAccount {
    return Intl.message(
      'Already have an account?',
      name: 'alreadyHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get logOut {
    return Intl.message('Log out', name: 'logOut', desc: '', args: []);
  }

  /// `Back`
  String get back {
    return Intl.message('Back', name: 'back', desc: '', args: []);
  }

  /// `Send code to my email`
  String get sendCodeToMyEmail {
    return Intl.message(
      'Send code to my email',
      name: 'sendCodeToMyEmail',
      desc: '',
      args: [],
    );
  }

  /// `Invalid login data`
  String get invalidLoginData {
    return Intl.message(
      'Invalid login data',
      name: 'invalidLoginData',
      desc: '',
      args: [],
    );
  }

  /// `User email not found`
  String get userEmailNotFound {
    return Intl.message(
      'User email not found',
      name: 'userEmailNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Your account has been baned`
  String get yourAccountBlocked {
    return Intl.message(
      'Your account has been baned',
      name: 'yourAccountBlocked',
      desc: '',
      args: [],
    );
  }

  /// `Your account has been deleted`
  String get yourAccountDeleted {
    return Intl.message(
      'Your account has been deleted',
      name: 'yourAccountDeleted',
      desc: '',
      args: [],
    );
  }

  /// `User already register`
  String get userAlreadyRegister {
    return Intl.message(
      'User already register',
      name: 'userAlreadyRegister',
      desc: '',
      args: [],
    );
  }

  /// `Code has been expired`
  String get codeHasBeenExpired {
    return Intl.message(
      'Code has been expired',
      name: 'codeHasBeenExpired',
      desc: '',
      args: [],
    );
  }

  /// `Invalid code`
  String get invalidCode {
    return Intl.message(
      'Invalid code',
      name: 'invalidCode',
      desc: '',
      args: [],
    );
  }

  /// `While authentication cannot find you`
  String get whileAuthCanFindYou {
    return Intl.message(
      'While authentication cannot find you',
      name: 'whileAuthCanFindYou',
      desc: '',
      args: [],
    );
  }

  /// `User register status not accepted yet`
  String get userRegisterStatusNotAcceptedYet {
    return Intl.message(
      'User register status not accepted yet',
      name: 'userRegisterStatusNotAcceptedYet',
      desc: '',
      args: [],
    );
  }

  /// `Device has been logout from all devices`
  String get deviceHasBeenLogoutFromAllDevices {
    return Intl.message(
      'Device has been logout from all devices',
      name: 'deviceHasBeenLogoutFromAllDevices',
      desc: '',
      args: [],
    );
  }

  /// `User device session end device deleted`
  String get userDeviceSessionEndDeviceDeleted {
    return Intl.message(
      'User device session end device deleted',
      name: 'userDeviceSessionEndDeviceDeleted',
      desc: '',
      args: [],
    );
  }

  /// `No code has been send to you to verify your email`
  String get noCodeHasBeenSendToYouToVerifyYourEmail {
    return Intl.message(
      'No code has been send to you to verify your email',
      name: 'noCodeHasBeenSendToYouToVerifyYourEmail',
      desc: '',
      args: [],
    );
  }

  /// `Room already in call`
  String get roomAlreadyInCall {
    return Intl.message(
      'Room already in call',
      name: 'roomAlreadyInCall',
      desc: '',
      args: [],
    );
  }

  /// `User in call now`
  String get peerUserInCallNow {
    return Intl.message(
      'User in call now',
      name: 'peerUserInCallNow',
      desc: '',
      args: [],
    );
  }

  /// `Call not allowed`
  String get callNotAllowed {
    return Intl.message(
      'Call not allowed',
      name: 'callNotAllowed',
      desc: '',
      args: [],
    );
  }

  /// `Peer user device offline`
  String get peerUserDeviceOffline {
    return Intl.message(
      'Peer user device offline',
      name: 'peerUserDeviceOffline',
      desc: '',
      args: [],
    );
  }

  /// `Email must be valid`
  String get emailMustBeValid {
    return Intl.message(
      'Email must be valid',
      name: 'emailMustBeValid',
      desc: '',
      args: [],
    );
  }

  /// `Wait 2 minutes to send mail`
  String get wait2MinutesToSendMail {
    return Intl.message(
      'Wait 2 minutes to send mail',
      name: 'wait2MinutesToSendMail',
      desc: '',
      args: [],
    );
  }

  /// `Code must equal to six numbers`
  String get codeMustEqualToSixNumbers {
    return Intl.message(
      'Code must equal to six numbers',
      name: 'codeMustEqualToSixNumbers',
      desc: '',
      args: [],
    );
  }

  /// `New password must have value`
  String get newPasswordMustHaveValue {
    return Intl.message(
      'New password must have value',
      name: 'newPasswordMustHaveValue',
      desc: '',
      args: [],
    );
  }

  /// `Confirm password must have value`
  String get confirmPasswordMustHaveValue {
    return Intl.message(
      'Confirm password must have value',
      name: 'confirmPasswordMustHaveValue',
      desc: '',
      args: [],
    );
  }

  /// `Congregations your account has been accepted`
  String get congregationsYourAccountHasBeenAccepted {
    return Intl.message(
      'Congregations your account has been accepted',
      name: 'congregationsYourAccountHasBeenAccepted',
      desc: '',
      args: [],
    );
  }

  /// `Your account is under review`
  String get yourAccountIsUnderReview {
    return Intl.message(
      'Your account is under review',
      name: 'yourAccountIsUnderReview',
      desc: '',
      args: [],
    );
  }

  /// `Waiting List`
  String get waitingList {
    return Intl.message(
      'Waiting List',
      name: 'waitingList',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get welcome {
    return Intl.message('Welcome', name: 'welcome', desc: '', args: []);
  }

  /// `Retry`
  String get retry {
    return Intl.message('Retry', name: 'retry', desc: '', args: []);
  }

  /// `Delete member`
  String get deleteMember {
    return Intl.message(
      'Delete member',
      name: 'deleteMember',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `Broadcast info`
  String get broadcastInfo {
    return Intl.message(
      'Broadcast info',
      name: 'broadcastInfo',
      desc: '',
      args: [],
    );
  }

  /// `Update title`
  String get updateTitle {
    return Intl.message(
      'Update title',
      name: 'updateTitle',
      desc: '',
      args: [],
    );
  }

  /// `Members`
  String get members {
    return Intl.message('Members', name: 'members', desc: '', args: []);
  }

  /// `Add Members`
  String get addMembers {
    return Intl.message('Add Members', name: 'addMembers', desc: '', args: []);
  }

  /// `Success`
  String get success {
    return Intl.message('Success', name: 'success', desc: '', args: []);
  }

  /// `Media`
  String get media {
    return Intl.message('Media', name: 'media', desc: '', args: []);
  }

  /// `Docs`
  String get docs {
    return Intl.message('Docs', name: 'docs', desc: '', args: []);
  }

  /// `Links`
  String get links {
    return Intl.message('Links', name: 'links', desc: '', args: []);
  }

  /// `Soon`
  String get soon {
    return Intl.message('Soon', name: 'soon', desc: '', args: []);
  }

  /// `Un star`
  String get unStar {
    return Intl.message('Un star', name: 'unStar', desc: '', args: []);
  }

  /// `Update group description will update all group members`
  String get updateGroupDescriptionWillUpdateAllGroupMembers {
    return Intl.message(
      'Update group description will update all group members',
      name: 'updateGroupDescriptionWillUpdateAllGroupMembers',
      desc: '',
      args: [],
    );
  }

  /// `Update nickname`
  String get updateNickname {
    return Intl.message(
      'Update nickname',
      name: 'updateNickname',
      desc: '',
      args: [],
    );
  }

  /// `Group info`
  String get groupInfo {
    return Intl.message('Group info', name: 'groupInfo', desc: '', args: []);
  }

  /// `You not participant in this group`
  String get youNotParticipantInThisGroup {
    return Intl.message(
      'You not participant in this group',
      name: 'youNotParticipantInThisGroup',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message('Search', name: 'search', desc: '', args: []);
  }

  /// `Media, Links, and Docs`
  String get mediaLinksAndDocs {
    return Intl.message(
      'Media, Links, and Docs',
      name: 'mediaLinksAndDocs',
      desc: '',
      args: [],
    );
  }

  /// `Starred Messages`
  String get starredMessages {
    return Intl.message(
      'Starred Messages',
      name: 'starredMessages',
      desc: '',
      args: [],
    );
  }

  /// `Nickname`
  String get nickname {
    return Intl.message('Nickname', name: 'nickname', desc: '', args: []);
  }

  /// `None`
  String get none {
    return Intl.message('None', name: 'none', desc: '', args: []);
  }

  /// `Yes`
  String get yes {
    return Intl.message('Yes', name: 'yes', desc: '', args: []);
  }

  /// `No`
  String get no {
    return Intl.message('No', name: 'no', desc: '', args: []);
  }

  /// `Exit Group`
  String get exitGroup {
    return Intl.message('Exit Group', name: 'exitGroup', desc: '', args: []);
  }

  /// `Click to add group description`
  String get clickToAddGroupDescription {
    return Intl.message(
      'Click to add group description',
      name: 'clickToAddGroupDescription',
      desc: '',
      args: [],
    );
  }

  /// `Un block user`
  String get unBlockUser {
    return Intl.message(
      'Un block user',
      name: 'unBlockUser',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to un block`
  String get areYouSureToUnBlock {
    return Intl.message(
      'Are you sure to un block',
      name: 'areYouSureToUnBlock',
      desc: '',
      args: [],
    );
  }

  /// `Contact info`
  String get contactInfo {
    return Intl.message(
      'Contact info',
      name: 'contactInfo',
      desc: '',
      args: [],
    );
  }

  /// `Audio`
  String get audio {
    return Intl.message('Audio', name: 'audio', desc: '', args: []);
  }

  /// `Video`
  String get video {
    return Intl.message('Video', name: 'video', desc: '', args: []);
  }

  /// `Hi iam using`
  String get hiIamUse {
    return Intl.message('Hi iam using', name: 'hiIamUse', desc: '', args: []);
  }

  /// `On`
  String get on {
    return Intl.message('On', name: 'on', desc: '', args: []);
  }

  /// `Off`
  String get off {
    return Intl.message('Off', name: 'off', desc: '', args: []);
  }

  /// `Un Block`
  String get unBlock {
    return Intl.message('Un Block', name: 'unBlock', desc: '', args: []);
  }

  /// `Block`
  String get block {
    return Intl.message('Block', name: 'block', desc: '', args: []);
  }

  /// `Choose at lest one member`
  String get chooseAtLestOneMember {
    return Intl.message(
      'Choose at lest one member',
      name: 'chooseAtLestOneMember',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message('Close', name: 'close', desc: '', args: []);
  }

  /// `Next`
  String get next {
    return Intl.message('Next', name: 'next', desc: '', args: []);
  }

  /// `App members`
  String get appMembers {
    return Intl.message('App members', name: 'appMembers', desc: '', args: []);
  }

  /// `Create`
  // String get create {
  //   return Intl.message('Create', name: 'create', desc: '', args: []);
  // }

  /// `Upgrade to admin`
  String get upgradeToAdmin {
    return Intl.message(
      'Upgrade to admin',
      name: 'upgradeToAdmin',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message('Update', name: 'update', desc: '', args: []);
  }

  /// `Delete chat`
  String get deleteChat {
    return Intl.message('Delete chat', name: 'deleteChat', desc: '', args: []);
  }

  /// `Clear chat`
  String get clearChat {
    return Intl.message('Clear chat', name: 'clearChat', desc: '', args: []);
  }

  /// `Show history`
  String get showHistory {
    return Intl.message(
      'Show history',
      name: 'showHistory',
      desc: '',
      args: [],
    );
  }

  /// `Group icon`
  String get groupIcon {
    return Intl.message('Group icon', name: 'groupIcon', desc: '', args: []);
  }

  /// `Tap to select an icon`
  String get tapToSelectAnIcon {
    return Intl.message(
      'Tap to select an icon',
      name: 'tapToSelectAnIcon',
      desc: '',
      args: [],
    );
  }

  /// `Group description`
  String get groupDescription {
    return Intl.message(
      'Group description',
      name: 'groupDescription',
      desc: '',
      args: [],
    );
  }

  /// `More`
  String get more {
    return Intl.message('More', name: 'more', desc: '', args: []);
  }

  /// `Message info`
  String get messageInfo {
    return Intl.message(
      'Message info',
      name: 'messageInfo',
      desc: '',
      args: [],
    );
  }

  /// `Successfully downloaded in`
  String get successfullyDownloadedIn {
    return Intl.message(
      'Successfully downloaded in',
      name: 'successfullyDownloadedIn',
      desc: '',
      args: [],
    );
  }

  /// `Delivered`
  String get delivered {
    return Intl.message('Delivered', name: 'delivered', desc: '', args: []);
  }

  /// `Read`
  String get read {
    return Intl.message('Read', name: 'read', desc: '', args: []);
  }

  /// `or login with`
  String get orLoginWith {
    return Intl.message(
      'or login with',
      name: 'orLoginWith',
      desc: '',
      args: [],
    );
  }

  /// `Reset password`
  String get resetPassword {
    return Intl.message(
      'Reset password',
      name: 'resetPassword',
      desc: '',
      args: [],
    );
  }

  /// `OTP Code`
  String get otpCode {
    return Intl.message('OTP Code', name: 'otpCode', desc: '', args: []);
  }

  /// `New password`
  String get newPassword {
    return Intl.message(
      'New password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure?`
  String get areYouSure {
    return Intl.message(
      'Are you sure?',
      name: 'areYouSure',
      desc: '',
      args: [],
    );
  }

  /// `Broadcast Members`
  String get broadcastMembers {
    return Intl.message(
      'Broadcast Members',
      name: 'broadcastMembers',
      desc: '',
      args: [],
    );
  }

  /// `Phone`
  String get phone {
    return Intl.message('Phone', name: 'phone', desc: '', args: []);
  }

  String get create {
    return Intl.message('Create', name: 'create', desc: '', args: []);
  }

  /// `Users`
  String get users {
    return Intl.message('Users', name: 'users', desc: '', args: []);
  }

  /// `Calls`
  String get calls {
    return Intl.message('Calls', name: 'calls', desc: '', args: []);
  }

  /// `Your are about to logout from this account`
  String get yourAreAboutToLogoutFromThisAccount {
    return Intl.message(
      'Your are about to logout from this account',
      name: 'yourAreAboutToLogoutFromThisAccount',
      desc: '',
      args: [],
    );
  }

  /// `No updates available now`
  String get noUpdatesAvailableNow {
    return Intl.message(
      'No updates available now',
      name: 'noUpdatesAvailableNow',
      desc: '',
      args: [],
    );
  }

  /// `Data privacy`
  String get dataPrivacy {
    return Intl.message(
      'Data privacy',
      name: 'dataPrivacy',
      desc: '',
      args: [],
    );
  }

  /// `All data has been backup you don\'t want need to manage save the data by your self! if you logout and login again you will see all chats same for web version`
  String get allDataHasBeenBackupYouDontNeedToManageSaveTheDataByYourself {
    return Intl.message(
      'All data has been backup you don\\\'t want need to manage save the data by your self! if you logout and login again you will see all chats same for web version',
      name: 'allDataHasBeenBackupYouDontNeedToManageSaveTheDataByYourself',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get account {
    return Intl.message('Account', name: 'account', desc: '', args: []);
  }

  /// `Linked Devices`
  String get linkedDevices {
    return Intl.message(
      'Linked Devices',
      name: 'linkedDevices',
      desc: '',
      args: [],
    );
  }

  /// `Storage and Data`
  String get storageAndData {
    return Intl.message(
      'Storage and Data',
      name: 'storageAndData',
      desc: '',
      args: [],
    );
  }

  /// `Tell a friend`
  String get tellAFriend {
    return Intl.message(
      'Tell a friend',
      name: 'tellAFriend',
      desc: '',
      args: [],
    );
  }

  /// `Help`
  String get help {
    return Intl.message('Help', name: 'help', desc: '', args: []);
  }

  /// `Blocked users`
  String get blockedUsers {
    return Intl.message(
      'Blocked users',
      name: 'blockedUsers',
      desc: '',
      args: [],
    );
  }

  /// `In app alerts`
  String get inAppAlerts {
    return Intl.message(
      'In app alerts',
      name: 'inAppAlerts',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Admin notification`
  String get adminNotification {
    return Intl.message(
      'Admin notification',
      name: 'adminNotification',
      desc: '',
      args: [],
    );
  }

  /// `Check for updates`
  String get checkForUpdates {
    return Intl.message(
      'Check for updates',
      name: 'checkForUpdates',
      desc: '',
      args: [],
    );
  }

  /// `Link By Qr Code`
  String get linkByQrCode {
    return Intl.message(
      'Link By Qr Code',
      name: 'linkByQrCode',
      desc: '',
      args: [],
    );
  }

  /// `Device status`
  String get deviceStatus {
    return Intl.message(
      'Device status',
      name: 'deviceStatus',
      desc: '',
      args: [],
    );
  }

  /// `Desktop, and other devices`
  String get desktopAndOtherDevices {
    return Intl.message(
      'Desktop, and other devices',
      name: 'desktopAndOtherDevices',
      desc: '',
      args: [],
    );
  }

  /// `Link a Device (Soon)`
  String get linkADeviceSoon {
    return Intl.message(
      'Link a Device (Soon)',
      name: 'linkADeviceSoon',
      desc: '',
      args: [],
    );
  }

  /// `Last active from`
  String get lastActiveFrom {
    return Intl.message(
      'Last active from',
      name: 'lastActiveFrom',
      desc: '',
      args: [],
    );
  }

  /// `Tap a device to edit or log out.`
  String get tapADeviceToEditOrLogOut {
    return Intl.message(
      'Tap a device to edit or log out.',
      name: 'tapADeviceToEditOrLogOut',
      desc: '',
      args: [],
    );
  }

  /// `Contact Us`
  String get contactUs {
    return Intl.message('Contact Us', name: 'contactUs', desc: '', args: []);
  }

  /// `Support chat (Soon)`
  String get supportChatSoon {
    return Intl.message(
      'Support chat (Soon)',
      name: 'supportChatSoon',
      desc: '',
      args: [],
    );
  }

  /// `Update your name`
  String get updateYourName {
    return Intl.message(
      'Update your name',
      name: 'updateYourName',
      desc: '',
      args: [],
    );
  }

  /// `Update your bio`
  String get updateYourBio {
    return Intl.message(
      'Update your bio',
      name: 'updateYourBio',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message('Edit', name: 'edit', desc: '', args: []);
  }

  /// `About`
  String get about {
    return Intl.message('About', name: 'about', desc: '', args: []);
  }

  /// `Old password`
  String get oldPassword {
    return Intl.message(
      'Old password',
      name: 'oldPassword',
      desc: '',
      args: [],
    );
  }

  /// `Delete my account`
  String get deleteMyAccount {
    return Intl.message(
      'Delete my account',
      name: 'deleteMyAccount',
      desc: '',
      args: [],
    );
  }

  /// `Password has been changed`
  String get passwordHasBeenChanged {
    return Intl.message(
      'Password has been changed',
      name: 'passwordHasBeenChanged',
      desc: '',
      args: [],
    );
  }

  /// `Logout from all devices?`
  String get logoutFromAllDevices {
    return Intl.message(
      'Logout from all devices?',
      name: 'logoutFromAllDevices',
      desc: '',
      args: [],
    );
  }

  /// `Update your password`
  String get updateYourPassword {
    return Intl.message(
      'Update your password',
      name: 'updateYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter your name and add an optional profile picture`
  String get enterNameAndAddOptionalProfilePicture {
    return Intl.message(
      'Enter your name and add an optional profile picture',
      name: 'enterNameAndAddOptionalProfilePicture',
      desc: '',
      args: [],
    );
  }

  /// `Privacy policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Chat`
  String get chat {
    return Intl.message('Chat', name: 'chat', desc: '', args: []);
  }

  /// `Send`
  String get send {
    return Intl.message('Send', name: 'send', desc: '', args: []);
  }

  /// `Your report has been submitted`
  String get reportHasBeenSubmitted {
    return Intl.message(
      'Your report has been submitted',
      name: 'reportHasBeenSubmitted',
      desc: '',
      args: [],
    );
  }

  /// `Offline`
  String get offline {
    return Intl.message('Offline', name: 'offline', desc: '', args: []);
  }

  /// `Harassment or Bullying: This option allows users to report individuals who are targeting them or others with harassing messages, threats, or other forms of bullying.`
  String get harassmentOrBullyingDescription {
    return Intl.message(
      'Harassment or Bullying: This option allows users to report individuals who are targeting them or others with harassing messages, threats, or other forms of bullying.',
      name: 'harassmentOrBullyingDescription',
      desc: '',
      args: [],
    );
  }

  /// `Spam or Scam: This option would be for users to report accounts that are sending spam messages, unsolicited advertisements, or are attempting to scam others.`
  String get spamOrScamDescription {
    return Intl.message(
      'Spam or Scam: This option would be for users to report accounts that are sending spam messages, unsolicited advertisements, or are attempting to scam others.',
      name: 'spamOrScamDescription',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to submit report about this user to the admin?`
  String get areYouSureToReportUserToAdmin {
    return Intl.message(
      'Are you sure to submit report about this user to the admin?',
      name: 'areYouSureToReportUserToAdmin',
      desc: '',
      args: [],
    );
  }

  /// `Group with`
  String get groupWith {
    return Intl.message('Group with', name: 'groupWith', desc: '', args: []);
  }

  /// `Inappropriate Content: Users can select this option to report any sexually explicit material, hate speech, or other content that violates community standards.`
  String get inappropriateContentDescription {
    return Intl.message(
      'Inappropriate Content: Users can select this option to report any sexually explicit material, hate speech, or other content that violates community standards.',
      name: 'inappropriateContentDescription',
      desc: '',
      args: [],
    );
  }

  /// `Other: This catch-all category can be used for violations that don't easily fit into the above categories. It might be helpful to include a text box for users to provide additional details.`
  String get otherCategoryDescription {
    return Intl.message(
      'Other: This catch-all category can be used for violations that don\'t easily fit into the above categories. It might be helpful to include a text box for users to provide additional details.',
      name: 'otherCategoryDescription',
      desc: '',
      args: [],
    );
  }

  /// `Explain here what happens`
  String get explainWhatHappens {
    return Intl.message(
      'Explain here what happens',
      name: 'explainWhatHappens',
      desc: '',
      args: [],
    );
  }

  /// `Login again!`
  String get loginAgain {
    return Intl.message('Login again!', name: 'loginAgain', desc: '', args: []);
  }

  /// `Your session is ended please login again!`
  String get yourSessionIsEndedPleaseLoginAgain {
    return Intl.message(
      'Your session is ended please login again!',
      name: 'yourSessionIsEndedPleaseLoginAgain',
      desc: '',
      args: [],
    );
  }

  /// `You are about to block this user. You can't send him chats and can't add him to groups or broadcast!`
  String get aboutToBlockUserWithConsequences {
    return Intl.message(
      'You are about to block this user. You can\'t send him chats and can\'t add him to groups or broadcast!',
      name: 'aboutToBlockUserWithConsequences',
      desc: '',
      args: [],
    );
  }

  /// `You are about to delete your account your account will not appears again in the users list`
  String
      get youAreAboutToDeleteYourAccountYourAccountWillNotAppearAgainInUsersList {
    return Intl.message(
      'You are about to delete your account your account will not appears again in the users list',
      name:
          'youAreAboutToDeleteYourAccountYourAccountWillNotAppearAgainInUsersList',
      desc: '',
      args: [],
    );
  }

  /// `Admin`
  String get admin {
    return Intl.message('Admin', name: 'admin', desc: '', args: []);
  }

  /// `Member`
  String get member {
    return Intl.message('Member', name: 'member', desc: '', args: []);
  }

  /// `Creator`
  String get creator {
    return Intl.message('Creator', name: 'creator', desc: '', args: []);
  }

  /// `Current device`
  String get currentDevice {
    return Intl.message(
      'Current device',
      name: 'currentDevice',
      desc: '',
      args: [],
    );
  }

  /// `Visits`
  String get visits {
    return Intl.message('Visits', name: 'visits', desc: '', args: []);
  }

  /// `Choose room`
  String get chooseRoom {
    return Intl.message('Choose room', name: 'chooseRoom', desc: '', args: []);
  }

  /// `Deleting this device means instantly logout this device`
  String get deleteThisDeviceDesc {
    return Intl.message(
      'Deleting this device means instantly logout this device',
      name: 'deleteThisDeviceDesc',
      desc: '',
      args: [],
    );
  }

  /// `You are about to upgrade to admin`
  String get youAreAboutToUpgradeToAdmin {
    return Intl.message(
      'You are about to upgrade to admin',
      name: 'youAreAboutToUpgradeToAdmin',
      desc: '',
      args: [],
    );
  }

  /// `Microphone permission must be accepted`
  String get microphonePermissionMustBeAccepted {
    return Intl.message(
      'Microphone permission must be accepted',
      name: 'microphonePermissionMustBeAccepted',
      desc: '',
      args: [],
    );
  }

  /// `Microphone and camera permission must be accepted`
  String get microphoneAndCameraPermissionMustBeAccepted {
    return Intl.message(
      'Microphone and camera permission must be accepted',
      name: 'microphoneAndCameraPermissionMustBeAccepted',
      desc: '',
      args: [],
    );
  }

  /// `Login now allowed. Please try again later.`
  String get loginNowAllowedNowPleaseTryAgainLater {
    return Intl.message(
      'Login now allowed. Please try again later.',
      name: 'loginNowAllowedNowPleaseTryAgainLater',
      desc: '',
      args: [],
    );
  }

  /// `Dashboard`
  String get dashboard {
    return Intl.message('Dashboard', name: 'dashboard', desc: '', args: []);
  }

  /// `Notification`
  String get notification {
    return Intl.message(
      'Notification',
      name: 'notification',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get total {
    return Intl.message('Total', name: 'total', desc: '', args: []);
  }

  /// `Blocked`
  String get blocked {
    return Intl.message('Blocked', name: 'blocked', desc: '', args: []);
  }

  /// `Deleted`
  String get deleted {
    return Intl.message('Deleted', name: 'deleted', desc: '', args: []);
  }

  /// `Accepted`
  String get accepted {
    return Intl.message('Accepted', name: 'accepted', desc: '', args: []);
  }

  /// `Not Accepted`
  String get notAccepted {
    return Intl.message(
      'Not Accepted',
      name: 'notAccepted',
      desc: '',
      args: [],
    );
  }

  /// `Web`
  String get web {
    return Intl.message('Web', name: 'web', desc: '', args: []);
  }

  /// `Android`
  String get android {
    return Intl.message('Android', name: 'android', desc: '', args: []);
  }

  /// `macOS`
  String get macOs {
    return Intl.message('macOS', name: 'macOs', desc: '', args: []);
  }

  /// `Windows`
  String get windows {
    return Intl.message('Windows', name: 'windows', desc: '', args: []);
  }

  /// `Other`
  String get other {
    return Intl.message('Other', name: 'other', desc: '', args: []);
  }

  /// `Total Visits`
  String get totalVisits {
    return Intl.message(
      'Total Visits',
      name: 'totalVisits',
      desc: '',
      args: [],
    );
  }

  /// `Total Messages`
  String get totalMessages {
    return Intl.message(
      'Total Messages',
      name: 'totalMessages',
      desc: '',
      args: [],
    );
  }

  /// `Text Messages`
  String get textMessages {
    return Intl.message(
      'Text Messages',
      name: 'textMessages',
      desc: '',
      args: [],
    );
  }

  /// `Image Messages`
  String get imageMessages {
    return Intl.message(
      'Image Messages',
      name: 'imageMessages',
      desc: '',
      args: [],
    );
  }

  /// `Video Messages`
  String get videoMessages {
    return Intl.message(
      'Video Messages',
      name: 'videoMessages',
      desc: '',
      args: [],
    );
  }

  /// `Voice Messages`
  String get voiceMessages {
    return Intl.message(
      'Voice Messages',
      name: 'voiceMessages',
      desc: '',
      args: [],
    );
  }

  /// `File Messages`
  String get fileMessages {
    return Intl.message(
      'File Messages',
      name: 'fileMessages',
      desc: '',
      args: [],
    );
  }

  /// `Info Messages`
  String get infoMessages {
    return Intl.message(
      'Info Messages',
      name: 'infoMessages',
      desc: '',
      args: [],
    );
  }

  /// `Voice Call Messages`
  String get voiceCallMessages {
    return Intl.message(
      'Voice Call Messages',
      name: 'voiceCallMessages',
      desc: '',
      args: [],
    );
  }

  /// `Video Call Messages`
  String get videoCallMessages {
    return Intl.message(
      'Video Call Messages',
      name: 'videoCallMessages',
      desc: '',
      args: [],
    );
  }

  /// `Location Messages`
  String get locationMessages {
    return Intl.message(
      'Location Messages',
      name: 'locationMessages',
      desc: '',
      args: [],
    );
  }

  /// `Direct Chat`
  String get directChat {
    return Intl.message('Direct Chat', name: 'directChat', desc: '', args: []);
  }

  /// `Group`
  String get group {
    return Intl.message('Group', name: 'group', desc: '', args: []);
  }

  /// `Broadcast`
  String get broadcast {
    return Intl.message('Broadcast', name: 'broadcast', desc: '', args: []);
  }

  /// `Message Counter`
  String get messageCounter {
    return Intl.message(
      'Message Counter',
      name: 'messageCounter',
      desc: '',
      args: [],
    );
  }

  /// `Room Counter`
  String get roomCounter {
    return Intl.message(
      'Room Counter',
      name: 'roomCounter',
      desc: '',
      args: [],
    );
  }

  /// `Countries`
  String get countries {
    return Intl.message('Countries', name: 'countries', desc: '', args: []);
  }

  /// `Devices`
  String get devices {
    return Intl.message('Devices', name: 'devices', desc: '', args: []);
  }

  /// `Notification Title`
  String get notificationTitle {
    return Intl.message(
      'Notification Title',
      name: 'notificationTitle',
      desc: '',
      args: [],
    );
  }

  /// `Notification Description`
  String get notificationDescription {
    return Intl.message(
      'Notification Description',
      name: 'notificationDescription',
      desc: '',
      args: [],
    );
  }

  /// `Notifications Page`
  String get notificationsPage {
    return Intl.message(
      'Notifications Page',
      name: 'notificationsPage',
      desc: '',
      args: [],
    );
  }

  /// `Update Feedback Email`
  String get updateFeedBackEmail {
    return Intl.message(
      'Update Feedback Email',
      name: 'updateFeedBackEmail',
      desc: '',
      args: [],
    );
  }

  /// `Set Max Message Forward and Share`
  String get setMaxMessageForwardAndShare {
    return Intl.message(
      'Set Max Message Forward and Share',
      name: 'setMaxMessageForwardAndShare',
      desc: '',
      args: [],
    );
  }

  /// `Set New Privacy Policy URL`
  String get setNewPrivacyPolicyUrl {
    return Intl.message(
      'Set New Privacy Policy URL',
      name: 'setNewPrivacyPolicyUrl',
      desc: '',
      args: [],
    );
  }

  /// `Forget Password Expire Time`
  String get forgetPasswordExpireTime {
    return Intl.message(
      'Forget Password Expire Time',
      name: 'forgetPasswordExpireTime',
      desc: '',
      args: [],
    );
  }

  /// `Call Timeout in Seconds`
  String get callTimeoutInSeconds {
    return Intl.message(
      'Call Timeout in Seconds',
      name: 'callTimeoutInSeconds',
      desc: '',
      args: [],
    );
  }

  /// `Set Max Group Members`
  String get setMaxGroupMembers {
    return Intl.message(
      'Set Max Group Members',
      name: 'setMaxGroupMembers',
      desc: '',
      args: [],
    );
  }

  /// `Set Max Broadcast Members`
  String get setMaxBroadcastMembers {
    return Intl.message(
      'Set Max Broadcast Members',
      name: 'setMaxBroadcastMembers',
      desc: '',
      args: [],
    );
  }

  /// `Allow Calls`
  String get allowCalls {
    return Intl.message('Allow Calls', name: 'allowCalls', desc: '', args: []);
  }

  /// `If this option is enabled, the video and voice call will be allowed.`
  String get ifThisOptionEnabledTheVideoAndVoiceCallWillBeAllowed {
    return Intl.message(
      'If this option is enabled, the video and voice call will be allowed.',
      name: 'ifThisOptionEnabledTheVideoAndVoiceCallWillBeAllowed',
      desc: '',
      args: [],
    );
  }

  /// `Allow Ads`
  String get allowAds {
    return Intl.message('Allow Ads', name: 'allowAds', desc: '', args: []);
  }

  /// `Allow Mobile Login`
  String get allowMobileLogin {
    return Intl.message(
      'Allow Mobile Login',
      name: 'allowMobileLogin',
      desc: '',
      args: [],
    );
  }

  /// `Allow Web Login`
  String get allowWebLogin {
    return Intl.message(
      'Allow Web Login',
      name: 'allowWebLogin',
      desc: '',
      args: [],
    );
  }

  /// `Messages`
  String get messages {
    return Intl.message('Messages', name: 'messages', desc: '', args: []);
  }

  /// `Apple Store App URL`
  String get appleStoreAppUrl {
    return Intl.message(
      'Apple Store App URL',
      name: 'appleStoreAppUrl',
      desc: '',
      args: [],
    );
  }

  /// `Google Play App URL`
  String get googlePlayAppUrl {
    return Intl.message(
      'Google Play App URL',
      name: 'googlePlayAppUrl',
      desc: '',
      args: [],
    );
  }

  /// `Privacy URL`
  String get privacyUrl {
    return Intl.message('Privacy URL', name: 'privacyUrl', desc: '', args: []);
  }

  /// `Feedback Email`
  String get feedBackEmail {
    return Intl.message(
      'Feedback Email',
      name: 'feedBackEmail',
      desc: '',
      args: [],
    );
  }

  /// `If this option is disabled, sending chat files, images, videos, and location will be blocked.`
  String
      get ifThisOptionDisabledTheSendChatFilesImageVideosAndLocationWillBeBlocked {
    return Intl.message(
      'If this option is disabled, sending chat files, images, videos, and location will be blocked.',
      name:
          'ifThisOptionDisabledTheSendChatFilesImageVideosAndLocationWillBeBlocked',
      desc: '',
      args: [],
    );
  }

  /// `Allow Send Media`
  String get allowSendMedia {
    return Intl.message(
      'Allow Send Media',
      name: 'allowSendMedia',
      desc: '',
      args: [],
    );
  }

  /// `If this option is disabled, creating chat broadcast will be blocked.`
  String get ifThisOptionDisabledTheCreateChatBroadcastWillBeBlocked {
    return Intl.message(
      'If this option is disabled, creating chat broadcast will be blocked.',
      name: 'ifThisOptionDisabledTheCreateChatBroadcastWillBeBlocked',
      desc: '',
      args: [],
    );
  }

  /// `Allow Create Broadcast`
  String get allowCreateBroadcast {
    return Intl.message(
      'Allow Create Broadcast',
      name: 'allowCreateBroadcast',
      desc: '',
      args: [],
    );
  }

  /// `If this option is disabled, creating chat groups will be blocked.`
  String get ifThisOptionDisabledTheCreateChatGroupsWillBeBlocked {
    return Intl.message(
      'If this option is disabled, creating chat groups will be blocked.',
      name: 'ifThisOptionDisabledTheCreateChatGroupsWillBeBlocked',
      desc: '',
      args: [],
    );
  }

  /// `Allow Create Groups`
  String get allowCreateGroups {
    return Intl.message(
      'Allow Create Groups',
      name: 'allowCreateGroups',
      desc: '',
      args: [],
    );
  }

  /// `If this option is disabled, the desktop login or register (Windows, Mac) will be blocked.`
  String
      get ifThisOptionDisabledTheDesktopLoginOrRegisterWindowsMacWillBeBlocked {
    return Intl.message(
      'If this option is disabled, the desktop login or register (Windows, Mac) will be blocked.',
      name:
          'ifThisOptionDisabledTheDesktopLoginOrRegisterWindowsMacWillBeBlocked',
      desc: '',
      args: [],
    );
  }

  /// `Allow Desktop Login`
  String get allowDesktopLogin {
    return Intl.message(
      'Allow Desktop Login',
      name: 'allowDesktopLogin',
      desc: '',
      args: [],
    );
  }

  /// `If this option is disabled, the web login or register will be blocked.`
  String get ifThisOptionDisabledTheWebLoginOrRegisterWillBeBlocked {
    return Intl.message(
      'If this option is disabled, the web login or register will be blocked.',
      name: 'ifThisOptionDisabledTheWebLoginOrRegisterWillBeBlocked',
      desc: '',
      args: [],
    );
  }

  /// `If this option is disabled, the mobile login or register will be blocked on Android and iOS only.`
  String
      get ifThisOptionDisabledTheMobileLoginOrRegisterWillBeBlockedOnAndroidIosOnly {
    return Intl.message(
      'If this option is disabled, the mobile login or register will be blocked on Android and iOS only.',
      name:
          'ifThisOptionDisabledTheMobileLoginOrRegisterWillBeBlockedOnAndroidIosOnly',
      desc: '',
      args: [],
    );
  }

  /// `If this option is enabled, the Google Ads banner will appear in chats.`
  String get ifThisOptionEnabledTheGoogleAdsBannerWillAppearInChats {
    return Intl.message(
      'If this option is enabled, the Google Ads banner will appear in chats.',
      name: 'ifThisOptionEnabledTheGoogleAdsBannerWillAppearInChats',
      desc: '',
      args: [],
    );
  }

  /// `User Profile`
  String get userProfile {
    return Intl.message(
      'User Profile',
      name: 'userProfile',
      desc: '',
      args: [],
    );
  }

  /// `User Info`
  String get userInfo {
    return Intl.message('User Info', name: 'userInfo', desc: '', args: []);
  }

  /// `Full Name`
  String get fullName {
    return Intl.message('Full Name', name: 'fullName', desc: '', args: []);
  }

  /// `Bio`
  String get bio {
    return Intl.message('Bio', name: 'bio', desc: '', args: []);
  }

  /// `No Bio`
  String get noBio {
    return Intl.message('No Bio', name: 'noBio', desc: '', args: []);
  }

  /// `Verified At`
  String get verifiedAt {
    return Intl.message('Verified At', name: 'verifiedAt', desc: '', args: []);
  }

  /// `Country`
  String get country {
    return Intl.message('Country', name: 'country', desc: '', args: []);
  }

  /// `Register Status`
  String get registerStatus {
    return Intl.message(
      'Register Status',
      name: 'registerStatus',
      desc: '',
      args: [],
    );
  }

  /// `Register Method`
  String get registerMethod {
    return Intl.message(
      'Register Method',
      name: 'registerMethod',
      desc: '',
      args: [],
    );
  }

  /// `Ban To`
  String get banTo {
    return Intl.message('Ban To', name: 'banTo', desc: '', args: []);
  }

  /// `Deleted At`
  String get deletedAt {
    return Intl.message('Deleted At', name: 'deletedAt', desc: '', args: []);
  }

  /// `Created At`
  String get createdAt {
    return Intl.message('Created At', name: 'createdAt', desc: '', args: []);
  }

  /// `Updated At`
  String get updatedAt {
    return Intl.message('Updated At', name: 'updatedAt', desc: '', args: []);
  }

  /// `Reports`
  String get reports {
    return Intl.message('Reports', name: 'reports', desc: '', args: []);
  }

  /// `Click to see all user devices details`
  String get clickToSeeAllUserDevicesDetails {
    return Intl.message(
      'Click to see all user devices details',
      name: 'clickToSeeAllUserDevicesDetails',
      desc: '',
      args: [],
    );
  }

  /// `All Deleted Messages`
  String get allDeletedMessages {
    return Intl.message(
      'All Deleted Messages',
      name: 'allDeletedMessages',
      desc: '',
      args: [],
    );
  }

  /// `Voice Call Message`
  String get voiceCallMessage {
    return Intl.message(
      'Voice Call Message',
      name: 'voiceCallMessage',
      desc: '',
      args: [],
    );
  }

  /// `Total Rooms`
  String get totalRooms {
    return Intl.message('Total Rooms', name: 'totalRooms', desc: '', args: []);
  }

  /// `Direct Rooms`
  String get directRooms {
    return Intl.message(
      'Direct Rooms',
      name: 'directRooms',
      desc: '',
      args: [],
    );
  }

  /// `User Action`
  String get userAction {
    return Intl.message('User Action', name: 'userAction', desc: '', args: []);
  }

  /// `Status`
  String get status {
    return Intl.message('Status', name: 'status', desc: '', args: []);
  }

  /// `Joined At`
  String get joinedAt {
    return Intl.message('Joined At', name: 'joinedAt', desc: '', args: []);
  }

  /// `Save Login`
  String get saveLogin {
    return Intl.message('Save Login', name: 'saveLogin', desc: '', args: []);
  }

  /// `Password is required`
  String get passwordIsRequired {
    return Intl.message(
      'Password is required',
      name: 'passwordIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Verified`
  String get verified {
    return Intl.message('Verified', name: 'verified', desc: '', args: []);
  }

  /// `Pending`
  String get pending {
    return Intl.message('Pending', name: 'pending', desc: '', args: []);
  }

  /// `iOS`
  String get ios {
    return Intl.message('iOS', name: 'ios', desc: '', args: []);
  }

  /// `Description is required`
  String get descriptionIsRequired {
    return Intl.message(
      'Description is required',
      name: 'descriptionIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Seconds`
  String get seconds {
    return Intl.message('Seconds', name: 'seconds', desc: '', args: []);
  }

  /// `Click to see all user information`
  String get clickToSeeAllUserInformations {
    return Intl.message(
      'Click to see all user information',
      name: 'clickToSeeAllUserInformations',
      desc: '',
      args: [],
    );
  }

  /// `Click to see all user countries`
  String get clickToSeeAllUserCountries {
    return Intl.message(
      'Click to see all user countries',
      name: 'clickToSeeAllUserCountries',
      desc: '',
      args: [],
    );
  }

  /// `Click to see all user messages details`
  String get clickToSeeAllUserMessagesDetails {
    return Intl.message(
      'Click to see all user messages details',
      name: 'clickToSeeAllUserMessagesDetails',
      desc: '',
      args: [],
    );
  }

  /// `Click to see all user rooms details`
  String get clickToSeeAllUserRoomsDetails {
    return Intl.message(
      'Click to see all user rooms details',
      name: 'clickToSeeAllUserRoomsDetails',
      desc: '',
      args: [],
    );
  }

  /// `Click to see all user reports`
  String get clickToSeeAllUserReports {
    return Intl.message(
      'Click to see all user reports',
      name: 'clickToSeeAllUserReports',
      desc: '',
      args: [],
    );
  }

  /// `Ban at`
  String get banAt {
    return Intl.message('Ban at', name: 'banAt', desc: '', args: []);
  }

  /// `Now you login as read-only admin. All edits you make will not be applied due to this being a test version.`
  String
      get nowYouLoginAsReadOnlyAdminAllEditYouDoneWillNotAppliedDueToThisIsTestVersion {
    return Intl.message(
      'Now you login as read-only admin. All edits you make will not be applied due to this being a test version.',
      name:
          'nowYouLoginAsReadOnlyAdminAllEditYouDoneWillNotAppliedDueToThisIsTestVersion',
      desc: '',
      args: [],
    );
  }

  /// `Create Story`
  String get createStory {
    return Intl.message(
      'Create Story',
      name: 'createStory',
      desc: '',
      args: [],
    );
  }

  /// `Write a caption...`
  String get writeACaption {
    return Intl.message(
      'Write a caption...',
      name: 'writeACaption',
      desc: '',
      args: [],
    );
  }

  /// `Story Created Successfully`
  String get storyCreatedSuccessfully {
    return Intl.message(
      'Story Created Successfully',
      name: 'storyCreatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Stories`
  String get stories {
    return Intl.message('Stories', name: 'stories', desc: '', args: []);
  }

  /// `Clear`
  String get clear {
    return Intl.message('Clear', name: 'clear', desc: '', args: []);
  }

  /// `Clear calls confirm`
  String get clearCallsConfirm {
    return Intl.message(
      'Clear calls confirm',
      name: 'clearCallsConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Choose how automatic download works`
  String get chooseHowAutomaticDownloadWorks {
    return Intl.message(
      'Choose how automatic download works',
      name: 'chooseHowAutomaticDownloadWorks',
      desc: '',
      args: [],
    );
  }

  /// `When using mobile data`
  String get whenUsingMobileData {
    return Intl.message(
      'When using mobile data',
      name: 'whenUsingMobileData',
      desc: '',
      args: [],
    );
  }

  /// `When using Wi-Fi`
  String get whenUsingWifi {
    return Intl.message(
      'When using Wi-Fi',
      name: 'whenUsingWifi',
      desc: '',
      args: [],
    );
  }

  /// `Image`
  String get image {
    return Intl.message('Image', name: 'image', desc: '', args: []);
  }

  /// `My Privacy`
  String get myPrivacy {
    return Intl.message('My Privacy', name: 'myPrivacy', desc: '', args: []);
  }

  /// `Create Text Story`
  String get createTextStory {
    return Intl.message(
      'Create Text Story',
      name: 'createTextStory',
      desc: '',
      args: [],
    );
  }

  /// `Create Media Story`
  String get createMediaStory {
    return Intl.message(
      'Create Media Story',
      name: 'createMediaStory',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get camera {
    return Intl.message('Camera', name: 'camera', desc: '', args: []);
  }

  /// `Gallery`
  String get gallery {
    return Intl.message('Gallery', name: 'gallery', desc: '', args: []);
  }

  /// `Recent update`
  String get recentUpdate {
    return Intl.message(
      'Recent update',
      name: 'recentUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Add new story`
  String get addNewStory {
    return Intl.message(
      'Add new story',
      name: 'addNewStory',
      desc: '',
      args: [],
    );
  }

  /// `Update your profile`
  String get updateYourProfile {
    return Intl.message(
      'Update your profile',
      name: 'updateYourProfile',
      desc: '',
      args: [],
    );
  }

  /// `Configure your account privacy`
  String get configureYourAccountPrivacy {
    return Intl.message(
      'Configure your account privacy',
      name: 'configureYourAccountPrivacy',
      desc: '',
      args: [],
    );
  }

  /// `You in public search`
  String get youInPublicSearch {
    return Intl.message(
      'You in public search',
      name: 'youInPublicSearch',
      desc: '',
      args: [],
    );
  }

  /// `Your profile appears in public search and adding for groups`
  String get yourProfileAppearsInPublicSearchAndAddingForGroups {
    return Intl.message(
      'Your profile appears in public search and adding for groups',
      name: 'yourProfileAppearsInPublicSearchAndAddingForGroups',
      desc: '',
      args: [],
    );
  }

  /// `Your last seen`
  String get yourLastSeen {
    return Intl.message(
      'Your last seen',
      name: 'yourLastSeen',
      desc: '',
      args: [],
    );
  }

  /// `Your last seen in chats`
  String get yourLastSeenInChats {
    return Intl.message(
      'Your last seen in chats',
      name: 'yourLastSeenInChats',
      desc: '',
      args: [],
    );
  }

  /// `Start new chat with you`
  String get startNewChatWithYou {
    return Intl.message(
      'Start new chat with you',
      name: 'startNewChatWithYou',
      desc: '',
      args: [],
    );
  }

  /// `Your story`
  String get yourStory {
    return Intl.message('Your story', name: 'yourStory', desc: '', args: []);
  }

  /// `For request`
  String get forRequest {
    return Intl.message('For request', name: 'forRequest', desc: '', args: []);
  }

  /// `Public`
  String get public {
    return Intl.message('Public', name: 'public', desc: '', args: []);
  }

  /// `Create your story`
  String get createYourStory {
    return Intl.message(
      'Create your story',
      name: 'createYourStory',
      desc: '',
      args: [],
    );
  }

  /// `Share your status`
  String get shareYourStatus {
    return Intl.message(
      'Share your status',
      name: 'shareYourStatus',
      desc: '',
      args: [],
    );
  }

  /// `One seen message`
  String get oneSeenMessage {
    return Intl.message(
      'One seen message',
      name: 'oneSeenMessage',
      desc: '',
      args: [],
    );
  }

  /// `One time seen`
  String get oneTimeSeen {
    return Intl.message(
      'One time seen',
      name: 'oneTimeSeen',
      desc: '',
      args: [],
    );
  }

  /// `Message has been viewed`
  String get messageHasBeenViewed {
    return Intl.message(
      'Message has been viewed',
      name: 'messageHasBeenViewed',
      desc: '',
      args: [],
    );
  }

  /// `Click to see`
  String get clickToSee {
    return Intl.message('Click to see', name: 'clickToSee', desc: '', args: []);
  }

  /// `Images`
  String get images {
    return Intl.message('Images', name: 'images', desc: '', args: []);
  }

  /// `userName`
  String get userName {
    return Intl.message('userName', name: 'userName', desc: '', args: []);
  }

  /// `Contacts has been synced`
  String get contactsHasBeenSynced {
    return Intl.message(
      'Contacts has been synced',
      name: 'contactsHasBeenSynced',
      desc: '',
      args: [],
    );
  }

  /// `Sync contacts`
  String get syncContacts {
    return Intl.message(
      'Sync contacts',
      name: 'syncContacts',
      desc: '',
      args: [],
    );
  }

  /// `enableSearchByUserName`
  String get enableSearchByUserName {
    return Intl.message(
      'enableSearchByUserName',
      name: 'enableSearchByUserName',
      desc: '',
      args: [],
    );
  }

  /// `If you want to see you contacts which use the app then you need to accept the permission of contacts`
  String get acceptContactsPermissionDescription {
    return Intl.message(
      'If you want to see you contacts which use the app then you need to accept the permission of contacts',
      name: 'acceptContactsPermissionDescription',
      desc: '',
      args: [],
    );
  }

  /// `Contact permission denied`
  String get contactPermissionDenied {
    return Intl.message(
      'Contact permission denied',
      name: 'contactPermissionDenied',
      desc: '',
      args: [],
    );
  }

  /// `Search by user name or full user Email`
  String get searchByUserNameOrFullUserEmail {
    return Intl.message(
      'Search by user name or full user Email',
      name: 'searchByUserNameOrFullUserEmail',
      desc: '',
      args: [],
    );
  }

  /// `Search by user full Email`
  String get searchByUserFullEmail {
    return Intl.message(
      'Search by user full Email',
      name: 'searchByUserFullEmail',
      desc: '',
      args: [],
    );
  }

  /// `This option will clear app storage don't worry you can still any time download it if auto download enable the message will auto download`
  String get clearAppStorageDescription {
    return Intl.message(
      'This option will clear app storage don\'t worry you can still any time download it if auto download enable the message will auto download',
      name: 'clearAppStorageDescription',
      desc: '',
      args: [],
    );
  }

  /// `Accept calls from users`
  String get acceptCallsFromUsers {
    return Intl.message(
      'Accept calls from users',
      name: 'acceptCallsFromUsers',
      desc: '',
      args: [],
    );
  }

  /// `Translate`
  String get translate {
    return Intl.message('Translate', name: 'translate', desc: '', args: []);
  }

  /// `Code page`
  String get codePage {
    return Intl.message('Code page', name: 'codePage', desc: '', args: []);
  }

  /// `Message privately with friends and family using on your browser.`
  String get messagePrivatelyWithFriendsAndFamily {
    return Intl.message(
      'Message privately with friends and family using on your browser.',
      name: 'messagePrivatelyWithFriendsAndFamily',
      desc: '',
      args: [],
    );
  }

  /// `1. Open the app on your phone. Tap Settings on Android, or on iPhone. Tap Linked devices and then Link a device. Point your phone at this screen to scan the QR code`
  String get openAppOnYourPhoneInstructions {
    return Intl.message(
      '1. Open the app on your phone. Tap Settings on Android, or on iPhone. Tap Linked devices and then Link a device. Point your phone at this screen to scan the QR code',
      name: 'openAppOnYourPhoneInstructions',
      desc: '',
      args: [],
    );
  }

  /// `Complete Your Profile`
  String get completeYourProfile {
    return Intl.message(
      'Complete Your Profile',
      name: 'completeYourProfile',
      desc: '',
      args: [],
    );
  }

  /// `Please provide your name to continue`
  String get pleaseProvideYourNameToContinue {
    return Intl.message(
      'Please provide your name to continue',
      name: 'pleaseProvideYourNameToContinue',
      desc: '',
      args: [],
    );
  }

  /// `Enter your full name`
  String get enterYourFullName {
    return Intl.message(
      'Enter your full name',
      name: 'enterYourFullName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your name`
  String get pleaseEnterYourName {
    return Intl.message(
      'Please enter your name',
      name: 'pleaseEnterYourName',
      desc: '',
      args: [],
    );
  }

  /// `Enable search by email`
  String get enableSearchByEmail {
    return Intl.message(
      'Enable search by email',
      name: 'enableSearchByEmail',
      desc: '',
      args: [],
    );
  }

  /// `phone number not valid`
  String get phoneNumberNotValid {
    return Intl.message(
      'phone number not valid',
      name: 'phoneNumberNotValid',
      desc: '',
      args: [],
    );
  }

  /// `Enter Verification Code`
  String get enterVerificationCode {
    return Intl.message(
      'Enter Verification Code',
      name: 'enterVerificationCode',
      desc: '',
      args: [],
    );
  }

  /// `We have sent a 6-digit code to {phone}`
  String sentSixDigitCode(Object phone) {
    return Intl.message(
      'We have sent a 6-digit code to $phone',
      name: 'sentSixDigitCode',
      desc: '',
      args: [phone],
    );
  }

  /// `Resend in {seconds} s`
  String resendInSeconds(int seconds) {
    return Intl.message(
      'Resend in $seconds s',
      name: 'resendInSeconds',
      desc: '',
      args: [seconds],
    );
  }

  /// `Verify`
  String get verify {
    return Intl.message('Verify', name: 'verify', desc: '', args: []);
  }

  /// `Please enter verification code`
  String get pleaseEnterVerificationCode {
    return Intl.message(
      'Please enter verification code',
      name: 'pleaseEnterVerificationCode',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid 6-digit code`
  String get pleaseEnterValid6DigitCode {
    return Intl.message(
      'Please enter a valid 6-digit code',
      name: 'pleaseEnterValid6DigitCode',
      desc: '',
      args: [],
    );
  }

  /// `The verification code you entered is invalid. Please check and try again.`
  String get invalidVerificationCode {
    return Intl.message(
      'The verification code you entered is invalid. Please check and try again.',
      name: 'invalidVerificationCode',
      desc: '',
      args: [],
    );
  }

  /// `Your verification session has expired. Please request a new code.`
  String get verificationSessionExpired {
    return Intl.message(
      'Your verification session has expired. Please request a new code.',
      name: 'verificationSessionExpired',
      desc: '',
      args: [],
    );
  }

  /// `Too many attempts. Please try again later.`
  String get tooManyAttempts {
    return Intl.message(
      'Too many attempts. Please try again later.',
      name: 'tooManyAttempts',
      desc: '',
      args: [],
    );
  }

  /// `Network error. Please check your connection and try again.`
  String get networkError {
    return Intl.message(
      'Network error. Please check your connection and try again.',
      name: 'networkError',
      desc: '',
      args: [],
    );
  }

  /// `Verification failed: {message}`
  String verificationFailed(Object message) {
    return Intl.message(
      'Verification failed: $message',
      name: 'verificationFailed',
      desc: '',
      args: [message],
    );
  }

  /// `Verification timed out. Please try again.`
  String get verificationTimedOut {
    return Intl.message(
      'Verification timed out. Please try again.',
      name: 'verificationTimedOut',
      desc: '',
      args: [],
    );
  }

  /// `Enter your phone number`
  String get enterYourPhoneNumber {
    return Intl.message(
      'Enter your phone number',
      name: 'enterYourPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `We will send you a verification code`
  String get weWillSendYouAVerificationCode {
    return Intl.message(
      'We will send you a verification code',
      name: 'weWillSendYouAVerificationCode',
      desc: '',
      args: [],
    );
  }

  /// `Send verification code`
  String get sendVerificationCode {
    return Intl.message(
      'Send verification code',
      name: 'sendVerificationCode',
      desc: '',
      args: [],
    );
  }

  /// `phone number`
  String get phoneNumber {
    return Intl.message(
      'phone number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Voice call`
  String get voiceCall {
    return Intl.message('Voice call', name: 'voiceCall', desc: '', args: []);
  }

  /// `x`
  String get x {
    return Intl.message('x', name: 'x', desc: '', args: []);
  }

  /// `Enter your name`
  String get enterYourName {
    return Intl.message(
      'Enter your name',
      name: 'enterYourName',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email`
  String get enterYourEmail {
    return Intl.message(
      'Enter your email',
      name: 'enterYourEmail',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password`
  String get enterYourPassword {
    return Intl.message(
      'Enter your password',
      name: 'enterYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm your password`
  String get confirmYourPassword {
    return Intl.message(
      'Confirm your password',
      name: 'confirmYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `Name is required`
  String get nameRequired {
    return Intl.message(
      'Name is required',
      name: 'nameRequired',
      desc: '',
      args: [],
    );
  }

  /// `Email is required`
  String get emailRequired {
    return Intl.message(
      'Email is required',
      name: 'emailRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email`
  String get invalidEmail {
    return Intl.message(
      'Please enter a valid email',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Password is required`
  String get passwordRequired {
    return Intl.message(
      'Password is required',
      name: 'passwordRequired',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 8 characters`
  String get passwordTooShort {
    return Intl.message(
      'Password must be at least 8 characters',
      name: 'passwordTooShort',
      desc: '',
      args: [],
    );
  }

  /// `Please confirm your password`
  String get confirmPasswordRequired {
    return Intl.message(
      'Please confirm your password',
      name: 'confirmPasswordRequired',
      desc: '',
      args: [],
    );
  }

  /// `Passwords don't match`
  String get passwordsDontMatch {
    return Intl.message(
      'Passwords don\'t match',
      name: 'passwordsDontMatch',
      desc: '',
      args: [],
    );
  }

  /// `Registration successful!`
  String get registrationSuccessful {
    return Intl.message(
      'Registration successful!',
      name: 'registrationSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Login successful!`
  String get loginSuccessful {
    return Intl.message(
      'Login successful!',
      name: 'loginSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot Password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Navigating to forgot password page`
  String get forgotPasswordNavigating {
    return Intl.message(
      'Navigating to forgot password page',
      name: 'forgotPasswordNavigating',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get dontHaveAnAccount {
    return Intl.message(
      'Don\'t have an account?',
      name: 'dontHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Enter the verification code sent to your email and create a new password`
  String get enterTheCodeAndNewPassword {
    return Intl.message(
      'Enter the verification code sent to your email and create a new password',
      name: 'enterTheCodeAndNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter new password`
  String get enterNewPassword {
    return Intl.message(
      'Enter new password',
      name: 'enterNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Re-enter new password`
  String get reenterNewPassword {
    return Intl.message(
      'Re-enter new password',
      name: 'reenterNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid 6-digit code`
  String get pleaseEnterValidCode {
    return Intl.message(
      'Please enter a valid 6-digit code',
      name: 'pleaseEnterValidCode',
      desc: '',
      args: [],
    );
  }

  /// `Didn't receive the code?`
  String get didntReceiveCode {
    return Intl.message(
      'Didn\'t receive the code?',
      name: 'didntReceiveCode',
      desc: '',
      args: [],
    );
  }

  /// `Resend`
  String get resend {
    return Intl.message('Resend', name: 'resend', desc: '', args: []);
  }

  /// `Code has been sent again to your email`
  String get codeSentAgain {
    return Intl.message(
      'Code has been sent again to your email',
      name: 'codeSentAgain',
      desc: '',
      args: [],
    );
  }

  /// `Click to join`
  String get clickToJoin {
    return Intl.message(
      'Click to join',
      name: 'clickToJoin',
      desc: '',
      args: [],
    );
  }

  /// `Store Urls`
  String get storeUrls {
    return Intl.message('Store Urls', name: 'storeUrls', desc: '', args: []);
  }

  /// `Clear all cache`
  String get clearAllCache {
    return Intl.message(
      'Clear all cache',
      name: 'clearAllCache',
      desc: '',
      args: [],
    );
  }

  /// `This option will clear app storage don't worry you can still any time download it if auto download enable the message will auto download`
  String get clickThisOptionWillClearAppStorage {
    return Intl.message(
      'This option will clear app storage don\'t worry you can still any time download it if auto download enable the message will auto download',
      name: 'clickThisOptionWillClearAppStorage',
      desc: '',
      args: [],
    );
  }

  /// `Delete app cache ?`
  String get deleteAppCache {
    return Intl.message(
      'Delete app cache ?',
      name: 'deleteAppCache',
      desc: '',
      args: [],
    );
  }

  /// `User Register Status`
  String get userRegisterStatus {
    return Intl.message(
      'User Register Status',
      name: 'userRegisterStatus',
      desc: '',
      args: [],
    );
  }

  /// `Is prime`
  String get isPrime {
    return Intl.message('Is prime', name: 'isPrime', desc: '', args: []);
  }

  /// `Video Compression`
  String get videoCompression {
    return Intl.message(
      'Video Compression',
      name: 'videoCompression',
      desc: '',
      args: [],
    );
  }

  /// `Choose quality for your video`
  String get chooseQualityForYourVideo {
    return Intl.message(
      'Choose quality for your video',
      name: 'chooseQualityForYourVideo',
      desc: '',
      args: [],
    );
  }

  /// `Ultra Low Quality`
  String get ultraLowQuality {
    return Intl.message(
      'Ultra Low Quality',
      name: 'ultraLowQuality',
      desc: '',
      args: [],
    );
  }

  /// `Very Low Quality`
  String get veryLowQuality {
    return Intl.message(
      'Very Low Quality',
      name: 'veryLowQuality',
      desc: '',
      args: [],
    );
  }

  /// `Low Quality`
  String get lowQuality {
    return Intl.message('Low Quality', name: 'lowQuality', desc: '', args: []);
  }

  /// `Medium Quality`
  String get mediumQuality {
    return Intl.message(
      'Medium Quality',
      name: 'mediumQuality',
      desc: '',
      args: [],
    );
  }

  /// `High Quality`
  String get highQuality {
    return Intl.message(
      'High Quality',
      name: 'highQuality',
      desc: '',
      args: [],
    );
  }

  /// `Smallest file size, faster upload`
  String get smallestFileSizeFasterUpload {
    return Intl.message(
      'Smallest file size, faster upload',
      name: 'smallestFileSizeFasterUpload',
      desc: '',
      args: [],
    );
  }

  /// `Very small file size`
  String get verySmallFileSize {
    return Intl.message(
      'Very small file size',
      name: 'verySmallFileSize',
      desc: '',
      args: [],
    );
  }

  /// `Small file size, faster upload`
  String get smallFileSizeFasterUploadLow {
    return Intl.message(
      'Small file size, faster upload',
      name: 'smallFileSizeFasterUploadLow',
      desc: '',
      args: [],
    );
  }

  /// `Balanced quality and file size`
  String get balancedQualityAndFileSize {
    return Intl.message(
      'Balanced quality and file size',
      name: 'balancedQualityAndFileSize',
      desc: '',
      args: [],
    );
  }

  /// `Better quality, larger file size`
  String get betterQualityLargerFileSize {
    return Intl.message(
      'Better quality, larger file size',
      name: 'betterQualityLargerFileSize',
      desc: '',
      args: [],
    );
  }

  /// `Skip Compression`
  String get skipCompression {
    return Intl.message(
      'Skip Compression',
      name: 'skipCompression',
      desc: '',
      args: [],
    );
  }

  /// `Send original video without compression`
  String get sendOriginalVideoWithoutCompression {
    return Intl.message(
      'Send original video without compression',
      name: 'sendOriginalVideoWithoutCompression',
      desc: '',
      args: [],
    );
  }

  /// `Apply`
  String get apply {
    return Intl.message('Apply', name: 'apply', desc: '', args: []);
  }

  /// `Compressing Video`
  String get compressingVideo {
    return Intl.message(
      'Compressing Video',
      name: 'compressingVideo',
      desc: '',
      args: [],
    );
  }

  /// `Analyzing video and preparing compression...`
  String get analyzingVideoAndPreparingCompression {
    return Intl.message(
      'Analyzing video and preparing compression...',
      name: 'analyzingVideoAndPreparingCompression',
      desc: '',
      args: [],
    );
  }

  /// `Compressing video, this may take a few moments...`
  String get compressingVideoThisMayTakeAFewMoments {
    return Intl.message(
      'Compressing video, this may take a few moments...',
      name: 'compressingVideoThisMayTakeAFewMoments',
      desc: '',
      args: [],
    );
  }

  /// `Processing video data and optimizing quality...`
  String get processingVideoDataAndOptimizingQuality {
    return Intl.message(
      'Processing video data and optimizing quality...',
      name: 'processingVideoDataAndOptimizingQuality',
      desc: '',
      args: [],
    );
  }

  /// `Finalizing compression and saving file...`
  String get finalizingCompressionAndSavingFile {
    return Intl.message(
      'Finalizing compression and saving file...',
      name: 'finalizingCompressionAndSavingFile',
      desc: '',
      args: [],
    );
  }

  /// `Almost done, just a few more seconds...`
  String get almostDoneJustAFewMoreSeconds {
    return Intl.message(
      'Almost done, just a few more seconds...',
      name: 'almostDoneJustAFewMoreSeconds',
      desc: '',
      args: [],
    );
  }

  /// `Calculating...`
  String get calculating {
    return Intl.message(
      'Calculating...',
      name: 'calculating',
      desc: '',
      args: [],
    );
  }

  /// `Finishing...`
  String get finishing {
    return Intl.message('Finishing...', name: 'finishing', desc: '', args: []);
  }

  /// `Estimating...`
  String get estimating {
    return Intl.message(
      'Estimating...',
      name: 'estimating',
      desc: '',
      args: [],
    );
  }

  /// `remaining`
  String get remaining {
    return Intl.message('remaining', name: 'remaining', desc: '', args: []);
  }

  /// `left`
  String get left {
    return Intl.message('left', name: 'left', desc: '', args: []);
  }

  /// `Cancel Compression`
  String get cancelCompression {
    return Intl.message(
      'Cancel Compression',
      name: 'cancelCompression',
      desc: '',
      args: [],
    );
  }

  /// `Compression Settings`
  String get compressionSettings {
    return Intl.message(
      'Compression Settings',
      name: 'compressionSettings',
      desc: '',
      args: [],
    );
  }

  /// `Delete Video`
  String get deleteVideo {
    return Intl.message(
      'Delete Video',
      name: 'deleteVideo',
      desc: '',
      args: [],
    );
  }

  /// `Compression quality set to {quality}. Video will be compressed when you submit.`
  String compressionQualitySetTo(String quality) {
    return Intl.message(
      'Compression quality set to $quality. Video will be compressed when you submit.',
      name: 'compressionQualitySetTo',
      desc: '',
      args: [quality],
    );
  }

  /// `Error processing media: {error}`
  String errorProcessingMedia(String error) {
    return Intl.message(
      'Error processing media: $error',
      name: 'errorProcessingMedia',
      desc: '',
      args: [error],
    );
  }

  /// `Video compression failed for {fileName}: {error}`
  String videoCompressionFailed(String fileName, String error) {
    return Intl.message(
      'Video compression failed for $fileName: $error',
      name: 'videoCompressionFailed',
      desc: '',
      args: [fileName, error],
    );
  }

  /// `Connection Quality`
  String get connectionQuality {
    return Intl.message(
      'Connection Quality',
      name: 'connectionQuality',
      desc: '',
      args: [],
    );
  }

  /// `Excellent`
  String get excellent {
    return Intl.message('Excellent', name: 'excellent', desc: '', args: []);
  }

  /// `Good`
  String get good {
    return Intl.message('Good', name: 'good', desc: '', args: []);
  }

  /// `Poor`
  String get poor {
    return Intl.message('Poor', name: 'poor', desc: '', args: []);
  }

  /// `Bad`
  String get bad {
    return Intl.message('Bad', name: 'bad', desc: '', args: []);
  }

  /// `Very Bad`
  String get veryBad {
    return Intl.message('Very Bad', name: 'veryBad', desc: '', args: []);
  }

  /// `Disconnected`
  String get disconnected {
    return Intl.message(
      'Disconnected',
      name: 'disconnected',
      desc: '',
      args: [],
    );
  }

  /// `Unknown`
  String get unknown {
    return Intl.message('Unknown', name: 'unknown', desc: '', args: []);
  }

  /// `Camera Off`
  String get cameraOff {
    return Intl.message('Camera Off', name: 'cameraOff', desc: '', args: []);
  }

  /// `Camera On`
  String get cameraOn {
    return Intl.message('Camera On', name: 'cameraOn', desc: '', args: []);
  }

  /// `Microphone Off`
  String get microphoneOff {
    return Intl.message(
      'Microphone Off',
      name: 'microphoneOff',
      desc: '',
      args: [],
    );
  }

  /// `Microphone On`
  String get microphoneOn {
    return Intl.message(
      'Microphone On',
      name: 'microphoneOn',
      desc: '',
      args: [],
    );
  }

  /// `Speaker Off`
  String get speakerOff {
    return Intl.message('Speaker Off', name: 'speakerOff', desc: '', args: []);
  }

  /// `Speaker On`
  String get speakerOn {
    return Intl.message('Speaker On', name: 'speakerOn', desc: '', args: []);
  }

  /// `Switch Camera`
  String get switchCamera {
    return Intl.message(
      'Switch Camera',
      name: 'switchCamera',
      desc: '',
      args: [],
    );
  }

  /// `End Call`
  String get endCall {
    return Intl.message('End Call', name: 'endCall', desc: '', args: []);
  }

  /// `Call Duration`
  String get callDuration {
    return Intl.message(
      'Call Duration',
      name: 'callDuration',
      desc: '',
      args: [],
    );
  }

  /// `Reconnecting...`
  String get reconnecting {
    return Intl.message(
      'Reconnecting...',
      name: 'reconnecting',
      desc: '',
      args: [],
    );
  }

  /// `Call Failed`
  String get callFailed {
    return Intl.message('Call Failed', name: 'callFailed', desc: '', args: []);
  }

  /// `Call Ended`
  String get callEnded {
    return Intl.message('Call Ended', name: 'callEnded', desc: '', args: []);
  }

  /// `Network connection is poor`
  String get networkPoor {
    return Intl.message(
      'Network connection is poor',
      name: 'networkPoor',
      desc: '',
      args: [],
    );
  }

  /// `Join Call`
  String get joinCall {
    return Intl.message('Join Call', name: 'joinCall', desc: '', args: []);
  }

  /// `Leave Call`
  String get leaveCall {
    return Intl.message('Leave Call', name: 'leaveCall', desc: '', args: []);
  }

  /// `Tap to swap video positions`
  String get tapToSwapVideo {
    return Intl.message(
      'Tap to swap video positions',
      name: 'tapToSwapVideo',
      desc: '',
      args: [],
    );
  }

  /// `User joined the call`
  String get userJoined {
    return Intl.message(
      'User joined the call',
      name: 'userJoined',
      desc: '',
      args: [],
    );
  }

  /// `User left the call`
  String get userLeft {
    return Intl.message(
      'User left the call',
      name: 'userLeft',
      desc: '',
      args: [],
    );
  }

  /// `Audio Only Mode`
  String get audioOnlyMode {
    return Intl.message(
      'Audio Only Mode',
      name: 'audioOnlyMode',
      desc: '',
      args: [],
    );
  }

  /// `Video Call Mode`
  String get videoCallMode {
    return Intl.message(
      'Video Call Mode',
      name: 'videoCallMode',
      desc: '',
      args: [],
    );
  }

  /// `Call Quality`
  String get callQuality {
    return Intl.message(
      'Call Quality',
      name: 'callQuality',
      desc: '',
      args: [],
    );
  }

  /// `{count} participants`
  String participantCount(int count) {
    return Intl.message(
      '$count participants',
      name: 'participantCount',
      desc: '',
      args: [count],
    );
  }

  /// `Choose compression quality for your video:`
  String get chooseCompressionQualityForYourVideo {
    return Intl.message(
      'Choose compression quality for your video:',
      name: 'chooseCompressionQualityForYourVideo',
      desc: '',
      args: [],
    );
  }

  /// `Original`
  String get originalFileSize {
    return Intl.message(
      'Original',
      name: 'originalFileSize',
      desc: '',
      args: [],
    );
  }

  /// `Estimated`
  String get estimatedFileSize {
    return Intl.message(
      'Estimated',
      name: 'estimatedFileSize',
      desc: '',
      args: [],
    );
  }

  /// `The file must be a video file`
  String get fileMustBeVideo {
    return Intl.message(
      'The file must be a video file',
      name: 'fileMustBeVideo',
      desc: '',
      args: [],
    );
  }

  /// `The file must be an image file`
  String get fileMustBeImage {
    return Intl.message(
      'The file must be an image file',
      name: 'fileMustBeImage',
      desc: '',
      args: [],
    );
  }

  /// `App storage size is`
  String get appStorageSizeIs {
    return Intl.message(
      'App storage size is',
      name: 'appStorageSizeIs',
      desc: '',
      args: [],
    );
  }

  /// `Activity`
  String get activity {
    return Intl.message('Activity', name: 'activity', desc: '', args: []);
  }

  /// `Server restart`
  String get serverRestart {
    return Intl.message(
      'Server restart',
      name: 'serverRestart',
      desc: '',
      args: [],
    );
  }

  /// `Admin Dashboard`
  String get adminDashboard {
    return Intl.message(
      'Admin Dashboard',
      name: 'adminDashboard',
      desc: '',
      args: [],
    );
  }

  /// `Secure Admin Access`
  String get secureAdminAccess {
    return Intl.message(
      'Secure Admin Access',
      name: 'secureAdminAccess',
      desc: '',
      args: [],
    );
  }

  /// `User Analytics`
  String get userAnalytics {
    return Intl.message(
      'User Analytics',
      name: 'userAnalytics',
      desc: '',
      args: [],
    );
  }

  /// `System Configuration`
  String get systemConfiguration {
    return Intl.message(
      'System Configuration',
      name: 'systemConfiguration',
      desc: '',
      args: [],
    );
  }

  /// `Welcome back`
  String get welcomeBack {
    return Intl.message(
      'Welcome back',
      name: 'welcomeBack',
      desc: '',
      args: [],
    );
  }

  /// `Enter your credentials to access dashboard`
  String get enterCredentialsToAccessDashboard {
    return Intl.message(
      'Enter your credentials to access dashboard',
      name: 'enterCredentialsToAccessDashboard',
      desc: '',
      args: [],
    );
  }

  /// `Enter your admin password`
  String get enterAdminPassword {
    return Intl.message(
      'Enter your admin password',
      name: 'enterAdminPassword',
      desc: '',
      args: [],
    );
  }

  /// `Need help?`
  String get needHelp {
    return Intl.message('Need help?', name: 'needHelp', desc: '', args: []);
  }

  /// `Apple iOS`
  String get appleIos {
    return Intl.message('Apple iOS', name: 'appleIos', desc: '', args: []);
  }

  /// `Google Android`
  String get googleAndroid {
    return Intl.message(
      'Google Android',
      name: 'googleAndroid',
      desc: '',
      args: [],
    );
  }

  /// `Microsoft Windows`
  String get microsoftWindows {
    return Intl.message(
      'Microsoft Windows',
      name: 'microsoftWindows',
      desc: '',
      args: [],
    );
  }

  /// `Apple Mac Store URL`
  String get appleMacStoreUrl {
    return Intl.message(
      'Apple Mac Store URL',
      name: 'appleMacStoreUrl',
      desc: '',
      args: [],
    );
  }

  /// `Web Chat`
  String get webChat {
    return Intl.message('Web Chat', name: 'webChat', desc: '', args: []);
  }

  /// `ID`
  String get id {
    return Intl.message('ID', name: 'id', desc: '', args: []);
  }

  /// `English`
  String get english {
    return Intl.message('English', name: 'english', desc: '', args: []);
  }

  /// `No data`
  String get noData {
    return Intl.message('No data', name: 'noData', desc: '', args: []);
  }

  /// `Video Trimmer`
  String get videoTrimmer {
    return Intl.message(
      'Video Trimmer',
      name: 'videoTrimmer',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Saving...`
  String get saving {
    return Intl.message('Saving...', name: 'saving', desc: '', args: []);
  }

  /// `Delete Image`
  String get deleteImage {
    return Intl.message(
      'Delete Image',
      name: 'deleteImage',
      desc: '',
      args: [],
    );
  }

  /// `Crop Image`
  String get cropImage {
    return Intl.message('Crop Image', name: 'cropImage', desc: '', args: []);
  }

  /// `Crop not available on web`
  String get cropNotAvailableOnWeb {
    return Intl.message(
      'Crop not available on web',
      name: 'cropNotAvailableOnWeb',
      desc: '',
      args: [],
    );
  }

  /// `Edit Image`
  String get editImage {
    return Intl.message('Edit Image', name: 'editImage', desc: '', args: []);
  }

  /// `Edit Video`
  String get editVideo {
    return Intl.message('Edit Video', name: 'editVideo', desc: '', args: []);
  }

  /// `Reset Trim`
  String get resetTrim {
    return Intl.message('Reset Trim', name: 'resetTrim', desc: '', args: []);
  }

  /// `Original`
  String get original {
    return Intl.message('Original', name: 'original', desc: '', args: []);
  }

  /// `Trimmed`
  String get trimmed {
    return Intl.message('Trimmed', name: 'trimmed', desc: '', args: []);
  }

  /// `Failed to save trimmed video`
  String get failedToSaveTrimmedVideo {
    return Intl.message(
      'Failed to save trimmed video',
      name: 'failedToSaveTrimmedVideo',
      desc: '',
      args: [],
    );
  }

  /// `Loading video...`
  String get loadingVideo {
    return Intl.message(
      'Loading video...',
      name: 'loadingVideo',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load video`
  String get failedToLoadVideo {
    return Intl.message(
      'Failed to load video',
      name: 'failedToLoadVideo',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message('Confirm', name: 'confirm', desc: '', args: []);
  }

  /// `GIF`
  String get gifIndicator {
    return Intl.message('GIF', name: 'gifIndicator', desc: '', args: []);
  }

  /// `Load failed`
  String get loadFailed {
    return Intl.message('Load failed', name: 'loadFailed', desc: '', args: []);
  }

  /// `Preview`
  String get preview {
    return Intl.message('Preview', name: 'preview', desc: '', args: []);
  }

  /// `Select`
  String get select {
    return Intl.message('Select', name: 'select', desc: '', args: []);
  }

  /// `No media found`
  String get emptyList {
    return Intl.message(
      'No media found',
      name: 'emptyList',
      desc: '',
      args: [],
    );
  }

  /// `Unsupported file type`
  String get unSupportedAssetType {
    return Intl.message(
      'Unsupported file type',
      name: 'unSupportedAssetType',
      desc: '',
      args: [],
    );
  }

  /// `Unable to access all photos`
  String get unableToAccessAll {
    return Intl.message(
      'Unable to access all photos',
      name: 'unableToAccessAll',
      desc: '',
      args: [],
    );
  }

  /// `Only showing photos and videos accessible to the app.`
  String get viewingLimitedAssetsTip {
    return Intl.message(
      'Only showing photos and videos accessible to the app.',
      name: 'viewingLimitedAssetsTip',
      desc: '',
      args: [],
    );
  }

  /// `Change accessible limited assets`
  String get changeAccessibleLimitedAssets {
    return Intl.message(
      'Change accessible limited assets',
      name: 'changeAccessibleLimitedAssets',
      desc: '',
      args: [],
    );
  }

  /// `App can only access limited assets on the device. Go to system settings and allow the app to access all photos on the device.`
  String get accessAllTip {
    return Intl.message(
      'App can only access limited assets on the device. Go to system settings and allow the app to access all photos on the device.',
      name: 'accessAllTip',
      desc: '',
      args: [],
    );
  }

  /// `Go to system settings`
  String get goToSystemSettings {
    return Intl.message(
      'Go to system settings',
      name: 'goToSystemSettings',
      desc: '',
      args: [],
    );
  }

  /// `Continue with limited access`
  String get accessLimitedAssets {
    return Intl.message(
      'Continue with limited access',
      name: 'accessLimitedAssets',
      desc: '',
      args: [],
    );
  }

  /// `Accessible assets`
  String get accessiblePathName {
    return Intl.message(
      'Accessible assets',
      name: 'accessiblePathName',
      desc: '',
      args: [],
    );
  }

  /// `Audio`
  String get sTypeAudioLabel {
    return Intl.message('Audio', name: 'sTypeAudioLabel', desc: '', args: []);
  }

  /// `Image`
  String get sTypeImageLabel {
    return Intl.message('Image', name: 'sTypeImageLabel', desc: '', args: []);
  }

  /// `Video`
  String get sTypeVideoLabel {
    return Intl.message('Video', name: 'sTypeVideoLabel', desc: '', args: []);
  }

  /// `Other`
  String get sTypeOtherLabel {
    return Intl.message('Other', name: 'sTypeOtherLabel', desc: '', args: []);
  }

  /// `Play`
  String get sActionPlayHint {
    return Intl.message('Play', name: 'sActionPlayHint', desc: '', args: []);
  }

  /// `Preview`
  String get sActionPreviewHint {
    return Intl.message(
      'Preview',
      name: 'sActionPreviewHint',
      desc: '',
      args: [],
    );
  }

  /// `Select`
  String get sActionSelectHint {
    return Intl.message(
      'Select',
      name: 'sActionSelectHint',
      desc: '',
      args: [],
    );
  }

  /// `Switch path`
  String get sActionSwitchPathLabel {
    return Intl.message(
      'Switch path',
      name: 'sActionSwitchPathLabel',
      desc: '',
      args: [],
    );
  }

  /// `Use camera`
  String get sActionUseCameraHint {
    return Intl.message(
      'Use camera',
      name: 'sActionUseCameraHint',
      desc: '',
      args: [],
    );
  }

  /// `Duration`
  String get sNameDurationLabel {
    return Intl.message(
      'Duration',
      name: 'sNameDurationLabel',
      desc: '',
      args: [],
    );
  }

  /// `Count`
  String get sUnitAssetCountLabel {
    return Intl.message(
      'Count',
      name: 'sUnitAssetCountLabel',
      desc: '',
      args: [],
    );
  }

  /// `Select media`
  String get selectMedia {
    return Intl.message(
      'Select media',
      name: 'selectMedia',
      desc: '',
      args: [],
    );
  }

  /// `Select photos`
  String get selectPhotos {
    return Intl.message(
      'Select photos',
      name: 'selectPhotos',
      desc: '',
      args: [],
    );
  }

  /// `Select videos`
  String get selectVideos {
    return Intl.message(
      'Select videos',
      name: 'selectVideos',
      desc: '',
      args: [],
    );
  }

  /// `Recent`
  String get recent {
    return Intl.message('Recent', name: 'recent', desc: '', args: []);
  }

  /// `All Photos`
  String get allPhotos {
    return Intl.message('All Photos', name: 'allPhotos', desc: '', args: []);
  }

  /// `All Videos`
  String get allVideos {
    return Intl.message('All Videos', name: 'allVideos', desc: '', args: []);
  }

  /// `No media found`
  String get noMediaFound {
    return Intl.message(
      'No media found',
      name: 'noMediaFound',
      desc: '',
      args: [],
    );
  }

  /// `Permission denied`
  String get permissionDenied {
    return Intl.message(
      'Permission denied',
      name: 'permissionDenied',
      desc: '',
      args: [],
    );
  }

  /// `Please grant camera permission`
  String get pleaseGrantCameraPermission {
    return Intl.message(
      'Please grant camera permission',
      name: 'pleaseGrantCameraPermission',
      desc: '',
      args: [],
    );
  }

  /// `Please grant storage permission`
  String get pleaseGrantStoragePermission {
    return Intl.message(
      'Please grant storage permission',
      name: 'pleaseGrantStoragePermission',
      desc: '',
      args: [],
    );
  }

  /// `Error loading image`
  String get errorLoadingImage {
    return Intl.message(
      'Error loading image',
      name: 'errorLoadingImage',
      desc: '',
      args: [],
    );
  }

  /// `Download image`
  String get downloadImage {
    return Intl.message(
      'Download image',
      name: 'downloadImage',
      desc: '',
      args: [],
    );
  }

  /// `Share image`
  String get shareImage {
    return Intl.message('Share image', name: 'shareImage', desc: '', args: []);
  }

  /// `Image info`
  String get imageInfo {
    return Intl.message('Image info', name: 'imageInfo', desc: '', args: []);
  }

  /// `Error downloading image`
  String get errorDownloadingImage {
    return Intl.message(
      'Error downloading image',
      name: 'errorDownloadingImage',
      desc: '',
      args: [],
    );
  }

  /// `Error sharing image`
  String get errorSharingImage {
    return Intl.message(
      'Error sharing image',
      name: 'errorSharingImage',
      desc: '',
      args: [],
    );
  }

  /// `File name`
  String get fileName {
    return Intl.message('File name', name: 'fileName', desc: '', args: []);
  }

  /// `File size`
  String get fileSize {
    return Intl.message('File size', name: 'fileSize', desc: '', args: []);
  }

  /// `File type`
  String get fileType {
    return Intl.message('File type', name: 'fileType', desc: '', args: []);
  }

  /// `Story Viewers`
  String get storyViewers {
    return Intl.message(
      'Story Viewers',
      name: 'storyViewers',
      desc: '',
      args: [],
    );
  }

  /// `No viewers yet`
  String get noViewersYet {
    return Intl.message(
      'No viewers yet',
      name: 'noViewersYet',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get locationFallback {
    return Intl.message(
      'Location',
      name: 'locationFallback',
      desc: '',
      args: [],
    );
  }

  /// `GPS`
  String get gpsLabel {
    return Intl.message('GPS', name: 'gpsLabel', desc: '', args: []);
  }

  /// `Tap to open in Maps`
  String get tapToOpenInMaps {
    return Intl.message(
      'Tap to open in Maps',
      name: 'tapToOpenInMaps',
      desc: '',
      args: [],
    );
  }

  /// `Selected Location`
  String get selectedLocation {
    return Intl.message(
      'Selected Location',
      name: 'selectedLocation',
      desc: '',
      args: [],
    );
  }

  /// `Analyzing video and preparing compression...`
  String get analyzingVideo {
    return Intl.message(
      'Analyzing video and preparing compression...',
      name: 'analyzingVideo',
      desc: '',
      args: [],
    );
  }

  /// `Compressing video, please wait...`
  String get compressingVideoWait {
    return Intl.message(
      'Compressing video, please wait...',
      name: 'compressingVideoWait',
      desc: '',
      args: [],
    );
  }

  /// `Finalizing compression...`
  String get finalizingCompression {
    return Intl.message(
      'Finalizing compression...',
      name: 'finalizingCompression',
      desc: '',
      args: [],
    );
  }

  /// `Almost done...`
  String get almostDone {
    return Intl.message(
      'Almost done...',
      name: 'almostDone',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load viewers`
  String get failedToLoadViewers {
    return Intl.message(
      'Failed to load viewers',
      name: 'failedToLoadViewers',
      desc: '',
      args: [],
    );
  }

  /// `Loading viewers...`
  String get loadingViewers {
    return Intl.message(
      'Loading viewers...',
      name: 'loadingViewers',
      desc: '',
      args: [],
    );
  }

  /// `Change Language`
  String get changeLanguage {
    return Intl.message(
      'Change Language',
      name: 'changeLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Toggle Theme`
  String get toggleTheme {
    return Intl.message(
      'Toggle Theme',
      name: 'toggleTheme',
      desc: '',
      args: [],
    );
  }

  /// `No custom settings`
  String get noCustomSettings {
    return Intl.message(
      'No custom settings',
      name: 'noCustomSettings',
      desc: '',
      args: [],
    );
  }

  /// `View All`
  String get viewAll {
    return Intl.message('View All', name: 'viewAll', desc: '', args: []);
  }

  /// `Custom`
  String get custom {
    return Intl.message('Custom', name: 'custom', desc: '', args: []);
  }

  /// `Search users...`
  String get searchUsers {
    return Intl.message(
      'Search users...',
      name: 'searchUsers',
      desc: '',
      args: [],
    );
  }

  /// `Searching...`
  String get searching {
    return Intl.message('Searching...', name: 'searching', desc: '', args: []);
  }

  /// `No users found`
  String get noUsersFound {
    return Intl.message(
      'No users found',
      name: 'noUsersFound',
      desc: '',
      args: [],
    );
  }

  /// `No users`
  String get noUsers {
    return Intl.message('No users', name: 'noUsers', desc: '', args: []);
  }

  /// `Try a different search term`
  String get tryDifferentSearch {
    return Intl.message(
      'Try a different search term',
      name: 'tryDifferentSearch',
      desc: '',
      args: [],
    );
  }

  /// `Users will appear here when available`
  String get usersWillAppearHere {
    return Intl.message(
      'Users will appear here when available',
      name: 'usersWillAppearHere',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'bn'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'hi'),
      Locale.fromSubtags(languageCode: 'id'),
      Locale.fromSubtags(languageCode: 'ja'),
      Locale.fromSubtags(languageCode: 'ko'),
      Locale.fromSubtags(languageCode: 'ml'),
      Locale.fromSubtags(languageCode: 'pt'),
      Locale.fromSubtags(languageCode: 'ru'),
      Locale.fromSubtags(languageCode: 'tr'),
      Locale.fromSubtags(languageCode: 'vi'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
