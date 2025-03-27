import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:location_tracker/src/domain/model/location.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class LocationsRepository {
  static final LocationsRepository _instance = LocationsRepository._internal();
  factory LocationsRepository() => _instance;
  LocationsRepository._internal();

  final List<Location> _cachedLocations = [];
  bool _isInitialized = false;

  final _controller = StreamController<List<Location>>.broadcast();
  Stream<List<Location>> get locationsStream => _controller.stream;

  final WebSocketChannel _channel = IOWebSocketChannel.connect('ws://192.168.1.138:3000');

  Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      final response = await http.get(Uri.parse('http://192.168.1.138:3000/locations'));
      if (response.statusCode == 200) {
        _cachedLocations.clear();
        _cachedLocations.addAll(
          (jsonDecode(response.body) as List).map((data) => Location.fromMap(data)),
        );
        _controller.add(_cachedLocations);
        _isInitialized = true;
      } else {
        throw Exception('Failed to fetch locations');
      }
    } catch (e) {
      print('[ERROR] Failed to initialize locations: $e');
    }

    _channel.stream.listen((message) {
      final data = jsonDecode(message);
      if (data['deleted'] != null) {
        _cachedLocations.removeWhere((loc) => loc.id == data['deleted']);
      } else {
        final updatedLocation = Location.fromMap(data);
        final index = _cachedLocations.indexWhere((loc) => loc.id == updatedLocation.id);
        if (index != -1) {
          _cachedLocations[index] = updatedLocation;
        } else {
          _cachedLocations.add(updatedLocation);
        }
      }
      _controller.add(_cachedLocations);
    });
  }

  Future<void> addLocation(Location location) async {
  try {
    final response = await http.post(
      Uri.parse('http://192.168.1.138:3000/location'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(location.toMap()),
    );
    if (response.statusCode == 201) {
      _cachedLocations.add(location); // Add to local cache
      _controller.add(_cachedLocations); // Notify listeners
      print('[DEBUG] Location added successfully');
    } else {
      throw Exception('Failed to add location');
    }
  } catch (e) {
    print('[ERROR] Failed to add location: $e');
  }
}

Future<void> updateLocation(Location location) async {
  try {
    final response = await http.put(
      Uri.parse('http://192.168.1.138:3000/location/${location.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(location.toMap()),
    );
    if (response.statusCode == 200) {
      final index = _cachedLocations.indexWhere((loc) => loc.id == location.id);
      if (index != -1) {
        _cachedLocations[index] = location; // Update the local cache
        _controller.add(_cachedLocations); // Notify listeners
      }
      print('[DEBUG] Location updated successfully');
    } else {
      throw Exception('Failed to update location');
    }
  } catch (e) {
    print('[ERROR] Failed to update location: $e');
  }
}

Future<void> removeLocation(int id) async {
  try {
    final response = await http.delete(Uri.parse('http://192.168.1.138:3000/location/$id'));
    if (response.statusCode == 204) {
      _cachedLocations.removeWhere((loc) => loc.id == id); // Remove from local cache
      _controller.add(_cachedLocations); // Notify listeners
      print('[DEBUG] Location deleted successfully');
    } else {
      throw Exception('Failed to delete location');
    }
  } catch (e) {
    print('[ERROR] Failed to delete location: $e');
  }
}

}
