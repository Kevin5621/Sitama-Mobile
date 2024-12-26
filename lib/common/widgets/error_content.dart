import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Sitama/core/config/assets/app_images.dart';
import 'package:Sitama/common/bloc/button/button_state.dart';
import 'package:Sitama/common/bloc/button/button_state_cubit.dart';

class ErrorContent extends StatefulWidget {
  final String errorMessage;
  final VoidCallback onRetry;
  final bool wasError;

  const ErrorContent({
    super.key,
    required this.errorMessage,
    required this.onRetry,
    required this.wasError,
  });

  @override
  State<ErrorContent> createState() => _ErrorContentState();
}

class _ErrorContentState extends State<ErrorContent> {
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  
  get errorMessage => widget.errorMessage;
  get onRetry => widget.onRetry;

  @override
  void initState() {
    super.initState();
    _setupConnectivityListener();
  }

  void _setupConnectivityListener() {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      bool hasConnection = results.contains(ConnectivityResult.wifi) || 
                          results.contains(ConnectivityResult.mobile);
      
      if (hasConnection && widget.wasError && mounted) {
        widget.onRetry();
      }
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ButtonStateCubit(),
      child: BlocBuilder<ButtonStateCubit, ButtonState>(
        builder: (context, state) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildErrorImage(),
                  const SizedBox(height: 24),
                  _buildErrorTitle(context),
                  const SizedBox(height: 8),
                  _buildErrorSubtitle(context),
                  const SizedBox(height: 24),
                  _buildRetryButton(context, state),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorImage() {
    return Image.asset(
      AppImages.offline,
      height: 200,
      width: 200,
    );
  }

  Widget _buildErrorTitle(BuildContext context) {
    return Text(
      _getErrorTitle(),
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildErrorSubtitle(BuildContext context) {
    return Text(
      _getSubtitleMessage(),
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey,
          ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildRetryButton(BuildContext context, ButtonState state) {
    return ElevatedButton.icon(
      onPressed: state is ButtonLoadingState
          ? null
          : () async {
              final cubit = context.read<ButtonStateCubit>();
              cubit.startLoading();
              
              // Wrap the onRetry callback in a try-catch to handle errors
              try {
                await Future(() => onRetry());
                // Reset state after successful retry
                cubit.resetState();
              } catch (e) {
                // Reset state if there's an error
                cubit.resetState();
              }
            },
      icon: state is ButtonLoadingState
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
          : const Icon(Icons.refresh),
      label: Text(
        state is ButtonLoadingState ? 'Menghubungkan...' : 'Coba Lagi',
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
      ),
    );
  }

  String _getErrorTitle() {
    if (widget.errorMessage.contains('koneksi') ||
        widget.errorMessage.contains('internet') ||
        widget.errorMessage.contains('server')) {
      return 'Tidak ada koneksi internet';
    }
    return 'Terjadi Kesalahan';
  }

  String _getSubtitleMessage() {
    if (widget.errorMessage.contains('koneksi') || widget.errorMessage.contains('internet')) {
      return 'Periksa koneksi internet Anda dan coba lagi';
    } else if (widget.errorMessage.contains('server')) {
      return 'Server sedang mengalami gangguan, silakan coba beberapa saat lagi';
    }
    return 'Terjadi kesalahan, silakan coba lagi';
  }
}