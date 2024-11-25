import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_store/shared/constants/variables.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/localization/presentation/local_cubit/local_cubit.dart';
import '../../features/authentication/presentation/cubit/auth_cubit.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int _selectedIndex = 0;

  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _pageController.jumpToPage(index);
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<LocalCubit>().checkLocalState();
    context.read<AuthCubit>().checkUserState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        key: const PageStorageKey<String>('page_view'),
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: pages
            .map(
              (page) => KeyedSubtree(
                key: ValueKey(page.runtimeType),
                child: page,
              ),
            )
            .toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: AppLocalizations.of(context)!.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.shopping_cart_sharp),
            label: AppLocalizations.of(context)!.cart,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: AppLocalizations.of(context)!.account,
          ),
        ],
        selectedItemColor: Colors.blue,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
