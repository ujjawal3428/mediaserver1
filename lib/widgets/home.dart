import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  bool isGridView = true;
  bool isDrawerOpen = false;

  final Color primaryColor = const Color(0xFF1E2025);
  final Color drawerColor = const Color.fromARGB(255, 28, 44, 58);
  final Color mediaItemColor = const Color(0xFF3C5665);
  final Color mediaTitleColor = const Color(0xFF5A7480);
  final Color textColor = const Color(0xFF92A4B1);

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 177, 204, 195),
      body: Stack(
        children: [
          _buildMediaView(), 
          _buildAnimatedDrawer(isDesktop: isDesktop), 
          if (!isDesktop) _buildMenuIcon(), 
          Positioned(
            top: 10,
            right: 14,
            child: IconButton(
              icon: Icon(isGridView ? Icons.list : Icons.grid_view, color: textColor, size: 28),
              onPressed: () {
                setState(() {
                  isGridView = !isGridView;
                });
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: mediaTitleColor,
        onPressed: () {},
        child: Icon(Icons.upload, color: textColor),
      ),
    );
  }

  Widget _buildMenuIcon() {
    return Positioned(
      top: 10,
      left: 10,
      child: IconButton(
        icon: Icon(isDrawerOpen ? Icons.close : Icons.menu, color: textColor, size: 28),
        onPressed: () {
          setState(() {
            isDrawerOpen = !isDrawerOpen;
          });
        },
      ),
    );
  }

  Widget _buildAnimatedDrawer({required bool isDesktop}) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      left: isDrawerOpen || isDesktop ? 0 : -250,
      top: 0,
      bottom: 0,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        child: Container(
          width: 250,
          decoration: BoxDecoration(
            color: drawerColor,
            boxShadow: [
              BoxShadow(color: mediaTitleColor.withAlpha(80), blurRadius: 10, spreadRadius: 5),
            ],
          ),
          child: Column(
            children: [
              _buildDrawerHeader(),
              
              _buildDrawerItem(Icons.home, "Home", () {}),
              _buildDrawerItem(Icons.help_outline, "Help", () {}),
              _buildDrawerItem(Icons.settings, "Settings", () {}),
              const Spacer(),
              _buildDrawerImage(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 65.0, left: 12, right: 12, bottom: 12,),
      child: Row(
        children: [
          Icon(Icons.account_circle, size: 50, color: textColor),
          const SizedBox(width: 12),
          Text("Welcome, User!", style: TextStyle(color: textColor, fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: ListTile(
        leading: Icon(icon, color: textColor),
        title: Text(title, style: TextStyle(color: textColor)),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildDrawerImage() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Image.asset(
        'assets/drawerimage.jpg',
        width: 200,
        height: 200,
        fit: BoxFit.cover,
      ),
    );
  }

Widget _buildMediaView() {
  return Padding(
    padding: const EdgeInsets.only(top: 35.0, left: 12, right: 12, bottom: 12),
    child: LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        int crossAxisCount;

      
        if (screenWidth > 1200) {
          crossAxisCount = 6;
        } else if (screenWidth > 900) {
          crossAxisCount = 5; 
        } else if (screenWidth > 600) {
          crossAxisCount = 4;
        } else {
          crossAxisCount = 2; 
        }

        return isGridView
            ? GridView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount, 
                  crossAxisSpacing: 16,  
                  mainAxisSpacing: 16,   
                ),
                itemCount: 10,
                itemBuilder: (context, index) => _buildMediaItem(index),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: 10,
                itemBuilder: (context, index) => _buildMediaItem(index),
              );
      },
    ),
  );
}


Widget _buildMediaItem(int index) {
  return GestureDetector(
    onTap: () {},
    child: Card(
      color: mediaItemColor,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      shadowColor: mediaTitleColor.withAlpha(128),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Constrain the size of the media item
          double mediaWidth = constraints.maxWidth > 200 ? 200 : constraints.maxWidth - 20;
          double mediaHeight = 145; 

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: mediaWidth,
                height: mediaHeight,
                decoration: BoxDecoration(
                  color: mediaTitleColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15), 
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Icon(Icons.image, size: 50, color: textColor),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Media Item $index",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
                  overflow: TextOverflow.ellipsis, 
                  maxLines: 1, 
                ),
              ),
            ],
          );
        },
      ),
    ),
  );
}

}
