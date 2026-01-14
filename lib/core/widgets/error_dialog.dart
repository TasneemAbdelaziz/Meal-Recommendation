import 'package:flutter/material.dart';
import 'package:recipe_app_withai/core/errors/auth_error_mapper.dart';
import 'package:recipe_app_withai/core/errors/failure.dart';
import 'package:recipe_app_withai/core/theme/app_pallet.dart';

class ErrorDialog extends StatelessWidget {
  final String message;
  final ErrorType? errorType;
  final VoidCallback? onRetry;
  final String? title;

  const ErrorDialog({
    super.key,
    required this.message,
    this.errorType,
    this.onRetry,
    this.title,
  });

  IconData _getErrorIcon() {
    switch (errorType) {
      case ErrorType.dns:
      case ErrorType.noInternet:
        return Icons.wifi_off_rounded;
      case ErrorType.timeout:
        return Icons.access_time_rounded;
      case ErrorType.credentials:
        return Icons.lock_outline_rounded;
      case ErrorType.server:
        return Icons.error_outline_rounded;
      default:
        return Icons.warning_amber_rounded;
    }
  }

  Color _getErrorColor() {
    switch (errorType) {
      case ErrorType.dns:
      case ErrorType.noInternet:
      case ErrorType.timeout:
        return Colors.orange;
      case ErrorType.credentials:
        return Colors.red;
      case ErrorType.server:
      case ErrorType.unknown:
      default:
        return Colors.red.shade700;
    }
  }

  String _getErrorTitle() {
    if (title != null) return title!;
    
    switch (errorType) {
      case ErrorType.dns:
        return 'Connection Error';
      case ErrorType.noInternet:
        return 'No Internet';
      case ErrorType.timeout:
        return 'Timeout Error';
      case ErrorType.credentials:
        return 'Invalid Credentials';
      case ErrorType.server:
        return 'Server Error';
      default:
        return 'Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    final errorColor = _getErrorColor();
    final errorIcon = _getErrorIcon();
    final errorTitle = _getErrorTitle();
    final userFriendlyMessage = errorType != null 
        ? AuthErrorMapper.getUserFriendlyMessage(errorType)
        : message;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Error icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: errorColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                errorIcon,
                size: 48,
                color: errorColor,
              ),
            ),
            const SizedBox(height: 20),
            
            // Error title
            Text(
              errorTitle,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: errorColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            
            // Error message
            Text(
              userFriendlyMessage,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: errorColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                if (onRetry != null) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onRetry!();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppPallet.mainColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Try Again',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> show(
    BuildContext context, {
    required String message,
    ErrorType? errorType,
    VoidCallback? onRetry,
    String? title,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ErrorDialog(
        message: message,
        errorType: errorType,
        onRetry: onRetry,
        title: title,
      ),
    );
  }
}
