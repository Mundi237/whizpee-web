import UIKit
import Foundation
import GoogleMaps
import flutter_local_notifications
import CallKit
import AVFAudio
import PushKit
import Flutter
import flutter_callkit_incoming
import Firebase
import FirebaseMessaging
// Note: Firebase is initialized from Flutter side, DO NOT call FirebaseApp.configure() here


@main
@objc class AppDelegate: FlutterAppDelegate, PKPushRegistryDelegate, CallkitIncomingAppDelegate, MessagingDelegate {

    // MARK: - Properties
    private var methodChannel: FlutterMethodChannel?
    private let channelName = "com.superup.call/navigation"
    private var isCallHandledFromBackground = false
    private var pendingCallModel: [String: Any]?
    private var lastAcceptedCallId: String?
    private var lastAcceptedCallTime: Date?

    // MARK: - Application Lifecycle
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        // Firebase is already configured from Flutter side, so we don't call FirebaseApp.configure() here

        // Setup notification delegate
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        }

        // Setup Firebase Messaging delegate
        Messaging.messaging().delegate = self

        // Configure Google Maps
        GMSServices.provideAPIKey("AIzaSyAP-yGIutctMXp1JWyxqzwWdi8prKzYeQg")

        // Setup Flutter method channel for navigation
        setupMethodChannel()

        // Setup VOIP Push Registry
        setupVoIPPushRegistry()

        // Register for remote notifications
        application.registerForRemoteNotifications()

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // MARK: - Method Channel Setup
    private func setupMethodChannel() {
        guard let controller = window?.rootViewController as? FlutterViewController else {
            print("Failed to get FlutterViewController")
            return
        }

        let binaryMessenger = controller.binaryMessenger
        methodChannel = FlutterMethodChannel(name: channelName, binaryMessenger: binaryMessenger)

        methodChannel?.setMethodCallHandler { [weak self] (call, result) in
            switch call.method {
            case "navigateToCall":
                // Handle navigation from Flutter side if needed
                result(true)
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }

    // MARK: - VoIP Push Setup
    private func setupVoIPPushRegistry() {
        let mainQueue = DispatchQueue.main
        let voipRegistry = PKPushRegistry(queue: mainQueue)
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = [.voIP]
    }

    // MARK: - PKPushRegistryDelegate
    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
        let deviceToken = credentials.token.map { String(format: "%02x", $0) }.joined()
        print("VoIP token updated: \(deviceToken)")
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.setDevicePushTokenVoIP(deviceToken)
    }

    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        print("VoIP token invalidated")
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.setDevicePushTokenVoIP("")
    }

    // Handle incoming VoIP pushes
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        print("Received VoIP push notification")
        guard type == .voIP else {
            completion()
            return
        }

        // Check if this is an ending call notification
        let isEnding = payload.dictionaryPayload["is_ending"] as? Bool ?? false

        if isEnding {
            print("Received call ending notification - ending all calls")
            // End all ongoing calls
            SwiftFlutterCallkitIncomingPlugin.sharedInstance?.endAllCalls()

            // Complete the push handling immediately
            completion()
            return
        }

        // Extract call data from payload for incoming call
        let callData = extractCallData(from: payload)

        // Store call data for background handling
        if UIApplication.shared.applicationState != .active {
            isCallHandledFromBackground = true
            pendingCallModel = callData.extra as? [String: Any]
        }

        // Show CallKit UI for incoming call
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.showCallkitIncoming(callData, fromPushKit: true)

        // Complete the push handling
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            completion()
        }
    }


    // MARK: - Call Data Extraction
    private func extractCallData(from payload: PKPushPayload) -> flutter_callkit_incoming.Data {
        let dict = payload.dictionaryPayload

        let id = dict["session_id"] as? String ?? UUID().uuidString
        let nameCaller = dict["caller_name"] as? String ?? "Unknown"
        let handle = dict["handle"] as? String ?? ""
        let callType = dict["call_type"] as? Int ?? 0

        let data = flutter_callkit_incoming.Data(
            id: id,
            nameCaller: nameCaller,
            handle: handle,
            type: callType
        )

        // Parse user_info if available
        if let userInfoString = dict["user_info"] as? String,
           let userInfoData = userInfoString.data(using: .utf8),
           let userInfoDict = try? JSONSerialization.jsonObject(with: userInfoData, options: []) as? NSDictionary {
            data.extra = userInfoDict
        } else {
            // Store raw payload data
            data.extra = dict as NSDictionary
        }

        print("Extracted call data: \(data.extra ?? [:])")
        return data
    }

    // MARK: - Call History Navigation (Recent Calls)
    override func application(_ application: UIApplication,
                              continue userActivity: NSUserActivity,
                              restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {

        guard let handleObj = userActivity.handle,
              let isVideo = userActivity.isVideo else {
            return false
        }

        let objData = handleObj.getDecryptHandle()
        let nameCaller = objData["nameCaller"] as? String ?? ""
        let handle = objData["handle"] as? String ?? ""
        let data = flutter_callkit_incoming.Data(
            id: UUID().uuidString,
            nameCaller: nameCaller,
            handle: handle,
            type: isVideo ? 1 : 0
        )

        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.startCall(data, fromPushKit: true)

        return super.application(application, continue: userActivity, restorationHandler: restorationHandler)
    }

    // MARK: - CallkitIncomingAppDelegate Methods
    func onAccept(_ call: Call, _ action: CXAnswerCallAction) {
        print("Call accepted: \(call.data.toJSON())")

        // Extract call ID for duplicate prevention
        let callInfo = convertCallDataToFlutterFormat(call.data)
        let callId = callInfo["callId"] as? String ?? ""

        // Check if this is a duplicate call within 2 seconds
        if let lastCallId = lastAcceptedCallId,
           let lastCallTime = lastAcceptedCallTime,
           lastCallId == callId,
           Date().timeIntervalSince(lastCallTime) < 2.0 {
            print("Duplicate call accept detected for \(callId), ignoring")
            action.fulfill()
            return
        }

        // Update last accepted call info
        lastAcceptedCallId = callId
        lastAcceptedCallTime = Date()

        // If app was in background, we need to launch it and navigate
        if isCallHandledFromBackground || UIApplication.shared.applicationState != .active {
            // Store only the essential call data
            UserDefaults.standard.set(callInfo, forKey: "pendingCallAccept")
            UserDefaults.standard.synchronize()

            // Launch the app if needed
            launchAppAndNavigateToCall(callData: call.data)
        } else {
            // App is already active, navigate directly
            navigateToCallScreen(callData: call.data)
        }

        // Fulfill the action
        action.fulfill()
    }

    func onDecline(_ call: Call, _ action: CXEndCallAction) {
        print("Call declined: \(call.data.toJSON())")

        let json = ["action": "DECLINE", "data": call.data.toJSON()] as [String: Any]

        // Send decline event to Flutter
        methodChannel?.invokeMethod("callDeclined", arguments: json)

        action.fulfill()
    }

    func onEnd(_ call: Call, _ action: CXEndCallAction) {
        print("Call ended: \(call.data.toJSON())")

        let json = ["action": "END", "data": call.data.toJSON()] as [String: Any]

        // Send end event to Flutter
        methodChannel?.invokeMethod("callEnded", arguments: json)

        action.fulfill()
    }

    func onTimeOut(_ call: Call) {
        print("Call timed out: \(call.data.toJSON())")

        let json = ["action": "TIMEOUT", "data": call.data.toJSON()] as [String: Any]

        // Send timeout event to Flutter
        methodChannel?.invokeMethod("callTimeout", arguments: json)
    }

    // Audio session callbacks for WebRTC
    func didActivateAudioSession(_ audioSession: AVAudioSession) {
        // Configure audio session for WebRTC if needed
        // RTCAudioSession.sharedInstance().audioSessionDidActivate(audioSession)
        // RTCAudioSession.sharedInstance().isAudioEnabled = true
    }

    func didDeactivateAudioSession(_ audioSession: AVAudioSession) {
        // Deactivate audio session for WebRTC if needed
        // RTCAudioSession.sharedInstance().audioSessionDidDeactivate(audioSession)
        // RTCAudioSession.sharedInstance().isAudioEnabled = false
    }

    // MARK: - Navigation Helpers
    private func launchAppAndNavigateToCall(callData: flutter_callkit_incoming.Data) {
        // If app is not active, we need to launch it
        if UIApplication.shared.applicationState != .active {
            // Create a deep link URL to launch the app
            if let url = URL(string: "superup://call?data=\(encodeCallData(callData))") {
                DispatchQueue.main.async {
                    UIApplication.shared.open(url, options: [:]) { success in
                        if !success {
                            // Fallback: Try to navigate after a delay
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                self.navigateToCallScreen(callData: callData)
                            }
                        }
                    }
                }
            }
        } else {
            // App is active, navigate directly
            navigateToCallScreen(callData: callData)
        }
    }

    private func navigateToCallScreen(callData: flutter_callkit_incoming.Data) {
        // Convert call data to Flutter format
        let callInfo = convertCallDataToFlutterFormat(callData)

        // Invoke Flutter method to navigate
        DispatchQueue.main.async { [weak self] in
            self?.methodChannel?.invokeMethod("navigateToCall", arguments: callInfo) { result in
                print("Navigation result: \(String(describing: result))")
            }
        }
    }

    private func convertCallDataToFlutterFormat(_ data: flutter_callkit_incoming.Data) -> [String: Any] {
        // Extract the actual call data from extra
        let extraData = data.extra as? [String: Any] ?? [:]

        // Get the call ID from extra data or generate a new one
        let callId = extraData["callId"] as? String ?? UUID().uuidString

        // Ensure all values are property list compliant
        var result: [String: Any] = [
            "callId": callId,
            "userName": data.nameCaller,
            "userImage": extraData["userImage"] as? String ?? "",
            "roomId": extraData["roomId"] as? String ?? "",
            "withVideo": data.type == 1,
            "roomType": extraData["roomType"] as? String ?? "s",
            "callStatus": extraData["callStatus"] as? String ?? "ring"
        ]

        // Only add groupName if it's a valid string
        if let groupName = extraData["groupName"] as? String, groupName != "<null>" {
            result["groupName"] = groupName
        }

        return result
    }

    private func encodeCallData(_ data: flutter_callkit_incoming.Data) -> String {
        // Encode call data for URL
        let dict = convertCallDataToFlutterFormat(data)
        if let jsonData = try? JSONSerialization.data(withJSONObject: dict),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        }
        return ""
    }

    // MARK: - Application State Changes
    override func applicationDidBecomeActive(_ application: UIApplication) {
        super.applicationDidBecomeActive(application)

        // Check for pending call accept
        if let pendingCallData = UserDefaults.standard.dictionary(forKey: "pendingCallAccept") {
            // Clear the pending call
            UserDefaults.standard.removeObject(forKey: "pendingCallAccept")
            UserDefaults.standard.synchronize()

            // Navigate to call screen with the stored call data
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.methodChannel?.invokeMethod("handlePendingCall", arguments: pendingCallData)
            }
        }

        // Reset background flag
        isCallHandledFromBackground = false
    }

    // MARK: - Firebase Cloud Messaging (FCM) Methods

    // Handle APNs token registration
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Foundation.Data) {
        print("=== APNs Token Registered ===")
        let tokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
        print("APNs Token: \(tokenString)")

        // Pass the APNs token to Firebase
        Messaging.messaging().apnsToken = deviceToken
    }

    // Handle APNs registration failure
    override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("=== Failed to Register for Remote Notifications ===")
        print("Error: \(error.localizedDescription)")
    }

    // Handle FCM token refresh
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("=== FCM Registration Token ===")
        print("FCM Token: \(fcmToken ?? "nil")")
        print("==============================")

        // You can send the FCM token to your server here if needed
    }

    // Handle background remote notifications (including silent push notifications)
    override func application(_ application: UIApplication,
                              didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                              fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        // Start background task to prevent app termination
        var backgroundTask: UIBackgroundTaskIdentifier = .invalid
        backgroundTask = application.beginBackgroundTask(withName: "FCM Background Notification") {
            // This block is called if the system is about to terminate the background task
            application.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        }

        // Only process if app is NOT in foreground (Active state)
        let isAppInForeground = application.applicationState == .active

        if !isAppInForeground {
            // Message delivery confirmation would be handled on Flutter/Dart side
            // via a method channel if needed, without exposing access tokens here
            print("Received background notification for roomId: \(userInfo["roomId"] ?? "unknown")")
        }

        // Let Firebase Messaging know about the message (for Analytics)
        Messaging.messaging().appDidReceiveMessage(userInfo)

        // Complete the background fetch and end background task
        completionHandler(.newData)

        // End the background task
        if backgroundTask != .invalid {
            application.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        }
    }

    // Handle notification when app is in foreground
    override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                         willPresent notification: UNNotification,
                                         withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo

        // Let Firebase Messaging know about the message
        Messaging.messaging().appDidReceiveMessage(userInfo)

        // Show notification even when app is in foreground
        if #available(iOS 14.0, *) {
            completionHandler([[.banner, .sound, .badge]])
        } else {
            completionHandler([[.alert, .sound, .badge]])
        }
    }

    // Handle notification tap
    override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                         didReceive response: UNNotificationResponse,
                                         withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo

        // Let Firebase Messaging know about the message
        Messaging.messaging().appDidReceiveMessage(userInfo)

        completionHandler()
    }
}