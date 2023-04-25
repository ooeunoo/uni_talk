import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:uni_talk/models/storage_box.dart';
import 'package:uni_talk/providers/storage_box_provider.dart';
import 'package:uni_talk/providers/user_provider.dart';
import 'package:uni_talk/screens/storage_box/widgets/storage_box_card.dart';

class StorageBoxHomeScreen extends StatefulWidget {
  const StorageBoxHomeScreen({super.key});

  @override
  State<StorageBoxHomeScreen> createState() => _StorageBoxHomeScreenState();
}

class _StorageBoxHomeScreenState extends State<StorageBoxHomeScreen> {
  final StorageBoxProvider _storageBoxProvider = StorageBoxProvider();
  final UserProvider _userProvider = UserProvider();
  final TextEditingController _titleTextController = TextEditingController();

  Future<bool> createStorageBox(String title) async {
    User? user = _userProvider.currentUser;
    if (user == null) {
      return false;
    }

    if (title.isEmpty) {
      return false;
    }

    StorageBox storageBox =
        StorageBox(icon: '', userId: user.uid, title: title, totalItems: 0);

    await _storageBoxProvider.createStorageBox(storageBox);

    return true;
  }

  void _showCreateStorageBoxDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('새 서랍장'),
        content: TextField(
          controller: _titleTextController,
          decoration: const InputDecoration(
            hintText: '',
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              bool success = await createStorageBox(_titleTextController.text);
              // Close the dialog box

              if (success) {
                Navigator.pop(context);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const int pageSize = 10;
    const int crossAxisCount = 1;
    const double mainAxisSpacing = 8;
    const double crossAxisSpacing = 8;
    final double itemWidth = MediaQuery.of(context).size.width / 2;
    const double itemHeight = 30.0;
    final double aspectRatio = itemWidth / itemHeight;

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          title: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 30),
              child: Text("서랍장",
                  style: TextStyle(
                      color: CupertinoColors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold))),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: IconButton(
                icon: const Icon(CupertinoIcons.add),
                onPressed: () {
                  _showCreateStorageBoxDialog(context);
                },
              ),
            ),
          ],
          centerTitle: false,
          elevation: 0,
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: FirestoreQueryBuilder<StorageBox>(
                    query: _storageBoxProvider.getStorageBoxReferences(
                        _userProvider.currentUser!.uid),
                    pageSize: pageSize,
                    builder: (context, snapshot, _) {
                      if (snapshot.isFetching) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text("Something went worng!, ${snapshot.error}");
                      } else {
                        return GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: aspectRatio,
                                    mainAxisSpacing: mainAxisSpacing,
                                    crossAxisSpacing: crossAxisSpacing,
                                    crossAxisCount: crossAxisCount),
                            itemCount: snapshot.docs.length,
                            itemBuilder: (context, index) {
                              final hasEndReeached = snapshot.hasMore &&
                                  index + 1 == snapshot.docs.length &&
                                  !snapshot.isFetchingMore;

                              if (hasEndReeached) {
                                snapshot.fetchMore();
                              }

                              final storageBox = snapshot.docs[index].data();
                              return StorageBoxCard(storageBox: storageBox);
                            });
                      }
                    },
                  )),
            )
          ],
        ));
  }
}
