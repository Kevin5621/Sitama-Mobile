// import 'dart:io';
// import 'package:path/path.dart' as path;
// import 'package:dio/dio.dart';
// import 'package:sistem_magang/core/service/security_utils.dart';

// class SecureApiClient {
//   final Dio _dio;
//   final String _baseUrl;
//   final String _secretKey;

//   String get secretKey => _secretKey;
  
//   SecureApiClient({
//     required String baseUrl,
//     required String secretKey,
//   }) : _baseUrl = baseUrl,
//        _secretKey = secretKey,
//        _dio = Dio() {
//     _dio.interceptors.add(
//       InterceptorsWrapper(
//         onRequest: (options, handler) {
//           // Add timestamp to prevent replay attacks
//           options.headers['X-Timestamp'] = DateTime.now().millisecondsSinceEpoch.toString();
//           final signature = SecurityUtils.generateRequestSignature(
//             options.data ?? {},
//             _secretKey,
//           );
//           options.headers['X-Signature'] = signature;
//           return handler.next(options);
//         },
//         onError: (error, handler) {
//           if (error.response?.statusCode == 401) {
//             // Handle unauthorized access
//           }
//           return handler.next(error);
//         },
//       ),
//     );
//   }

//   // Implement get method
//   Future<Response> get(String endpoint) async {
//     try {
//       final headers = {
//         'Authorization': 'Bearer ${await _getSecureToken()}',
//       };

//       return await _dio.get(
//         '$_baseUrl$endpoint',
//         options: Options(headers: headers),
//       );
//     } catch (e) {
//       if (e is SecurityException) rethrow;
//       throw SecurityException('GET request failed: ${e.toString()}');
//     }
//   }

//   Future<Response> uploadImage(File imageFile) async {
//     try {
//       // Validate file before upload
//       await SecurityUtils.validateImageFile(imageFile);
      
//       // Generate secure filename
//       final secureFilename = SecurityUtils.generateSecureFilename(
//         path.basename(imageFile.path)
//       );
      
//       final formData = FormData.fromMap({
//         'profile_image': await MultipartFile.fromFile(
//           imageFile.path,
//           filename: secureFilename,
//         ),
//       });

//       final headers = {
//         'Authorization': 'Bearer ${await _getSecureToken()}',
//         'Content-Type': 'multipart/form-data',
//       };

//       return await _dio.post(
//         '$_baseUrl/user/upload-profile-image',
//         data: formData,
//         options: Options(headers: headers),
//       );
//     } catch (e) {
//       if (e is SecurityException) rethrow;
//       throw SecurityException('Upload gagal: ${e.toString()}');
//     }
//   }

//   Future<String> _getSecureToken() async {
//     // Implement secure token retrieval
//     return '';
//   }
// }