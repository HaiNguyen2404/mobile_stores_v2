import 'package:flutter/material.dart';
import 'package:mobile_store/shared/constants/variables.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/localization/presentation/local_cubit/local_cubit.dart';

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
          BlocBuilder<LocalCubit, LocalState>(
            builder: (context, state) {
              return DropdownButton(
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
                  print(value);
                  setState(() {
                    initLocal = value;
                  });
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

  changeLocal(String local) {
    context.read<LocalCubit>().changeLocalState(local);
  }
}
