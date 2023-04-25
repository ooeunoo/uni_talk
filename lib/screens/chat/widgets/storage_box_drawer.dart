import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:uni_talk/models/storage_box.dart';
import 'package:uni_talk/providers/storage_box_provider.dart';
import 'package:uni_talk/providers/user_provider.dart';
import 'package:uni_talk/screens/chat/widgets/save_storage_box_card.dart';

class StorageBoxDrawer extends StatefulWidget {
  final void Function(StorageBox storageBox) handleSaveStorage;

  const StorageBoxDrawer({super.key, required this.handleSaveStorage});

  @override
  State<StorageBoxDrawer> createState() => _StorageBoxDrawerState();
}

class _StorageBoxDrawerState extends State<StorageBoxDrawer> {
  final StorageBoxProvider _storageBoxProvider = StorageBoxProvider();
  final UserProvider _userProvider = UserProvider();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    const int crossAxisCount = 1;
    final double itemWidth = MediaQuery.of(context).size.width / 2;
    const double itemHeight = 30.0;
    final double aspectRatio = itemWidth / itemHeight;

    return SizedBox(
        height: screenHeight * 1, // Set the height to half of the screen height
        // Customize your BottomSheet content here
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      width: 30,
                    ),
                    // add IconButton
                    IconButton(
                      icon: const Icon(CupertinoIcons.add),
                      iconSize: 30,
                      onPressed: () {
                        // Add your onPressed logic here
                      },
                    ),
                  ],
                )),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: FirestoreQueryBuilder<StorageBox>(
                query: _storageBoxProvider
                    .getStorageBoxReferences(_userProvider.currentUser!.uid),
                builder: (context, snapshot, _) {
                  if (snapshot.isFetching) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text("Something went worng!, ${snapshot.error}");
                  } else {
                    return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                          return SaveStorageBoxCard(
                              storageBox: storageBox,
                              handleSaveStorage: (storageBox) =>
                                  widget.handleSaveStorage(storageBox));
                        });
                  }
                },
              ),
            ))
          ],
        ));
  }
}
