import 'package:flutter/material.dart';

class Location {
  int id;
  String nameOfLocation;
  String address;
  double latitude;
  double longitude;
  String description;
  String markerColor;

  

  Location(this.id, this.nameOfLocation, this.address, this.latitude, this.longitude, this.description, this.markerColor);
  Location.empty() :
    id = 0,
    nameOfLocation = 'Loc1',
    address = '',
    latitude = 0.0,
    longitude = 0.0,
    description = "This is a great place to visit!",
    markerColor = 'red';


  @override
  bool operator ==(Object other) {
    return other is Location && other.id == id;
  }

Color getParsedColor() {
    try {
      if (markerColor.startsWith('#')) {
        return Color(int.parse(markerColor.replaceFirst('#', '0xFF')));
      } else {
        Map<String, Color> colorMapping = {
          'red': Colors.red,
          'blue': Colors.blue,
          'green': Colors.green,
          'yellow': Colors.yellow, 
          'purple': Colors.purple, 
          'orange': Colors.orange, 
          'pink': Colors.pink, 
          'brown': Colors.brown, 
          'black': Colors.black, 
          'white: ': Colors.white,
        };
        return colorMapping[markerColor.toLowerCase()] ?? Colors.grey;
      }
    } catch (e) {
      return Colors.grey; // Default color
    }
  }


  @override
  int get hashCode => id.hashCode;

  bool isIdentical(Location other) {
    return other.id == id && other.nameOfLocation == nameOfLocation && other.address == address && other.latitude == latitude && other.longitude == longitude && other.description == description && other.markerColor == markerColor;
    }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'nameOfLocation': nameOfLocation,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
      'markerColor': markerColor
    };
    map['id'] = id;
    return map;
  }

  Location.fromMap(Map<dynamic, dynamic> map) :
    id = map['id'],
    nameOfLocation = map['nameOfLocation'],
    address = map['address'],
    latitude = map['latitude'],
    longitude = map['longitude'],
    description = map['description'],
    markerColor = map['markerColor'];
}