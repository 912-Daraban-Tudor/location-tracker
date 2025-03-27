import 'package:flutter/material.dart';
import 'package:location_tracker/src/domain/model/location.dart';
import 'package:location_tracker/src/pages/widges/location_form.dart';

class EditLocation extends StatelessWidget {
  static const routeName = '/editLocation';

  @override
  Widget build (BuildContext context) {
    final oldLocation = ModalRoute.of(context)!.settings.arguments as Location;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Edit Location'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LocationForm(
          initialData: oldLocation,
          onSubmit: (location) {
            Navigator.pop(context, location);
          },
        )
      )
    );
  }
}