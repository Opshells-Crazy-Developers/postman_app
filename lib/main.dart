import 'package:flutter/material.dart';

void main() => runApp(PostmanApp());

class PostmanApp extends StatelessWidget {
  const PostmanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PostmanUI(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PostmanUI extends StatefulWidget {
  const PostmanUI({super.key});

  @override
  State<PostmanUI> createState() => _PostmanUIState();
}

class _PostmanUIState extends State<PostmanUI> {
  String? openDrawer;
  List<String> tabs = ['Overview']; // To store tab names
  int selectedTabIndex = 0; // To track the selected tab

// Add this method to handle adding new tabs
  void _addNewTab() {
    setState(() {
      tabs.add('New Request ${tabs.length + 1}');
      selectedTabIndex = tabs.length - 1; // Select the newly added tab
    });
  }

  void _showDrawer(String drawerType) {
    setState(() {
      openDrawer = openDrawer == drawerType ? null : drawerType;
    });
  }

  Widget buildOutlinedTab(String title, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: () {
          setState(() {
            selectedTabIndex = index;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(
              color:
                  selectedTabIndex == index ? Colors.orange : Colors.grey[600]!,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  color:
                      selectedTabIndex == index ? Colors.orange : Colors.white,
                  fontSize: 14,
                ),
              ),
              SizedBox(width: 8),
              InkWell(
                onTap: () {
                  setState(() {
                    tabs.removeAt(index);
                    if (selectedTabIndex >= tabs.length) {
                      selectedTabIndex = tabs.length - 1;
                    }
                  });
                },
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'Test examples in Postman',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.grey[850],
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                // Logo Icon
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.api, // You can change this to your logo icon
                    color: Colors.orange,
                    size: 24,
                  ),
                ),
                SizedBox(width: 16), // Spacing between icons
                // Search Container
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: Colors.grey[400],
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Search',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Icon(
                  Icons.menu, // You can change this to your logo icon
                  color: Colors.white,
                  size: 24,
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Row(
                  children: [
                    // Sidebar
                    Container(
                      width: 60,
                      color: Colors.grey[900],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 5),
                          IconButton(
                            icon: Icon(Icons.web,
                                color: openDrawer == 'web'
                                    ? Colors.orange
                                    : Colors.white),
                            onPressed: () => _showDrawer('web'),
                          ),
                          IconButton(
                            icon: Icon(Icons.crop_landscape_outlined,
                                color: openDrawer == 'workspace'
                                    ? Colors.orange
                                    : Colors.white),
                            onPressed: () => _showDrawer('workspace'),
                          ),
                          IconButton(
                            icon: Icon(Icons.event_note_outlined,
                                color: openDrawer == 'collections'
                                    ? Colors.orange
                                    : Colors.white),
                            onPressed: () => _showDrawer('collections'),
                          ),
                          IconButton(
                            icon: Icon(Icons.api_outlined,
                                color: openDrawer == 'apis'
                                    ? Colors.orange
                                    : Colors.white),
                            onPressed: () => _showDrawer('apis'),
                          ),
                          IconButton(
                            icon: Icon(Icons.monitor_heart,
                                color: openDrawer == 'monitor'
                                    ? Colors.orange
                                    : Colors.white),
                            onPressed: () => _showDrawer('monitor'),
                          ),
                          IconButton(
                            icon: Icon(Icons.history,
                                color: openDrawer == 'history'
                                    ? Colors.orange
                                    : Colors.white),
                            onPressed: () => _showDrawer('history'),
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(Icons.help_outline,
                                color: openDrawer == 'help'
                                    ? Colors.orange
                                    : Colors.white),
                            onPressed: () => _showDrawer('help'),
                          ),
                          IconButton(
                            icon: Icon(Icons.settings_outlined,
                                color: openDrawer == 'settings'
                                    ? Colors.orange
                                    : Colors.white),
                            onPressed: () => _showDrawer('settings'),
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                    // Main Content
                    Expanded(
                      child: Column(
                        children: [
                          // Header
                          Container(
                            color: Colors.grey[900],
                            height: 50,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 8.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  SizedBox(width: 8),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.arrow_back_ios,
                                      color: Colors.grey[600],
                                      size: 18,
                                    ),
                                  ),
                                  Container(
                                    width: 120,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: List.generate(
                                          tabs.length,
                                          (index) => buildOutlinedTab(
                                              tabs[index], index),
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.grey[600],
                                      size: 18,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed:
                                        _addNewTab, // Add this function to the + icon
                                    icon: Icon(Icons.add, color: Colors.white),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.arrow_drop_down,
                                        color: Colors.white),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'No environment',
                                    style: TextStyle(color: Colors.grey[400]),
                                  ),
                                  Icon(Icons.expand_more,
                                      color: Colors.grey[400]),
                                ],
                              ),
                            ),
                          ),

                          // Content Area
                          Expanded(
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Test examples in Postman',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'This public workspace contains collections and test examples.',
                                      style: TextStyle(color: Colors.grey[400]),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Overlay Drawer
                if (openDrawer != null)
                  Positioned(
                    left: 60,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 300,
                      decoration: BoxDecoration(
                        color: Colors.grey[850],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Drawer Header
                          Container(
                            padding: EdgeInsets.all(16),
                            color: Colors.grey[900],
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _getDrawerTitle(openDrawer!),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.close, color: Colors.white),
                                  onPressed: () =>
                                      setState(() => openDrawer = null),
                                ),
                              ],
                            ),
                          ),
                          // Drawer Content
                          Expanded(
                            child: _buildDrawerContent(openDrawer!),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getDrawerTitle(String drawerType) {
    switch (drawerType) {
      case 'web':
        return 'Web';
      case 'workspace':
        return 'Workspace';
      case 'collections':
        return 'Collections';
      case 'apis':
        return 'APIs';
      case 'monitor':
        return 'Monitors';
      case 'help':
        return 'Help';
      case 'settings':
        return 'Settings';
      case 'history':
        return 'History';
      default:
        return 'Information';
    }
  }

  Widget _buildDrawerContent(String drawerType) {
    switch (drawerType) {
      case 'collections':
        return ListView(
          children: [
            ListTile(
              leading: Icon(Icons.folder, color: Colors.white),
              title: Text('My Collection 1',
                  style: TextStyle(color: Colors.white)),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.folder, color: Colors.white),
              title: Text('My Collection 2',
                  style: TextStyle(color: Colors.white)),
              onTap: () {},
            ),
          ],
        );
      case 'apis':
        return ListView(
          children: [
            ListTile(
              leading: Icon(Icons.api, color: Colors.white),
              title: Text('API 1', style: TextStyle(color: Colors.white)),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.api, color: Colors.white),
              title: Text('API 2', style: TextStyle(color: Colors.white)),
              onTap: () {},
            ),
          ],
        );
      default:
        return Center(
          child: Text(
            'Content for ${_getDrawerTitle(drawerType)}',
            style: TextStyle(color: Colors.white),
          ),
        );
    }
  }
}
