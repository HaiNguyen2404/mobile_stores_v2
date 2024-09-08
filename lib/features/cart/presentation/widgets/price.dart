import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/presentation/local_cubit/local_cubit.dart';

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
              '${price * state.convertedValue}',
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
