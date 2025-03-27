import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location_tracker/src/domain/model/location.dart';
import 'package:location_tracker/src/data/repository/locations_repository.dart';
import 'package:location_tracker/src/pages/widges/delete_confirmation.dart';

class RecycleViewLocations extends StatefulWidget {
  const RecycleViewLocations({super.key});

  static const routeName = '/locations';

  @override
  State<RecycleViewLocations> createState() => _RecycleViewLocationsState();
}

class _RecycleViewLocationsState extends State<RecycleViewLocations> {
  final LocationsRepository _locationsRepo = LocationsRepository();
  late Stream<List<Location>> _locationsStream;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _locationsRepo.initialize().then((_) {
      setState(() {
        _isLoading = false;
        _locationsStream = _locationsRepo.locationsStream;
      });
    }).catchError((error) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Failed to load locations. Please try again later.";
      });
    });
  }

  Future<void> _navigateToAddingLocation() async {
    final result = await Navigator.pushNamed(context, '/addLocation');
    if (result != null) {
      print('Adding location: $result'); // Debug print
      await _locationsRepo.addLocation(result as Location);
      setState(() {}); // Refresh the UI
    }
  }

  Future<void> _navigateToEditingLocation(Location location) async {
    final result = await Navigator.pushNamed(context, '/editLocation', arguments: location);
    if (result != null) {
      print('Editing location: $result'); // Debug print
      await _locationsRepo.updateLocation(result as Location);
      setState(() {}); // Refresh the UI
    }
  }

  Future<void> _navigateToDeletingLocation(Location location) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return DeleteConfirmation(
          title: 'Delete Location',
          content: 'Are you sure you want to delete ${location.nameOfLocation}?',
        );
      },
    );
    if (result == true) {
      print('Deleting location: ${location.id}'); // Debug print
      await _locationsRepo.removeLocation(location.id);
      setState(() {}); // Refresh the UI
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<DateTime>(
          stream: Stream.periodic(Duration(seconds: 1), (_) => DateTime.now()),
          builder: (context, snapshot) {
            return Text(snapshot.hasData
                ? DateFormat('yyyy/MM/dd - HH:mm:ss').format(snapshot.data!)
                : 'Loading date...');
          },
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!, style: TextStyle(color: Colors.red)))
              : StreamBuilder<List<Location>>(
                  stream: _locationsStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No locations stored'));
                    }
                    final locations = snapshot.data!;
                    return ListView.builder(
                      itemCount: locations.length,
                      itemBuilder: (context, index) {
                        final location = locations[index];
                        return GestureDetector(
                          onTap: () => _navigateToEditingLocation(location),
                          onLongPress: () => _navigateToDeletingLocation(location),
                          child: Card(
                            color: location.getParsedColor(),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              side: BorderSide(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                width: 0.8,
                              ),
                            ),
                            child: SizedBox(
                              height: 130,
                              child: Row(
                                children: [
                                  Container(
                                    width: 110,
                                    height: 120,
                                    margin: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      child: GoogleMap(
                                        initialCameraPosition: CameraPosition(
                                          target: LatLng(location.latitude, location.longitude),
                                          zoom: 15,
                                        ),
                                        markers: {
                                          Marker(
                                            markerId: MarkerId("location_marker_${location.id}"),
                                            position: LatLng(location.latitude, location.longitude),
                                          ),
                                        },
                                        zoomControlsEnabled: false,
                                        zoomGesturesEnabled: true,
                                        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{}
                                          ..add(Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer())),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          location.nameOfLocation,
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                                        ),
                                        Text(location.address, style: TextStyle(color: Colors.black)),
                                        Text("Latitude: ${location.latitude}", style: TextStyle(color: Colors.black)),
                                        Text("Longitude: ${location.longitude}", style: TextStyle(color: Colors.black)),
                                        Flexible(
                                          child: Text(
                                            location.description,
                                            style: TextStyle(color: Colors.black),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddingLocation,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}