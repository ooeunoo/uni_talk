import 'package:firebase_auth/firebase_auth.dart';
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
  final searchController = TextEditingController();

  Future<void> getCreateStorageBox() async {
    User? user = _userProvider.currentUser;
    if (user == null) {
      return;
    }

    StorageBox storageBox =
        StorageBox(icon: '', userId: user.uid, title: 'hello', totalItems: 0);

    await _storageBoxProvider.createStorageBox(storageBox);

    return;
  }

  @override
  Widget build(BuildContext context) {
    const int pageSize = 10;
    const int crossAxisCount = 1;
    final double itemWidth = MediaQuery.of(context).size.width / 2;
    const double itemHeight = 50.0;
    final double aspectRatio = itemWidth / itemHeight;

    return Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: searchController,
            decoration: const InputDecoration(
              hintText: 'Search',
              hintStyle: TextStyle(color: Colors.white54),
              border: InputBorder.none,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                getCreateStorageBox();
              },
            ),
          ],
          elevation: 0,
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FirestoreQueryBuilder<StorageBox>(
                    query: _storageBoxProvider.getStorageBoxReferences(
                        UserProvider().currentUser!.uid),
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
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 8,
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
