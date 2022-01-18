import 'dart:io';
import 'models.dart';
import 'utils.dart';

String getMapDirectionsUrl({
  required MapType mapType,
  required Coords destination,
  String? destinationTitle,
  Coords? origin,
  String? originTitle,
  DirectionsMode? directionsMode,
  List<Coords>? waypoints,
  Map<String, String>? extraParams,
}) {
  switch (mapType) {
    case MapType.google:
      return Utils.buildUrl(
        url: 'https://www.google.com/maps/dir/',
        queryParams: {
          'api': '1',
          'destination': '$destination',
          'origin': Utils.nullOrValue(
            origin,
            '${origin?.latitude},${origin?.longitude}',
          ),
          'waypoints': waypoints
              ?.map((coords) => '${coords.latitude},${coords.longitude}')
              .join('|'),
          'travelmode': Utils.enumToString(directionsMode),
          ...extraParams ?? {},
        },
      );

    case MapType.googleGo:
      return Utils.buildUrl(
        url: 'https://www.google.com/maps/dir/',
        queryParams: {
          'api': '1',
          'destination': '$destination',
          'origin': Utils.nullOrValue(
            origin,
            '${origin?.latitude},${origin?.longitude}',
          ),
          'waypoints': waypoints
              ?.map((coords) => '${coords.latitude},${coords.longitude}')
              .join('|'),
          'travelmode': Utils.enumToString(directionsMode),
          ...extraParams ?? {},
        },
      );

    case MapType.apple:
      return Utils.buildUrl(
        url: 'http://maps.apple.com/maps',
        queryParams: {
          'daddr': '$destination',
          ...extraParams ?? {},
        },
      );

    case MapType.amap:
      return Utils.buildUrl(
        url: Platform.isIOS ? 'iosamap://path' : 'amapuri://route/plan/',
        queryParams: {
          'sourceApplication': 'applicationName',
          'dlat': '${destination.latitude}',
          'dlon': '${destination.longitude}',
          'dname': destinationTitle,
          'slat': Utils.nullOrValue(origin, '${origin?.latitude}'),
          'slon': Utils.nullOrValue(origin, '${origin?.longitude}'),
          'sname': originTitle,
          't': Utils.getAmapDirectionsMode(directionsMode),
          'dev': '0',
          ...extraParams ?? {},
        },
      );

    case MapType.baidu:
      final latlng = '${origin?.latitude},${origin?.longitude}';
      return Utils.buildUrl(
        url: 'baidumap://map/direction',
        queryParams: {
          'destination':
              'name: ${destinationTitle ?? 'Destination'}|latlng:$destination',
          'origin': Utils.nullOrValue(
            origin,
            'name: ${originTitle ?? 'Origin'}|latlng:$latlng',
          ),
          'coord_type': 'gcj02',
          'mode': Utils.getBaiduDirectionsMode(directionsMode),
          'src': 'com.map_launcher',
          ...extraParams ?? {},
        },
      );

    case MapType.waze:
      return Utils.buildUrl(
        url: 'waze://',
        queryParams: {
          'll': '$destination',
          'z': '10',
          'navigate': 'yes',
          ...extraParams ?? {},
        },
      );

    case MapType.citymapper:
      return Utils.buildUrl(url: 'citymapper://directions', queryParams: {
        'endcoord': '$destination',
        'endname': destinationTitle,
        'startcoord': Utils.nullOrValue(
          origin,
          '${origin?.latitude},${origin?.longitude}',
        ),
        'startname': originTitle,
        ...extraParams ?? {},
      });

    case MapType.osmand:
    case MapType.osmandplus:
      if (Platform.isIOS) {
        return Utils.buildUrl(
          url: 'osmandmaps://navigate',
          queryParams: {
            'lat': '${destination.latitude}',
            'lon': '${destination.longitude}',
            'title': destinationTitle,
            ...extraParams ?? {},
          },
        );
      }
      return 'osmand.navigation:q=$destination';

    case MapType.mapswithme:
      // Couldn't get //route to work properly as of 2020/07
      // so just using the marker method for now
      // return Utils.buildUrl(
      //   url: 'mapsme://route',
      //   queryParams: {
      //     'dll': '$destination',
      //     'daddr': destinationTitle,
      //     'sll': Utils.nullOrValue(
      //       origin,
      //       '${origin?.latitude},${origin?.longitude}',
      //     ),
      //     'saddr': originTitle,
      //     'type': Utils.getMapsMeDirectionsMode(directionsMode),
      //   },
      // );
      return Utils.buildUrl(
        url: 'mapsme://map',
        queryParams: {
          'v': '1',
          'll': '$destination',
          'n': destinationTitle,
          ...extraParams ?? {},
        },
      );

    case MapType.yandexMaps:
      return Utils.buildUrl(
        url: 'yandexmaps://maps.yandex.com/',
        queryParams: {
          'rtext': '${origin?.latitude},${origin?.longitude}~$destination',
          'rtt': Utils.getYandexMapsDirectionsMode(directionsMode),
          ...extraParams ?? {},
        },
      );

    case MapType.yandexNavi:
      return Utils.buildUrl(
        url: 'yandexnavi://build_route_on_map',
        queryParams: {
          'lat_to': '${destination.latitude}',
          'lon_to': '${destination.longitude}',
          'lat_from': Utils.nullOrValue(origin, '${origin?.latitude}'),
          'lon_from': Utils.nullOrValue(origin, '${origin?.longitude}'),
        },
      );

    case MapType.doubleGis:
      final directionsPath = Utils.getDoubleGisDirectionsMode(directionsMode);
      final fromPath =
          origin == null ? '' : 'from/${origin.toStringReversed()}/';
      final toPath = 'to/${destination.toStringReversed()}';
      final path = '$directionsPath/$fromPath$toPath';
      return Utils.buildUrl(
        url: 'dgis://2gis.ru/routeSearch/rsType/$path',
        queryParams: {
          ...extraParams ?? {},
        },
      );

    case MapType.tencent:
      return Utils.buildUrl(
        url: 'qqmap://map/routeplan',
        queryParams: {
          'from': originTitle,
          'fromcoord': '${origin?.latitude},${origin?.longitude}',
          'to': destinationTitle,
          'tocoord': '$destination',
          'type': Utils.getTencentDirectionsMode(directionsMode),
          ...extraParams ?? {},
        },
      );

    case MapType.here:
      final originPath =
          '${origin?.latitude},${origin?.longitude},$originTitle';
      return Utils.buildUrl(
        url: 'https://share.here.com/r/$originPath/$destination',
        queryParams: {
          'm': Utils.getHereDirectionsMode(directionsMode),
          ...extraParams ?? {},
        },
      );
  }
}
