import 'package:flutter/material.dart';
import 'package:location_tracker/src/domain/model/location.dart';
import 'package:location_tracker/src/pages/widges/location_form.dart';

class AddLocation extends StatelessWidget {
  static const routeName = '/addLocation';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Add Location'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LocationForm(
          initialData: Location.empty(),
          onSubmit: (location) {
            Navigator.pop(context, location);
          },
        ),
      ),
    );
  }
}