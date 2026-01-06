// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ko locale. All the
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
  String get localeName => 'ko';

  static String m0(quality) =>
      "압축 품질이 ${quality}(으)로 설정되었습니다. 전송 시 동영상이 압축됩니다.";

  static String m1(error) => "미디어 처리 오류: ${error}";

  static String m2(count) => "${count}명 참가자";

  static String m3(seconds) => "${seconds}초 후 재전송";

  static String m4(phone) => "${phone}로 6자리 코드를 보냈습니다";

  static String m5(message) => "인증 실패: ${message}";

  static String m6(fileName, error) => "${fileName} 동영상 압축에 실패했습니다: ${error}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("정보"),
    "aboutToBlockUserWithConsequences": MessageLookupByLibrary.simpleMessage(
      "이 사용자를 차단하려고 합니다. 그에게 채팅을 보낼 수 없으며 그룹이나 방송에 추가할 수 없습니다!",
    ),
    "acceptCallsFromUsers": MessageLookupByLibrary.simpleMessage("사용자의 통화 허용"),
    "acceptContactsPermissionDescription": MessageLookupByLibrary.simpleMessage(
      "앱을 사용하는 연락처를 보려면 연락처 권한을 허용해야 합니다",
    ),
    "accepted": MessageLookupByLibrary.simpleMessage("수락됨"),
    "accessAllTip": MessageLookupByLibrary.simpleMessage(
      "앱은 기기의 제한된 자산에만 액세스할 수 있습니다. 시스템 설정으로 이동하여 앱이 기기의 모든 사진에 액세스할 수 있도록 허용하세요.",
    ),
    "accessLimitedAssets": MessageLookupByLibrary.simpleMessage("제한된 액세스로 계속"),
    "accessiblePathName": MessageLookupByLibrary.simpleMessage("액세스 가능한 자산"),
    "account": MessageLookupByLibrary.simpleMessage("계정"),
    "actions": MessageLookupByLibrary.simpleMessage("작업"),
    "activity": MessageLookupByLibrary.simpleMessage("활동"),
    "addMembers": MessageLookupByLibrary.simpleMessage("멤버 추가"),
    "addNewStory": MessageLookupByLibrary.simpleMessage("새로운 스토리 추가"),
    "addParticipants": MessageLookupByLibrary.simpleMessage("참가자 추가"),
    "addedYouToNewBroadcast": MessageLookupByLibrary.simpleMessage(
      "새로운 방송에 당신을 추가했습니다",
    ),
    "admin": MessageLookupByLibrary.simpleMessage("관리자"),
    "adminDashboard": MessageLookupByLibrary.simpleMessage("관리자 대시보드"),
    "adminNotification": MessageLookupByLibrary.simpleMessage("관리자 알림"),
    "allDataHasBeenBackupYouDontNeedToManageSaveTheDataByYourself":
        MessageLookupByLibrary.simpleMessage(
          "모든 데이터가 백업되었으므로 데이터를 직접 관리할 필요가 없습니다. 다시 로그인하면 모든 채팅이 동일하게 표시됩니다.",
        ),
    "allDeletedMessages": MessageLookupByLibrary.simpleMessage("모든 삭제된 메시지"),
    "allPhotos": MessageLookupByLibrary.simpleMessage("모든 사진"),
    "allVideos": MessageLookupByLibrary.simpleMessage("모든 동영상"),
    "allowAds": MessageLookupByLibrary.simpleMessage("광고 허용"),
    "allowCalls": MessageLookupByLibrary.simpleMessage("통화 허용"),
    "allowCreateBroadcast": MessageLookupByLibrary.simpleMessage("방송 생성 허용"),
    "allowCreateGroups": MessageLookupByLibrary.simpleMessage("그룹 생성 허용"),
    "allowDesktopLogin": MessageLookupByLibrary.simpleMessage("데스크톱 로그인 허용"),
    "allowMobileLogin": MessageLookupByLibrary.simpleMessage("모바일 로그인 허용"),
    "allowSendMedia": MessageLookupByLibrary.simpleMessage("미디어 전송 허용"),
    "allowWebLogin": MessageLookupByLibrary.simpleMessage("웹 로그인 허용"),
    "almostDone": MessageLookupByLibrary.simpleMessage("거의 완료..."),
    "almostDoneJustAFewMoreSeconds": MessageLookupByLibrary.simpleMessage(
      "거의 완료되었습니다. 몇 초만 더 기다려 주세요...",
    ),
    "alreadyHaveAnAccount": MessageLookupByLibrary.simpleMessage(
      "이미 계정이 있으십니까?",
    ),
    "analyzingVideo": MessageLookupByLibrary.simpleMessage(
      "비디오 분석 및 압축 준비 중...",
    ),
    "analyzingVideoAndPreparingCompression":
        MessageLookupByLibrary.simpleMessage("동영상을 분석하고 압축을 준비하는 중..."),
    "android": MessageLookupByLibrary.simpleMessage("안드로이드"),
    "appMembers": MessageLookupByLibrary.simpleMessage("앱 멤버"),
    "appStorageSizeIs": MessageLookupByLibrary.simpleMessage("앱 저장소 크기는"),
    "appleIos": MessageLookupByLibrary.simpleMessage("Apple iOS"),
    "appleMacStoreUrl": MessageLookupByLibrary.simpleMessage(
      "Apple Mac Store URL",
    ),
    "appleStoreAppUrl": MessageLookupByLibrary.simpleMessage("애플 스토어 앱 URL"),
    "apply": MessageLookupByLibrary.simpleMessage("적용"),
    "areYouSure": MessageLookupByLibrary.simpleMessage("확실합니까?"),
    "areYouSureToBlock": MessageLookupByLibrary.simpleMessage("차단하시겠습니까"),
    "areYouSureToLeaveThisGroupThisActionCantUndo":
        MessageLookupByLibrary.simpleMessage("이 그룹을 나가시겠습니까? 이 작업은 되돌릴 수 없습니다"),
    "areYouSureToPermitYourCopyThisActionCantUndo":
        MessageLookupByLibrary.simpleMessage(
          "내 사본을 허용하시겠습니까? 이 작업은 되돌릴 수 없습니다",
        ),
    "areYouSureToReportUserToAdmin": MessageLookupByLibrary.simpleMessage(
      "이 사용자에 대한 신고를 관리자에게 제출하시겠습니까?",
    ),
    "areYouSureToUnBlock": MessageLookupByLibrary.simpleMessage("차단 해제하시겠습니까"),
    "areYouWantToMakeVideoCall": MessageLookupByLibrary.simpleMessage(
      "비디오 통화를 시작하시겠습니까?",
    ),
    "areYouWantToMakeVoiceCall": MessageLookupByLibrary.simpleMessage(
      "음성 통화를 시작하시겠습니까?",
    ),
    "audio": MessageLookupByLibrary.simpleMessage("오디오"),
    "audioCall": MessageLookupByLibrary.simpleMessage("음성 통화"),
    "audioOnlyMode": MessageLookupByLibrary.simpleMessage("음성 전용 모드"),
    "back": MessageLookupByLibrary.simpleMessage("뒤로"),
    "bad": MessageLookupByLibrary.simpleMessage("나쁨"),
    "balancedQualityAndFileSize": MessageLookupByLibrary.simpleMessage(
      "화질과 파일 크기의 균형",
    ),
    "banAt": MessageLookupByLibrary.simpleMessage("차단 일자"),
    "banTo": MessageLookupByLibrary.simpleMessage("차단 종료 시간"),
    "betterQualityLargerFileSize": MessageLookupByLibrary.simpleMessage(
      "더 좋은 화질, 더 큰 파일 크기",
    ),
    "bio": MessageLookupByLibrary.simpleMessage("자기 소개"),
    "block": MessageLookupByLibrary.simpleMessage("차단"),
    "blockUser": MessageLookupByLibrary.simpleMessage("사용자 차단"),
    "blocked": MessageLookupByLibrary.simpleMessage("차단됨"),
    "blockedUsers": MessageLookupByLibrary.simpleMessage("차단된 사용자"),
    "broadcast": MessageLookupByLibrary.simpleMessage("방송"),
    "broadcastInfo": MessageLookupByLibrary.simpleMessage("방송 정보"),
    "broadcastMembers": MessageLookupByLibrary.simpleMessage("방송 멤버"),
    "broadcastName": MessageLookupByLibrary.simpleMessage("방송 이름"),
    "broadcastParticipants": MessageLookupByLibrary.simpleMessage("방송 참가자"),
    "broadcastSettings": MessageLookupByLibrary.simpleMessage("방송 설정"),
    "calculating": MessageLookupByLibrary.simpleMessage("계산 중..."),
    "callDuration": MessageLookupByLibrary.simpleMessage("통화 시간"),
    "callEnded": MessageLookupByLibrary.simpleMessage("통화 종료"),
    "callFailed": MessageLookupByLibrary.simpleMessage("통화 실패"),
    "callNotAllowed": MessageLookupByLibrary.simpleMessage("통화가 허용되지 않음"),
    "callQuality": MessageLookupByLibrary.simpleMessage("통화 품질"),
    "callTimeoutInSeconds": MessageLookupByLibrary.simpleMessage(
      "통화 제한 시간 (초)",
    ),
    "calls": MessageLookupByLibrary.simpleMessage("통화"),
    "camera": MessageLookupByLibrary.simpleMessage("카메라"),
    "cameraOff": MessageLookupByLibrary.simpleMessage("카메라 끄기"),
    "cameraOn": MessageLookupByLibrary.simpleMessage("카메라 켜기"),
    "cancel": MessageLookupByLibrary.simpleMessage("취소"),
    "cancelCompression": MessageLookupByLibrary.simpleMessage("압축 취소"),
    "canceled": MessageLookupByLibrary.simpleMessage("취소됨"),
    "changeAccessibleLimitedAssets": MessageLookupByLibrary.simpleMessage(
      "액세스 가능한 제한된 자산 변경",
    ),
    "changeLanguage": MessageLookupByLibrary.simpleMessage("언어 변경"),
    "changeSubject": MessageLookupByLibrary.simpleMessage("주제 변경"),
    "chat": MessageLookupByLibrary.simpleMessage("채팅"),
    "chats": MessageLookupByLibrary.simpleMessage("채팅"),
    "checkForUpdates": MessageLookupByLibrary.simpleMessage("업데이트 확인"),
    "chooseAtLestOneMember": MessageLookupByLibrary.simpleMessage(
      "적어도 하나의 멤버를 선택하세요",
    ),
    "chooseCompressionQualityForYourVideo":
        MessageLookupByLibrary.simpleMessage("동영상 압축 품질을 선택하세요:"),
    "chooseHowAutomaticDownloadWorks": MessageLookupByLibrary.simpleMessage(
      "자동 다운로드 작동 방식 선택",
    ),
    "chooseQualityForYourVideo": MessageLookupByLibrary.simpleMessage(
      "동영상 품질을 선택하세요",
    ),
    "chooseRoom": MessageLookupByLibrary.simpleMessage("방 선택"),
    "clear": MessageLookupByLibrary.simpleMessage("지우기"),
    "clearAllCache": MessageLookupByLibrary.simpleMessage("모든 캐시 지우기"),
    "clearAppStorageDescription": MessageLookupByLibrary.simpleMessage(
      "이 옵션은 앱 저장소를 지웁니다. 걱정하지 마세요. 자동 다운로드가 활성화된 경우 메시지는 언제든지 자동으로 다운로드됩니다.",
    ),
    "clearCallsConfirm": MessageLookupByLibrary.simpleMessage(
      "전화 지우기를 확인하시겠습니까?",
    ),
    "clearChat": MessageLookupByLibrary.simpleMessage("채팅 지우기"),
    "clickThisOptionWillClearAppStorage": MessageLookupByLibrary.simpleMessage(
      "이 옵션은 앱 스토리지를 지웁니다. 자동 다운로드가 활성화되어 있으면 언제든지 다시 다운로드할 수 있으니 걱정하지 마세요. 메시지가 자동으로 다운로드됩니다.",
    ),
    "clickToAddGroupDescription": MessageLookupByLibrary.simpleMessage(
      "그룹 설명을 추가하려면 클릭하세요",
    ),
    "clickToJoin": MessageLookupByLibrary.simpleMessage("클릭하여 가입"),
    "clickToSee": MessageLookupByLibrary.simpleMessage("보려면 클릭"),
    "clickToSeeAllUserCountries": MessageLookupByLibrary.simpleMessage(
      "모든 사용자 국가 보기를 클릭하세요",
    ),
    "clickToSeeAllUserDevicesDetails": MessageLookupByLibrary.simpleMessage(
      "모든 사용자 디바이스 세부 정보 보기",
    ),
    "clickToSeeAllUserInformations": MessageLookupByLibrary.simpleMessage(
      "모든 사용자 정보 보기를 클릭하세요",
    ),
    "clickToSeeAllUserMessagesDetails": MessageLookupByLibrary.simpleMessage(
      "모든 사용자 메시지 세부 정보 보기를 클릭하세요",
    ),
    "clickToSeeAllUserReports": MessageLookupByLibrary.simpleMessage(
      "모든 사용자 리포트 보기를 클릭하세요",
    ),
    "clickToSeeAllUserRoomsDetails": MessageLookupByLibrary.simpleMessage(
      "모든 사용자 방 세부 정보 보기를 클릭하세요",
    ),
    "close": MessageLookupByLibrary.simpleMessage("닫기"),
    "codeHasBeenExpired": MessageLookupByLibrary.simpleMessage("코드가 만료되었습니다"),
    "codeMustEqualToSixNumbers": MessageLookupByLibrary.simpleMessage(
      "코드는 6자리여야 합니다",
    ),
    "codePage": MessageLookupByLibrary.simpleMessage("코드 페이지"),
    "codeSentAgain": MessageLookupByLibrary.simpleMessage(
      "코드가 이메일로 다시 전송되었습니다",
    ),
    "completeYourProfile": MessageLookupByLibrary.simpleMessage("프로필을 완료하세요"),
    "compressingVideo": MessageLookupByLibrary.simpleMessage("동영상 압축 중"),
    "compressingVideoThisMayTakeAFewMoments":
        MessageLookupByLibrary.simpleMessage("동영상을 압축하는 중입니다. 잠시만 기다려 주세요..."),
    "compressingVideoWait": MessageLookupByLibrary.simpleMessage(
      "비디오 압축 중, 잠시 기다려 주세요...",
    ),
    "compressionQualitySetTo": m0,
    "compressionSettings": MessageLookupByLibrary.simpleMessage("압축 설정"),
    "configureYourAccountPrivacy": MessageLookupByLibrary.simpleMessage(
      "계정 개인 정보 설정",
    ),
    "confirm": MessageLookupByLibrary.simpleMessage("확인"),
    "confirmPassword": MessageLookupByLibrary.simpleMessage("비밀번호 확인"),
    "confirmPasswordMustHaveValue": MessageLookupByLibrary.simpleMessage(
      "비밀번호 확인은 값을 가져야 합니다",
    ),
    "confirmPasswordRequired": MessageLookupByLibrary.simpleMessage(
      "비밀번호를 확인하세요",
    ),
    "confirmYourPassword": MessageLookupByLibrary.simpleMessage("비밀번호를 확인하세요"),
    "congregationsYourAccountHasBeenAccepted":
        MessageLookupByLibrary.simpleMessage("계정이 승인되었습니다"),
    "connecting": MessageLookupByLibrary.simpleMessage("연결 중..."),
    "connectionQuality": MessageLookupByLibrary.simpleMessage("연결 품질"),
    "contactInfo": MessageLookupByLibrary.simpleMessage("연락처 정보"),
    "contactPermissionDenied": MessageLookupByLibrary.simpleMessage(
      "연락처 권한이 거부되었습니다",
    ),
    "contactUs": MessageLookupByLibrary.simpleMessage("문의하기"),
    "contactsHasBeenSynced": MessageLookupByLibrary.simpleMessage(
      "연락처가 동기화되었습니다",
    ),
    "copy": MessageLookupByLibrary.simpleMessage("복사"),
    "countries": MessageLookupByLibrary.simpleMessage("국가"),
    "country": MessageLookupByLibrary.simpleMessage("국가"),
    "create": MessageLookupByLibrary.simpleMessage("생성"),
    "createBroadcast": MessageLookupByLibrary.simpleMessage("방송 만들기"),
    "createGroup": MessageLookupByLibrary.simpleMessage("그룹 만들기"),
    "createMediaStory": MessageLookupByLibrary.simpleMessage("미디어 스토리 만들기"),
    "createStory": MessageLookupByLibrary.simpleMessage("스토리 만들기"),
    "createTextStory": MessageLookupByLibrary.simpleMessage("텍스트 스토리 만들기"),
    "createYourStory": MessageLookupByLibrary.simpleMessage("당신의 스토리 만들기"),
    "createdAt": MessageLookupByLibrary.simpleMessage("생성 시간"),
    "creator": MessageLookupByLibrary.simpleMessage("창조자"),
    "cropImage": MessageLookupByLibrary.simpleMessage("이미지 자르기"),
    "cropNotAvailableOnWeb": MessageLookupByLibrary.simpleMessage(
      "웹에서는 자르기를 사용할 수 없습니다",
    ),
    "currentDevice": MessageLookupByLibrary.simpleMessage("현재 기기"),
    "dashboard": MessageLookupByLibrary.simpleMessage("대시보드"),
    "dataPrivacy": MessageLookupByLibrary.simpleMessage("데이터 개인 정보 보호"),
    "delete": MessageLookupByLibrary.simpleMessage("삭제"),
    "deleteAppCache": MessageLookupByLibrary.simpleMessage("앱 캐시를 삭제하시겠습니까?"),
    "deleteChat": MessageLookupByLibrary.simpleMessage("채팅 삭제"),
    "deleteFromAll": MessageLookupByLibrary.simpleMessage("모두에서 삭제"),
    "deleteFromMe": MessageLookupByLibrary.simpleMessage("나에서 삭제"),
    "deleteImage": MessageLookupByLibrary.simpleMessage("이미지 삭제"),
    "deleteMember": MessageLookupByLibrary.simpleMessage("멤버 삭제"),
    "deleteMyAccount": MessageLookupByLibrary.simpleMessage("내 계정 삭제"),
    "deleteThisDeviceDesc": MessageLookupByLibrary.simpleMessage(
      "이 기기를 삭제하면 즉시 로그아웃됩니다",
    ),
    "deleteUser": MessageLookupByLibrary.simpleMessage("사용자 삭제"),
    "deleteVideo": MessageLookupByLibrary.simpleMessage("동영상 삭제"),
    "deleteYouCopy": MessageLookupByLibrary.simpleMessage("내 사본 삭제"),
    "deleted": MessageLookupByLibrary.simpleMessage("삭제됨"),
    "deletedAt": MessageLookupByLibrary.simpleMessage("삭제 시간"),
    "delivered": MessageLookupByLibrary.simpleMessage("전달됨"),
    "description": MessageLookupByLibrary.simpleMessage("설명"),
    "descriptionIsRequired": MessageLookupByLibrary.simpleMessage("설명 필수"),
    "desktopAndOtherDevices": MessageLookupByLibrary.simpleMessage(
      "데스크톱 및 기타 기기",
    ),
    "deviceHasBeenLogoutFromAllDevices": MessageLookupByLibrary.simpleMessage(
      "모든 기기에서 로그아웃되었습니다",
    ),
    "deviceStatus": MessageLookupByLibrary.simpleMessage("기기 상태"),
    "devices": MessageLookupByLibrary.simpleMessage("기기"),
    "didntReceiveCode": MessageLookupByLibrary.simpleMessage("코드를 받지 못했나요?"),
    "directChat": MessageLookupByLibrary.simpleMessage("직접 채팅"),
    "directRooms": MessageLookupByLibrary.simpleMessage("직접 방"),
    "disconnected": MessageLookupByLibrary.simpleMessage("연결 끊김"),
    "dismissedToMemberBy": MessageLookupByLibrary.simpleMessage("멤버로 내린 사람:"),
    "dismissesToMember": MessageLookupByLibrary.simpleMessage("멤버로 내림"),
    "docs": MessageLookupByLibrary.simpleMessage("문서"),
    "done": MessageLookupByLibrary.simpleMessage("완료"),
    "dontHaveAnAccount": MessageLookupByLibrary.simpleMessage("계정이 없으신가요?"),
    "download": MessageLookupByLibrary.simpleMessage("다운로드"),
    "downloadImage": MessageLookupByLibrary.simpleMessage("이미지 다운로드"),
    "downloading": MessageLookupByLibrary.simpleMessage("다운로드 중..."),
    "edit": MessageLookupByLibrary.simpleMessage("편집"),
    "editImage": MessageLookupByLibrary.simpleMessage("이미지 편집"),
    "editVideo": MessageLookupByLibrary.simpleMessage("비디오 편집"),
    "email": MessageLookupByLibrary.simpleMessage("이메일"),
    "emailMustBeValid": MessageLookupByLibrary.simpleMessage("이메일은 유효해야 합니다"),
    "emailNotValid": MessageLookupByLibrary.simpleMessage("유효하지 않은 이메일"),
    "emailRequired": MessageLookupByLibrary.simpleMessage("이메일은 필수 항목입니다"),
    "emptyList": MessageLookupByLibrary.simpleMessage("미디어를 찾을 수 없음"),
    "enableSearchByEmail": MessageLookupByLibrary.simpleMessage("이메일로 검색 활성화"),
    "enableSearchByUserName": MessageLookupByLibrary.simpleMessage(
      "사용자 이름으로 검색 활성화",
    ),
    "endCall": MessageLookupByLibrary.simpleMessage("통화 종료"),
    "english": MessageLookupByLibrary.simpleMessage("영어"),
    "enterAdminPassword": MessageLookupByLibrary.simpleMessage(
      "관리자 비밀번호를 입력하세요",
    ),
    "enterCredentialsToAccessDashboard": MessageLookupByLibrary.simpleMessage(
      "대시보드에 접근하려면 인증 정보를 입력하세요",
    ),
    "enterNameAndAddOptionalProfilePicture":
        MessageLookupByLibrary.simpleMessage("이름을 입력하고 선택적 프로필 사진을 추가하세요"),
    "enterNewPassword": MessageLookupByLibrary.simpleMessage("새 비밀번호를 입력하세요"),
    "enterTheCodeAndNewPassword": MessageLookupByLibrary.simpleMessage(
      "이메일로 전송된 인증 코드를 입력하고 새 비밀번호를 만드세요",
    ),
    "enterVerificationCode": MessageLookupByLibrary.simpleMessage("인증 코드 입력"),
    "enterYourEmail": MessageLookupByLibrary.simpleMessage("이메일을 입력하세요"),
    "enterYourFullName": MessageLookupByLibrary.simpleMessage("전체 이름을 입력하세요"),
    "enterYourName": MessageLookupByLibrary.simpleMessage("이름을 입력하세요"),
    "enterYourPassword": MessageLookupByLibrary.simpleMessage("비밀번호를 입력하세요"),
    "enterYourPhoneNumber": MessageLookupByLibrary.simpleMessage("전화번호를 입력하세요"),
    "error": MessageLookupByLibrary.simpleMessage("오류"),
    "errorDownloadingImage": MessageLookupByLibrary.simpleMessage(
      "이미지 다운로드 오류",
    ),
    "errorLoadingImage": MessageLookupByLibrary.simpleMessage("이미지 로딩 오류"),
    "errorProcessingMedia": m1,
    "errorSharingImage": MessageLookupByLibrary.simpleMessage("이미지 공유 오류"),
    "estimatedFileSize": MessageLookupByLibrary.simpleMessage("예상"),
    "estimating": MessageLookupByLibrary.simpleMessage("추정 중..."),
    "excellent": MessageLookupByLibrary.simpleMessage("우수"),
    "exitGroup": MessageLookupByLibrary.simpleMessage("그룹 나가기"),
    "explainWhatHappens": MessageLookupByLibrary.simpleMessage(
      "여기에 무슨 일이 일어나는지 설명하세요",
    ),
    "failedToLoadVideo": MessageLookupByLibrary.simpleMessage("비디오 로딩 실패"),
    "failedToLoadViewers": MessageLookupByLibrary.simpleMessage("시청자 로딩 실패"),
    "failedToSaveTrimmedVideo": MessageLookupByLibrary.simpleMessage(
      "트림된 비디오 저장 실패",
    ),
    "feedBackEmail": MessageLookupByLibrary.simpleMessage("피드백 이메일"),
    "fileHasBeenSavedTo": MessageLookupByLibrary.simpleMessage(
      "파일이 다음 위치에 저장되었습니다",
    ),
    "fileMessages": MessageLookupByLibrary.simpleMessage("파일 메시지"),
    "fileMustBeImage": MessageLookupByLibrary.simpleMessage(
      "파일은 이미지 파일이어야 합니다",
    ),
    "fileMustBeVideo": MessageLookupByLibrary.simpleMessage(
      "파일은 동영상 파일이어야 합니다",
    ),
    "fileName": MessageLookupByLibrary.simpleMessage("파일 이름"),
    "fileSize": MessageLookupByLibrary.simpleMessage("파일 크기"),
    "fileType": MessageLookupByLibrary.simpleMessage("파일 유형"),
    "files": MessageLookupByLibrary.simpleMessage("파일"),
    "finalizingCompression": MessageLookupByLibrary.simpleMessage("압축 완료 중..."),
    "finalizingCompressionAndSavingFile": MessageLookupByLibrary.simpleMessage(
      "압축을 완료하고 파일을 저장하는 중...",
    ),
    "finished": MessageLookupByLibrary.simpleMessage("완료됨"),
    "finishing": MessageLookupByLibrary.simpleMessage("완료 중..."),
    "forRequest": MessageLookupByLibrary.simpleMessage("요청 용"),
    "forgetPassword": MessageLookupByLibrary.simpleMessage("비밀번호 잊어버림"),
    "forgetPasswordExpireTime": MessageLookupByLibrary.simpleMessage(
      "비밀번호 재설정 만료 시간",
    ),
    "forgotPassword": MessageLookupByLibrary.simpleMessage("비밀번호를 잊으셨나요?"),
    "forgotPasswordNavigating": MessageLookupByLibrary.simpleMessage(
      "비밀번호 찾기 페이지로 이동",
    ),
    "forward": MessageLookupByLibrary.simpleMessage("전달"),
    "fullName": MessageLookupByLibrary.simpleMessage("전체 이름"),
    "gallery": MessageLookupByLibrary.simpleMessage("갤러리"),
    "gifIndicator": MessageLookupByLibrary.simpleMessage("GIF"),
    "globalSearch": MessageLookupByLibrary.simpleMessage("글로벌 검색"),
    "goToSystemSettings": MessageLookupByLibrary.simpleMessage("시스템 설정으로 이동"),
    "good": MessageLookupByLibrary.simpleMessage("양호"),
    "googleAndroid": MessageLookupByLibrary.simpleMessage("Google Android"),
    "googlePlayAppUrl": MessageLookupByLibrary.simpleMessage("구글 플레이 앱 URL"),
    "gpsLabel": MessageLookupByLibrary.simpleMessage("GPS"),
    "group": MessageLookupByLibrary.simpleMessage("그룹"),
    "groupCreatedBy": MessageLookupByLibrary.simpleMessage("그룹 생성자:"),
    "groupDescription": MessageLookupByLibrary.simpleMessage("그룹 설명"),
    "groupIcon": MessageLookupByLibrary.simpleMessage("그룹 아이콘"),
    "groupInfo": MessageLookupByLibrary.simpleMessage("그룹 정보"),
    "groupMembers": MessageLookupByLibrary.simpleMessage("그룹 멤버"),
    "groupName": MessageLookupByLibrary.simpleMessage("그룹 이름"),
    "groupParticipants": MessageLookupByLibrary.simpleMessage("그룹 참가자"),
    "groupSettings": MessageLookupByLibrary.simpleMessage("그룹 설정"),
    "groupWith": MessageLookupByLibrary.simpleMessage("그룹과 함께"),
    "harassmentOrBullyingDescription": MessageLookupByLibrary.simpleMessage(
      "괴롭힘 또는 괴롭힘: 이 옵션은 사용자가 자신이나 다른 사람을 괴롭히거나 협박하는 개인을 신고하는 데 사용됩니다.",
    ),
    "help": MessageLookupByLibrary.simpleMessage("도움말"),
    "hiIamUse": MessageLookupByLibrary.simpleMessage("안녕하세요, 사용 중입니다"),
    "highQuality": MessageLookupByLibrary.simpleMessage("높은 화질"),
    "id": MessageLookupByLibrary.simpleMessage("ID"),
    "ifThisOptionDisabledTheCreateChatBroadcastWillBeBlocked":
        MessageLookupByLibrary.simpleMessage("이 옵션이 비활성화된 경우 채팅 방송 생성이 차단됩니다"),
    "ifThisOptionDisabledTheCreateChatGroupsWillBeBlocked":
        MessageLookupByLibrary.simpleMessage("이 옵션이 비활성화된 경우 채팅 그룹 생성이 차단됩니다"),
    "ifThisOptionDisabledTheDesktopLoginOrRegisterWindowsMacWillBeBlocked":
        MessageLookupByLibrary.simpleMessage(
          "이 옵션이 비활성화된 경우 데스크톱 로그인 또는 등록 (Windows 및 macOS)이 차단됩니다",
        ),
    "ifThisOptionDisabledTheMobileLoginOrRegisterWillBeBlockedOnAndroidIosOnly":
        MessageLookupByLibrary.simpleMessage(
          "이 옵션이 활성화된 경우 Google 광고 배너가 채팅에 표시됩니다",
        ),
    "ifThisOptionDisabledTheSendChatFilesImageVideosAndLocationWillBeBlocked":
        MessageLookupByLibrary.simpleMessage(
          "이 옵션이 비활성화된 경우 채팅 파일, 이미지, 비디오 및 위치 전송이 차단됩니다",
        ),
    "ifThisOptionDisabledTheWebLoginOrRegisterWillBeBlocked":
        MessageLookupByLibrary.simpleMessage(
          "이 옵션이 비활성화된 경우 웹 로그인 또는 등록이 차단됩니다",
        ),
    "ifThisOptionEnabledTheGoogleAdsBannerWillAppearInChats":
        MessageLookupByLibrary.simpleMessage(
          "이 옵션이 활성화되면 Google 광고 배너가 채팅에 나타납니다.",
        ),
    "ifThisOptionEnabledTheVideoAndVoiceCallWillBeAllowed":
        MessageLookupByLibrary.simpleMessage("이 옵션이 활성화되면 비디오 및 음성 통화가 허용됩니다"),
    "image": MessageLookupByLibrary.simpleMessage("이미지"),
    "imageInfo": MessageLookupByLibrary.simpleMessage("이미지 정보"),
    "imageMessages": MessageLookupByLibrary.simpleMessage("이미지 메시지"),
    "images": MessageLookupByLibrary.simpleMessage("이미지"),
    "inAppAlerts": MessageLookupByLibrary.simpleMessage("앱 내 알림"),
    "inCall": MessageLookupByLibrary.simpleMessage("통화 중"),
    "inappropriateContentDescription": MessageLookupByLibrary.simpleMessage(
      "부적절한 콘텐츠: 사용자는 성적으로 음란한 자료, 혐오 발언 또는 공동체 기준을 위반하는 기타 콘텐츠를 신고하기 위해이 옵션을 선택할 수 있습니다.",
    ),
    "info": MessageLookupByLibrary.simpleMessage("정보"),
    "infoMessages": MessageLookupByLibrary.simpleMessage("정보 메시지"),
    "invalidCode": MessageLookupByLibrary.simpleMessage("유효하지 않은 코드"),
    "invalidEmail": MessageLookupByLibrary.simpleMessage("유효한 이메일을 입력하세요"),
    "invalidLoginData": MessageLookupByLibrary.simpleMessage("유효하지 않은 로그인 데이터"),
    "invalidVerificationCode": MessageLookupByLibrary.simpleMessage(
      "입력하신 인증 코드가 유효하지 않습니다. 확인 후 다시 시도해 주세요.",
    ),
    "ios": MessageLookupByLibrary.simpleMessage("iOS"),
    "isPrime": MessageLookupByLibrary.simpleMessage("소수인가요?"),
    "joinCall": MessageLookupByLibrary.simpleMessage("통화 참여"),
    "joinedAt": MessageLookupByLibrary.simpleMessage("가입 일자"),
    "joinedBy": MessageLookupByLibrary.simpleMessage("가입한 사람:"),
    "kickMember": MessageLookupByLibrary.simpleMessage("멤버 퇴출"),
    "kickedBy": MessageLookupByLibrary.simpleMessage("강퇴한 사람:"),
    "language": MessageLookupByLibrary.simpleMessage("언어"),
    "lastActiveFrom": MessageLookupByLibrary.simpleMessage("마지막 활동 일시"),
    "leaveCall": MessageLookupByLibrary.simpleMessage("통화 나가기"),
    "leaveGroup": MessageLookupByLibrary.simpleMessage("그룹 나가기"),
    "leaveGroupAndDeleteYourMessageCopy": MessageLookupByLibrary.simpleMessage(
      "그룹 나가기 및 내 메시지 사본 삭제",
    ),
    "left": MessageLookupByLibrary.simpleMessage("남음"),
    "leftTheGroup": MessageLookupByLibrary.simpleMessage("그룹에서 나감"),
    "linkADeviceSoon": MessageLookupByLibrary.simpleMessage("기기 연결 (곧)"),
    "linkByQrCode": MessageLookupByLibrary.simpleMessage("QR 코드로 연결"),
    "linkedDevices": MessageLookupByLibrary.simpleMessage("연결된 기기"),
    "links": MessageLookupByLibrary.simpleMessage("링크"),
    "loadFailed": MessageLookupByLibrary.simpleMessage("로드 실패"),
    "loading": MessageLookupByLibrary.simpleMessage("로딩 중..."),
    "loadingVideo": MessageLookupByLibrary.simpleMessage("비디오 로딩 중..."),
    "loadingViewers": MessageLookupByLibrary.simpleMessage("시청자 로딩 중..."),
    "location": MessageLookupByLibrary.simpleMessage("위치"),
    "locationFallback": MessageLookupByLibrary.simpleMessage("위치"),
    "locationMessages": MessageLookupByLibrary.simpleMessage("위치 메시지"),
    "logOut": MessageLookupByLibrary.simpleMessage("로그아웃"),
    "login": MessageLookupByLibrary.simpleMessage("로그인"),
    "loginAgain": MessageLookupByLibrary.simpleMessage("다시 로그인하세요!"),
    "loginNowAllowedNowPleaseTryAgainLater":
        MessageLookupByLibrary.simpleMessage(
          "현재 로그인이 허용되지 않았습니다. 나중에 다시 시도하세요.",
        ),
    "loginSuccessful": MessageLookupByLibrary.simpleMessage("로그인 성공!"),
    "logoutFromAllDevices": MessageLookupByLibrary.simpleMessage(
      "모든 기기에서 로그아웃하시겠습니까?",
    ),
    "lowQuality": MessageLookupByLibrary.simpleMessage("낮은 화질"),
    "macOs": MessageLookupByLibrary.simpleMessage("macOS"),
    "makeCall": MessageLookupByLibrary.simpleMessage("통화 시작"),
    "media": MessageLookupByLibrary.simpleMessage("미디어"),
    "mediaLinksAndDocs": MessageLookupByLibrary.simpleMessage("미디어, 링크 및 문서"),
    "mediumQuality": MessageLookupByLibrary.simpleMessage("보통 화질"),
    "member": MessageLookupByLibrary.simpleMessage("멤버"),
    "members": MessageLookupByLibrary.simpleMessage("멤버"),
    "messageCounter": MessageLookupByLibrary.simpleMessage("메시지 카운터"),
    "messageHasBeenDeleted": MessageLookupByLibrary.simpleMessage(
      "메시지가 삭제되었습니다",
    ),
    "messageHasBeenViewed": MessageLookupByLibrary.simpleMessage(
      "메시지가 확인되었습니다",
    ),
    "messageInfo": MessageLookupByLibrary.simpleMessage("메시지 정보"),
    "messagePrivatelyWithFriendsAndFamily":
        MessageLookupByLibrary.simpleMessage(
          "브라우저를 사용하여 친구 및 가족과 개인 메시지를 보냅니다.",
        ),
    "messages": MessageLookupByLibrary.simpleMessage("메시지"),
    "microphoneAndCameraPermissionMustBeAccepted":
        MessageLookupByLibrary.simpleMessage(
          "Microphone and camera permission must be accepted",
        ),
    "microphoneOff": MessageLookupByLibrary.simpleMessage("마이크 끄기"),
    "microphoneOn": MessageLookupByLibrary.simpleMessage("마이크 켜기"),
    "microphonePermissionMustBeAccepted": MessageLookupByLibrary.simpleMessage(
      "Microphone permission must be accepted",
    ),
    "microsoftWindows": MessageLookupByLibrary.simpleMessage(
      "Microsoft Windows",
    ),
    "minutes": MessageLookupByLibrary.simpleMessage("분"),
    "more": MessageLookupByLibrary.simpleMessage("더 보기"),
    "mute": MessageLookupByLibrary.simpleMessage("음소거"),
    "muteNotifications": MessageLookupByLibrary.simpleMessage("알림 음소거"),
    "myPrivacy": MessageLookupByLibrary.simpleMessage("개인 정보"),
    "name": MessageLookupByLibrary.simpleMessage("이름"),
    "nameMustHaveValue": MessageLookupByLibrary.simpleMessage("이름은 값을 가져야 합니다"),
    "nameRequired": MessageLookupByLibrary.simpleMessage("이름은 필수 항목입니다"),
    "needHelp": MessageLookupByLibrary.simpleMessage("도움이 필요하신가요?"),
    "needNewAccount": MessageLookupByLibrary.simpleMessage("새 계정이 필요합니까?"),
    "networkError": MessageLookupByLibrary.simpleMessage(
      "네트워크 오류. 연결을 확인하고 다시 시도해 주세요.",
    ),
    "networkPoor": MessageLookupByLibrary.simpleMessage("네트워크 연결이 나쁩니다"),
    "newBroadcast": MessageLookupByLibrary.simpleMessage("새로운 방송"),
    "newGroup": MessageLookupByLibrary.simpleMessage("새 그룹"),
    "newPassword": MessageLookupByLibrary.simpleMessage("새 비밀번호"),
    "newPasswordMustHaveValue": MessageLookupByLibrary.simpleMessage(
      "새 비밀번호는 값을 가져야 합니다",
    ),
    "newUpdateIsAvailable": MessageLookupByLibrary.simpleMessage(
      "새 업데이트가 있습니다",
    ),
    "next": MessageLookupByLibrary.simpleMessage("다음"),
    "nickname": MessageLookupByLibrary.simpleMessage("닉네임"),
    "no": MessageLookupByLibrary.simpleMessage("아니요"),
    "noBio": MessageLookupByLibrary.simpleMessage("자기 소개 없음"),
    "noCodeHasBeenSendToYouToVerifyYourEmail":
        MessageLookupByLibrary.simpleMessage("귀하의 이메일을 확인하기 위한 코드가 전송되지 않았습니다"),
    "noCustomSettings": MessageLookupByLibrary.simpleMessage("사용자 정의 설정 없음"),
    "noData": MessageLookupByLibrary.simpleMessage("데이터 없음"),
    "noMediaFound": MessageLookupByLibrary.simpleMessage("미디어를 찾을 수 없음"),
    "noUpdatesAvailableNow": MessageLookupByLibrary.simpleMessage("현재 업데이트 없음"),
    "noViewersYet": MessageLookupByLibrary.simpleMessage("아직 시청자가 없습니다"),
    "none": MessageLookupByLibrary.simpleMessage("없음"),
    "notAccepted": MessageLookupByLibrary.simpleMessage("미수락됨"),
    "notification": MessageLookupByLibrary.simpleMessage("알림"),
    "notificationDescription": MessageLookupByLibrary.simpleMessage("알림 설명"),
    "notificationTitle": MessageLookupByLibrary.simpleMessage("알림 제목"),
    "notificationsPage": MessageLookupByLibrary.simpleMessage("알림 페이지"),
    "nowYouLoginAsReadOnlyAdminAllEditYouDoneWillNotAppliedDueToThisIsTestVersion":
        MessageLookupByLibrary.simpleMessage(
          "현재 읽기 전용 관리자로 로그인되었습니다. 이것은 테스트 버전이므로 수행한 모든 편집은 적용되지 않습니다.",
        ),
    "off": MessageLookupByLibrary.simpleMessage("끄기"),
    "offline": MessageLookupByLibrary.simpleMessage("오프라인"),
    "ok": MessageLookupByLibrary.simpleMessage("확인"),
    "oldPassword": MessageLookupByLibrary.simpleMessage("이전 비밀번호"),
    "on": MessageLookupByLibrary.simpleMessage("켜기"),
    "oneSeenMessage": MessageLookupByLibrary.simpleMessage("한 번 본 메시지"),
    "oneTimeSeen": MessageLookupByLibrary.simpleMessage("한 번 확인됨"),
    "online": MessageLookupByLibrary.simpleMessage("온라인"),
    "openAppOnYourPhoneInstructions": MessageLookupByLibrary.simpleMessage(
      "1. 휴대전화에서 앱을 엽니다. Android에서는 설정을, iPhone에서는 설정을 누릅니다. 연결된 기기를 누른 다음 기기 연결을 누릅니다. 이 화면을 스캔하려면 휴대전화를 이 화면에 가져다 대세요.",
    ),
    "orLoginWith": MessageLookupByLibrary.simpleMessage("또는 다음으로 로그인:"),
    "original": MessageLookupByLibrary.simpleMessage("원본"),
    "originalFileSize": MessageLookupByLibrary.simpleMessage("원본"),
    "other": MessageLookupByLibrary.simpleMessage("기타"),
    "otherCategoryDescription": MessageLookupByLibrary.simpleMessage(
      "기타: 이 옵션은 위의 카테고리에 쉽게 포함되지 않는 위반 사항에 사용할 수 있습니다. 사용자가 추가 세부 정보를 제공할 수 있도록 텍스트 상자를 포함하는 것이 도움이 될 수 있습니다.",
    ),
    "otpCode": MessageLookupByLibrary.simpleMessage("OTP 코드"),
    "participantCount": m2,
    "password": MessageLookupByLibrary.simpleMessage("비밀번호"),
    "passwordHasBeenChanged": MessageLookupByLibrary.simpleMessage(
      "비밀번호가 변경되었습니다",
    ),
    "passwordIsRequired": MessageLookupByLibrary.simpleMessage("비밀번호 필수"),
    "passwordMustHaveValue": MessageLookupByLibrary.simpleMessage(
      "비밀번호는 값을 가져야 합니다",
    ),
    "passwordNotMatch": MessageLookupByLibrary.simpleMessage("비밀번호가 일치하지 않습니다"),
    "passwordRequired": MessageLookupByLibrary.simpleMessage("비밀번호는 필수 항목입니다"),
    "passwordTooShort": MessageLookupByLibrary.simpleMessage(
      "비밀번호는 8자 이상이어야 합니다",
    ),
    "passwordsDontMatch": MessageLookupByLibrary.simpleMessage(
      "비밀번호가 일치하지 않습니다",
    ),
    "peerUserDeviceOffline": MessageLookupByLibrary.simpleMessage(
      "피어 사용자의 기기 오프라인 상태",
    ),
    "peerUserInCallNow": MessageLookupByLibrary.simpleMessage("현재 통화 중인 사용자"),
    "pending": MessageLookupByLibrary.simpleMessage("보류 중"),
    "permissionDenied": MessageLookupByLibrary.simpleMessage("권한이 거부됨"),
    "phone": MessageLookupByLibrary.simpleMessage("전화"),
    "phoneNumber": MessageLookupByLibrary.simpleMessage("전화번호"),
    "phoneNumberNotValid": MessageLookupByLibrary.simpleMessage(
      "전화번호가 유효하지 않습니다",
    ),
    "pleaseEnterValid6DigitCode": MessageLookupByLibrary.simpleMessage(
      "유효한 6자리 코드를 입력해 주세요",
    ),
    "pleaseEnterValidCode": MessageLookupByLibrary.simpleMessage(
      "유효한 6자리 코드를 입력하세요",
    ),
    "pleaseEnterVerificationCode": MessageLookupByLibrary.simpleMessage(
      "인증 코드를 입력해 주세요",
    ),
    "pleaseEnterYourName": MessageLookupByLibrary.simpleMessage("이름을 입력하세요"),
    "pleaseGrantCameraPermission": MessageLookupByLibrary.simpleMessage(
      "카메라 권한을 허용해주세요",
    ),
    "pleaseGrantStoragePermission": MessageLookupByLibrary.simpleMessage(
      "저장소 권한을 허용해주세요",
    ),
    "pleaseProvideYourNameToContinue": MessageLookupByLibrary.simpleMessage(
      "계속하려면 이름을 입력하세요",
    ),
    "poor": MessageLookupByLibrary.simpleMessage("불량"),
    "preview": MessageLookupByLibrary.simpleMessage("미리보기"),
    "privacyPolicy": MessageLookupByLibrary.simpleMessage("개인 정보 보호 정책"),
    "privacyUrl": MessageLookupByLibrary.simpleMessage("개인 정보 보호 URL"),
    "processingVideoDataAndOptimizingQuality":
        MessageLookupByLibrary.simpleMessage("동영상 데이터를 처리하고 화질을 최적화하는 중..."),
    "profile": MessageLookupByLibrary.simpleMessage("프로필"),
    "promotedToAdminBy": MessageLookupByLibrary.simpleMessage("관리자로 승격한 사람:"),
    "public": MessageLookupByLibrary.simpleMessage("공개"),
    "read": MessageLookupByLibrary.simpleMessage("읽음"),
    "recent": MessageLookupByLibrary.simpleMessage("최근"),
    "recentUpdate": MessageLookupByLibrary.simpleMessage("최근 업데이트"),
    "recentUpdates": MessageLookupByLibrary.simpleMessage("최근 업데이트"),
    "reconnecting": MessageLookupByLibrary.simpleMessage("재연결 중..."),
    "recording": MessageLookupByLibrary.simpleMessage("녹음 중..."),
    "reenterNewPassword": MessageLookupByLibrary.simpleMessage(
      "새 비밀번호를 다시 입력하세요",
    ),
    "register": MessageLookupByLibrary.simpleMessage("등록"),
    "registerMethod": MessageLookupByLibrary.simpleMessage("등록 방법"),
    "registerStatus": MessageLookupByLibrary.simpleMessage("등록 상태"),
    "registrationSuccessful": MessageLookupByLibrary.simpleMessage("등록 성공!"),
    "rejected": MessageLookupByLibrary.simpleMessage("거부됨"),
    "remaining": MessageLookupByLibrary.simpleMessage("남음"),
    "repliedToYourSelf": MessageLookupByLibrary.simpleMessage("자기 자신에게 답장함"),
    "reply": MessageLookupByLibrary.simpleMessage("답장"),
    "replyToYourSelf": MessageLookupByLibrary.simpleMessage("자기 자신에게 답장"),
    "report": MessageLookupByLibrary.simpleMessage("신고"),
    "reportHasBeenSubmitted": MessageLookupByLibrary.simpleMessage(
      "신고가 제출되었습니다",
    ),
    "reportUser": MessageLookupByLibrary.simpleMessage("사용자 신고"),
    "reports": MessageLookupByLibrary.simpleMessage("리포트"),
    "resend": MessageLookupByLibrary.simpleMessage("재전송"),
    "resendInSeconds": m3,
    "resetPassword": MessageLookupByLibrary.simpleMessage("비밀번호 재설정"),
    "resetTrim": MessageLookupByLibrary.simpleMessage("트림 재설정"),
    "retry": MessageLookupByLibrary.simpleMessage("재시도"),
    "ring": MessageLookupByLibrary.simpleMessage("벨 울림"),
    "roomAlreadyInCall": MessageLookupByLibrary.simpleMessage("이미 통화 중인 방"),
    "roomCounter": MessageLookupByLibrary.simpleMessage("방 카운터"),
    "sActionPlayHint": MessageLookupByLibrary.simpleMessage("재생"),
    "sActionPreviewHint": MessageLookupByLibrary.simpleMessage("미리보기"),
    "sActionSelectHint": MessageLookupByLibrary.simpleMessage("선택"),
    "sActionSwitchPathLabel": MessageLookupByLibrary.simpleMessage("경로 전환"),
    "sActionUseCameraHint": MessageLookupByLibrary.simpleMessage("카메라 사용"),
    "sNameDurationLabel": MessageLookupByLibrary.simpleMessage("시간"),
    "sTypeAudioLabel": MessageLookupByLibrary.simpleMessage("오디오"),
    "sTypeImageLabel": MessageLookupByLibrary.simpleMessage("이미지"),
    "sTypeOtherLabel": MessageLookupByLibrary.simpleMessage("기타"),
    "sTypeVideoLabel": MessageLookupByLibrary.simpleMessage("동영상"),
    "sUnitAssetCountLabel": MessageLookupByLibrary.simpleMessage("개수"),
    "save": MessageLookupByLibrary.simpleMessage("저장"),
    "saveLogin": MessageLookupByLibrary.simpleMessage("로그인 정보 저장"),
    "saving": MessageLookupByLibrary.simpleMessage("저장 중..."),
    "search": MessageLookupByLibrary.simpleMessage("검색"),
    "searchByUserFullEmail": MessageLookupByLibrary.simpleMessage("전체 이메일로 검색"),
    "searchByUserNameOrFullUserEmail": MessageLookupByLibrary.simpleMessage(
      "사용자 이름 또는 전체 이메일로 검색",
    ),
    "seconds": MessageLookupByLibrary.simpleMessage("초"),
    "secureAdminAccess": MessageLookupByLibrary.simpleMessage("보안 관리자 접근"),
    "select": MessageLookupByLibrary.simpleMessage("선택"),
    "selectMedia": MessageLookupByLibrary.simpleMessage("미디어 선택"),
    "selectPhotos": MessageLookupByLibrary.simpleMessage("사진 선택"),
    "selectVideos": MessageLookupByLibrary.simpleMessage("동영상 선택"),
    "selectedLocation": MessageLookupByLibrary.simpleMessage("선택된 위치"),
    "send": MessageLookupByLibrary.simpleMessage("보내기"),
    "sendCodeToMyEmail": MessageLookupByLibrary.simpleMessage("이메일로 코드 보내기"),
    "sendMessage": MessageLookupByLibrary.simpleMessage("메시지 보내기"),
    "sendOriginalVideoWithoutCompression": MessageLookupByLibrary.simpleMessage(
      "압축 없이 원본 동영상 전송",
    ),
    "sendVerificationCode": MessageLookupByLibrary.simpleMessage("인증 코드 보내기"),
    "sentSixDigitCode": m4,
    "serverRestart": MessageLookupByLibrary.simpleMessage("서버 재시작"),
    "sessionEnd": MessageLookupByLibrary.simpleMessage("세션 종료"),
    "setMaxBroadcastMembers": MessageLookupByLibrary.simpleMessage(
      "최대 방송 멤버 설정",
    ),
    "setMaxGroupMembers": MessageLookupByLibrary.simpleMessage("최대 그룹 멤버 설정"),
    "setMaxMessageForwardAndShare": MessageLookupByLibrary.simpleMessage(
      "최대 메시지 전달 및 공유 설정",
    ),
    "setNewPrivacyPolicyUrl": MessageLookupByLibrary.simpleMessage(
      "새 개인 정보 보호 정책 URL 설정",
    ),
    "setToAdmin": MessageLookupByLibrary.simpleMessage("관리자로 설정"),
    "settings": MessageLookupByLibrary.simpleMessage("설정"),
    "share": MessageLookupByLibrary.simpleMessage("공유"),
    "shareImage": MessageLookupByLibrary.simpleMessage("이미지 공유"),
    "shareMediaAndLocation": MessageLookupByLibrary.simpleMessage(
      "미디어 및 위치 공유",
    ),
    "shareYourStatus": MessageLookupByLibrary.simpleMessage("상태 공유"),
    "showHistory": MessageLookupByLibrary.simpleMessage("기록 보기"),
    "showMedia": MessageLookupByLibrary.simpleMessage("미디어 표시"),
    "skipCompression": MessageLookupByLibrary.simpleMessage("압축 건너뛰기"),
    "smallFileSizeFasterUploadLow": MessageLookupByLibrary.simpleMessage(
      "작은 파일 크기, 빠른 업로드",
    ),
    "smallestFileSizeFasterUpload": MessageLookupByLibrary.simpleMessage(
      "가장 작은 파일 크기, 빠른 업로드",
    ),
    "soon": MessageLookupByLibrary.simpleMessage("곧"),
    "spamOrScamDescription": MessageLookupByLibrary.simpleMessage(
      "스팸 또는 사기: 이 옵션은 스팸 메시지, 무단 광고 메시지를 보내는 계정 또는 다른 사람을 사기치려고 하는 계정을 신고하는 데 사용됩니다.",
    ),
    "speakerOff": MessageLookupByLibrary.simpleMessage("스피커 끄기"),
    "speakerOn": MessageLookupByLibrary.simpleMessage("스피커 켜기"),
    "star": MessageLookupByLibrary.simpleMessage("별표"),
    "starMessage": MessageLookupByLibrary.simpleMessage("메시지에 별표"),
    "starredMessage": MessageLookupByLibrary.simpleMessage("별표 표시된 메시지"),
    "starredMessages": MessageLookupByLibrary.simpleMessage("스타된 메시지"),
    "startChat": MessageLookupByLibrary.simpleMessage("채팅 시작"),
    "startNewChatWithYou": MessageLookupByLibrary.simpleMessage(
      "당신과 새로운 채팅 시작",
    ),
    "status": MessageLookupByLibrary.simpleMessage("상태"),
    "storageAndData": MessageLookupByLibrary.simpleMessage("저장 및 데이터"),
    "storeUrls": MessageLookupByLibrary.simpleMessage("스토어 URL"),
    "stories": MessageLookupByLibrary.simpleMessage("스토리"),
    "storyCreatedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "스토리가 성공적으로 만들어졌습니다",
    ),
    "storyViewers": MessageLookupByLibrary.simpleMessage("스토리 시청자"),
    "success": MessageLookupByLibrary.simpleMessage("성공"),
    "successfullyDownloadedIn": MessageLookupByLibrary.simpleMessage(
      "다음 위치에 성공적으로 다운로드됨",
    ),
    "supportChatSoon": MessageLookupByLibrary.simpleMessage("지원 채팅 (곧)"),
    "switchCamera": MessageLookupByLibrary.simpleMessage("카메라 전환"),
    "syncContacts": MessageLookupByLibrary.simpleMessage("연락처 동기화"),
    "systemConfiguration": MessageLookupByLibrary.simpleMessage("시스템 구성"),
    "tapADeviceToEditOrLogOut": MessageLookupByLibrary.simpleMessage(
      "편집 또는 로그아웃하려면 기기를 탭하세요.",
    ),
    "tapForPhoto": MessageLookupByLibrary.simpleMessage("사진을 보려면 탭하세요"),
    "tapToOpenInMaps": MessageLookupByLibrary.simpleMessage("지도에서 열려면 탭하세요"),
    "tapToSelectAnIcon": MessageLookupByLibrary.simpleMessage(
      "아이콘 선택을 위해 탭하세요",
    ),
    "tapToSwapVideo": MessageLookupByLibrary.simpleMessage("탭하여 비디오 위치 교체"),
    "tellAFriend": MessageLookupByLibrary.simpleMessage("친구에게 알리기"),
    "textFieldHint": MessageLookupByLibrary.simpleMessage("메시지 입력..."),
    "textMessages": MessageLookupByLibrary.simpleMessage("텍스트 메시지"),
    "thereIsFileHasSizeBiggerThanAllowedSize":
        MessageLookupByLibrary.simpleMessage("허용된 크기보다 큰 파일이 있습니다"),
    "thereIsVideoSizeBiggerThanAllowedSize":
        MessageLookupByLibrary.simpleMessage("허용된 크기보다 큰 비디오가 있습니다"),
    "timeout": MessageLookupByLibrary.simpleMessage("시간 초과"),
    "titleIsRequired": MessageLookupByLibrary.simpleMessage("제목은 필수 항목입니다"),
    "today": MessageLookupByLibrary.simpleMessage("오늘"),
    "toggleTheme": MessageLookupByLibrary.simpleMessage("테마 전환"),
    "tooManyAttempts": MessageLookupByLibrary.simpleMessage(
      "너무 많은 시도. 나중에 다시 시도해 주세요.",
    ),
    "total": MessageLookupByLibrary.simpleMessage("총"),
    "totalMessages": MessageLookupByLibrary.simpleMessage("총 메시지 수"),
    "totalRooms": MessageLookupByLibrary.simpleMessage("총 방 수"),
    "totalVisits": MessageLookupByLibrary.simpleMessage("총 방문수"),
    "translate": MessageLookupByLibrary.simpleMessage("번역"),
    "trimmed": MessageLookupByLibrary.simpleMessage("트림됨"),
    "typing": MessageLookupByLibrary.simpleMessage("입력 중..."),
    "ultraLowQuality": MessageLookupByLibrary.simpleMessage("초저화질"),
    "unBlock": MessageLookupByLibrary.simpleMessage("차단 해제"),
    "unBlockUser": MessageLookupByLibrary.simpleMessage("사용자 차단 해제"),
    "unMute": MessageLookupByLibrary.simpleMessage("음소거 해제"),
    "unStar": MessageLookupByLibrary.simpleMessage("스타 해제"),
    "unSupportedAssetType": MessageLookupByLibrary.simpleMessage(
      "지원되지 않는 파일 형식",
    ),
    "unableToAccessAll": MessageLookupByLibrary.simpleMessage(
      "모든 사진에 액세스할 수 없음",
    ),
    "unknown": MessageLookupByLibrary.simpleMessage("알 수 없음"),
    "update": MessageLookupByLibrary.simpleMessage("업데이트"),
    "updateBroadcastTitle": MessageLookupByLibrary.simpleMessage("방송 제목 업데이트"),
    "updateFeedBackEmail": MessageLookupByLibrary.simpleMessage("피드백 이메일 업데이트"),
    "updateGroupDescription": MessageLookupByLibrary.simpleMessage(
      "그룹 설명 업데이트",
    ),
    "updateGroupDescriptionWillUpdateAllGroupMembers":
        MessageLookupByLibrary.simpleMessage("그룹 설명을 업데이트하면 모든 그룹 멤버가 업데이트됩니다"),
    "updateGroupTitle": MessageLookupByLibrary.simpleMessage("그룹 제목 업데이트"),
    "updateImage": MessageLookupByLibrary.simpleMessage("이미지 업데이트"),
    "updateNickname": MessageLookupByLibrary.simpleMessage("닉네임 업데이트"),
    "updateTitle": MessageLookupByLibrary.simpleMessage("제목 업데이트"),
    "updateTitleTo": MessageLookupByLibrary.simpleMessage("제목 업데이트"),
    "updateYourBio": MessageLookupByLibrary.simpleMessage("자기 소개 업데이트"),
    "updateYourName": MessageLookupByLibrary.simpleMessage("이름 업데이트"),
    "updateYourPassword": MessageLookupByLibrary.simpleMessage("비밀번호 업데이트"),
    "updateYourProfile": MessageLookupByLibrary.simpleMessage("프로필 업데이트"),
    "updatedAt": MessageLookupByLibrary.simpleMessage("업데이트 시간"),
    "upgradeToAdmin": MessageLookupByLibrary.simpleMessage("관리자로 업그레이드"),
    "userAction": MessageLookupByLibrary.simpleMessage("사용자 작업"),
    "userAlreadyRegister": MessageLookupByLibrary.simpleMessage(
      "사용자가 이미 등록되었습니다",
    ),
    "userAnalytics": MessageLookupByLibrary.simpleMessage("사용자 분석"),
    "userDeviceSessionEndDeviceDeleted": MessageLookupByLibrary.simpleMessage(
      "사용자 기기 세션이 종료되었으며 기기가 삭제되었습니다",
    ),
    "userEmailNotFound": MessageLookupByLibrary.simpleMessage(
      "사용자 이메일을 찾을 수 없습니다",
    ),
    "userInfo": MessageLookupByLibrary.simpleMessage("사용자 정보"),
    "userJoined": MessageLookupByLibrary.simpleMessage("사용자가 통화에 참여했습니다"),
    "userLeft": MessageLookupByLibrary.simpleMessage("사용자가 통화를 나갔습니다"),
    "userName": MessageLookupByLibrary.simpleMessage("사용자 이름"),
    "userPage": MessageLookupByLibrary.simpleMessage("사용자 페이지"),
    "userProfile": MessageLookupByLibrary.simpleMessage("사용자 프로필"),
    "userRegisterStatus": MessageLookupByLibrary.simpleMessage("사용자 등록 상태"),
    "userRegisterStatusNotAcceptedYet": MessageLookupByLibrary.simpleMessage(
      "사용자 등록 상태가 아직 승인되지 않았습니다",
    ),
    "users": MessageLookupByLibrary.simpleMessage("사용자"),
    "usersAddedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "사용자가 성공적으로 추가되었습니다",
    ),
    "vMessageInfoTrans": MessageLookupByLibrary.simpleMessage("메시지 정보"),
    "vMessagesInfoTrans": MessageLookupByLibrary.simpleMessage("메시지 정보"),
    "verificationFailed": m5,
    "verificationSessionExpired": MessageLookupByLibrary.simpleMessage(
      "인증 세션이 만료되었습니다. 새 코드를 요청해 주세요.",
    ),
    "verificationTimedOut": MessageLookupByLibrary.simpleMessage(
      "인증 시간이 초과되었습니다. 다시 시도해 주세요.",
    ),
    "verified": MessageLookupByLibrary.simpleMessage("인증됨"),
    "verifiedAt": MessageLookupByLibrary.simpleMessage("인증됨"),
    "verify": MessageLookupByLibrary.simpleMessage("확인"),
    "veryBad": MessageLookupByLibrary.simpleMessage("매우 나쁨"),
    "veryLowQuality": MessageLookupByLibrary.simpleMessage("매우 낮은 화질"),
    "verySmallFileSize": MessageLookupByLibrary.simpleMessage("매우 작은 파일 크기"),
    "video": MessageLookupByLibrary.simpleMessage("비디오"),
    "videoCallMessages": MessageLookupByLibrary.simpleMessage("비디오 통화 메시지"),
    "videoCallMode": MessageLookupByLibrary.simpleMessage("비디오 통화 모드"),
    "videoCompression": MessageLookupByLibrary.simpleMessage("동영상 압축"),
    "videoCompressionFailed": m6,
    "videoMessages": MessageLookupByLibrary.simpleMessage("비디오 메시지"),
    "videoTrimmer": MessageLookupByLibrary.simpleMessage("비디오 트리머"),
    "viewingLimitedAssetsTip": MessageLookupByLibrary.simpleMessage(
      "앱에서 액세스할 수 있는 사진과 동영상만 표시됩니다.",
    ),
    "visits": MessageLookupByLibrary.simpleMessage("방문"),
    "voiceCall": MessageLookupByLibrary.simpleMessage("음성 통화"),
    "voiceCallMessage": MessageLookupByLibrary.simpleMessage("음성 통화 메시지"),
    "voiceCallMessages": MessageLookupByLibrary.simpleMessage("음성 통화 메시지"),
    "voiceMessages": MessageLookupByLibrary.simpleMessage("음성 메시지"),
    "wait2MinutesToSendMail": MessageLookupByLibrary.simpleMessage(
      "이메일을 보내려면 2분을 기다려야 합니다",
    ),
    "waitingList": MessageLookupByLibrary.simpleMessage("대기 목록"),
    "weHighRecommendToDownloadThisUpdate": MessageLookupByLibrary.simpleMessage(
      "이 업데이트를 다운로드하는 것을 강력히 권장합니다",
    ),
    "weWillSendYouAVerificationCode": MessageLookupByLibrary.simpleMessage(
      "인증 코드를 보내드립니다",
    ),
    "web": MessageLookupByLibrary.simpleMessage("웹"),
    "webChat": MessageLookupByLibrary.simpleMessage("웹 채팅"),
    "welcome": MessageLookupByLibrary.simpleMessage("환영합니다"),
    "welcomeBack": MessageLookupByLibrary.simpleMessage("다시 오신 것을 환영합니다"),
    "whenUsingMobileData": MessageLookupByLibrary.simpleMessage("모바일 데이터 사용 시"),
    "whenUsingWifi": MessageLookupByLibrary.simpleMessage("Wi-Fi 사용 시"),
    "whileAuthCanFindYou": MessageLookupByLibrary.simpleMessage(
      "인증 중에 귀하를 찾을 수 없습니다",
    ),
    "windows": MessageLookupByLibrary.simpleMessage("Windows"),
    "writeACaption": MessageLookupByLibrary.simpleMessage("캡션 쓰기..."),
    "x": MessageLookupByLibrary.simpleMessage("x"),
    "yes": MessageLookupByLibrary.simpleMessage("예"),
    "yesterday": MessageLookupByLibrary.simpleMessage("어제"),
    "you": MessageLookupByLibrary.simpleMessage("당신"),
    "youAreAboutToDeleteThisUserFromYourList":
        MessageLookupByLibrary.simpleMessage("이 사용자를 목록에서 삭제하려고 합니다"),
    "youAreAboutToDeleteYourAccountYourAccountWillNotAppearAgainInUsersList":
        MessageLookupByLibrary.simpleMessage(
          "계정을 삭제하려고 합니다. 계정은 사용자 목록에 다시 나타나지 않습니다",
        ),
    "youAreAboutToDismissesToMember": MessageLookupByLibrary.simpleMessage(
      "멤버를 내리려고 합니다",
    ),
    "youAreAboutToKick": MessageLookupByLibrary.simpleMessage("멤버를 퇴출하려고 합니다"),
    "youAreAboutToUpgradeToAdmin": MessageLookupByLibrary.simpleMessage(
      "관리자로 업그레이드하려고 합니다",
    ),
    "youDontHaveAccess": MessageLookupByLibrary.simpleMessage("접근 권한이 없습니다"),
    "youInPublicSearch": MessageLookupByLibrary.simpleMessage("공개 검색에서 당신"),
    "youNotParticipantInThisGroup": MessageLookupByLibrary.simpleMessage(
      "이 그룹에 참가자가 아닙니다",
    ),
    "yourAccountBlocked": MessageLookupByLibrary.simpleMessage(
      "귀하의 계정이 차단되었습니다",
    ),
    "yourAccountDeleted": MessageLookupByLibrary.simpleMessage(
      "귀하의 계정이 삭제되었습니다",
    ),
    "yourAccountIsUnderReview": MessageLookupByLibrary.simpleMessage(
      "귀하의 계정은 검토 중입니다",
    ),
    "yourAreAboutToLogoutFromThisAccount": MessageLookupByLibrary.simpleMessage(
      "이 계정에서 로그아웃하려고 합니다",
    ),
    "yourLastSeen": MessageLookupByLibrary.simpleMessage("마지막으로 본 시간"),
    "yourLastSeenInChats": MessageLookupByLibrary.simpleMessage(
      "채팅에서 마지막으로 본 시간",
    ),
    "yourProfileAppearsInPublicSearchAndAddingForGroups":
        MessageLookupByLibrary.simpleMessage("귀하의 프로필은 공개 검색 및 그룹 추가에 표시됩니다"),
    "yourSessionIsEndedPleaseLoginAgain": MessageLookupByLibrary.simpleMessage(
      "세션이 종료되었습니다. 다시 로그인하세요!",
    ),
    "yourStory": MessageLookupByLibrary.simpleMessage("당신의 스토리"),
  };
}
