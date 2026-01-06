// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ja locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ja';

  static String m0(quality) => "圧縮品質を${quality}に設定しました。送信時に動画が圧縮されます。";

  static String m1(error) => "メディア処理エラー：${error}";

  static String m2(count) => "${count}参加者";

  static String m3(seconds) => "${seconds}秒後に再送信";

  static String m4(phone) => "${phone}に6桁のコードを送信しました";

  static String m5(message) => "認証に失敗しました：${message}";

  static String m6(fileName, error) => "${fileName}の動画圧縮に失敗しました：${error}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("情報"),
    "aboutToBlockUserWithConsequences": MessageLookupByLibrary.simpleMessage(
      "このユーザーをブロックしようとしています。彼にチャットを送信したり、グループまたはブロードキャストに追加したりすることはできません！",
    ),
    "acceptCallsFromUsers": MessageLookupByLibrary.simpleMessage(
      "ユーザーからの通話を受け入れる",
    ),
    "acceptContactsPermissionDescription": MessageLookupByLibrary.simpleMessage(
      "アプリを使用している連絡先を確認するには、連絡先の許可を承認する必要があります",
    ),
    "accepted": MessageLookupByLibrary.simpleMessage("承認済み"),
    "accessAllTip": MessageLookupByLibrary.simpleMessage(
      "アプリはデバイス上の制限されたアセットにのみアクセスできます。システム設定に移動し、アプリがデバイス上のすべての写真にアクセスできるようにしてください。",
    ),
    "accessLimitedAssets": MessageLookupByLibrary.simpleMessage("制限されたアクセスで続行"),
    "accessiblePathName": MessageLookupByLibrary.simpleMessage("アクセス可能なアセット"),
    "account": MessageLookupByLibrary.simpleMessage("アカウント"),
    "actions": MessageLookupByLibrary.simpleMessage("アクション"),
    "activity": MessageLookupByLibrary.simpleMessage("アクティビティ"),
    "addMembers": MessageLookupByLibrary.simpleMessage("メンバーを追加"),
    "addNewStory": MessageLookupByLibrary.simpleMessage("新しいストーリーを追加"),
    "addParticipants": MessageLookupByLibrary.simpleMessage("参加者を追加"),
    "addedYouToNewBroadcast": MessageLookupByLibrary.simpleMessage(
      "新しいブロードキャストに追加されました",
    ),
    "admin": MessageLookupByLibrary.simpleMessage("管理者"),
    "adminDashboard": MessageLookupByLibrary.simpleMessage("管理者ダッシュボード"),
    "adminNotification": MessageLookupByLibrary.simpleMessage("管理者通知"),
    "allDataHasBeenBackupYouDontNeedToManageSaveTheDataByYourself":
        MessageLookupByLibrary.simpleMessage(
          "すべてのデータはバックアップされ、データの管理は必要ありません。ログアウトして再ログインすると、ウェブバージョンと同じチャットが表示されます",
        ),
    "allDeletedMessages": MessageLookupByLibrary.simpleMessage("すべての削除済みメッセージ"),
    "allPhotos": MessageLookupByLibrary.simpleMessage("すべての写真"),
    "allVideos": MessageLookupByLibrary.simpleMessage("すべての動画"),
    "allowAds": MessageLookupByLibrary.simpleMessage("広告を許可"),
    "allowCalls": MessageLookupByLibrary.simpleMessage("通話を許可"),
    "allowCreateBroadcast": MessageLookupByLibrary.simpleMessage(
      "ブロードキャストの作成を許可",
    ),
    "allowCreateGroups": MessageLookupByLibrary.simpleMessage("グループの作成を許可"),
    "allowDesktopLogin": MessageLookupByLibrary.simpleMessage("デスクトップログインを許可"),
    "allowMobileLogin": MessageLookupByLibrary.simpleMessage("モバイルログインを許可"),
    "allowSendMedia": MessageLookupByLibrary.simpleMessage("メディアの送信を許可"),
    "allowWebLogin": MessageLookupByLibrary.simpleMessage("Webログインを許可"),
    "almostDone": MessageLookupByLibrary.simpleMessage("ほぼ完了..."),
    "almostDoneJustAFewMoreSeconds": MessageLookupByLibrary.simpleMessage(
      "もうすぐ完了です。あと数秒お待ちください...",
    ),
    "alreadyHaveAnAccount": MessageLookupByLibrary.simpleMessage(
      "既にアカウントをお持ちですか？",
    ),
    "analyzingVideo": MessageLookupByLibrary.simpleMessage("動画を分析して圧縮を準備中..."),
    "analyzingVideoAndPreparingCompression":
        MessageLookupByLibrary.simpleMessage("動画を分析し、圧縮を準備中..."),
    "android": MessageLookupByLibrary.simpleMessage("Android"),
    "appMembers": MessageLookupByLibrary.simpleMessage("アプリのメンバー"),
    "appStorageSizeIs": MessageLookupByLibrary.simpleMessage("アプリのストレージサイズは"),
    "appleIos": MessageLookupByLibrary.simpleMessage("Apple iOS"),
    "appleMacStoreUrl": MessageLookupByLibrary.simpleMessage(
      "Apple Mac Store URL",
    ),
    "appleStoreAppUrl": MessageLookupByLibrary.simpleMessage(
      "Apple StoreアプリURL",
    ),
    "apply": MessageLookupByLibrary.simpleMessage("適用"),
    "areYouSure": MessageLookupByLibrary.simpleMessage("本当に確認しますか？"),
    "areYouSureToBlock": MessageLookupByLibrary.simpleMessage("ユーザーをブロックしますか："),
    "areYouSureToLeaveThisGroupThisActionCantUndo":
        MessageLookupByLibrary.simpleMessage("このグループを退席しますか？このアクションは元に戻せません"),
    "areYouSureToPermitYourCopyThisActionCantUndo":
        MessageLookupByLibrary.simpleMessage("コピーを許可しますか？このアクションは元に戻せません"),
    "areYouSureToReportUserToAdmin": MessageLookupByLibrary.simpleMessage(
      "このユーザーについて管理者に報告する確認していますか？",
    ),
    "areYouSureToUnBlock": MessageLookupByLibrary.simpleMessage(
      "本当にブロックを解除しますか？",
    ),
    "areYouWantToMakeVideoCall": MessageLookupByLibrary.simpleMessage(
      "ビデオ通話を開始しますか？",
    ),
    "areYouWantToMakeVoiceCall": MessageLookupByLibrary.simpleMessage(
      "音声通話を開始しますか？",
    ),
    "audio": MessageLookupByLibrary.simpleMessage("オーディオ"),
    "audioCall": MessageLookupByLibrary.simpleMessage("音声通話"),
    "audioOnlyMode": MessageLookupByLibrary.simpleMessage("音声のみモード"),
    "back": MessageLookupByLibrary.simpleMessage("戻る"),
    "bad": MessageLookupByLibrary.simpleMessage("悪い"),
    "balancedQualityAndFileSize": MessageLookupByLibrary.simpleMessage(
      "品質とファイルサイズのバランス",
    ),
    "banAt": MessageLookupByLibrary.simpleMessage("ブロック日時"),
    "banTo": MessageLookupByLibrary.simpleMessage("ブロック解除日時"),
    "betterQualityLargerFileSize": MessageLookupByLibrary.simpleMessage(
      "より良い品質、大きなファイルサイズ",
    ),
    "bio": MessageLookupByLibrary.simpleMessage("バイオ"),
    "block": MessageLookupByLibrary.simpleMessage("ブロック"),
    "blockUser": MessageLookupByLibrary.simpleMessage("ユーザーをブロック"),
    "blocked": MessageLookupByLibrary.simpleMessage("ブロック済み"),
    "blockedUsers": MessageLookupByLibrary.simpleMessage("ブロックされたユーザー"),
    "broadcast": MessageLookupByLibrary.simpleMessage("ブロードキャスト"),
    "broadcastInfo": MessageLookupByLibrary.simpleMessage("ブロードキャスト情報"),
    "broadcastMembers": MessageLookupByLibrary.simpleMessage("ブロードキャストメンバー"),
    "broadcastName": MessageLookupByLibrary.simpleMessage("ブロードキャスト名"),
    "broadcastParticipants": MessageLookupByLibrary.simpleMessage(
      "ブロードキャスト参加者",
    ),
    "broadcastSettings": MessageLookupByLibrary.simpleMessage("ブロードキャストの設定"),
    "calculating": MessageLookupByLibrary.simpleMessage("計算中..."),
    "callDuration": MessageLookupByLibrary.simpleMessage("通話時間"),
    "callEnded": MessageLookupByLibrary.simpleMessage("通話終了"),
    "callFailed": MessageLookupByLibrary.simpleMessage("通話失敗"),
    "callNotAllowed": MessageLookupByLibrary.simpleMessage("通話が許可されていません"),
    "callQuality": MessageLookupByLibrary.simpleMessage("通話品質"),
    "callTimeoutInSeconds": MessageLookupByLibrary.simpleMessage("通話タイムアウト（秒）"),
    "calls": MessageLookupByLibrary.simpleMessage("通話"),
    "camera": MessageLookupByLibrary.simpleMessage("カメラ"),
    "cameraOff": MessageLookupByLibrary.simpleMessage("カメラオフ"),
    "cameraOn": MessageLookupByLibrary.simpleMessage("カメラオン"),
    "cancel": MessageLookupByLibrary.simpleMessage("キャンセル"),
    "cancelCompression": MessageLookupByLibrary.simpleMessage("圧縮をキャンセル"),
    "canceled": MessageLookupByLibrary.simpleMessage("キャンセル"),
    "changeAccessibleLimitedAssets": MessageLookupByLibrary.simpleMessage(
      "アクセス可能な制限されたアセットを変更",
    ),
    "changeLanguage": MessageLookupByLibrary.simpleMessage("言語を変更"),
    "changeSubject": MessageLookupByLibrary.simpleMessage("サブジェクトを変更"),
    "chat": MessageLookupByLibrary.simpleMessage("チャット"),
    "chats": MessageLookupByLibrary.simpleMessage("チャット"),
    "checkForUpdates": MessageLookupByLibrary.simpleMessage("アップデートの確認"),
    "chooseAtLestOneMember": MessageLookupByLibrary.simpleMessage(
      "少なくとも1人のメンバーを選択してください",
    ),
    "chooseCompressionQualityForYourVideo":
        MessageLookupByLibrary.simpleMessage("動画の圧縮品質を選択してください："),
    "chooseHowAutomaticDownloadWorks": MessageLookupByLibrary.simpleMessage(
      "自動ダウンロードの動作方法を選択",
    ),
    "chooseQualityForYourVideo": MessageLookupByLibrary.simpleMessage(
      "動画の品質を選択してください",
    ),
    "chooseRoom": MessageLookupByLibrary.simpleMessage("ルームを選択"),
    "clear": MessageLookupByLibrary.simpleMessage("クリア"),
    "clearAllCache": MessageLookupByLibrary.simpleMessage("すべてのキャッシュをクリアする"),
    "clearAppStorageDescription": MessageLookupByLibrary.simpleMessage(
      "このオプションはアプリのストレージをクリアします。心配しないでください、自動ダウンロードが有効になっている場合、メッセージは自動的に再ダウンロードされます。",
    ),
    "clearCallsConfirm": MessageLookupByLibrary.simpleMessage(
      "電話をクリアすることを確認しますか？",
    ),
    "clearChat": MessageLookupByLibrary.simpleMessage("チャットをクリア"),
    "clickThisOptionWillClearAppStorage": MessageLookupByLibrary.simpleMessage(
      "このオプションはアプリのストレージをクリアします。自動ダウンロードが有効になっている場合は、いつでも再ダウンロードできますのでご心配なく。メッセージは自動的にダウンロードされます",
    ),
    "clickToAddGroupDescription": MessageLookupByLibrary.simpleMessage(
      "クリックしてグループ説明を追加",
    ),
    "clickToJoin": MessageLookupByLibrary.simpleMessage("クリックして参加する"),
    "clickToSee": MessageLookupByLibrary.simpleMessage("見るにはクリック"),
    "clickToSeeAllUserCountries": MessageLookupByLibrary.simpleMessage(
      "すべてのユーザー国を表示するにはクリック",
    ),
    "clickToSeeAllUserDevicesDetails": MessageLookupByLibrary.simpleMessage(
      "すべてのユーザーデバイスの詳細を表示するにはクリック",
    ),
    "clickToSeeAllUserInformations": MessageLookupByLibrary.simpleMessage(
      "すべてのユーザー情報を表示するにはクリック",
    ),
    "clickToSeeAllUserMessagesDetails": MessageLookupByLibrary.simpleMessage(
      "すべてのユーザーメッセージの詳細を表示するにはクリック",
    ),
    "clickToSeeAllUserReports": MessageLookupByLibrary.simpleMessage(
      "すべてのユーザーレポートを表示するにはクリック",
    ),
    "clickToSeeAllUserRoomsDetails": MessageLookupByLibrary.simpleMessage(
      "すべてのユーザールームの詳細を表示するにはクリック",
    ),
    "close": MessageLookupByLibrary.simpleMessage("閉じる"),
    "codeHasBeenExpired": MessageLookupByLibrary.simpleMessage("コードは期限切れです"),
    "codeMustEqualToSixNumbers": MessageLookupByLibrary.simpleMessage(
      "コードは6つの数字と等しくなければなりません",
    ),
    "codePage": MessageLookupByLibrary.simpleMessage("コードページ"),
    "codeSentAgain": MessageLookupByLibrary.simpleMessage("コードがメールに再送信されました"),
    "completeYourProfile": MessageLookupByLibrary.simpleMessage("プロフィールを完成させる"),
    "compressingVideo": MessageLookupByLibrary.simpleMessage("動画を圧縮中"),
    "compressingVideoThisMayTakeAFewMoments":
        MessageLookupByLibrary.simpleMessage("動画を圧縮中です。しばらくお待ちください..."),
    "compressingVideoWait": MessageLookupByLibrary.simpleMessage(
      "動画を圧縮中、お待ちください...",
    ),
    "compressionQualitySetTo": m0,
    "compressionSettings": MessageLookupByLibrary.simpleMessage("圧縮設定"),
    "configureYourAccountPrivacy": MessageLookupByLibrary.simpleMessage(
      "アカウントのプライバシーを設定",
    ),
    "confirm": MessageLookupByLibrary.simpleMessage("確認"),
    "confirmPassword": MessageLookupByLibrary.simpleMessage("パスワードの確認"),
    "confirmPasswordMustHaveValue": MessageLookupByLibrary.simpleMessage(
      "パスワードの確認は必須です",
    ),
    "confirmPasswordRequired": MessageLookupByLibrary.simpleMessage(
      "パスワードを確認してください",
    ),
    "confirmYourPassword": MessageLookupByLibrary.simpleMessage(
      "パスワードを認証してください",
    ),
    "congregationsYourAccountHasBeenAccepted":
        MessageLookupByLibrary.simpleMessage("おめでとうございます、アカウントが承認されました"),
    "connecting": MessageLookupByLibrary.simpleMessage("接続中..."),
    "connectionQuality": MessageLookupByLibrary.simpleMessage("接続品質"),
    "contactInfo": MessageLookupByLibrary.simpleMessage("連絡先情報"),
    "contactPermissionDenied": MessageLookupByLibrary.simpleMessage(
      "連絡先の許可が拒否されました",
    ),
    "contactUs": MessageLookupByLibrary.simpleMessage("お問い合わせ"),
    "contactsHasBeenSynced": MessageLookupByLibrary.simpleMessage(
      "連絡先が同期されました",
    ),
    "copy": MessageLookupByLibrary.simpleMessage("コピー"),
    "countries": MessageLookupByLibrary.simpleMessage("国"),
    "country": MessageLookupByLibrary.simpleMessage("国"),
    "create": MessageLookupByLibrary.simpleMessage("作成"),
    "createBroadcast": MessageLookupByLibrary.simpleMessage("ブロードキャストを作成"),
    "createGroup": MessageLookupByLibrary.simpleMessage("グループを作成"),
    "createMediaStory": MessageLookupByLibrary.simpleMessage("メディアストーリーを作成"),
    "createStory": MessageLookupByLibrary.simpleMessage("ストーリーを作成"),
    "createTextStory": MessageLookupByLibrary.simpleMessage("テキストストーリーを作成"),
    "createYourStory": MessageLookupByLibrary.simpleMessage("あなたのストーリーを作成"),
    "createdAt": MessageLookupByLibrary.simpleMessage("作成日時"),
    "creator": MessageLookupByLibrary.simpleMessage("作成者"),
    "cropImage": MessageLookupByLibrary.simpleMessage("画像をトリミング"),
    "cropNotAvailableOnWeb": MessageLookupByLibrary.simpleMessage(
      "Webではトリミングできません",
    ),
    "currentDevice": MessageLookupByLibrary.simpleMessage("現在のデバイス"),
    "dashboard": MessageLookupByLibrary.simpleMessage("ダッシュボード"),
    "dataPrivacy": MessageLookupByLibrary.simpleMessage("データプライバシー"),
    "delete": MessageLookupByLibrary.simpleMessage("削除"),
    "deleteAppCache": MessageLookupByLibrary.simpleMessage("アプリのキャッシュを削除しますか？"),
    "deleteChat": MessageLookupByLibrary.simpleMessage("チャットを削除"),
    "deleteFromAll": MessageLookupByLibrary.simpleMessage("全てから削除"),
    "deleteFromMe": MessageLookupByLibrary.simpleMessage("自分から削除"),
    "deleteImage": MessageLookupByLibrary.simpleMessage("画像を削除"),
    "deleteMember": MessageLookupByLibrary.simpleMessage("メンバーを削除"),
    "deleteMyAccount": MessageLookupByLibrary.simpleMessage("アカウントを削除"),
    "deleteThisDeviceDesc": MessageLookupByLibrary.simpleMessage(
      "このデバイスを削除すると、このデバイスからログアウトが即時に実行されます",
    ),
    "deleteUser": MessageLookupByLibrary.simpleMessage("ユーザーを削除"),
    "deleteVideo": MessageLookupByLibrary.simpleMessage("動画を削除"),
    "deleteYouCopy": MessageLookupByLibrary.simpleMessage("コピーを削除"),
    "deleted": MessageLookupByLibrary.simpleMessage("削除済み"),
    "deletedAt": MessageLookupByLibrary.simpleMessage("削除日時"),
    "delivered": MessageLookupByLibrary.simpleMessage("配信済み"),
    "description": MessageLookupByLibrary.simpleMessage("説明"),
    "descriptionIsRequired": MessageLookupByLibrary.simpleMessage("説明は必須です"),
    "desktopAndOtherDevices": MessageLookupByLibrary.simpleMessage(
      "デスクトップおよびその他のデバイス",
    ),
    "deviceHasBeenLogoutFromAllDevices": MessageLookupByLibrary.simpleMessage(
      "デバイスはすべてのデバイスからログアウトしました",
    ),
    "deviceStatus": MessageLookupByLibrary.simpleMessage("デバイスの状態"),
    "devices": MessageLookupByLibrary.simpleMessage("デバイス"),
    "didntReceiveCode": MessageLookupByLibrary.simpleMessage("コードを受信しませんでしたか？"),
    "directChat": MessageLookupByLibrary.simpleMessage("ダイレクトチャット"),
    "directRooms": MessageLookupByLibrary.simpleMessage("ダイレクトルーム"),
    "disconnected": MessageLookupByLibrary.simpleMessage("切断"),
    "dismissedToMemberBy": MessageLookupByLibrary.simpleMessage("メンバーに降格："),
    "dismissesToMember": MessageLookupByLibrary.simpleMessage("メンバーに降格"),
    "docs": MessageLookupByLibrary.simpleMessage("ドキュメント"),
    "done": MessageLookupByLibrary.simpleMessage("完了"),
    "dontHaveAnAccount": MessageLookupByLibrary.simpleMessage(
      "アカウントをお持ちではありませんか？",
    ),
    "download": MessageLookupByLibrary.simpleMessage("ダウンロード"),
    "downloadImage": MessageLookupByLibrary.simpleMessage("画像をダウンロード"),
    "downloading": MessageLookupByLibrary.simpleMessage("ダウンロード中..."),
    "edit": MessageLookupByLibrary.simpleMessage("編集"),
    "editImage": MessageLookupByLibrary.simpleMessage("画像を編集"),
    "editVideo": MessageLookupByLibrary.simpleMessage("動画を編集"),
    "email": MessageLookupByLibrary.simpleMessage("メールアドレス"),
    "emailMustBeValid": MessageLookupByLibrary.simpleMessage(
      "メールアドレスは有効である必要があります",
    ),
    "emailNotValid": MessageLookupByLibrary.simpleMessage("メールアドレスが無効です"),
    "emailRequired": MessageLookupByLibrary.simpleMessage("メールアドレスは必須です"),
    "emptyList": MessageLookupByLibrary.simpleMessage("メディアが見つかりません"),
    "enableSearchByEmail": MessageLookupByLibrary.simpleMessage(
      "メールアドレスで検索を有効にする",
    ),
    "enableSearchByUserName": MessageLookupByLibrary.simpleMessage(
      "ユーザー名で検索を有効にする",
    ),
    "endCall": MessageLookupByLibrary.simpleMessage("通話終了"),
    "english": MessageLookupByLibrary.simpleMessage("英語"),
    "enterAdminPassword": MessageLookupByLibrary.simpleMessage(
      "管理者パスワードを入力してください",
    ),
    "enterCredentialsToAccessDashboard": MessageLookupByLibrary.simpleMessage(
      "ダッシュボードにアクセスするには認証情報を入力してください",
    ),
    "enterNameAndAddOptionalProfilePicture":
        MessageLookupByLibrary.simpleMessage("名前を入力し、オプションのプロフィール画像を追加"),
    "enterNewPassword": MessageLookupByLibrary.simpleMessage(
      "新しいパスワードを入力してください",
    ),
    "enterTheCodeAndNewPassword": MessageLookupByLibrary.simpleMessage(
      "メールに送信された認証コードを入力して、新しいパスワードを作成してください",
    ),
    "enterVerificationCode": MessageLookupByLibrary.simpleMessage("認証コードを入力"),
    "enterYourEmail": MessageLookupByLibrary.simpleMessage("メールアドレスを入力してください"),
    "enterYourFullName": MessageLookupByLibrary.simpleMessage("フルネームを入力してください"),
    "enterYourName": MessageLookupByLibrary.simpleMessage("名前を入力してください"),
    "enterYourPassword": MessageLookupByLibrary.simpleMessage("パスワードを入力してください"),
    "enterYourPhoneNumber": MessageLookupByLibrary.simpleMessage(
      "電話番号を入力してください",
    ),
    "error": MessageLookupByLibrary.simpleMessage("エラー"),
    "errorDownloadingImage": MessageLookupByLibrary.simpleMessage(
      "画像のダウンロードエラー",
    ),
    "errorLoadingImage": MessageLookupByLibrary.simpleMessage("画像の読み込みエラー"),
    "errorProcessingMedia": m1,
    "errorSharingImage": MessageLookupByLibrary.simpleMessage("画像の共有エラー"),
    "estimatedFileSize": MessageLookupByLibrary.simpleMessage("推定サイズ"),
    "estimating": MessageLookupByLibrary.simpleMessage("推定中..."),
    "excellent": MessageLookupByLibrary.simpleMessage("優秀"),
    "exitGroup": MessageLookupByLibrary.simpleMessage("グループを退出"),
    "explainWhatHappens": MessageLookupByLibrary.simpleMessage(
      "ここに何が起こるかを説明してください",
    ),
    "failedToLoadVideo": MessageLookupByLibrary.simpleMessage("動画の読み込みに失敗しました"),
    "failedToLoadViewers": MessageLookupByLibrary.simpleMessage("視聴者の読み込みに失敗"),
    "failedToSaveTrimmedVideo": MessageLookupByLibrary.simpleMessage(
      "トリムされた動画の保存に失敗しました",
    ),
    "feedBackEmail": MessageLookupByLibrary.simpleMessage("フィードバックメール"),
    "fileHasBeenSavedTo": MessageLookupByLibrary.simpleMessage("ファイルは保存されました："),
    "fileMessages": MessageLookupByLibrary.simpleMessage("ファイルメッセージ"),
    "fileMustBeImage": MessageLookupByLibrary.simpleMessage(
      "ファイルは画像ファイルである必要があります",
    ),
    "fileMustBeVideo": MessageLookupByLibrary.simpleMessage(
      "ファイルは動画ファイルである必要があります",
    ),
    "fileName": MessageLookupByLibrary.simpleMessage("ファイル名"),
    "fileSize": MessageLookupByLibrary.simpleMessage("ファイルサイズ"),
    "fileType": MessageLookupByLibrary.simpleMessage("ファイルタイプ"),
    "files": MessageLookupByLibrary.simpleMessage("ファイル"),
    "finalizingCompression": MessageLookupByLibrary.simpleMessage("圧縮を完了中..."),
    "finalizingCompressionAndSavingFile": MessageLookupByLibrary.simpleMessage(
      "圧縮を完了し、ファイルを保存中...",
    ),
    "finished": MessageLookupByLibrary.simpleMessage("終了"),
    "finishing": MessageLookupByLibrary.simpleMessage("完了中..."),
    "forRequest": MessageLookupByLibrary.simpleMessage("リクエスト用"),
    "forgetPassword": MessageLookupByLibrary.simpleMessage("パスワードを忘れました"),
    "forgetPasswordExpireTime": MessageLookupByLibrary.simpleMessage(
      "パスワードリセットの有効期限",
    ),
    "forgotPassword": MessageLookupByLibrary.simpleMessage("パスワードを忘れましたか？"),
    "forgotPasswordNavigating": MessageLookupByLibrary.simpleMessage(
      "パスワードを忘れた場合のページに移動します",
    ),
    "forward": MessageLookupByLibrary.simpleMessage("転送"),
    "fullName": MessageLookupByLibrary.simpleMessage("フルネーム"),
    "gallery": MessageLookupByLibrary.simpleMessage("ギャラリー"),
    "gifIndicator": MessageLookupByLibrary.simpleMessage("GIF"),
    "globalSearch": MessageLookupByLibrary.simpleMessage("グローバル検索"),
    "goToSystemSettings": MessageLookupByLibrary.simpleMessage("システム設定に移動"),
    "good": MessageLookupByLibrary.simpleMessage("良好"),
    "googleAndroid": MessageLookupByLibrary.simpleMessage("Google Android"),
    "googlePlayAppUrl": MessageLookupByLibrary.simpleMessage(
      "Google PlayアプリURL",
    ),
    "gpsLabel": MessageLookupByLibrary.simpleMessage("GPS"),
    "group": MessageLookupByLibrary.simpleMessage("グループ"),
    "groupCreatedBy": MessageLookupByLibrary.simpleMessage("グループ作成者："),
    "groupDescription": MessageLookupByLibrary.simpleMessage("グループ説明"),
    "groupIcon": MessageLookupByLibrary.simpleMessage("グループアイコン"),
    "groupInfo": MessageLookupByLibrary.simpleMessage("グループ情報"),
    "groupMembers": MessageLookupByLibrary.simpleMessage("グループメンバー"),
    "groupName": MessageLookupByLibrary.simpleMessage("グループ名"),
    "groupParticipants": MessageLookupByLibrary.simpleMessage("グループ参加者"),
    "groupSettings": MessageLookupByLibrary.simpleMessage("グループの設定"),
    "groupWith": MessageLookupByLibrary.simpleMessage("グループと"),
    "harassmentOrBullyingDescription": MessageLookupByLibrary.simpleMessage(
      "嫌がらせやいじめ：このオプションを使用して、嫌がらせメッセージ、脅迫、またはその他のいじめ行為を行っている個人を報告できます。",
    ),
    "help": MessageLookupByLibrary.simpleMessage("ヘルプ"),
    "hiIamUse": MessageLookupByLibrary.simpleMessage("こんにちは、私は使います"),
    "highQuality": MessageLookupByLibrary.simpleMessage("高品質"),
    "id": MessageLookupByLibrary.simpleMessage("ID"),
    "ifThisOptionDisabledTheCreateChatBroadcastWillBeBlocked":
        MessageLookupByLibrary.simpleMessage(
          "このオプションが無効になっている場合、チャットブロードキャストの作成がブロックされます",
        ),
    "ifThisOptionDisabledTheCreateChatGroupsWillBeBlocked":
        MessageLookupByLibrary.simpleMessage(
          "このオプションが無効になっている場合、チャットグループの作成がブロックされます",
        ),
    "ifThisOptionDisabledTheDesktopLoginOrRegisterWindowsMacWillBeBlocked":
        MessageLookupByLibrary.simpleMessage(
          "このオプションが無効になっている場合、デスクトップログインまたは登録（WindowsおよびmacOS）がブロックされます",
        ),
    "ifThisOptionDisabledTheMobileLoginOrRegisterWillBeBlockedOnAndroidIosOnly":
        MessageLookupByLibrary.simpleMessage(
          "このオプションが有効になっている場合、Google広告バナーがチャットに表示されます",
        ),
    "ifThisOptionDisabledTheSendChatFilesImageVideosAndLocationWillBeBlocked":
        MessageLookupByLibrary.simpleMessage(
          "このオプションが無効になっている場合、チャットファイル、画像、ビデオ、および位置情報の送信がブロックされます",
        ),
    "ifThisOptionDisabledTheWebLoginOrRegisterWillBeBlocked":
        MessageLookupByLibrary.simpleMessage(
          "このオプションが無効になっている場合、Webログインまたは登録がブロックされます",
        ),
    "ifThisOptionEnabledTheGoogleAdsBannerWillAppearInChats":
        MessageLookupByLibrary.simpleMessage(
          "このオプションが有効になっている場合、Google広告バナーがチャットに表示されます。",
        ),
    "ifThisOptionEnabledTheVideoAndVoiceCallWillBeAllowed":
        MessageLookupByLibrary.simpleMessage(
          "このオプションが有効になっている場合、ビデオ通話および音声通話が許可されます",
        ),
    "image": MessageLookupByLibrary.simpleMessage("画像"),
    "imageInfo": MessageLookupByLibrary.simpleMessage("画像情報"),
    "imageMessages": MessageLookupByLibrary.simpleMessage("画像メッセージ"),
    "images": MessageLookupByLibrary.simpleMessage("画像"),
    "inAppAlerts": MessageLookupByLibrary.simpleMessage("アプリ内アラート"),
    "inCall": MessageLookupByLibrary.simpleMessage("通話中"),
    "inappropriateContentDescription": MessageLookupByLibrary.simpleMessage(
      "不適切なコンテンツ：ユーザーは、性的に露骨なコンテンツ、ヘイトスピーチ、またはコミュニティの基準に違反するその他のコンテンツを報告するためにこのオプションを選択できます。",
    ),
    "info": MessageLookupByLibrary.simpleMessage("情報"),
    "infoMessages": MessageLookupByLibrary.simpleMessage("情報メッセージ"),
    "invalidCode": MessageLookupByLibrary.simpleMessage("無効なコード"),
    "invalidEmail": MessageLookupByLibrary.simpleMessage("有効なメールアドレスを入力してください"),
    "invalidLoginData": MessageLookupByLibrary.simpleMessage("無効なログインデータ"),
    "invalidVerificationCode": MessageLookupByLibrary.simpleMessage(
      "入力された認証コードが無効です。確認して再試行してください。",
    ),
    "ios": MessageLookupByLibrary.simpleMessage("iOS"),
    "isPrime": MessageLookupByLibrary.simpleMessage("素数ですか"),
    "joinCall": MessageLookupByLibrary.simpleMessage("通話に参加"),
    "joinedAt": MessageLookupByLibrary.simpleMessage("参加日時"),
    "joinedBy": MessageLookupByLibrary.simpleMessage("参加者："),
    "kickMember": MessageLookupByLibrary.simpleMessage("メンバーをキック"),
    "kickedBy": MessageLookupByLibrary.simpleMessage("キックされました："),
    "language": MessageLookupByLibrary.simpleMessage("言語"),
    "lastActiveFrom": MessageLookupByLibrary.simpleMessage("最後にアクティブ"),
    "leaveCall": MessageLookupByLibrary.simpleMessage("通話を退出"),
    "leaveGroup": MessageLookupByLibrary.simpleMessage("グループを退席"),
    "leaveGroupAndDeleteYourMessageCopy": MessageLookupByLibrary.simpleMessage(
      "グループを退席してメッセージのコピーを削除",
    ),
    "left": MessageLookupByLibrary.simpleMessage("残り"),
    "leftTheGroup": MessageLookupByLibrary.simpleMessage("グループを退席"),
    "linkADeviceSoon": MessageLookupByLibrary.simpleMessage(
      "デバイスをリンクする（近日公開予定）",
    ),
    "linkByQrCode": MessageLookupByLibrary.simpleMessage("QRコードでリンク"),
    "linkedDevices": MessageLookupByLibrary.simpleMessage("リンクされたデバイス"),
    "links": MessageLookupByLibrary.simpleMessage("リンク"),
    "loadFailed": MessageLookupByLibrary.simpleMessage("読み込み失敗"),
    "loading": MessageLookupByLibrary.simpleMessage("読み込み中..."),
    "loadingVideo": MessageLookupByLibrary.simpleMessage("動画を読み込み中..."),
    "loadingViewers": MessageLookupByLibrary.simpleMessage("視聴者を読み込み中..."),
    "location": MessageLookupByLibrary.simpleMessage("位置情報"),
    "locationFallback": MessageLookupByLibrary.simpleMessage("場所"),
    "locationMessages": MessageLookupByLibrary.simpleMessage("位置情報メッセージ"),
    "logOut": MessageLookupByLibrary.simpleMessage("ログアウト"),
    "login": MessageLookupByLibrary.simpleMessage("ログイン"),
    "loginAgain": MessageLookupByLibrary.simpleMessage("再度ログイン！"),
    "loginNowAllowedNowPleaseTryAgainLater":
        MessageLookupByLibrary.simpleMessage(
          "現在、ログインは許可されていません。後でもう一度お試しください。",
        ),
    "loginSuccessful": MessageLookupByLibrary.simpleMessage("ログインに成功しました！"),
    "logoutFromAllDevices": MessageLookupByLibrary.simpleMessage(
      "すべてのデバイスからログアウトしますか？",
    ),
    "lowQuality": MessageLookupByLibrary.simpleMessage("低品質"),
    "macOs": MessageLookupByLibrary.simpleMessage("macOS"),
    "makeCall": MessageLookupByLibrary.simpleMessage("通話を開始"),
    "media": MessageLookupByLibrary.simpleMessage("メディア"),
    "mediaLinksAndDocs": MessageLookupByLibrary.simpleMessage(
      "メディア、リンク、およびドキュメント",
    ),
    "mediumQuality": MessageLookupByLibrary.simpleMessage("中品質"),
    "member": MessageLookupByLibrary.simpleMessage("メンバー"),
    "members": MessageLookupByLibrary.simpleMessage("メンバー"),
    "messageCounter": MessageLookupByLibrary.simpleMessage("メッセージカウンター"),
    "messageHasBeenDeleted": MessageLookupByLibrary.simpleMessage(
      "メッセージが削除されました",
    ),
    "messageHasBeenViewed": MessageLookupByLibrary.simpleMessage(
      "メッセージは閲覧されました",
    ),
    "messageInfo": MessageLookupByLibrary.simpleMessage("メッセージ情報"),
    "messagePrivatelyWithFriendsAndFamily":
        MessageLookupByLibrary.simpleMessage(
          "ブラウザを使用して友人や家族とプライベートメッセージを送信します。",
        ),
    "messages": MessageLookupByLibrary.simpleMessage("メッセージ"),
    "microphoneAndCameraPermissionMustBeAccepted":
        MessageLookupByLibrary.simpleMessage(
          "Microphone and camera permission must be accepted",
        ),
    "microphoneOff": MessageLookupByLibrary.simpleMessage("マイクオフ"),
    "microphoneOn": MessageLookupByLibrary.simpleMessage("マイクオン"),
    "microphonePermissionMustBeAccepted": MessageLookupByLibrary.simpleMessage(
      "Microphone permission must be accepted",
    ),
    "microsoftWindows": MessageLookupByLibrary.simpleMessage(
      "Microsoft Windows",
    ),
    "minutes": MessageLookupByLibrary.simpleMessage("分"),
    "more": MessageLookupByLibrary.simpleMessage("詳細"),
    "mute": MessageLookupByLibrary.simpleMessage("ミュート"),
    "muteNotifications": MessageLookupByLibrary.simpleMessage("通知をミュート"),
    "myPrivacy": MessageLookupByLibrary.simpleMessage("プライバシー"),
    "name": MessageLookupByLibrary.simpleMessage("名前"),
    "nameMustHaveValue": MessageLookupByLibrary.simpleMessage("名前は必須です"),
    "nameRequired": MessageLookupByLibrary.simpleMessage("名前は必須です"),
    "needHelp": MessageLookupByLibrary.simpleMessage("ヘルプが必要ですか？"),
    "needNewAccount": MessageLookupByLibrary.simpleMessage("新しいアカウントが必要ですか？"),
    "networkError": MessageLookupByLibrary.simpleMessage(
      "ネットワークエラー。接続を確認して再試行してください。",
    ),
    "networkPoor": MessageLookupByLibrary.simpleMessage("ネットワーク接続が悪い"),
    "newBroadcast": MessageLookupByLibrary.simpleMessage("新しいブロードキャスト"),
    "newGroup": MessageLookupByLibrary.simpleMessage("新しいグループ"),
    "newPassword": MessageLookupByLibrary.simpleMessage("新しいパスワード"),
    "newPasswordMustHaveValue": MessageLookupByLibrary.simpleMessage(
      "新しいパスワードは必須です",
    ),
    "newUpdateIsAvailable": MessageLookupByLibrary.simpleMessage(
      "新しいアップデートが利用可能です",
    ),
    "next": MessageLookupByLibrary.simpleMessage("次へ"),
    "nickname": MessageLookupByLibrary.simpleMessage("ニックネーム"),
    "no": MessageLookupByLibrary.simpleMessage("いいえ"),
    "noBio": MessageLookupByLibrary.simpleMessage("バイオなし"),
    "noCodeHasBeenSendToYouToVerifyYourEmail":
        MessageLookupByLibrary.simpleMessage("メールを確認するためのコードが送信されていません"),
    "noCustomSettings": MessageLookupByLibrary.simpleMessage("カスタム設定なし"),
    "noData": MessageLookupByLibrary.simpleMessage("データなし"),
    "noMediaFound": MessageLookupByLibrary.simpleMessage("メディアが見つかりません"),
    "noUpdatesAvailableNow": MessageLookupByLibrary.simpleMessage(
      "現在、アップデートは利用できません",
    ),
    "noViewersYet": MessageLookupByLibrary.simpleMessage("まだ視聴者はいません"),
    "none": MessageLookupByLibrary.simpleMessage("なし"),
    "notAccepted": MessageLookupByLibrary.simpleMessage("未承認"),
    "notification": MessageLookupByLibrary.simpleMessage("通知"),
    "notificationDescription": MessageLookupByLibrary.simpleMessage("通知の説明"),
    "notificationTitle": MessageLookupByLibrary.simpleMessage("通知タイトル"),
    "notificationsPage": MessageLookupByLibrary.simpleMessage("通知ページ"),
    "nowYouLoginAsReadOnlyAdminAllEditYouDoneWillNotAppliedDueToThisIsTestVersion":
        MessageLookupByLibrary.simpleMessage(
          "現在、読み取り専用の管理者としてログインしています。これはテストバージョンのため、行ったすべての編集が適用されません。",
        ),
    "off": MessageLookupByLibrary.simpleMessage("オフ"),
    "offline": MessageLookupByLibrary.simpleMessage("オフライン"),
    "ok": MessageLookupByLibrary.simpleMessage("OK"),
    "oldPassword": MessageLookupByLibrary.simpleMessage("古いパスワード"),
    "on": MessageLookupByLibrary.simpleMessage("オン"),
    "oneSeenMessage": MessageLookupByLibrary.simpleMessage("一度見たメッセージ"),
    "oneTimeSeen": MessageLookupByLibrary.simpleMessage("一回だけ閲覧済み"),
    "online": MessageLookupByLibrary.simpleMessage("オンライン"),
    "openAppOnYourPhoneInstructions": MessageLookupByLibrary.simpleMessage(
      "1. 携帯電話でアプリを開きます。Androidでは「設定」、iPhoneでは「設定」をタップします。「リンクされたデバイス」をタップし、次に「デバイスをリンク」をタップします。この画面をスキャンするために携帯電話を向けます。",
    ),
    "orLoginWith": MessageLookupByLibrary.simpleMessage("または次でログイン"),
    "original": MessageLookupByLibrary.simpleMessage("オリジナル"),
    "originalFileSize": MessageLookupByLibrary.simpleMessage("元のサイズ"),
    "other": MessageLookupByLibrary.simpleMessage("その他"),
    "otherCategoryDescription": MessageLookupByLibrary.simpleMessage(
      "その他：上記のカテゴリに簡単に適合しない違反に使用できるキャッチオールカテゴリです。ユーザーが追加の詳細を提供できるように、テキストボックスを含めるのが役立つかもしれません。",
    ),
    "otpCode": MessageLookupByLibrary.simpleMessage("OTPコード"),
    "participantCount": m2,
    "password": MessageLookupByLibrary.simpleMessage("パスワード"),
    "passwordHasBeenChanged": MessageLookupByLibrary.simpleMessage(
      "パスワードが変更されました",
    ),
    "passwordIsRequired": MessageLookupByLibrary.simpleMessage("パスワードは必須です"),
    "passwordMustHaveValue": MessageLookupByLibrary.simpleMessage("パスワードは必須です"),
    "passwordNotMatch": MessageLookupByLibrary.simpleMessage("パスワードが一致しません"),
    "passwordRequired": MessageLookupByLibrary.simpleMessage("パスワードは必須です"),
    "passwordTooShort": MessageLookupByLibrary.simpleMessage(
      "パスワードは8文字以上である必要があります",
    ),
    "passwordsDontMatch": MessageLookupByLibrary.simpleMessage("パスワードが一致しません"),
    "peerUserDeviceOffline": MessageLookupByLibrary.simpleMessage(
      "相手のユーザーデバイスがオフラインです",
    ),
    "peerUserInCallNow": MessageLookupByLibrary.simpleMessage(
      "相手のユーザーは現在通話中です",
    ),
    "pending": MessageLookupByLibrary.simpleMessage("保留中"),
    "permissionDenied": MessageLookupByLibrary.simpleMessage("権限が拒否されました"),
    "phone": MessageLookupByLibrary.simpleMessage("電話"),
    "phoneNumber": MessageLookupByLibrary.simpleMessage("電話番号"),
    "phoneNumberNotValid": MessageLookupByLibrary.simpleMessage("電話番号が無効です"),
    "pleaseEnterValid6DigitCode": MessageLookupByLibrary.simpleMessage(
      "有効な6桁のコードを入力してください",
    ),
    "pleaseEnterValidCode": MessageLookupByLibrary.simpleMessage(
      "有効な6桁のコードを入力してください",
    ),
    "pleaseEnterVerificationCode": MessageLookupByLibrary.simpleMessage(
      "認証コードを入力してください",
    ),
    "pleaseEnterYourName": MessageLookupByLibrary.simpleMessage("名前を入力してください"),
    "pleaseGrantCameraPermission": MessageLookupByLibrary.simpleMessage(
      "カメラの権限を許可してください",
    ),
    "pleaseGrantStoragePermission": MessageLookupByLibrary.simpleMessage(
      "ストレージの権限を許可してください",
    ),
    "pleaseProvideYourNameToContinue": MessageLookupByLibrary.simpleMessage(
      "続行するには名前を入力してください",
    ),
    "poor": MessageLookupByLibrary.simpleMessage("不良"),
    "preview": MessageLookupByLibrary.simpleMessage("プレビュー"),
    "privacyPolicy": MessageLookupByLibrary.simpleMessage("プライバシーポリシー"),
    "privacyUrl": MessageLookupByLibrary.simpleMessage("プライバシーURL"),
    "processingVideoDataAndOptimizingQuality":
        MessageLookupByLibrary.simpleMessage("動画データを処理し、品質を最適化中..."),
    "profile": MessageLookupByLibrary.simpleMessage("プロフィール"),
    "promotedToAdminBy": MessageLookupByLibrary.simpleMessage("管理者に昇格："),
    "public": MessageLookupByLibrary.simpleMessage("公開"),
    "read": MessageLookupByLibrary.simpleMessage("既読"),
    "recent": MessageLookupByLibrary.simpleMessage("最近"),
    "recentUpdate": MessageLookupByLibrary.simpleMessage("最近の更新"),
    "recentUpdates": MessageLookupByLibrary.simpleMessage("最近のアップデート"),
    "reconnecting": MessageLookupByLibrary.simpleMessage("再接続中..."),
    "recording": MessageLookupByLibrary.simpleMessage("録音中..."),
    "reenterNewPassword": MessageLookupByLibrary.simpleMessage(
      "新しいパスワードを再入力してください",
    ),
    "register": MessageLookupByLibrary.simpleMessage("登録"),
    "registerMethod": MessageLookupByLibrary.simpleMessage("登録方法"),
    "registerStatus": MessageLookupByLibrary.simpleMessage("登録ステータス"),
    "registrationSuccessful": MessageLookupByLibrary.simpleMessage(
      "登録が成功しました！",
    ),
    "rejected": MessageLookupByLibrary.simpleMessage("拒否"),
    "remaining": MessageLookupByLibrary.simpleMessage("残り"),
    "repliedToYourSelf": MessageLookupByLibrary.simpleMessage("自分に返信しました"),
    "reply": MessageLookupByLibrary.simpleMessage("返信"),
    "replyToYourSelf": MessageLookupByLibrary.simpleMessage("自分に返信"),
    "report": MessageLookupByLibrary.simpleMessage("通報"),
    "reportHasBeenSubmitted": MessageLookupByLibrary.simpleMessage(
      "レポートが送信されました",
    ),
    "reportUser": MessageLookupByLibrary.simpleMessage("ユーザーを通報"),
    "reports": MessageLookupByLibrary.simpleMessage("レポート"),
    "resend": MessageLookupByLibrary.simpleMessage("再送信"),
    "resendInSeconds": m3,
    "resetPassword": MessageLookupByLibrary.simpleMessage("パスワードをリセット"),
    "resetTrim": MessageLookupByLibrary.simpleMessage("トリムをリセット"),
    "retry": MessageLookupByLibrary.simpleMessage("再試行"),
    "ring": MessageLookupByLibrary.simpleMessage("呼び出し中..."),
    "roomAlreadyInCall": MessageLookupByLibrary.simpleMessage("ルームは既に通話中です"),
    "roomCounter": MessageLookupByLibrary.simpleMessage("ルームカウンター"),
    "sActionPlayHint": MessageLookupByLibrary.simpleMessage("再生"),
    "sActionPreviewHint": MessageLookupByLibrary.simpleMessage("プレビュー"),
    "sActionSelectHint": MessageLookupByLibrary.simpleMessage("選択"),
    "sActionSwitchPathLabel": MessageLookupByLibrary.simpleMessage("パスを切り替え"),
    "sActionUseCameraHint": MessageLookupByLibrary.simpleMessage("カメラを使用"),
    "sNameDurationLabel": MessageLookupByLibrary.simpleMessage("時間"),
    "sTypeAudioLabel": MessageLookupByLibrary.simpleMessage("オーディオ"),
    "sTypeImageLabel": MessageLookupByLibrary.simpleMessage("画像"),
    "sTypeOtherLabel": MessageLookupByLibrary.simpleMessage("その他"),
    "sTypeVideoLabel": MessageLookupByLibrary.simpleMessage("動画"),
    "sUnitAssetCountLabel": MessageLookupByLibrary.simpleMessage("数"),
    "save": MessageLookupByLibrary.simpleMessage("保存"),
    "saveLogin": MessageLookupByLibrary.simpleMessage("ログイン情報を保存"),
    "saving": MessageLookupByLibrary.simpleMessage("保存中..."),
    "search": MessageLookupByLibrary.simpleMessage("検索"),
    "searchByUserFullEmail": MessageLookupByLibrary.simpleMessage(
      "完全なメールアドレスで検索",
    ),
    "searchByUserNameOrFullUserEmail": MessageLookupByLibrary.simpleMessage(
      "ユーザー名または完全なメールアドレスで検索",
    ),
    "seconds": MessageLookupByLibrary.simpleMessage("秒"),
    "secureAdminAccess": MessageLookupByLibrary.simpleMessage("セキュア管理者アクセス"),
    "select": MessageLookupByLibrary.simpleMessage("選択"),
    "selectMedia": MessageLookupByLibrary.simpleMessage("メディアを選択"),
    "selectPhotos": MessageLookupByLibrary.simpleMessage("写真を選択"),
    "selectVideos": MessageLookupByLibrary.simpleMessage("動画を選択"),
    "selectedLocation": MessageLookupByLibrary.simpleMessage("選択された場所"),
    "send": MessageLookupByLibrary.simpleMessage("送信"),
    "sendCodeToMyEmail": MessageLookupByLibrary.simpleMessage("コードを私のメールに送信"),
    "sendMessage": MessageLookupByLibrary.simpleMessage("メッセージを送信"),
    "sendOriginalVideoWithoutCompression": MessageLookupByLibrary.simpleMessage(
      "圧縮なしで元の動画を送信",
    ),
    "sendVerificationCode": MessageLookupByLibrary.simpleMessage("確認コードを送信"),
    "sentSixDigitCode": m4,
    "serverRestart": MessageLookupByLibrary.simpleMessage("サーバー再起動"),
    "sessionEnd": MessageLookupByLibrary.simpleMessage("セッション終了"),
    "setMaxBroadcastMembers": MessageLookupByLibrary.simpleMessage(
      "最大ブロードキャストメンバー数を設定",
    ),
    "setMaxGroupMembers": MessageLookupByLibrary.simpleMessage(
      "最大グループメンバー数を設定",
    ),
    "setMaxMessageForwardAndShare": MessageLookupByLibrary.simpleMessage(
      "最大メッセージ転送および共有を設定",
    ),
    "setNewPrivacyPolicyUrl": MessageLookupByLibrary.simpleMessage(
      "新しいプライバシーポリシーのURLを設定",
    ),
    "setToAdmin": MessageLookupByLibrary.simpleMessage("管理者に設定"),
    "settings": MessageLookupByLibrary.simpleMessage("設定"),
    "share": MessageLookupByLibrary.simpleMessage("共有"),
    "shareImage": MessageLookupByLibrary.simpleMessage("画像を共有"),
    "shareMediaAndLocation": MessageLookupByLibrary.simpleMessage(
      "メディアと位置情報を共有",
    ),
    "shareYourStatus": MessageLookupByLibrary.simpleMessage("ステータスを共有"),
    "showHistory": MessageLookupByLibrary.simpleMessage("履歴を表示"),
    "showMedia": MessageLookupByLibrary.simpleMessage("メディアを表示"),
    "skipCompression": MessageLookupByLibrary.simpleMessage("圧縮をスキップ"),
    "smallFileSizeFasterUploadLow": MessageLookupByLibrary.simpleMessage(
      "小さなファイルサイズ、高速アップロード",
    ),
    "smallestFileSizeFasterUpload": MessageLookupByLibrary.simpleMessage(
      "最小ファイルサイズ、高速アップロード",
    ),
    "soon": MessageLookupByLibrary.simpleMessage("近日公開"),
    "spamOrScamDescription": MessageLookupByLibrary.simpleMessage(
      "スパムまたは詐欺：このオプションは、スパムメッセージ、不要な広告を送信しているアカウント、または他のユーザーを騙そうとしているアカウントを報告するためのものです。",
    ),
    "speakerOff": MessageLookupByLibrary.simpleMessage("スピーカーオフ"),
    "speakerOn": MessageLookupByLibrary.simpleMessage("スピーカーオン"),
    "star": MessageLookupByLibrary.simpleMessage("スター"),
    "starMessage": MessageLookupByLibrary.simpleMessage("メッセージをスター付け"),
    "starredMessage": MessageLookupByLibrary.simpleMessage("スター付きメッセージ"),
    "starredMessages": MessageLookupByLibrary.simpleMessage("スター付きメッセージ"),
    "startChat": MessageLookupByLibrary.simpleMessage("チャットを開始"),
    "startNewChatWithYou": MessageLookupByLibrary.simpleMessage(
      "あなたと新しいチャットを開始",
    ),
    "status": MessageLookupByLibrary.simpleMessage("ステータス"),
    "storageAndData": MessageLookupByLibrary.simpleMessage("ストレージとデータ"),
    "storeUrls": MessageLookupByLibrary.simpleMessage("ストアのURL"),
    "stories": MessageLookupByLibrary.simpleMessage("ストーリー"),
    "storyCreatedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "ストーリーの作成に成功しました",
    ),
    "storyViewers": MessageLookupByLibrary.simpleMessage("ストーリー視聴者"),
    "success": MessageLookupByLibrary.simpleMessage("成功"),
    "successfullyDownloadedIn": MessageLookupByLibrary.simpleMessage(
      "ダウンロードが正常に完了しました",
    ),
    "supportChatSoon": MessageLookupByLibrary.simpleMessage("サポートチャット（近日公開予定）"),
    "switchCamera": MessageLookupByLibrary.simpleMessage("カメラ切り替え"),
    "syncContacts": MessageLookupByLibrary.simpleMessage("連絡先を同期する"),
    "systemConfiguration": MessageLookupByLibrary.simpleMessage("システム設定"),
    "tapADeviceToEditOrLogOut": MessageLookupByLibrary.simpleMessage(
      "デバイスをタップして編集またはログアウト",
    ),
    "tapForPhoto": MessageLookupByLibrary.simpleMessage("写真をタップ"),
    "tapToOpenInMaps": MessageLookupByLibrary.simpleMessage("マップで開くにはタップ"),
    "tapToSelectAnIcon": MessageLookupByLibrary.simpleMessage("アイコンを選択するにはタップ"),
    "tapToSwapVideo": MessageLookupByLibrary.simpleMessage("タップしてビデオ位置を入れ替え"),
    "tellAFriend": MessageLookupByLibrary.simpleMessage("友達に教える"),
    "textFieldHint": MessageLookupByLibrary.simpleMessage("メッセージを入力..."),
    "textMessages": MessageLookupByLibrary.simpleMessage("テキストメッセージ"),
    "thereIsFileHasSizeBiggerThanAllowedSize":
        MessageLookupByLibrary.simpleMessage("許容サイズよりも大きいファイルがあります"),
    "thereIsVideoSizeBiggerThanAllowedSize":
        MessageLookupByLibrary.simpleMessage("許容サイズよりも大きいビデオがあります"),
    "timeout": MessageLookupByLibrary.simpleMessage("タイムアウト"),
    "titleIsRequired": MessageLookupByLibrary.simpleMessage("タイトルが必要です"),
    "today": MessageLookupByLibrary.simpleMessage("今日"),
    "toggleTheme": MessageLookupByLibrary.simpleMessage("テーマを切り替え"),
    "tooManyAttempts": MessageLookupByLibrary.simpleMessage(
      "試行回数が多すぎます。後でもう一度お試しください。",
    ),
    "total": MessageLookupByLibrary.simpleMessage("合計"),
    "totalMessages": MessageLookupByLibrary.simpleMessage("総メッセージ数"),
    "totalRooms": MessageLookupByLibrary.simpleMessage("合計ルーム数"),
    "totalVisits": MessageLookupByLibrary.simpleMessage("総訪問数"),
    "translate": MessageLookupByLibrary.simpleMessage("翻訳"),
    "trimmed": MessageLookupByLibrary.simpleMessage("トリム済み"),
    "typing": MessageLookupByLibrary.simpleMessage("入力中..."),
    "ultraLowQuality": MessageLookupByLibrary.simpleMessage("超低品質"),
    "unBlock": MessageLookupByLibrary.simpleMessage("ブロック解除"),
    "unBlockUser": MessageLookupByLibrary.simpleMessage("ユーザーのブロックを解除"),
    "unMute": MessageLookupByLibrary.simpleMessage("ミュート解除"),
    "unStar": MessageLookupByLibrary.simpleMessage("スターを解除"),
    "unSupportedAssetType": MessageLookupByLibrary.simpleMessage(
      "サポートされていないファイルタイプ",
    ),
    "unableToAccessAll": MessageLookupByLibrary.simpleMessage(
      "すべての写真にアクセスできません",
    ),
    "unknown": MessageLookupByLibrary.simpleMessage("不明"),
    "update": MessageLookupByLibrary.simpleMessage("更新"),
    "updateBroadcastTitle": MessageLookupByLibrary.simpleMessage(
      "ブロードキャストのタイトルを更新",
    ),
    "updateFeedBackEmail": MessageLookupByLibrary.simpleMessage(
      "フィードバックメールを更新",
    ),
    "updateGroupDescription": MessageLookupByLibrary.simpleMessage(
      "グループの説明を更新",
    ),
    "updateGroupDescriptionWillUpdateAllGroupMembers":
        MessageLookupByLibrary.simpleMessage(
          "グループの説明を更新すると、すべてのグループメンバーに適用されます",
        ),
    "updateGroupTitle": MessageLookupByLibrary.simpleMessage("グループのタイトルを更新"),
    "updateImage": MessageLookupByLibrary.simpleMessage("画像を更新"),
    "updateNickname": MessageLookupByLibrary.simpleMessage("ニックネームを更新"),
    "updateTitle": MessageLookupByLibrary.simpleMessage("タイトルを更新"),
    "updateTitleTo": MessageLookupByLibrary.simpleMessage("タイトルを更新"),
    "updateYourBio": MessageLookupByLibrary.simpleMessage("バイオを更新"),
    "updateYourName": MessageLookupByLibrary.simpleMessage("名前を更新"),
    "updateYourPassword": MessageLookupByLibrary.simpleMessage("パスワードを更新"),
    "updateYourProfile": MessageLookupByLibrary.simpleMessage("プロフィールを更新"),
    "updatedAt": MessageLookupByLibrary.simpleMessage("更新日時"),
    "upgradeToAdmin": MessageLookupByLibrary.simpleMessage("管理者に昇格"),
    "userAction": MessageLookupByLibrary.simpleMessage("ユーザーアクション"),
    "userAlreadyRegister": MessageLookupByLibrary.simpleMessage(
      "ユーザーは既に登録済みです",
    ),
    "userAnalytics": MessageLookupByLibrary.simpleMessage("ユーザー分析"),
    "userDeviceSessionEndDeviceDeleted": MessageLookupByLibrary.simpleMessage(
      "ユーザーデバイスセッション終了、デバイス削除",
    ),
    "userEmailNotFound": MessageLookupByLibrary.simpleMessage(
      "ユーザーメールアドレスが見つかりません",
    ),
    "userInfo": MessageLookupByLibrary.simpleMessage("ユーザー情報"),
    "userJoined": MessageLookupByLibrary.simpleMessage("ユーザーが通話に参加しました"),
    "userLeft": MessageLookupByLibrary.simpleMessage("ユーザーが通話を退出しました"),
    "userName": MessageLookupByLibrary.simpleMessage("ユーザー名"),
    "userPage": MessageLookupByLibrary.simpleMessage("ユーザーページ"),
    "userProfile": MessageLookupByLibrary.simpleMessage("ユーザープロファイル"),
    "userRegisterStatus": MessageLookupByLibrary.simpleMessage("ユーザー登録ステータス"),
    "userRegisterStatusNotAcceptedYet": MessageLookupByLibrary.simpleMessage(
      "ユーザー登録ステータスはまだ受け入れられていません",
    ),
    "users": MessageLookupByLibrary.simpleMessage("ユーザー"),
    "usersAddedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "ユーザーが正常に追加されました",
    ),
    "vMessageInfoTrans": MessageLookupByLibrary.simpleMessage("メッセージ情報"),
    "vMessagesInfoTrans": MessageLookupByLibrary.simpleMessage("メッセージ情報"),
    "verificationFailed": m5,
    "verificationSessionExpired": MessageLookupByLibrary.simpleMessage(
      "認証セッションの有効期限が切れました。新しいコードをリクエストしてください。",
    ),
    "verificationTimedOut": MessageLookupByLibrary.simpleMessage(
      "検証がタイムアウトしました。もう一度お試しください。",
    ),
    "verified": MessageLookupByLibrary.simpleMessage("確認済み"),
    "verifiedAt": MessageLookupByLibrary.simpleMessage("確認済み"),
    "verify": MessageLookupByLibrary.simpleMessage("確認"),
    "veryBad": MessageLookupByLibrary.simpleMessage("非常に悪い"),
    "veryLowQuality": MessageLookupByLibrary.simpleMessage("非常に低品質"),
    "verySmallFileSize": MessageLookupByLibrary.simpleMessage("非常に小さなファイルサイズ"),
    "video": MessageLookupByLibrary.simpleMessage("ビデオ"),
    "videoCallMessages": MessageLookupByLibrary.simpleMessage("ビデオ通話メッセージ"),
    "videoCallMode": MessageLookupByLibrary.simpleMessage("ビデオ通話モード"),
    "videoCompression": MessageLookupByLibrary.simpleMessage("動画圧縮"),
    "videoCompressionFailed": m6,
    "videoMessages": MessageLookupByLibrary.simpleMessage("ビデオメッセージ"),
    "videoTrimmer": MessageLookupByLibrary.simpleMessage("動画トリマー"),
    "viewingLimitedAssetsTip": MessageLookupByLibrary.simpleMessage(
      "アプリがアクセス可能な写真と動画のみを表示しています。",
    ),
    "visits": MessageLookupByLibrary.simpleMessage("訪問"),
    "voiceCall": MessageLookupByLibrary.simpleMessage("音声通話"),
    "voiceCallMessage": MessageLookupByLibrary.simpleMessage("音声通話メッセージ"),
    "voiceCallMessages": MessageLookupByLibrary.simpleMessage("音声通話メッセージ"),
    "voiceMessages": MessageLookupByLibrary.simpleMessage("音声メッセージ"),
    "wait2MinutesToSendMail": MessageLookupByLibrary.simpleMessage(
      "メールを送信するには2分待ってください",
    ),
    "waitingList": MessageLookupByLibrary.simpleMessage("待機リスト"),
    "weHighRecommendToDownloadThisUpdate": MessageLookupByLibrary.simpleMessage(
      "このアップデートのダウンロードを強くお勧めします",
    ),
    "weWillSendYouAVerificationCode": MessageLookupByLibrary.simpleMessage(
      "確認コードをお送りします",
    ),
    "web": MessageLookupByLibrary.simpleMessage("ウェブ"),
    "webChat": MessageLookupByLibrary.simpleMessage("ウェブチャット"),
    "welcome": MessageLookupByLibrary.simpleMessage("ようこそ"),
    "welcomeBack": MessageLookupByLibrary.simpleMessage("おかえりなさい"),
    "whenUsingMobileData": MessageLookupByLibrary.simpleMessage(
      "モバイルデータを使用している場合",
    ),
    "whenUsingWifi": MessageLookupByLibrary.simpleMessage("Wi-Fiを使用している場合"),
    "whileAuthCanFindYou": MessageLookupByLibrary.simpleMessage(
      "認証があなたを見つけることができない間",
    ),
    "windows": MessageLookupByLibrary.simpleMessage("Windows"),
    "writeACaption": MessageLookupByLibrary.simpleMessage("キャプションを入力..."),
    "x": MessageLookupByLibrary.simpleMessage("x"),
    "yes": MessageLookupByLibrary.simpleMessage("はい"),
    "yesterday": MessageLookupByLibrary.simpleMessage("昨日"),
    "you": MessageLookupByLibrary.simpleMessage("あなた"),
    "youAreAboutToDeleteThisUserFromYourList":
        MessageLookupByLibrary.simpleMessage("このユーザーをリストから削除しようとしています"),
    "youAreAboutToDeleteYourAccountYourAccountWillNotAppearAgainInUsersList":
        MessageLookupByLibrary.simpleMessage(
          "アカウントを削除しようとしています。アカウントはユーザーリストに再表示されません",
        ),
    "youAreAboutToDismissesToMember": MessageLookupByLibrary.simpleMessage(
      "メンバーを降格しようとしています",
    ),
    "youAreAboutToKick": MessageLookupByLibrary.simpleMessage("キックしようとしています"),
    "youAreAboutToUpgradeToAdmin": MessageLookupByLibrary.simpleMessage(
      "管理者に昇格しようとしています",
    ),
    "youDontHaveAccess": MessageLookupByLibrary.simpleMessage("アクセス権がありません"),
    "youInPublicSearch": MessageLookupByLibrary.simpleMessage("パブリック検索での表示"),
    "youNotParticipantInThisGroup": MessageLookupByLibrary.simpleMessage(
      "このグループの参加者ではありません",
    ),
    "yourAccountBlocked": MessageLookupByLibrary.simpleMessage(
      "アカウントがブロックされました",
    ),
    "yourAccountDeleted": MessageLookupByLibrary.simpleMessage("アカウントが削除されました"),
    "yourAccountIsUnderReview": MessageLookupByLibrary.simpleMessage(
      "アカウントは審査中です",
    ),
    "yourAreAboutToLogoutFromThisAccount": MessageLookupByLibrary.simpleMessage(
      "このアカウントからログアウトしようとしています",
    ),
    "yourLastSeen": MessageLookupByLibrary.simpleMessage("最後に見た"),
    "yourLastSeenInChats": MessageLookupByLibrary.simpleMessage("チャットで最後に見た"),
    "yourProfileAppearsInPublicSearchAndAddingForGroups":
        MessageLookupByLibrary.simpleMessage(
          "あなたのプロフィールは、パブリック検索とグループへの追加に表示されます",
        ),
    "yourSessionIsEndedPleaseLoginAgain": MessageLookupByLibrary.simpleMessage(
      "セッションが終了しました。もう一度ログインしてください。",
    ),
    "yourStory": MessageLookupByLibrary.simpleMessage("あなたのストーリー"),
  };
}
