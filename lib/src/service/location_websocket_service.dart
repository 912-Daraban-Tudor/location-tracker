import 'dart:convert';
import 'package:web_socket_channel/io.dart';
import 'package:location_tracker/src/domain/model/location.dart';

class LocationWebSocketService {
  final _channel = IOWebSocketChannel.connect('ws://localhost:3000');

  Stream<Location> get locationStream =>
      _channel.stream.map((data) => Location.fromMap(jsonDecode(data)));
}
