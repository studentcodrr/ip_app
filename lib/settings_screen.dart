import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taskflow_app/widgets/sidebar.dart'; 
import 'package:taskflow_app/features/auth/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final User? user = FirebaseAuth.instance.currentUser;

  Future<void> _changeUsername() async {
    final nameCtrl = TextEditingController(text: user?.displayName);
    final passCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Change Username"),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: "New Username"),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passCtrl,
                decoration: const InputDecoration(labelText: "Confirm Current Password"),
                obscureText: true,
                validator: (v) => v!.isEmpty ? "Required for security" : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                try {
                  AuthCredential credential = EmailAuthProvider.credential(
                    email: user!.email!, 
                    password: passCtrl.text
                  );
                  await user!.reauthenticateWithCredential(credential);

                  await user!.updateDisplayName(nameCtrl.text);
                  
                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Username updated successfully!"))
                    );
                    setState(() {});
                  }
                } on FirebaseAuthException catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: ${e.message}"), backgroundColor: Colors.red)
                  );
                }
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Future<void> _changePassword() async {
    final currentPassCtrl = TextEditingController();
    final newPassCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Change Password"),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: currentPassCtrl,
                decoration: const InputDecoration(labelText: "Current Password"),
                obscureText: true,
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: newPassCtrl,
                decoration: const InputDecoration(labelText: "New Password"),
                obscureText: true,
                validator: (v) => (v!.length < 6) ? "Min 6 chars" : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                try {
                  AuthCredential credential = EmailAuthProvider.credential(
                    email: user!.email!, 
                    password: currentPassCtrl.text
                  );
                  await user!.reauthenticateWithCredential(credential);

                  await user!.updatePassword(newPassCtrl.text);

                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Password changed! Please log in again."))
                    );
                    
                    // Optional: Force Logout
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                        (route) => false
                    );
                  }
                } on FirebaseAuthException catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: ${e.message}"), backgroundColor: Colors.red)
                  );
                }
              }
            },
            child: const Text("Update Password"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(currentPage: 'Settings'),
      appBar: AppBar(
        title: const Text("Settings"),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Account Settings',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text("Email: ${user?.email}", style: const TextStyle(color: Colors.grey)),
                Text("Username: ${user?.displayName ?? 'Not set'}", style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 32),
                
                _SettingsButton(
                  label: 'Change Username',
                  icon: Icons.person_outline,
                  onTap: _changeUsername,
                ),
                const SizedBox(height: 16),
                
                _SettingsButton(
                  label: 'Change Password',
                  icon: Icons.lock_outline,
                  onTap: _changePassword,
                ),
                const SizedBox(height: 16),
                
                const Divider(height: 40),

                _SettingsButton(
                  label: 'Log Out',
                  icon: Icons.logout,
                  isDestructive: true, 
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    if (context.mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                        (Route<dynamic> route) => false, 
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;  
  final bool isDestructive;

  const _SettingsButton({
    required this.label,
    required this.icon,
    this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? Colors.red.shade400 : Theme.of(context).colorScheme.primary;
    final isDisabled = onTap == null;

    return ElevatedButton.icon(
      icon: Icon(icon, color: isDisabled ? Colors.grey : color),
      label: Text(
        label,
        style: TextStyle(color: isDisabled ? Colors.grey : color, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        alignment: Alignment.centerLeft,
        backgroundColor: Colors.white,
        foregroundColor: color,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      onPressed: isDisabled ? null : onTap,
    );
  }
}