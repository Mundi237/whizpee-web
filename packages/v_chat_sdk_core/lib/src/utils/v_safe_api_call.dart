// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

/// Result type for API operations
class Result<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  const Result._({
    this.data,
    this.error,
    required this.isSuccess,
  });

  /// Create a success result
  factory Result.success(T data) => Result._(
        data: data,
        isSuccess: true,
      );

  /// Create a failure result
  factory Result.failure(String error) => Result._(
        error: error,
        isSuccess: false,
      );

  /// Pattern matching method
  R when<R>({
    required R Function(T data) success,
    required R Function(String error) failure,
  }) {
    if (isSuccess && data != null) {
      return success(data as T);
    } else {
      return failure(error ?? 'Unknown error');
    }
  }

  /// Check if result is success
  bool get isSuccessResult => isSuccess;

  /// Check if result is failure
  bool get isFailureResult => !isSuccess;

  /// Get data if success, otherwise null
  T? get successData => isSuccess ? data : null;

  /// Get error if failure, otherwise null
  String? get failureError => isFailureResult ? error : null;
}

/// Configuration for API calls
class VApiConfig {
  final bool ignoreTimeoutErrors;
  final bool ignoreNetworkErrors;
  final bool throwExceptions;
  final Duration timeout;

  const VApiConfig({
    this.ignoreTimeoutErrors = true,
    this.ignoreNetworkErrors = true,
    this.throwExceptions = false,
    this.timeout = const Duration(seconds: 30),
  });
}

/// Custom exception class for V Chat API calls
class VApiException implements Exception {
  final String message;
  final dynamic originalError;
  final StackTrace? stackTrace;
  final bool isNetworkError;
  final bool isTimeoutError;
  final bool isHttpError;
  final bool isFormatError;

  const VApiException({
    required this.message,
    this.originalError,
    this.stackTrace,
    this.isNetworkError = false,
    this.isTimeoutError = false,
    this.isHttpError = false,
    this.isFormatError = false,
  });

  @override
  String toString() => message;
}

/// Safe API call function for v chat service http calls with improved error handling
Future<Result<T>> vSafeApiCallWithRetryWithRetry<T>({
  Function()? onLoading,
  required Future<T> Function() request,
  required Function(T response) onSuccess,
  VoidCallback? finallyCallback,
  bool ignoreTimeoutAndNoInternet = true,
  dynamic onError,
  VApiConfig? config,
}) async {
  final apiConfig = config ?? const VApiConfig();

  try {
    // Call onLoading if provided
    onLoading?.call();

    // Execute the request with timeout
    final res = await request().timeout(apiConfig.timeout);

    // Call onSuccess with the result
    await onSuccess(res);

    return Result.success(res);
  } on SocketException catch (err, stackTrace) {
    return _handleNetworkError(
      err,
      stackTrace,
      ignoreTimeoutAndNoInternet,
      onError,
      apiConfig,
    );
  } on TimeoutException catch (err, stackTrace) {
    return _handleTimeoutError(
      err,
      stackTrace,
      ignoreTimeoutAndNoInternet,
      onError,
      apiConfig,
    );
  } on HttpException catch (err, stackTrace) {
    return _handleHttpError(
      err,
      stackTrace,
      onError,
      apiConfig,
    );
  } on FormatException catch (err, stackTrace) {
    return _handleFormatError(
      err,
      stackTrace,
      onError,
      apiConfig,
    );
  } catch (err, stackTrace) {
    return _handleGenericError(
      err,
      stackTrace,
      onError,
      apiConfig,
    );
  } finally {
    // Always call finallyCallback if provided
    finallyCallback?.call();
  }
}

/// Helper function to safely call onError with backward compatibility
void _callOnError(dynamic onError, String message, StackTrace stackTrace) {
  if (onError == null) return;

  if (onError is Function(String, StackTrace)) {
    onError(message, stackTrace);
  } else if (onError is Function(String)) {
    onError(message);
  }
}

/// Handle network errors
Result<T> _handleNetworkError<T>(
  SocketException err,
  StackTrace stackTrace,
  bool ignoreTimeoutAndNoInternet,
  dynamic onError,
  VApiConfig config,
) {
  final errorMessage = 'Network error: ${err.message}';
  final exception = VApiException(
    message: errorMessage,
    originalError: err,
    stackTrace: stackTrace,
    isNetworkError: true,
  );

  if (!ignoreTimeoutAndNoInternet) {
    log(errorMessage, error: err, stackTrace: stackTrace, level: 1000);
    _callOnError(onError, errorMessage, stackTrace);
  }

  if (config.throwExceptions) {
    throw exception;
  }

  return Result.failure(errorMessage);
}

/// Handle timeout errors
Result<T> _handleTimeoutError<T>(
  TimeoutException err,
  StackTrace stackTrace,
  bool ignoreTimeoutAndNoInternet,
  dynamic onError,
  VApiConfig config,
) {
  final errorMessage =
      'Request timeout: ${err.message ?? "Connection timed out"}';
  final exception = VApiException(
    message: errorMessage,
    originalError: err,
    stackTrace: stackTrace,
    isTimeoutError: true,
  );

  if (!ignoreTimeoutAndNoInternet) {
    log(errorMessage, error: err, stackTrace: stackTrace, level: 1000);
    _callOnError(onError, errorMessage, stackTrace);
  }

  if (config.throwExceptions) {
    throw exception;
  }

  return Result.failure(errorMessage);
}

/// Handle HTTP errors
Result<T> _handleHttpError<T>(
  HttpException err,
  StackTrace stackTrace,
  dynamic onError,
  VApiConfig config,
) {
  final errorMessage = 'HTTP error: ${err.message}';
  final exception = VApiException(
    message: errorMessage,
    originalError: err,
    stackTrace: stackTrace,
    isHttpError: true,
  );

  log(errorMessage, error: err, stackTrace: stackTrace, level: 1000);
  _callOnError(onError, errorMessage, stackTrace);

  if (config.throwExceptions) {
    throw exception;
  }

  return Result.failure(errorMessage);
}

/// Handle format/parsing errors
Result<T> _handleFormatError<T>(
  FormatException err,
  StackTrace stackTrace,
  dynamic onError,
  VApiConfig config,
) {
  final errorMessage = 'Data format error: ${err.message}';
  final exception = VApiException(
    message: errorMessage,
    originalError: err,
    stackTrace: stackTrace,
    isFormatError: true,
  );

  log(errorMessage, error: err, stackTrace: stackTrace, level: 1000);
  _callOnError(onError, errorMessage, stackTrace);

  if (config.throwExceptions) {
    throw exception;
  }

  return Result.failure(errorMessage);
}

/// Handle generic errors
Result<T> _handleGenericError<T>(
  dynamic err,
  StackTrace stackTrace,
  dynamic onError,
  VApiConfig config,
) {
  final errorMessage = err.toString();

  // Re-throw if it's already a VApiException to avoid recursion
  if (err is VApiException) {
    if (config.throwExceptions) {
      throw err;
    }
    return Result.failure(err.message);
  }

  final exception = VApiException(
    message: errorMessage,
    originalError: err,
    stackTrace: stackTrace,
  );

  // Always log unexpected errors
  log(errorMessage, error: err, stackTrace: stackTrace, level: 1000);
  _callOnError(onError, errorMessage, stackTrace);

  if (config.throwExceptions) {
    throw exception;
  }

  return Result.failure(errorMessage);
}

/// Extension for handling VApiException in UI
extension VApiExceptionExtension on VApiException {
  /// Get user-friendly error message
  String get userMessage {
    if (isNetworkError) {
      return 'Please check your internet connection and try again.';
    } else if (isTimeoutError) {
      return 'The request took too long. Please try again.';
    } else if (isFormatError) {
      return 'Invalid data received. Please try again later.';
    } else if (isHttpError) {
      return 'Server error occurred. Please try again later.';
    } else {
      return 'Something went wrong. Please try again.';
    }
  }

  /// Check if error should be retried
  bool get canRetry => isNetworkError || isTimeoutError;

  /// Check if error is critical and should not be ignored
  bool get isCritical => isHttpError || isFormatError;
}

/// Extension to create a copy of VApiConfig with modified values
extension VApiConfigExtension on VApiConfig {
  VApiConfig copyWith({
    bool? ignoreTimeoutErrors,
    bool? ignoreNetworkErrors,
    bool? throwExceptions,
    Duration? timeout,
  }) {
    return VApiConfig(
      ignoreTimeoutErrors: ignoreTimeoutErrors ?? this.ignoreTimeoutErrors,
      ignoreNetworkErrors: ignoreNetworkErrors ?? this.ignoreNetworkErrors,
      throwExceptions: throwExceptions ?? this.throwExceptions,
      timeout: timeout ?? this.timeout,
    );
  }
}
