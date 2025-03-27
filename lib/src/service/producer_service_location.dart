import "package:location_tracker/src/domain/model/location.dart";
import "package:location_tracker/src/data/repository/locations_repository.dart";

class ProducerService {
  final LocationsRepository _locationsRepository = LocationsRepository();

  Future addLocation(Location location) {
    return _locationsRepository.addLocation(location);
  }

  Future removeLocation(int locationID) {
    return _locationsRepository.removeLocation(locationID);
  }

  Future updateLocation(Location location) {
    return _locationsRepository.updateLocation(location);
  }

  /*
  Future<List<Location>> getLocations() {
    return _locationsRepository.getLocations();
  }

  
  Future getLocationById(int id) {
    return _locationsRepository.getLocationById(id);
  }
  */
}
