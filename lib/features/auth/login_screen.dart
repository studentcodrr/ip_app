import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskflow_app/features/auth/auth_controller.dart';
import 'package:taskflow_app/features/dashboard/dashboard_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  // Toggle between Login and Sign Up modes
  bool _isLoginMode = true;
  
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final controller = ref.read(authControllerProvider.notifier);

    // Call the Controller (which handles Auth + Firestore Sync)
    if (_isLoginMode) {
      await controller.login(email, password);
    } else {
      await controller.signUp(email, password);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    // Watch the controller state for Loading/Error
    final authState = ref.watch(authControllerProvider);

    // Listen for success to navigate
    ref.listen(authControllerProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${next.error}"),
            backgroundColor: Colors.red,
          ),
        );
      } else if (!next.isLoading && !next.hasError && previous?.isLoading == true) {
        // Only navigate if we just finished loading successfully
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(_isLoginMode ? 'Login' : 'Create Account'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'TaskFlow AI',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                    ),
                    const SizedBox(height: 40),
                    
                    // Email Field
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || !value.contains('@')) {
                          return 'Please enter a valid email.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Password Field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock_outline),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return 'Password must be at least 6 characters.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Loading Indicator or Button
                    if (authState.isLoading)
                      const Center(child: CircularProgressIndicator())
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: colorScheme.primary,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: _submit,
                            child: Text(
                              _isLoginMode ? 'Login' : 'Sign Up',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Toggle Button
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isLoginMode = !_isLoginMode;
                              });
                            },
                            child: Text(
                              _isLoginMode
                                  ? 'Don\'t have an account? Sign Up'
                                  : 'Already have an account? Login',
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}