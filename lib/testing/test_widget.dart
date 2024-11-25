import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_store/features/home/presentation/cubit/product_cubit.dart';

class TestWidget extends StatefulWidget {
  const TestWidget({
    super.key,
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  State<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: BlocBuilder<ProductCubit, ProductState>(
            builder: (context, state) {
              return Text('Bloc');
            },
          ),
        ),
      ),
    );
  }
}
