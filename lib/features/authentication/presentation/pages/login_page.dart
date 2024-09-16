// presentation/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_store/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:mobile_store/features/authentication/presentation/pages/register_page.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthLoaded) {
            Navigator.pop(context);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
            context.read<AuthCubit>().checkUserState();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'User name'),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  validateInput(context);
                },
                child: const Text('Login'),
              ),
              const SizedBox(height: 10),
              TextButton(
                  onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      ),
                  child: const Text('Register')),
            ],
          ),
        ),
      ),
    );
  }

  void validateInput(BuildContext context) {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      showDialog(context: context, builder: showMessage);
    } else {
      context.read<AuthCubit>().loginAndGetToken(
            usernameController.text.trim(),
            passwordController.text.trim(),
          );
    }
  }

  Widget showMessage(BuildContext context) {
    return AlertDialog(
      title: const Text('All Field should not be empty!'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop;
          },
          child: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ),
      ],
    );
  }
}
