import 'dart:core';

import 'package:flutter/material.dart';

class Event {
  late String name, description;
  late DateTime date;

  Event(name_, description_, date_) {
    name = name_;
    description = description_;
    date = date_;
  }
}
