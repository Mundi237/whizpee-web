import 'package:v_chat_sdk_core/src/models/call/v_call_notification_model.dart';
import 'package:v_chat_sdk_core/src/models/models.dart';

class CallKitBackgroundCallModel {
  final DateTime date;
  final VCallNotificationModel model;
  final bool isProcessed;
  final bool isAccepted;

//<editor-fold desc="Data Methods">
  const CallKitBackgroundCallModel({
    required this.date,
    required this.model,
    required this.isProcessed,
    required this.isAccepted,
  });

  @override
  String toString() {
    return 'CallKitBackgroundCallModel{ date: $date, model: $model, isProcessed: $isProcessed, isAccepted: $isAccepted,}';
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date.millisecondsSinceEpoch,
      'model': model.toMap(),
      'isProcessed': isProcessed,
      'isAccepted': isAccepted,
    };
  }

  factory CallKitBackgroundCallModel.fromMap(Map<String, dynamic> map) {
    return CallKitBackgroundCallModel(
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      model:
          VCallNotificationModel.fromMap(map['model'] as Map<String, dynamic>),
      isProcessed: map['isProcessed'] as bool,
      isAccepted: map['isAccepted'] as bool,
    );
  }

  CallKitBackgroundCallModel copyWith({
    DateTime? date,
    VCallNotificationModel? model,
    bool? isProcessed,
    bool? isAccepted,
  }) {
    return CallKitBackgroundCallModel(
      date: date ?? this.date,
      model: model ?? this.model,
      isProcessed: isProcessed ?? this.isProcessed,
      isAccepted: isAccepted ?? this.isAccepted,
    );
  }
//</editor-fold>
}
