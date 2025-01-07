import 'package:flutter/material.dart';
import 'package:postman_app/widgets/app_state.dart';
import 'package:postman_app/widgets/main_drawer.dart';
import 'package:postman_app/components/Environment_Workspace/workspace_environment.dart';
import 'package:postman_app/components/MainScreen_components/overview.dart';
import 'package:postman_app/widgets/search_bar.dart';
import 'package:postman_app/widgets/tab_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String? selectedWorkspace;
  String? selectedEnvironment;
  final List<String> environments = ['No Environment'];
  final List<String> tabs = ['Overview'];
  int selectedTabIndex = 0;

  final List<Widget> tabPages = [
    Overview(), // Assuming you have an Overview widget
  ];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final appState = AppState.of(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(screenSize.height * 0.08), // Responsive height
        child: AppBar(
          backgroundColor: Colors.grey[900],
          title: Searchbar(),
        ),
      ),
      drawer: MainDrawer(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              // Workspace and Tab Section
              Container(
                color: Colors.grey[900],
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.03,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height:
                          screenSize.height * 0.05, // Adjust height as needed
                      child: WorkspaceEnvironment(
                        selectedWorkspace: selectedWorkspace,
                        selectedEnvironment: selectedEnvironment,
                        environments: environments,
                        onWorkspaceChanged: (newValue) =>
                            setState(() => selectedWorkspace = newValue),
                        onEnvironmentChanged: (newValue) =>
                            setState(() => selectedEnvironment = newValue),
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.01),
                    TabBarComponent(
                      tabs: appState.tabs,
                      selectedTabIndex: appState.selectedTabIndex,
                      onTabSelected: appState.selectTab,
                      onAddNewTab: () => appState
                          .addTab('New Request ${appState.tabs.length + 1}'),
                    ),
                  ],
                ),
              ),

              // Tab Content
              Expanded(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: screenSize.height * 0.001),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[850],
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: appState.tabPages[appState.selectedTabIndex],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
