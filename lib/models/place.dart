import 'dart:io';

import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Place {
  Place({required this.image, required this.title, required this.location , id })
    : id = id ?? uuid.v4();

  final String id;
  final String title;
  final File image;
  final PlaceLocation location;
}

class PlaceLocation {
  final double latitude;
  final double longtitude;
  final String address;

  const PlaceLocation({
    required this.latitude,
    required this.longtitude,
    required this.address,
  });
}
