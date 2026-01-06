// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:v_chat_call_service/v_chat_call_service.dart';
//
// /// Example implementation of the call service
// class CallServiceExample extends StatefulWidget {
//   const CallServiceExample({super.key});
//
//   @override
//   State<CallServiceExample> createState() => _CallServiceExampleState();
// }
//
// class _CallServiceExampleState extends State<CallServiceExample> {
//   final CallServiceManager _callManager = CallServiceManager.instance;
//   CallState _currentCallState = CallState.ended;
//   int _callDuration = 0;
//   bool _isMuted = false;
//   bool _isSpeakerOn = false;
//   Timer? _callTimer;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeCallService();
//   }
//
//   @override
//   void dispose() {
//     _callTimer?.cancel();
//     _callManager.dispose();
//     super.dispose();
//   }
//
//   /// Initialize the call service
//   Future<void> _initializeCallService() async {
//     await _callManager.initialize();
//   }
//
//   /// Start a new call
//   Future<void> _startCall({
//     required String callerName,
//     String? callerAvatarUrl,
//     bool isVideoCall = false,
//     bool isIncoming = false,
//   }) async {
//     setState(() {
//       _currentCallState = isIncoming ? CallState.ringing : CallState.dialing;
//       _callDuration = 0;
//       _isMuted = false;
//       _isSpeakerOn = false;
//     });
//
//     final callData = CallNotificationData(
//       callId: DateTime.now().millisecondsSinceEpoch.toString(),
//       callerName: callerName,
//       callerAvatarUrl: callerAvatarUrl,
//       callState: _currentCallState,
//       callDuration: _callDuration,
//       isVideoCall: isVideoCall,
//       isMuted: _isMuted,
//       isSpeakerOn: _isSpeakerOn,
//       isIncoming: isIncoming,
//     );
//
//     final success = await _callManager.startCallService(
//       callData: callData,
//       onCallAction: _handleCallAction,
//     );
//
//     if (success) {
//       // Simulate call progression
//       if (!isIncoming) {
//         _simulateOutgoingCall();
//       }
//     } else {
//       _showSnackBar('Failed to start call service');
//     }
//   }
//
//   /// Simulate outgoing call progression
//   void _simulateOutgoingCall() {
//     // After 3 seconds, connect the call
//     Timer(const Duration(seconds: 3), () {
//       _connectCall();
//     });
//   }
//
//   /// Connect the call
//   void _connectCall() {
//     setState(() {
//       _currentCallState = CallState.connected;
//     });
//
//     _updateCallService();
//     _startCallTimer();
//   }
//
//   /// Answer an incoming call
//   void _answerCall() {
//     setState(() {
//       _currentCallState = CallState.connected;
//     });
//
//     _updateCallService();
//     _startCallTimer();
//   }
//
//   /// End the call
//   Future<void> _endCall() async {
//     _callTimer?.cancel();
//     _callTimer = null;
//
//     setState(() {
//       _currentCallState = CallState.ended;
//     });
//
//     await _callManager.endCall();
//   }
//
//   /// Toggle mute
//   Future<void> _toggleMute() async {
//     setState(() {
//       _isMuted = !_isMuted;
//     });
//
//     await _callManager.toggleMute(_isMuted);
//   }
//
//   /// Toggle speaker
//   Future<void> _toggleSpeaker() async {
//     setState(() {
//       _isSpeakerOn = !_isSpeakerOn;
//     });
//
//     await _callManager.toggleSpeaker(_isSpeakerOn);
//   }
//
//   /// Start call timer
//   void _startCallTimer() {
//     _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       setState(() {
//         _callDuration++;
//       });
//       _updateCallService();
//     });
//   }
//
//   /// Update call service with current state
//   Future<void> _updateCallService() async {
//     if (!_callManager.isServiceRunning) return;
//
//     final callData = CallNotificationData(
//       callId: DateTime.now().millisecondsSinceEpoch.toString(),
//       callerName: 'John Doe',
//       callerAvatarUrl: null,
//       callState: _currentCallState,
//       callDuration: _callDuration,
//       isVideoCall: false,
//       isMuted: _isMuted,
//       isSpeakerOn: _isSpeakerOn,
//       isIncoming: false,
//     );
//
//     await _callManager.updateCall(callData);
//   }
//
//   /// Handle call actions from notification
//   void _handleCallAction(String action) {
//     switch (action) {
//       case 'answerCall':
//         _answerCall();
//         break;
//       case 'declineCall':
//         _endCall();
//         break;
//       case 'endCall':
//         _endCall();
//         break;
//       case 'toggleMute':
//         _toggleMute();
//         break;
//       case 'toggleSpeaker':
//         _toggleSpeaker();
//         break;
//     }
//   }
//
//   /// Show snack bar message
//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }
//
//   /// Format call duration
//   String get _formattedDuration {
//     final minutes = _callDuration ~/ 60;
//     final seconds = _callDuration % 60;
//     return '${minutes.toString().padLeft(2, '0')}:'
//         '${seconds.toString().padLeft(2, '0')}';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Call Service Example'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   children: [
//                     Text(
//                       'Call Status',
//                       style: Theme.of(context).textTheme.titleLarge,
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       _currentCallState.displayName,
//                       style: Theme.of(context).textTheme.bodyLarge,
//                     ),
//                     if (_currentCallState.isActive) ...[
//                       const SizedBox(height: 8),
//                       Text(
//                         'Duration: $_formattedDuration',
//                         style: Theme.of(context).textTheme.bodyMedium,
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//
//             // Call control buttons
//             if (_currentCallState == CallState.ended) ...[
//               ElevatedButton(
//                 onPressed: () => _startCall(
//                   callerName: 'John Doe',
//                   isVideoCall: false,
//                   isIncoming: false,
//                 ),
//                 child: const Text('Start Voice Call'),
//               ),
//               const SizedBox(height: 8),
//               ElevatedButton(
//                 onPressed: () => _startCall(
//                   callerName: 'Jane Smith',
//                   isVideoCall: true,
//                   isIncoming: false,
//                 ),
//                 child: const Text('Start Video Call'),
//               ),
//               const SizedBox(height: 8),
//               ElevatedButton(
//                 onPressed: () => _startCall(
//                   callerName: 'Alice Johnson',
//                   isVideoCall: false,
//                   isIncoming: true,
//                 ),
//                 child: const Text('Simulate Incoming Call'),
//               ),
//             ] else if (_currentCallState == CallState.ringing) ...[
//               Row(
//                 children: [
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: _answerCall,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.green,
//                       ),
//                       child: const Text('Answer'),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: _endCall,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                       ),
//                       child: const Text('Decline'),
//                     ),
//                   ),
//                 ],
//               ),
//             ] else if (_currentCallState.isActive) ...[
//               Row(
//                 children: [
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: _toggleMute,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: _isMuted ? Colors.red : Colors.grey,
//                       ),
//                       child: Text(_isMuted ? 'Unmute' : 'Mute'),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: _toggleSpeaker,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor:
//                             _isSpeakerOn ? Colors.blue : Colors.grey,
//                       ),
//                       child: Text(_isSpeakerOn ? 'Speaker Off' : 'Speaker On'),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               ElevatedButton(
//                 onPressed: _endCall,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.red,
//                 ),
//                 child: const Text('End Call'),
//               ),
//             ],
//
//             const SizedBox(height: 24),
//
//             // Service status
//             Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   children: [
//                     Text(
//                       'Service Status',
//                       style: Theme.of(context).textTheme.titleMedium,
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       _callManager.isServiceRunning
//                           ? 'Foreground Service: Running'
//                           : 'Foreground Service: Stopped',
//                       style: TextStyle(
//                         color: _callManager.isServiceRunning
//                             ? Colors.green
//                             : Colors.red,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
