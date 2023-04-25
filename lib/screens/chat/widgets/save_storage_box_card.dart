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
          color: const Color.fromARGB(204, 255, 255, 255),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
              height: 5.0, // Set the desired height for the card.
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 50,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              storageBox.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18.0,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(storageBox.totalItems.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18.0,
                            color: Colors.grey))
                  ],
                ),
              )),
        ));
  }
}
