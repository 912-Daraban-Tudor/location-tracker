import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:location_tracker/src/domain/model/location.dart';

class LocationApiService {
  static const String baseUrl = 'http://192.168.1.138:3000';

  // Fetch all locations
  static Future<List<Location>> getLocations() async {
    final response = await http.get(Uri.parse('$baseUrl/locations'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Location.fromMap(json)).toList();
    } else {
      throw Exception('Failed to load locations');
    }
  }

  // Add a new location
  static Future<Location> addLocation(Location location) async {
    final response = await http.post(
      Uri.parse('$baseUrl/location'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(location.toMap()),
    );

    if (response.statusCode == 201) {
      return Location.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add location');
    }
  }

  // Update a location
  static Future<void> updateLocation(Location location) async {
    final response = await http.put(
      Uri.parse('$baseUrl/location/${location.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(location.toMap()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update location');
    }
  }

  // Delete a location
  static Future<void> removeLocation(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/location/$id'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete location');
    }
  }
}
