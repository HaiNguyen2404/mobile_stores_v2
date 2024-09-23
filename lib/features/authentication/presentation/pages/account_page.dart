import 'package:flutter/material.dart';
import 'package:mobile_store/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:mobile_store/features/authentication/presentation/pages/login_page.dart';
import 'package:mobile_store/shared/constants/variables.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/localization/presentation/local_cubit/local_cubit.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late String initLocal;

  @override
  void initState() {
    super.initState();
    context.read<LocalCubit>().checkLocalState();
    initLocal = context.read<LocalCubit>().checkLocal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: Text(AppLocalizations.of(context)!.account),
        actions: [
          DropdownButton(
            value: initLocal,
            items: const [
              DropdownMenuItem(
                value: 'en',
                child: Center(
                  child: Text('English'),
                ),
              ),
              DropdownMenuItem(
                value: 'vi',
                child: Center(
                  child: Text('Tiếng Việt'),
                ),
              ),
            ],
            onChanged: (value) {
              changeLocal(value!);
              setState(() {
                initLocal = value;
              });
            },
          ),
        ],
      ),
      body: Center(
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthInitial) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('You are not signed in'),
                  ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    ),
                    child: const Text('Login'),
                  ),
                ],
              );
            } else if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AuthLoaded) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.user.name),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AuthCubit>().logoutAndLoadState();
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Log out")));
                    },
                    child: const Text('Logout'),
                  ),
                ],
              );
            } else if (state is AuthError) {
              return Text(state.message);
            } else {
              return const Text('Unimplemented state');
            }
          },
        ),
      ),
    );
  }

  changeLocal(String local) {
    context.read<LocalCubit>().changeLocalState(local);
  }
}
