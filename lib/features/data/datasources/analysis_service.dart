import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/medical_analysis_result.dart';
import 'package:medivine/features/presentation/screens/scanScreen/prompt.dart'
    as prompt_file;
import 'package:cloud_firestore/cloud_firestore.dart';

class GeminiAnalysisService {
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';
  final String _apiKey;

  GeminiAnalysisService({required String apiKey}) : _apiKey = apiKey;

  Future<MedicalAnalysisResult?> analyzeOralImage(File imageFile) async {
    try {
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(imageBytes);
      String mimeType = _getMimeType(imageFile.path);

      final prompt = prompt_file.prompt;

      Map<String, dynamic> requestBody = {
        "contents": [
          {
            "parts": [
              {"text": prompt},
              {
                "inline_data": {"mime_type": mimeType, "data": base64Image}
              }
            ]
          }
        ]
      };

      final response = await http.post(
        Uri.parse('$_baseUrl?key=$_apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'];
        if (text != null && text is String) {
          final cleanText =
              text.replaceAll('```json', '').replaceAll('```', '').trim();
          final analysisJson = jsonDecode(cleanText);
          return MedicalAnalysisResult.fromJson(analysisJson);
        } else {
          throw Exception("Tidak ada hasil analisis dari Gemini.");
        }
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        throw Exception("Gagal request ke Gemini: ${response.statusCode}");
      }
    } catch (e) {
      print('Exception during analysis: $e');
      return null;
    }
  }

  String _getMimeType(String filePath) {
    String extension = filePath.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg';
    }
  }

  Future<String?> uploadImageToCloudinary(String imagePath) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://api.cloudinary.com/v1_1/dyejedtcq/upload'),
    );
    request.fields['upload_preset'] = 'medivine';
    request.files.add(await http.MultipartFile.fromPath('file', imagePath));
    try {
      final response = await request.send();
      print('DEBUG: Cloudinary upload status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        print('DEBUG: Cloudinary response: $responseData');
        final jsonResponse = json.decode(responseData);
        return jsonResponse['secure_url'];
      } else {
        final responseData = await response.stream.bytesToString();
        print('DEBUG: Cloudinary error response: $responseData');
        return null;
      }
    } catch (e, stack) {
      print('DEBUG: Exception Cloudinary: $e');
      print('DEBUG: Stacktrace Cloudinary: $stack');
      return null;
    }
  }

  Future<void> saveAnalysisToFirestore(Map<String, dynamic> data) async {
    try {
      print('DEBUG: Saving to Firestore: $data');
      await FirebaseFirestore.instance.collection('analysis').add(data);
      print('DEBUG: Save to Firestore success');
    } catch (e, stack) {
      print('DEBUG: Firestore save error: $e');
      print('DEBUG: Firestore stacktrace: $stack');
      rethrow;
    }
  }
}
