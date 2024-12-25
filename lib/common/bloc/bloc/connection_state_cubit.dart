// import 'dart:async';
// import 'package:Sitama/common/bloc/bloc/connection_state.dart';
// import 'package:Sitama/core/constansts/api_urls.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';

// class ConnectionStateCubit extends Cubit<NetworkState> {
//   final Connectivity _connectivity = Connectivity();
//   final Dio _dio = Dio();
//   StreamSubscription? _connectivitySubscription;
//   Timer? _retryTimer;
//   final Duration checkInterval = const Duration(seconds: 5);

//   ConnectionStateCubit() : super(NetworkInitial()) {
//     _initializeDio();
//     monitorConnection();
//   }

//   void _initializeDio() {
//     _dio.options.baseUrl = ApiUrls.baseUrl;
//     _dio.options.connectTimeout = const Duration(seconds: 5);
//     _dio.options.receiveTimeout = const Duration(seconds: 3);
    
//     _dio.interceptors.add(
//       InterceptorsWrapper(
//         onRequest: (options, handler) {
//           return handler.next(options);
//         },
//       ),
//     );
//   }

//   void monitorConnection() {
//     _connectivitySubscription = _connectivity.onConnectivityChanged.listen((result) {
//       if (result == ConnectivityResult.none) {
//         emit(NetworkFailure('Tidak ada koneksi internet'));
//         _startRetryTimer();
//       } else {
//         _checkServerConnection();
//       }
//     });

//     checkConnection();
//   }

//   Future<void> checkConnection() async {
//     emit(NetworkLoading());
    
//     try {
//       final result = await _connectivity.checkConnectivity();
//       if (result == ConnectivityResult.none) {
//         emit(NetworkFailure('Tidak ada koneksi internet'));
//         _startRetryTimer();
//       } else {
//         await _checkServerConnection();
//       }
//     } catch (e) {
//       emit(NetworkFailure('Terjadi kesalahan: ${e.toString()}'));
//       _startRetryTimer();
//     }
//   }

//   Future<void> _checkServerConnection() async {
//     emit(NetworkLoading());
    
//     try {
//       final response = await _dio.get(ApiUrls.studentHome);
      
//       if (response.statusCode == 200) {
//         emit(NetworkSuccess());
//         _cancelRetryTimer();
//       } else {
//         emit(NetworkFailure('Tidak dapat terhubung ke server'));
//         _startRetryTimer();
//       }
//     } on DioException catch (e) {
//       String errorMessage = 'Gagal terhubung ke server';
      
//       switch (e.type) {
//         case DioExceptionType.connectionTimeout:
//         case DioExceptionType.sendTimeout:
//         case DioExceptionType.receiveTimeout:
//           errorMessage = 'Waktu koneksi habis';
//           break;
//         case DioExceptionType.badResponse:
//           errorMessage = 'Server sedang bermasalah (${e.response?.statusCode})';
//           break;
//         case DioExceptionType.connectionError:
//           errorMessage = 'Tidak dapat terhubung ke server';
//           break;
//         default:
//           errorMessage = 'Terjadi kesalahan: ${e.message}';
//       }
      
//       emit(NetworkFailure(errorMessage));
//       _startRetryTimer();
//     }
//   }

//   void _startRetryTimer() {
//     _retryTimer?.cancel();
//     _retryTimer = Timer.periodic(checkInterval, (timer) {
//       checkConnection();
//     });
//   }

//   void _cancelRetryTimer() {
//     _retryTimer?.cancel();
//     _retryTimer = null;
//   }

//   @override
//   Future<void> close() {
//     _connectivitySubscription?.cancel();
//     _retryTimer?.cancel();
//     _dio.close();
//     return super.close();
//   }
// }