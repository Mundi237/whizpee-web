import 'dart:async';

import 'package:flutter/material.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_message_page/v_chat_message_page.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class OneTimeSeenPage extends StatefulWidget {
  final VBaseMessage message;
  final VMessageLocalization language;

  const OneTimeSeenPage({
    super.key,
    required this.message,
    required this.language,
  });

  @override
  State<OneTimeSeenPage> createState() => _OneTimeSeenPageState();
}

class _OneTimeSeenPageState extends State<OneTimeSeenPage> with StreamMix {
  final _voiceControllers = VVoicePlayerController((localId) => null);
  final _messageStateController = StreamController<VBaseMessage>.broadcast();
  final _vEventBus = VEventBusSingleton.vEventBus;

  late VBaseMessage _currentMessage;
  bool _isMessageDeleted = false;

  @override
  void initState() {
    super.initState();
    _currentMessage = widget.message;
    _initializeMessageStreams();
    _markMessageAsSeen();
  }

  @override
  void dispose() {
    _cleanupResources();
    super.dispose();
  }

  void _initializeMessageStreams() {
    streamsMix.addAll([
      _createMessageUpdateStream(),
      _createMessageDeleteStream(),
      _createMessageAllDeletedStream(),
      _createDownloadProgressStream(),
      _createDownloadStatusStream(),
      _createMessageStatusStream(),
      _createOneSeenStatusStream(),
      _createStarStatusStream(),
    ]);
  }

  StreamSubscription _createMessageUpdateStream() {
    return _vEventBus
        .on<VUpdateMessageEvent>()
        .where(_isRelevantMessageEvent)
        .listen(_handleMessageUpdate);
  }

  StreamSubscription _createMessageDeleteStream() {
    return _vEventBus
        .on<VDeleteMessageEvent>()
        .where(_isRelevantMessageEvent)
        .listen(_handleMessageDelete);
  }

  StreamSubscription _createMessageAllDeletedStream() {
    return _vEventBus
        .on<VUpdateMessageAllDeletedEvent>()
        .where(_isRelevantMessageEvent)
        .listen(_handleMessageAllDeleted);
  }

  StreamSubscription _createDownloadProgressStream() {
    return _vEventBus
        .on<VUpdateProgressMessageEvent>()
        .where(_isRelevantMessageEvent)
        .listen(_handleDownloadProgress);
  }

  StreamSubscription _createDownloadStatusStream() {
    return _vEventBus
        .on<VUpdateIsDownloadMessageEvent>()
        .where(_isRelevantMessageEvent)
        .listen(_handleDownloadStatus);
  }

  StreamSubscription _createMessageStatusStream() {
    return _vEventBus
        .on<VUpdateMessageStatusEvent>()
        .where(_isRelevantMessageEvent)
        .listen(_handleMessageStatus);
  }

  StreamSubscription _createOneSeenStatusStream() {
    return _vEventBus
        .on<VUpdateMessageOneSeenEvent>()
        .where(_isRelevantMessageEvent)
        .listen(_handleOneSeenStatus);
  }

  StreamSubscription _createStarStatusStream() {
    return _vEventBus
        .on<VUpdateMessageStarEvent>()
        .where(_isRelevantMessageEvent)
        .listen(_handleStarStatus);
  }

  bool _isRelevantMessageEvent(dynamic event) {
    final isMatchingRoom = event.roomId == _currentMessage.roomId;
    final isMatchingMessage = event.localId == _currentMessage.localId;
    return isMatchingRoom && isMatchingMessage;
  }

  void _handleMessageUpdate(VUpdateMessageEvent event) {
    _updateCurrentMessage((message) => event.messageModel);
  }

  void _handleMessageDelete(VDeleteMessageEvent event) {
    _updateCurrentMessage((message) {
      message.isDeleted = true;
      return message;
    });
    setState(() {
      _isMessageDeleted = true;
    });
  }

  void _handleMessageAllDeleted(VUpdateMessageAllDeletedEvent event) {
    _updateCurrentMessage((message) {
      message.allDeletedAt = event.message.allDeletedAt;
      return message;
    });
  }

  void _handleDownloadProgress(VUpdateProgressMessageEvent event) {
    _updateCurrentMessage((message) {
      message.progress = event.progress;
      return message;
    });
  }

  void _handleDownloadStatus(VUpdateIsDownloadMessageEvent event) {
    _updateCurrentMessage((message) {
      message.isDownloading = event.isDownloading;
      return message;
    });
  }

  void _handleMessageStatus(VUpdateMessageStatusEvent event) {
    _updateCurrentMessage((message) {
      message.emitStatus = event.emitState;
      return message;
    });
  }

  void _handleOneSeenStatus(VUpdateMessageOneSeenEvent event) {
    _updateCurrentMessage((message) {
      message.isOneSeenByMe = true;
      return message;
    });
  }

  void _handleStarStatus(VUpdateMessageStarEvent event) {
    _updateCurrentMessage((message) {
      message.isStared = event.isStar;
      return message;
    });
  }

  void _updateCurrentMessage(VBaseMessage Function(VBaseMessage) updater) {
    _currentMessage = updater(_currentMessage);
    _messageStateController.add(_currentMessage);
  }

  @override
  Widget build(BuildContext context) {
    if (_isMessageDeleted) {
      return _buildMessageDeletedView();
    }

    return Container(
      decoration: context.vMessageTheme.scaffoldDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _buildAppBar(),
        body: _buildMessageBody(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: S.of(context).oneSeenMessage.text,
    );
  }

  Widget _buildMessageBody() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildRealtimeMessageItem(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRealtimeMessageItem() {
    return StreamBuilder<VBaseMessage>(
      stream: _messageStateController.stream,
      initialData: _currentMessage,
      builder: (context, snapshot) {
        final message = snapshot.data ?? _currentMessage;

        return VMessageItem(
          forceSeen: true,
          message: message,
          roomType: VRoomType.s,
          language: widget.language,
          voiceController: _getVoiceController,
        );
      },
    );
  }

  Widget _buildMessageDeletedView() {
    return Container(
      decoration: context.vMessageTheme.scaffoldDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _buildAppBar(),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.delete_outline,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                S.of(context).messageHasBeenDeleted.text.color(Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }

  VVoiceMessageController? _getVoiceController(VBaseMessage message) {
    if (message is VVoiceMessage) {
      return _voiceControllers.getVoiceController(message);
    }
    return null;
  }

  Future<void> _markMessageAsSeen() async {
    await vSafeApiCall(
      request: () async {
        await VChatController.I.nativeApi.local.message.addOneSeen(
          roomId: _currentMessage.roomId,
          localId: _currentMessage.localId,
        );
        await VChatController.I.nativeApi.remote.message.addOneSeen(
          roomId: _currentMessage.roomId,
          messageId: _currentMessage.id,
        );
      },
      onSuccess: (response) {},
    );
  }

  void _cleanupResources() {
    _voiceControllers.close();
    _messageStateController.close();
    closeStreamMix();
  }
}
