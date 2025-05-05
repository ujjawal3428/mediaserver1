import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://api.ansh.ltd";
  static const String authToken = "ansh"; // Replace with actual token

  static Map<String, String> headers = {
    "Authorization": authToken,
    "Content-Type": "application/json"
  };
  static Future<Map<String, dynamic>> listDrives(
      {int page = 1, int limit = 10}) async {
    final url = Uri.parse(
        "$baseUrl/list?path=/home/ansh/Drives&page=$page&limit=$limit");

    final response = await http.get(url, headers: headers);
    return json.decode(response.body);
  }

  /// List Files and Directories
  static Future<Map<String, dynamic>> listFiles(String folderPath,
      {int page = 1, int limit = 10}) async {
    final url =
        Uri.parse("$baseUrl/list?path=$folderPath&page=$page&limit=$limit");

    final response = await http.get(url, headers: headers);
    return json.decode(response.body);
  }

  /// Upload a File
  static Future<Map<String, dynamic>> uploadFile(
      File file, String targetPath) async {
    var uri = Uri.parse("$baseUrl/upload?path=$targetPath");

    var request = http.MultipartRequest("POST", uri);
    request.headers["Authorization"] = authToken;
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    var response = await request.send();
    var responseData = await response.stream.bytesToString();
    return json.decode(responseData);
  }

  /// Create a Folder
  static Future<Map<String, dynamic>> createFolder(String folderPath) async {
    final url = Uri.parse("$baseUrl/folder");
    final body = json.encode({"path": folderPath});

    final response = await http.post(url, headers: headers, body: body);
    return json.decode(response.body);
  }

  /// Delete File/Folder
  static Future<Map<String, dynamic>> deleteItem(String path) async {
    final url = Uri.parse("$baseUrl/delete?path=$path");

    final response = await http.delete(url, headers: headers);
    return json.decode(response.body);
  }

  /// Rename File/Folder
  static Future<Map<String, dynamic>> renameItem(
      String oldPath, String newPath) async {
    final url = Uri.parse("$baseUrl/rename");
    final body = json.encode({"oldPath": oldPath, "newPath": newPath});

    final response = await http.patch(url, headers: headers, body: body);
    return json.decode(response.body);
  }

  /// Download File
  static Future<void> downloadFile(String filePath, String saveAs) async {
    final url = Uri.parse("$baseUrl/download?path=$filePath");
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final file = File(saveAs);
      await file.writeAsBytes(response.bodyBytes);
    }
  }
}
