import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile_store/cubit/local_cubit.dart';
import 'package:mobile_store/cubit/local_state.dart';

class GrandTotal extends StatelessWidget {
  const GrandTotal({super.key, required this.grandTotal});
  final double grandTotal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8, right: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            '${AppLocalizations.of(context)!.grand_total}: ',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          BlocBuilder<LocalCubit, LocalState>(
            builder: (context, state) {
              if (state is Vietnamese) {
                return Text(
                  '${grandTotal * state.currencyValue} đ',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                );
              } else {
                return Text(
                  '$grandTotal USD',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
