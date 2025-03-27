import 'package:flutter/material.dart';
import 'package:location_tracker/src/domain/model/location.dart';

class LocationForm extends StatelessWidget {
  final Location initialData;
  final Function(Location) onSubmit;

  LocationForm({required this.initialData, required this.onSubmit});

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _descriptionController = TextEditingController(); 
  final _colorMarkerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (initialData.id != 0) {
      _nameController.text = initialData.nameOfLocation;
      _addressController.text = initialData.address;
      _latitudeController.text = initialData.latitude.toString();
      _longitudeController.text = initialData.longitude.toString();
      _descriptionController.text = initialData.description;
      _colorMarkerController.text = initialData.markerColor;
    }

    void submitForm() {
      if (_formKey.currentState!.validate()) {
        var location = Location.empty();
        if (initialData.id != 0) {
          location = initialData;
        }
        location.nameOfLocation = _nameController.text;
        location.address = _addressController.text;
        location.latitude = double.parse(_latitudeController.text);
        location.longitude = double.parse(_longitudeController.text);
        location.description = _descriptionController.text;
        location.markerColor = _colorMarkerController.text;
        if (location.markerColor == '') {
          location.markerColor = 'red';
        }
        if (location.description == 'empty') {
          location.description = '${location.nameOfLocation} This is a great place to visit!';
        }
        onSubmit(location);
      }
    }

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value != initialData.nameOfLocation) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name!';
                  }
                  if (value.length < 3) {
                    return 'Please enter a name with at least 3 characters!';
                  }
                  if (!RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(value)) {
                    return 'Please enter a name with only letters, spaces and numbers!';
                  }
                  if (value.length > 50) {
                    return 'Please enter a name with at most 50 characters!';
                  }
                }
                return null;
              },
            ),
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an address!';
                }
                if (value.length < 3) {
                  return 'Please enter an address with at least 3 characters!';
                }
                if (value.length > 100) {
                  return 'Please enter an address with at most 100 characters!';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _latitudeController,
              decoration: InputDecoration(labelText: 'Latitude'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a latitude!';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid latitude!';
                }
                if (double.parse(value) < -90 || double.parse(value) > 90) {
                  return 'Please enter a latitude between -90 and 90!';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _longitudeController,
              decoration: InputDecoration(labelText: 'Longitude'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a longitude!';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid longitude!';
                }
                if (double.parse(value) < -180 || double.parse(value) > 180) {
                  return 'Please enter a longitude between -180 and 180!';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description!';
                }
                if (value.length < 3) {
                  return 'Please enter a description with at least 3 characters!';
                }
                if (value.length > 200) {
                  return 'Please enter a description with at most 200 characters!';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _colorMarkerController,
              decoration: InputDecoration(labelText: 'Color Marker'),
              validator: (value) {
                List<String> colors = ['red', 'blue', 'green', 'yellow', 'purple', 'orange', 'pink', 'brown', 'black', 'white'];
                if (value == null || value.isEmpty) {
                  return 'Please enter a color marker!';
                }
                if (!colors.contains(value)) {
                  return 'Please enter a valid color marker!';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: submitForm,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}