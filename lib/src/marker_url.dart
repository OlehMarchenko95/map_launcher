import 'dart:io';

import 'models.dart';
import 'utils.dart';

String getMapMarkerUrl({
  required MapType mapType,
  required Coords coords,
  String? title,
  String? description,
  int? zoom,
  Map<String, String>? extraParams,
}) {
  final zoomLevel = zoom ?? 16;
  switch (mapType) {
    case MapType.google:
      return Utils.buildUrl(
        url: Platform.isIOS ? 'comgooglemaps://' : 'geo:0,0',
        queryParams: {
          'q': '$coords($title)',
          'zoom': '$zoomLevel',
          ...extraParams ?? {},
        },
      );

    case MapType.googleGo:
      return Utils.buildUrl(
        url: 'http://maps.google.com/maps',
        queryParams: {
          'q': '$coords($title)',
          'zoom': '$zoomLevel',
          ...extraParams ?? {},
        },
      );

    case MapType.amap:
      return Utils.buildUrl(
        url: '${Platform.isIOS ? 'ios' : 'android'}amap://viewMap',
        queryParams: {
          'sourceApplication': 'map_launcher',
          'poiname': '$title',
          'lat': '${coords.latitude}',
          'lon': '${coords.longitude}',
          'zoom': '$zoomLevel',
          'dev': '0',
          ...extraParams ?? {},
        },
      );

    case MapType.baidu:
      return Utils.buildUrl(
        url: 'baidumap://map/marker',
        queryParams: {
          'location': '$coords',
          'title': title ?? 'Title',
          'content': description ??
              'Description', // baidu fails if no description provided
          'traffic': 'on',
          'src': 'com.map_launcher',
          'coord_type': 'gcj02',
          'zoom': '$zoomLevel',
          ...extraParams ?? {},
        },
      );

    case MapType.apple:
      return Utils.buildUrl(
        url: 'http://maps.apple.com/maps',
        queryParams: {
          'saddr': '$coords',
          ...extraParams ?? {},
        },
      );

    case MapType.waze:
      return Utils.buildUrl(
        url: 'waze://',
        queryParams: {
          'll': '$coords',
          'z': '$zoomLevel',
          ...extraParams ?? {},
        },
      );

    case MapType.yandexNavi:
      return Utils.buildUrl(
        url: 'yandexnavi://show_point_on_map',
        queryParams: {
          'lat': '${coords.latitude}',
          'lon': '${coords.longitude}',
          'zoom': '$zoomLevel',
          'no-balloon': '0',
          'desc': '$title',
          ...extraParams ?? {},
        },
      );

    case MapType.yandexMaps:
      return Utils.buildUrl(
        url: 'yandexmaps://maps.yandex.ru/',
        queryParams: {
          'pt': coords.toStringReversed(),
          'z': '$zoomLevel',
          'l': 'map',
          ...extraParams ?? {},
        },
      );

    case MapType.citymapper:
      return Utils.buildUrl(
        url: 'citymapper://directions',
        queryParams: {
          'endcoord': '$coords',
          'endname': '$title',
          ...extraParams ?? {},
        },
      );

    case MapType.mapswithme:
      return Utils.buildUrl(
        url: 'mapsme://map',
        queryParams: {
          'v': '1',
          'll': '$coords',
          'n': title,
          ...extraParams ?? {},
        },
      );

    case MapType.osmand:
    case MapType.osmandplus:
      if (Platform.isIOS) {
        return Utils.buildUrl(
          url: 'osmandmaps://',
          queryParams: {
            'lat': '${coords.latitude}',
            'lon': '${coords.longitude}',
            'z': '$zoomLevel',
            'title': title,
            ...extraParams ?? {},
          },
        );
      }
      return Utils.buildUrl(
        url: 'http://osmand.net/go',
        queryParams: {
          'lat': '${coords.latitude}',
          'lon': '${coords.longitude}',
          'z': '$zoomLevel',
          ...extraParams ?? {},
        },
      );

    case MapType.doubleGis:
      if (Platform.isIOS) {
        return Utils.buildUrl(
          url: 'dgis://2gis.ru/geo/${coords.toStringReversed()}',
          queryParams: {
            ...extraParams ?? {},
          },
        );
      }

      // android app does not seem to support marker by coordinates
      // so falling back to directions
      return Utils.buildUrl(
        url: 'dgis://2gis.ru/routeSearch/rsType/car/to/'
            '${coords.toStringReversed()}',
        queryParams: {
          ...extraParams ?? {},
        },
      );

    case MapType.tencent:
      return Utils.buildUrl(
        url: 'qqmap://map/marker',
        queryParams: {
          'marker': 'coord:$coords${title != null ? ';title:$title' : ''}',
          ...extraParams ?? {},
        },
      );

    case MapType.here:
      return Utils.buildUrl(
        url: 'https://share.here.com/l/$coords,$title',
        queryParams: {
          'z': '$zoomLevel',
          ...extraParams ?? {},
        },
      );
  }
}
