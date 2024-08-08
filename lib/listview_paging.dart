import 'package:flutter/material.dart';

class ListviewPaging extends StatefulWidget {
  const ListviewPaging({super.key});

  @override
  State<ListviewPaging> createState() => _ListviewPagingState();
}

class _ListviewPagingState extends State<ListviewPaging> {
  final ScrollController _scrollController = ScrollController();
  final List<int> _data = List.generate(20, (index) => index); // Initial data

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMoreData);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // void _loadMoreData() {
  //   setState(() {
  //     _data.addAll(List.generate(10, (index) => _data.length + index));
  //   });
  // }

  void _loadMoreData() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // User has reached the end of the list
      // Load more data or trigger pagination
      setState(() {
        _data.addAll(List.generate(10, (index) => _data.length + index));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Infinite Scroll using ListView'),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.extentAfter == 0) {
            _loadMoreData();
          }
          return false;
        },
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _data.length + 1, // Add 1 for loading indicator
          itemBuilder: (_, index) {
            if (index < _data.length) {
              return ListTile(
                title: Text('Item ${[index]}'),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
