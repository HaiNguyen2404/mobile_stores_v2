import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile_store/cubit/local_cubit.dart';
import 'package:mobile_store/cubit/local_state.dart';
import 'package:mobile_store/utilities/variables.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Box localBox = Hive.box("local_box");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: Text(AppLocalizations.of(context)!.account),
        actions: [
          BlocBuilder<LocalCubit, LocalState>(
            builder: (context, state) {
              return DropdownButton(
                value: state.local,
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
                  state.local = value!;
                  localBox.put("language", value);
                  context.read<LocalCubit>().changeLanguage();
                },
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Text(AppLocalizations.of(context)!.account_page),
      ),
    );
  }
}
