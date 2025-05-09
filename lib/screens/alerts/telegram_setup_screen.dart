// lib\screens\alerts\telegram_setup_screen.dart

import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/loading_indicator.dart';

class TelegramSetupScreen extends StatefulWidget {
  const TelegramSetupScreen({Key? key}) : super(key: key);

  @override
  _TelegramSetupScreenState createState() => _TelegramSetupScreenState();
}

class _TelegramSetupScreenState extends State<TelegramSetupScreen> {
  final TextEditingController _chatIdController = TextEditingController();
  bool _isLoading = false;
  String _message = '';

  @override
  void dispose() {
    _chatIdController.dispose();
    super.dispose();
  }

  void _testTelegramAlert() async {
    setState(() {
      _isLoading = true;
      _message = '';
    });
    // TODO: Integrate your Telegram provider/service call here.
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isLoading = false;
      _message = 'Test alert sent successfully!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.primaryColor,
      appBar: AppBar(
        backgroundColor: AppConstants.primaryColor,
        title: const Text(
          'Telegram Setup',
          style:
              TextStyle(fontFamily: 'Rajdhani', color: AppConstants.textColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          children: [
            TextField(
              controller: _chatIdController,
              style: const TextStyle(color: AppConstants.textColor),
              decoration: InputDecoration(
                labelText: 'Telegram Chat ID',
                labelStyle: const TextStyle(color: AppConstants.textColor),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppConstants.accentColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: AppConstants.accentColor, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _isLoading
                ? const LoadingIndicator()
                : CustomButton(
                    text: 'Test Telegram Alert',
                    onPressed: _testTelegramAlert,
                  ),
            if (_message.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                _message,
                style: const TextStyle(color: AppConstants.textColor),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
