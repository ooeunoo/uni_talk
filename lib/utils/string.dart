import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

ValueKey getValueKey() {
  const uuid = Uuid();
  return ValueKey(uuid.v4());
}

void printLongString(String data) {
  const int maxPrintLength = 800;
  if (data.length <= maxPrintLength) {
    print(data);
  } else {
    int startIndex = 0;
    int endIndex = maxPrintLength;
    while (startIndex < data.length) {
      if (endIndex > data.length) {
        endIndex = data.length;
      }
      print(data.substring(startIndex, endIndex));
      startIndex = endIndex;
      endIndex = endIndex + maxPrintLength;
    }
  }
}

void printWithoutLimit(String data) {
  print('#####################################');
  data.split('\n').forEach((line) => print(line));
  print('#####################################');

}
