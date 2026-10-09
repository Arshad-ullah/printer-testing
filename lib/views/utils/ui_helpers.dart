import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UiHelpers {
  static void showSnackbar(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    showSnackbar(context, 'Copied to clipboard');
  }
}
