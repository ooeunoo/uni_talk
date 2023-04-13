import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

ValueKey getValueKey() {
  const uuid = Uuid();
  return ValueKey(uuid.v4());
}
