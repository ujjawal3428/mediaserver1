import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool isGridView = true;
  bool isDrawerOpen = false;

  final Color primaryColor = Color(0xFF181818);
  final Color drawerColor = Color.fromARGB(255, 57, 130, 132); // Muted Teal
  final Color mediaItemColor =   Color.fromARGB(255, 82, 115, 119); // Electric Blue
  final Color mediaTitleColor =  Color(0xFF2F3E46);   // Soft Silver
  final Color textColor = Colors.white;

  // Drawer width constant
  final double drawerWidth = 250;

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 181, 188, 197),
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
                if (!isDesktop) _buildMenuIcon(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          right: (isDrawerOpen || isDesktop) ? drawerWidth / 4 : 16,
        ),
        child: Positioned(
          right: 0,
          bottom: 20,
          child: FloatingActionButton(
            backgroundColor: mediaTitleColor,
            onPressed: () {},
            child: Icon(Icons.upload, color: textColor),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(bool isDesktop) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        right: 8,
      ),
      child: Column(
        children: [
          IconButton(
            icon: Icon(
              isGridView ? Icons.list : Icons.grid_view,
              color: textColor,
              size: 28,
            ),
            onPressed: () {
              setState(() {
                isGridView = !isGridView;
              });
            },
          ),
           Text('Media', style: TextStyle(
            fontSize: 18,
           ),),
        ],
      ),
    );
  }

  Widget _buildMenuIcon() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 16,
      child: IconButton(
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
      ),
    );
  }

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

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
      padding: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          'assets/drawerimage.jpg',
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
        } else {
          crossAxisCount = 2;
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: isGridView
              ? GridView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: 10,
                  itemBuilder: (context, index) => _buildMediaItem(index),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemCount: 10,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildMediaItem(index),
                  ),
                ),
        );
      },
    );
  }

  Widget _buildMediaItem(int index) {
    return Card(
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
                child: Icon(Icons.image, size: 50, color: textColor),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              "Media Item $index",
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
    );
  }
}
