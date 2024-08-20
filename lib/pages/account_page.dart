import 'package:flutter/material.dart';
import 'package:mobile_store/cubit/local_cubit.dart';
import 'package:mobile_store/utilities/variables.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  dynamic dropDownValue = locale.first;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: Text(AppLocalizations.of(context)!.account),
        actions: [
          DropdownButton(
            value: dropDownValue,
            items: const [
              DropdownMenuItem(
                value: Locale('en'),
                child: Center(
                  child: Text('English'),
                ),
              ),
              DropdownMenuItem(
                value: Locale('vi'),
                child: Center(
                  child: Text('Tiếng Việt'),
                ),
              ),
            ],
            onChanged: (value) {
              setState(() {
                dropDownValue = value!;
              });
              context.read<LocalCubit>().changeLanguage(dropDownValue);
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
