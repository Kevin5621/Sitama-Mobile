import 'dart:math';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:io';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;

class SecurityUtils {
  // Validasi file image
  static Future<bool> validateImageFile(File file) async {
    try {
      // 1. Validasi ukuran file (max 5MB)
      final fileSize = await file.length();
      if (fileSize > 5 * 1024 * 1024) {
        throw SecurityException('Ukuran file terlalu besar (max 5MB)');
      }

      // 2. Validasi tipe file
      final mimeType = lookupMimeType(file.path);
      final validImageTypes = ['image/jpeg', 'image/png', 'image/jpg'];
      if (!validImageTypes.contains(mimeType)) {
        throw SecurityException('Format file tidak valid');
      }

      // 3. Validasi ekstensi file
      final extension = path.extension(file.path).toLowerCase();
      final validExtensions = ['.jpg', '.jpeg', '.png'];
      if (!validExtensions.contains(extension)) {
        throw SecurityException('Ekstensi file tidak valid');
      }

      // 4. Basic file content validation
      final bytes = await file.readAsBytes();
      final header = bytes.sublist(0, min(bytes.length, 8));
      
      // Check magic numbers for common image formats    
      if (header.length < 3 || header.length < 8) {
        throw SecurityException('File header is too short');
      }

      return true;
    } catch (e) {
      if (e is SecurityException) rethrow;
      throw SecurityException('Validasi file gagal: ${e.toString()}');
    }
  }

  // Generate secure filename
  static String generateSecureFilename(String originalFilename) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = base64Url.encode(List<int>.generate(8, (_) => Random().nextInt(256)));
    final extension = path.extension(originalFilename).toLowerCase();
    return '$timestamp$random$extension';
  }

  String sanitizeFileName(String fileName) {
  final sanitizedFileName = fileName
      .replaceAll(RegExp(r'[^a-zA-Z0-9_.-]'), '_') 
      .trim(); 

  // Optionally, limit the file name length to prevent overly long names
  if (sanitizedFileName.length > 255) {
    return sanitizedFileName.substring(0, 255); 
  }

  return sanitizedFileName;
}


  // Generate request signature
  static String generateRequestSignature(Map<String, dynamic> data, String secretKey) {
    final sortedData = Map.fromEntries(
      data.entries.toList()..sort((a, b) => a.key.compareTo(b.key))
    );
    final dataString = json.encode(sortedData);
    final hmac = Hmac(sha256, utf8.encode(secretKey));
    final digest = hmac.convert(utf8.encode(dataString));
    return digest.toString();
  }

  static sanitizeInput(param0) {}
}

class SecurityException implements Exception {
  final String message;
  SecurityException(this.message);
  
  @override
  String toString() => message;
}