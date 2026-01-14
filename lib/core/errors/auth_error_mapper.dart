import 'dart:async';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'failure.dart';

class AuthErrorMapper {
  static Failure mapException(dynamic error) {
    // Socket/DNS errors (errno=7, Failed host lookup)
    if (error is SocketException) {
      if (error.message.contains('Failed host lookup') || 
          error.osError?.errorCode == 7) {
        return DnsFailure(
          'Cannot connect to server. Please check your internet connection or try switching networks/VPN.',
        );
      }
      return NetworkFailure(
        'Network error: ${error.message}',
        ErrorType.noInternet,
      );
    }

    // Timeout errors
    if (error is TimeoutException) {
      return TimeoutFailure(
        'Connection timeout. Please check your internet and try again.',
      );
    }

    // HTTP Client exceptions
    if (error.toString().contains('ClientException')) {
      if (error.toString().contains('SocketException')) {
        return DnsFailure(
          'Cannot connect to server. Please check your internet connection or try switching networks/VPN.',
        );
      }
      return NetworkFailure(
        'Network error. Please check your connection and try again.',
        ErrorType.noInternet,
      );
    }

    // Supabase Auth exceptions (wrong credentials, etc.)
    if (error is AuthException) {
      if (error.statusCode == '400' || 
          error.message.contains('Invalid login credentials') ||
          error.message.contains('invalid_grant')) {
        return CredentialsFailure('Invalid email or password. Please try again.');
      }
      return ServerFailure('Authentication error: ${error.message}');
    }

    // Generic server errors
    if (error is PostgrestException) {
      return ServerFailure('Server error: ${error.message}');
    }

    // Unknown errors
    return Failure(
      'Something went wrong. Please try again later.',
      ErrorType.unknown,
    );
  }

  static String getUserFriendlyMessage(ErrorType? errorType) {
    switch (errorType) {
      case ErrorType.dns:
        return 'Cannot connect to server. Please check your internet connection or try switching networks/VPN.';
      case ErrorType.timeout:
        return 'Connection timeout. Please check your internet and try again.';
      case ErrorType.noInternet:
        return 'No internet connection. Please check your network settings.';
      case ErrorType.credentials:
        return 'Invalid email or password. Please try again.';
      case ErrorType.server:
        return 'Server error. Please try again later.';
      case ErrorType.unknown:
      default:
        return 'Something went wrong. Please try again later.';
    }
  }
}
