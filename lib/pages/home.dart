import 'dart:convert'; // For decoding JSON
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_server/pages/video_player.dart';
import '../service/api_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> drives = [];
  List<Map<String, dynamic>> files = [];
  String driveName = '';
  List<String> pathStack = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchDrives();
  }

  Future<void> fetchFiles(String directory) async {
    setState(() => isLoading = true);
    final response = await ApiService.listFiles(directory);
    setState(() {
      files = List<Map<String, dynamic>>.from(response['items']);
      isLoading = false;
    });
  }

  Uint8List? decodeBase64Thumbnail(String? base64String) {
    if (base64String == null || base64String.isEmpty) return null;
    final base64Data =
        base64String.split(',').last; // Remove the MIME type prefix
    return base64.decode(base64Data);
  }

  Future<void> fetchDrives() async {
    setState(() => isLoading = true);
    final response = await ApiService.listDrives();
    setState(() {
      drives = List<Map<String, dynamic>>.from(response['items']);
      isLoading = false;
      driveName = drives.first['name'];
    });
    if (drives.isNotEmpty) {
      fetchFiles(drives.first['path']);
    }
  }

  bool isDrawerOpen = false;

  final Color primaryColor = Color(0xFF181818);
  final Color drawerColor = Color.fromARGB(255, 195, 32, 75); // Drawer
  final Color mediaItemColor =
      Color.fromARGB(255, 255, 120, 136); //video title background
  final Color mediaTitleColor = Color(0xFF2F3E46); // thumbnail background
  final Color textColor = Colors.white;

  // Drawer width constant
  final double drawerWidth = 250;

  void handlePopWithResult(bool canPop, dynamic result) {}

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 900;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (!didPop && pathStack.isNotEmpty) {
          pathStack.removeLast();

          String previousPath;

          if (pathStack.isNotEmpty) {
            previousPath = pathStack.last;
          } else if (drives.isNotEmpty) {
            previousPath = drives.first['path'];
          } else {
            return;
          }

          await fetchFiles(previousPath);
        } else if (!didPop && pathStack.isEmpty) {
          debugPrint('PathStack is empty, exiting or back to root.');
          Navigator.of(context).pop(result);
        }
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          body: Row(
            children: [
              _buildAnimatedDrawer(isDesktop: isDesktop),
              Expanded(
                child: Stack(
                  children: [
                    AnimatedPadding(
                      duration: const Duration(milliseconds: 400),
                      padding: EdgeInsets.only(
                        left: (isDrawerOpen || isDesktop) ? 8 : 0,
                      ),
                      child: Column(
                        children: [
                          _buildAppBar(isDesktop),
                          Expanded(child: _buildMediaView()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: Padding(
            padding: EdgeInsets.only(
              right: (isDrawerOpen || isDesktop) ? drawerWidth / 4 : 16,
            ),
            child: FloatingActionButton(
              backgroundColor: mediaTitleColor,
              onPressed: () {},
              child: Icon(Icons.upload, color: textColor),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(bool isDesktop) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        right: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (!isDesktop) _buildMenuIcon(),
          if (!isDrawerOpen)
            Text(
              driveName,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMenuIcon() {
    return IconButton(
      icon: Icon(
        isDrawerOpen ? Icons.close : Icons.menu,
        color: textColor,
        size: 28,
      ),
      onPressed: () {
        setState(() {
          isDrawerOpen = !isDrawerOpen;
        });
      },
    );
  }

  bool isDrivesExpanded = false; // Track dropdown state

  Widget _buildAnimatedDrawer({required bool isDesktop}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      width: (isDrawerOpen || isDesktop) ? drawerWidth : 0,
      curve: Curves.easeInOut,
      child: Align(
        alignment: Alignment.centerLeft,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: (isDrawerOpen || isDesktop) ? 1.0 : 0.0,
          child: OverflowBox(
            maxWidth: drawerWidth,
            child: Container(
              width: drawerWidth,
              decoration: BoxDecoration(
                color: drawerColor,
                boxShadow: [
                  BoxShadow(
                    color: mediaTitleColor.withAlpha(80),
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDrawerHeader(),
                  _buildDrawerItem(Icons.home, "Home", () {}, null),
                  _buildDrawerItem(Icons.help_outline, "Help", () {}, null),
                  _buildDrawerItem(Icons.settings, "Settings", () {}, null),
                  _buildDrawerItem(
                    Icons.storage,
                    "Drives",
                    () {
                      setState(() {
                        isDrivesExpanded = !isDrivesExpanded;
                      });
                    },
                    isDrivesExpanded ? Icons.expand_less : Icons.expand_more,
                  ),

                  // Drives Item with Expand/Collapse Feature

                  // Show Drives when expanded
                  if (isDrivesExpanded)
                    Container(
                      color: Colors.transparent,
                      child: Column(
                        children: drives.map((drive) {
                          return ListTile(
                            title: Text(
                              drive['name'],
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              setState(() {
                                isDrawerOpen = false;
                                driveName = drive['name'];
                                pathStack.add(drive['path']);
                              });
                              fetchFiles(drive['path']);
                            },
                          );
                        }).toList(),
                      ),
                    ),

                  const Spacer(),
                  _buildDrawerImage()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 16,
        right: 16,
        bottom: 16,
      ),
      child: Row(
        children: [
          Icon(Icons.account_circle, size: 50, color: textColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Welcome, User!",
              style: TextStyle(color: textColor, fontSize: 18),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
      IconData icon, String title, VoidCallback onTap, IconData? trail) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: textColor),
        title: Row(
          children: [
            Text(title, style: TextStyle(color: textColor)),
            const Spacer(),
            Icon(
              trail,
              color: textColor,
            )
          ],
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildDrawerImage() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          'assets/drawerimage.png',
          width: drawerWidth - 32,
          height: 200,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildMediaView() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        int crossAxisCount;

        if (screenWidth > 1200) {
          crossAxisCount = 6;
        } else if (screenWidth > 900) {
          crossAxisCount = 5;
        } else if (screenWidth > 600) {
          crossAxisCount = 4;
        } else if (screenWidth > 200) {
          crossAxisCount = 2;
        } else {
          crossAxisCount = 1;
        }

        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: files.isEmpty
                ? Center(
                    child: Text(
                      'No Files available',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: files.length,
                    itemBuilder: (context, index) =>
                        _buildMediaItem(files[index]),
                  ));
      },
    );
  }

  Widget _buildMediaItem(Map<String, dynamic> file) {
    final thumbnailBytes = decodeBase64Thumbnail(file['thumbnail']);
    return InkWell(
      onTap: () {
        if (file['isDirectory'] == true) {
          pathStack.add(file['path']);
          fetchFiles(file['path']);
        } else {
          Get.to(VideoPlayerScreen(
              videoUrl:
                  'https://api.ansh.ltd/file?path=${file["path"]}&token=ansh',
              title: file['name']));
        }
      },
      child: Card(
        color: mediaItemColor,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        shadowColor: mediaTitleColor.withAlpha(128),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: mediaTitleColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Center(
                  child: file['isDirectory']
                      ? Icon(
                          Icons.folder,
                          size: 50,
                          color: textColor,
                        )
                      : thumbnailBytes != null
                          ? Image.memory(
                              thumbnailBytes,
                              fit: BoxFit.cover,
                            )
                          : Icon(Icons.insert_drive_file, color: Colors.blue),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                file['name'] ?? 'Unnamed',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
