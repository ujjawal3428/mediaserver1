import 'package:flutter/material.dart';
import '../service/api_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> drives = [];
  List<Map<String, dynamic>> files = [];
  List<String> pathStack = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchDrives();
  }

  Future<void> fetchDrives() async {
    setState(() => isLoading = true);
    final response = await ApiService.listDrives();
    setState(() {
      drives = List<Map<String, dynamic>>.from(response['items']);
      isLoading = false;
    });
    if (drives.isNotEmpty) {
      fetchFiles(drives.first['path']);
    }
  }

  Future<void> fetchFiles(String directory) async {
    setState(() => isLoading = true);
    final response = await ApiService.listFiles(directory);
    setState(() {
      files = List<Map<String, dynamic>>.from(response['items']);
      isLoading = false;
    });
  }

  void navigateToDirectory(String directory) {
    pathStack.add(directory);
    fetchFiles(directory);
  }

  void goBack() {
    if (pathStack.isNotEmpty) {
      pathStack.removeLast();
      fetchFiles(pathStack.isNotEmpty ? pathStack.last : drives.first['path']);
    }
  }

  void uploadFile() {
    // Implement upload functionality here
  }

  void downloadFile(String filePath) {
    // Implement download functionality here
  }

  void viewFile(String filePath) {
    // Implement file viewing functionality here
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Row(
          children: [
            _buildSidebar(),
            Expanded(child: _buildFileView()),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueGrey,
          onPressed: uploadFile,
          child: Icon(Icons.upload, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 250,
      color: Colors.grey[900],
      child: Column(
        children: [
          for (var drive in drives)
            ListTile(
              title: Text(drive['name'], style: TextStyle(color: Colors.white)),
              onTap: () => fetchFiles(drive['path']),
            ),
        ],
      ),
    );
  }

  Widget _buildFileView() {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Column(
            children: [
              if (pathStack.isNotEmpty)
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: goBack,
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: files.length,
                  itemBuilder: (context, index) {
                    final file = files[index];
                    return ListTile(
                      leading: Icon(
                        file['isDirectory']
                            ? Icons.folder
                            : Icons.insert_drive_file,
                        color: Colors.white,
                      ),
                      title: Text(file['name'],
                          style: TextStyle(color: Colors.white)),
                      onTap: file['isDirectory']
                          ? () => navigateToDirectory(file['path'])
                          : () => viewFile(file['path']),
                      trailing: !file['isDirectory']
                          ? IconButton(
                              icon: Icon(Icons.download, color: Colors.white),
                              onPressed: () => downloadFile(file['path']),
                            )
                          : null,
                    );
                  },
                ),
              ),
            ],
          );
  }
}
