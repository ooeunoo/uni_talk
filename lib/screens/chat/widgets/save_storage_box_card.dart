import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni_talk/models/storage_box.dart';

class SaveStorageBoxCard extends StatelessWidget {
  final StorageBox storageBox;
  final void Function(StorageBox storageBox) handleSaveStorage;

  const SaveStorageBoxCard(
      {super.key, required this.storageBox, required this.handleSaveStorage});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => handleSaveStorage(storageBox),
        child: Card(
          color: Colors.white,
          elevation: 3.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            height: 10.0, // Set the desired height for the card.
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            storageBox.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    handleSaveStorage(storageBox);
                  },
                  icon: const Icon(
                    CupertinoIcons.add_circled,
                    color: Colors.blue,
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
