import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:leeds_library/core/theme/app_colors.dart';

class ErrorWithRefreshWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRefresh;

  const ErrorWithRefreshWidget({
    super.key,
    this.errorMessage = 'Something went wrong',
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.errorColor,
            ),
            const SizedBox(height: 16),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh),
              label:  Text(translate('button_refresh')),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
