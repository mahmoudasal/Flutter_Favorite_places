import 'dart:io';

import 'package:favorite_places/models/place.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class PlacesException implements Exception {
  final String message;
  final String? details;
  
  PlacesException(this.message, [this.details]);
  
  @override
  String toString() => 'PlacesException: $message${details != null ? ' ($details)' : ''}';
}

Future<Database> _getDatabase() async {
  try {
    final dbPath = await sql.getDatabasesPath();
    final db = await sql.openDatabase(
      path.join(dbPath, 'places.db'),
      onCreate: (db, version) async {
        try {
          await db.execute(
            'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)',
          );
        } catch (e) {
          throw PlacesException('Failed to create database table', e.toString());
        }
      },
      version: 2,
    );
    return db;
  } catch (e) {
    throw PlacesException('Failed to initialize database', e.toString());
  }
}

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);

  Future<void> loadPlaces() async {
    try {
      final db = await _getDatabase();

      final data = await db.query('user_places');
      final places = <Place>[];
      
      for (final row in data) {
        try {
          final imageFile = File(row['image'] as String);
          // Check if image file exists before creating Place
          if (await imageFile.exists()) {
            places.add(
              Place(
                id: row['id'] as String,
                title: row['title'] as String,
                location: PlaceLocation(
                  latitude: row['lat'] as double,
                  longtitude: row['lng'] as double,
                  address: row['address'] as String,
                ),
                image: imageFile,
              ),
            );
          }
        } catch (e) {
          // Log individual place loading error but continue with others
          print('Error loading place ${row['id']}: $e');
        }
      }

      state = places;
    } catch (e) {
      throw PlacesException('Failed to load places from database', e.toString());
    }
  }

  Future<void> addPlace(String title, File image, PlaceLocation location) async {
    try {
      // Validate inputs
      if (title.trim().isEmpty) {
        throw PlacesException('Place title cannot be empty');
      }
      
      if (!await image.exists()) {
        throw PlacesException('Selected image file does not exist');
      }

      // Get app directory with error handling
      final appDir = await syspath.getApplicationDocumentsDirectory();
      final filename = path.basename(image.path);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final uniqueFilename = '${timestamp}_$filename';
      final targetPath = '${appDir.path}/$uniqueFilename';

      // Copy image with error handling
      final copiedImage = await image.copy(targetPath);
      
      // Verify the copy was successful
      if (!await copiedImage.exists()) {
        throw PlacesException('Failed to save image file');
      }

      final newPlace = Place(
        title: title.trim(),
        image: copiedImage,
        location: location,
      );

      // Database operations with error handling
      final db = await _getDatabase();
      
      await db.insert('user_places', {
        'id': newPlace.id,
        'title': newPlace.title,
        'image': newPlace.image.path,
        'lat': newPlace.location.latitude,
        'lng': newPlace.location.longtitude,
        'address': newPlace.location.address,
      });

      // Update state only after successful database insert
      state = [newPlace, ...state];
    } catch (e) {
      if (e is PlacesException) {
        rethrow;
      }
      throw PlacesException('Failed to add place', e.toString());
    }
  }

  Future<void> removePlace(String placeId) async {
    try {
      final db = await _getDatabase();
      
      // Find the place to get image path before deletion
      final placeData = await db.query(
        'user_places',
        where: 'id = ?',
        whereArgs: [placeId],
      );
      
      if (placeData.isEmpty) {
        throw PlacesException('Place not found');
      }

      // Delete from database
      final deletedRows = await db.delete(
        'user_places',
        where: 'id = ?',
        whereArgs: [placeId],
      );

      if (deletedRows == 0) {
        throw PlacesException('Failed to delete place from database');
      }

      // Try to delete the image file (don't throw error if this fails)
      try {
        final imageFile = File(placeData.first['image'] as String);
        if (await imageFile.exists()) {
          await imageFile.delete();
        }
      } catch (e) {
        print('Warning: Could not delete image file: $e');
      }

      // Update state
      state = state.where((place) => place.id != placeId).toList();
    } catch (e) {
      if (e is PlacesException) {
        rethrow;
      }
      throw PlacesException('Failed to remove place', e.toString());
    }
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
      (ref) => UserPlacesNotifier(),
    );
