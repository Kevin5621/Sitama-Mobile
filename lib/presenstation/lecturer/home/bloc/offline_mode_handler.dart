import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sitama/presenstation/lecturer/home/bloc/lecturer_display_cubit.dart';

class ConnectivityHandler extends StatefulWidget {
  final Widget child;
  const ConnectivityHandler({super.key, required this.child});

  @override
  State<ConnectivityHandler> createState() => _ConnectivityHandlerState();
}

class _ConnectivityHandlerState extends State<ConnectivityHandler> {
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool _wasOffline = false;

  @override
  void initState() {
    super.initState();
    _initConnectivity();
  }

  Future<void> _initConnectivity() async {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen(_updateConnectionStatus as void Function(List<ConnectivityResult> event)?) as StreamSubscription<ConnectivityResult>;
  }

  void _updateConnectionStatus(ConnectivityResult result) async {
    final isOffline = result == ConnectivityResult.none;
    
    if (_wasOffline && !isOffline) {
      if (context.mounted) {
        final cubit = context.read<LecturerDisplayCubit>();
        cubit.displayLecturer();
      }
    }
    
    _wasOffline = isOffline;
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}