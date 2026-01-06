// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:super_up/app/modules/annonces/cores/error_handler.dart';
import 'package:super_up/app/modules/annonces/cores/error_model.dart';

enum AppStatus { starting, error, loading, data }

enum RequestStatus { starting, waiting, completed }

class AppState<T> {
  AppStatus status;
  T? data;
  ErrorModel? errorModel;

  AppState({this.status = AppStatus.starting, this.data, this.errorModel});

  AppState<T> copyWith({
    AppStatus? status,
    dynamic data,
    ErrorModel? errorModel,
  }) {
    return AppState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorModel: errorModel ?? this.errorModel,
    );
  }

  factory AppState.loading() => AppState(status: AppStatus.loading);

  factory AppState.completed(T data) =>
      AppState(status: AppStatus.data, data: data);

  factory AppState.error(ErrorModel errorModel) =>
      AppState(status: AppStatus.error, errorModel: errorModel);

  factory AppState.trash(dynamic except) =>
      AppState(status: AppStatus.error, errorModel: returnError(except));

  @override
  String toString() =>
      'AppState(status: $status, data: $data, errorModel: $errorModel)';

  @override
  bool operator ==(covariant AppState other) {
    if (identical(this, other)) return true;

    return other.status == status &&
        other.data == data &&
        other.errorModel == errorModel;
  }

  bool get hasError => status == AppStatus.error && errorModel != null;
  bool get hasData => status == AppStatus.data;
  bool get hasNotNullData => status == AppStatus.data && data != null;
  bool get isLoading => status == AppStatus.loading;

  @override
  int get hashCode => status.hashCode ^ data.hashCode ^ errorModel.hashCode;
}
