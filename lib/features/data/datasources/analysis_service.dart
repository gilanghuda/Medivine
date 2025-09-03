import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/medical_analysis_result.dart';
import 'package:medivine/features/presentation/screens/scanScreen/prompt.dart'
    as prompt_file;

class GeminiAnalysisService {
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';
  final String _apiKey;

  GeminiAnalysisService({required String apiKey}) : _apiKey = apiKey;

  Future<MedicalAnalysisResult?> analyzeOralImage(File imageFile) async {
    try {
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(imageBytes);
      String mimeType = _getMimeType(imageFile.path);

      // Ambil prompt dari prompt.dart
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
          // Clean markdown if any
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
}
