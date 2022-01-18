import 'map_launcher.dart';
import 'utils.dart';

enum MapType {
  apple,
  google,
  googleGo,
  amap,
  baidu,
  waze,
  yandexMaps,
  yandexNavi,
  citymapper,
  mapswithme,
  osmand,
  osmandplus,
  doubleGis,
  tencent,
  here,
}

enum DirectionsMode {
  driving,
  walking,
  transit,
  bicycling,
}

class Coords {
  const Coords(this.latitude, this.longitude);

  final double latitude;
  final double longitude;

  @override
  String toString() => '$latitude,$longitude';

  String toStringReversed() => '$longitude,$latitude';
}

class AvailableMap {
  AvailableMap({
    required this.mapName,
    required this.mapType,
    required this.icon,
  });

  String mapName;
  MapType mapType;
  String icon;

  static AvailableMap? fromJson(dynamic json) {
    final mapType = Utils.enumFromString(MapType.values, json['mapType']);
    if (mapType != null) {
      return AvailableMap(
        mapName: json['mapName'],
        mapType: mapType,
        icon: 'packages/map_launcher/assets/icons/${json['mapType']}.svg',
      );
    } else {
      return null;
    }
  }

  Future<void> showMarker({
    required Coords coords,
    required String title,
    String? description,
    int? zoom,
    Map<String, String>? extraParams,
  }) {
    return MapLauncher.showMarker(
      mapType: mapType,
      coords: coords,
      title: title,
      description: description,
      zoom: zoom,
      extraParams: extraParams,
    );
  }

  Future<void> showDirections({
    required Coords destination,
    String? destinationTitle,
    Coords? origin,
    String? originTitle,
    List<Coords>? waypoints,
    DirectionsMode directionsMode = DirectionsMode.driving,
    Map<String, String>? extraParams,
  }) {
    return MapLauncher.showDirections(
      mapType: mapType,
      destination: destination,
      destinationTitle: destinationTitle,
      origin: origin,
      originTitle: originTitle,
      waypoints: waypoints,
      directionsMode: directionsMode,
      extraParams: extraParams,
    );
  }

  @override
  String toString() {
    return 'AvailableMap { mapName: $mapName, '
        'mapType: ${Utils.enumToString(mapType)} }';
  }
}
