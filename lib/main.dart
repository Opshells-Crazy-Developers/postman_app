import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Postman Clone',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.orange,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MainScreen(),
        '/web': (context) => WebPage(),
        '/workspace': (context) => WorkspacePage(),
        '/collections': (context) => CollectionsPage(),
        '/apis': (context) => ApisPage(),
        '/monitor': (context) => MonitorPage(),
        '/history': (context) => HistoryPage(),
        '/help': (context) => HelpPage(),
        '/settings': (context) => SettingsPage(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String? openDrawer;

  List<String> tabs = ['Overview'];
  // To store tab names
  int selectedTabIndex = 0;
  // To track the selected tab
  void _addNewTab() {
    setState(() {
      tabs.add('New Request ${tabs.length + 1}');
      selectedTabIndex = tabs.length - 1; // Select the newly added tab
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
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.grey[400]),
              SizedBox(width: 8),
              Expanded(
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: MainDrawer(),
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
                                (index) => buildOutlinedTab(tabs[index], index),
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
                          icon:
                              Icon(Icons.arrow_drop_down, color: Colors.white),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'No environment',
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                        Icon(Icons.expand_more, color: Colors.grey[400]),
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
    );
  }
}

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.grey[900],
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.api, size: 40, color: Colors.orange),
                  SizedBox(height: 8),
                  Text(
                    'Postman Clone',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            DrawerListTile(
              icon: Icons.web,
              title: 'Web',
              onTap: () => Navigator.pushNamed(context, '/web'),
            ),
            DrawerListTile(
              icon: Icons.crop_landscape_outlined,
              title: 'Workspace',
              onTap: () => Navigator.pushNamed(context, '/workspace'),
            ),
            DrawerListTile(
              icon: Icons.event_note_outlined,
              title: 'Collections',
              onTap: () => Navigator.pushNamed(context, '/collections'),
            ),
            DrawerListTile(
              icon: Icons.api_outlined,
              title: 'APIs',
              onTap: () => Navigator.pushNamed(context, '/apis'),
            ),
            DrawerListTile(
              icon: Icons.monitor_heart,
              title: 'Monitor',
              onTap: () => Navigator.pushNamed(context, '/monitor'),
            ),
            DrawerListTile(
              icon: Icons.history,
              title: 'History',
              onTap: () => Navigator.pushNamed(context, '/history'),
            ),
            Divider(color: Colors.grey[800]),
            DrawerListTile(
              icon: Icons.help_outline,
              title: 'Help',
              onTap: () => Navigator.pushNamed(context, '/help'),
            ),
            DrawerListTile(
              icon: Icons.settings_outlined,
              title: 'Settings',
              onTap: () => Navigator.pushNamed(context, '/settings'),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const DrawerListTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: TextStyle(color: Colors.white)),
      onTap: onTap,
      hoverColor: Colors.orange.withOpacity(0.1),
    );
  }
}

// Separate pages
class WebPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Web'),
        backgroundColor: Colors.grey[900],
      ),
      drawer: MainDrawer(),
      body: Container(
        color: Colors.grey[850],
        child: Center(
          child:
              Text('Web Page Content', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}

class WorkspacePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workspace'),
        backgroundColor: Colors.grey[900],
      ),
      drawer: MainDrawer(),
      body: Container(
        color: Colors.grey[850],
        child: Center(
          child:
              Text('Workspace Content', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}

class CollectionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Collections'),
        backgroundColor: Colors.grey[900],
      ),
      drawer: MainDrawer(),
      body: Container(
        color: Colors.grey[850],
        child: Center(
          child: Text('Collections Content',
              style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}

class ApisPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('APIs'),
        backgroundColor: Colors.grey[900],
      ),
      drawer: MainDrawer(),
      body: Container(
        color: Colors.grey[850],
        child: Center(
          child: Text('APIs Content', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}

class MonitorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monitor'),
        backgroundColor: Colors.grey[900],
      ),
      drawer: MainDrawer(),
      body: Container(
        color: Colors.grey[850],
        child: Center(
          child: Text('Monitor Content', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        backgroundColor: Colors.grey[900],
      ),
      drawer: MainDrawer(),
      body: Container(
        color: Colors.grey[850],
        child: Center(
          child: Text('History Content', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}

class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help'),
        backgroundColor: Colors.grey[900],
      ),
      drawer: MainDrawer(),
      body: Container(
        color: Colors.grey[850],
        child: Center(
          child: Text('Help Content', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.grey[900],
      ),
      drawer: MainDrawer(),
      body: Container(
        color: Colors.grey[850],
        child: Center(
          child:
              Text('Settings Content', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
