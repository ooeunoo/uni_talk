import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Container(
          margin: const EdgeInsets.only(right: 25),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: CupertinoColors.systemGrey6,
          ),
          child: CupertinoTextField(
            controller: _searchController,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            placeholder: 'Search',
            prefix: const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Icon(CupertinoIcons.search,
                  color: CupertinoColors.systemGrey),
            ),
            style: const TextStyle(
              fontSize: 16,
              color: CupertinoColors.black,
            ),
            clearButtonMode: OverlayVisibilityMode.editing,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: CupertinoColors.systemGrey6,
            ),
            placeholderStyle:
                const TextStyle(color: CupertinoColors.systemGrey),
            cursorColor: CupertinoColors.black,
            keyboardType: TextInputType.text,
          ),
        ),
        elevation: 0,
      ),
    );
  }
}
