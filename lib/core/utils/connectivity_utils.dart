import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

Future<bool> hasInternetConnection(Connectivity connectivity) async {
  final connectivityResult = await connectivity.checkConnectivity();
  final allowedConnections = [
    ConnectivityResult.mobile,
    ConnectivityResult.wifi,
  ];

  final hasMatchingConnection = connectivityResult.any((result) => allowedConnections.contains(result));

  return hasMatchingConnection;
}
