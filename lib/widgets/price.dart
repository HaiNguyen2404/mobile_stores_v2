import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_store/cubit/local_cubit.dart';
import 'package:mobile_store/cubit/local_state.dart';

class Price extends StatelessWidget {
  const Price({super.key, required this.price});
  final int price;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: BlocBuilder<LocalCubit, LocalState>(
        builder: (context, state) {
          if (state is Vietnamese) {
            return Text(
              '${price * state.currencyValue}',
              textAlign: TextAlign.center,
            );
          } else {
            return Text(
              '$price ',
              textAlign: TextAlign.center,
            );
          }
        },
      ),
    );
  }
}
