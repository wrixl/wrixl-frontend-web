// lib\profile\user_profile.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wrixl_frontend/providers/theme_provider.dart';
import 'package:wrixl_frontend/utils/constants.dart';
import 'package:wrixl_frontend/theme/theme.dart';
import 'package:wrixl_frontend/utils/responsive.dart';

// Linked screens
import 'package:wrixl_frontend/screens/alerts/telegram_setup_screen.dart';
import 'package:wrixl_frontend/screens/payment/subscription_page.dart';
import 'package:wrixl_frontend/screens/auth/login_screen.dart';
import 'package:wrixl_frontend/screens/auth/register_screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  String _displayName = "J. Gregoire";
  String _email = "jasong@example.com";
  String? _avatarUrl;

  bool _notificationsEnabled = true;


  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile', style: Theme.of(context).textTheme.titleLarge),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: AppConstants.secondaryTextColor.withOpacity(0.3),
                      backgroundImage: _avatarUrl != null
                          ? NetworkImage(_avatarUrl!)
                          : const AssetImage('assets/images/default_avatar.png')
                              as ImageProvider,
                    ),
                    Positioned(
                      child: Material(
                        shape: const CircleBorder(),
                        color: AppConstants.accentColor,
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () {
                            // TODO: open image picker
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.camera_alt, size: 20, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              TextFormField(
                initialValue: _displayName,
                style: Theme.of(context).textTheme.bodyLarge,
                decoration: const InputDecoration(
                  labelText: 'Display Name',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Please enter your name' : null,
                onSaved: (value) => _displayName = value!.trim(),
              ),
              const SizedBox(height: 16),

              TextFormField(
                initialValue: _email,
                style: Theme.of(context).textTheme.bodyLarge,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter your email';
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  return emailRegex.hasMatch(value)
                      ? null
                      : 'Please enter a valid email address';
                },
                onSaved: (value) => _email = value!.trim(),
              ),
              const SizedBox(height: 24),

              SwitchListTile(
                title: const Text('Enable Notifications'),
                secondary: const Icon(Icons.notifications),
                value: _notificationsEnabled,
                onChanged: (v) => setState(() => _notificationsEnabled = v),
              ),
              SwitchListTile(
                title: const Text('Force Light Mode'),
                secondary: const Icon(Icons.light_mode),
                subtitle: const Text('Override system theme'),
                value: !context.read<ThemeProvider>().isDark,
                onChanged: (forceLight) {
                  context.read<ThemeProvider>().toggle(forceLight);
                  setState(() {}); // if you have local UI dependent on this
                },
              ),


              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('Save Profile'),
                  onPressed: _onSave,
                ),
              ),

              const SizedBox(height: 32),
              Divider(color: AppConstants.accentColor.withOpacity(0.3)),
              const SizedBox(height: 16),

              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  _buildProfileAction(
                    icon: Icons.telegram,
                    label: 'Telegram Alerts',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TelegramSetupScreen()),
                    ),
                  ),
                  _buildProfileAction(
                    icon: Icons.credit_card,
                    label: 'Subscription',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SubscriptionPage()),
                    ),
                  ),
                  _buildProfileAction(
                    icon: Icons.login,
                    label: 'Login',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    ),
                  ),
                  _buildProfileAction(
                    icon: Icons.person_add,
                    label: 'Register',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon, color: Colors.black),
      label: Text(label, style: const TextStyle(color: Colors.black)),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppConstants.accentColor,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onTap,
    );
  }

  void _onSave() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved!')),
      );
    }
  }
}
