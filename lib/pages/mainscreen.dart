import 'package:flutter/material.dart';
import 'package:postman_app/components/search_bar.dart';
import 'package:postman_app/components/main_drawer.dart';
import 'package:postman_app/components/tab_bar.dart';
import 'package:postman_app/components/workspace_environment.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String? selectedWorkspace;
  String? selectedEnvironment;
  final List<String> environments = ['No Environment'];
  final List<String> tabs = ['Overview'];
  int selectedTabIndex = 0;

  void _addNewTab() {
    setState(() {
      tabs.add('New Request ${tabs.length + 1}');
      selectedTabIndex = tabs.length - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Searchbar(),
      ),
      drawer: MainDrawer(),
      body: Container(
        color: Colors.grey[900],
        height: 144,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              WorkspaceEnvironment(
                selectedWorkspace: selectedWorkspace,
                selectedEnvironment: selectedEnvironment,
                environments: environments,
                onWorkspaceChanged: (newValue) =>
                    setState(() => selectedWorkspace = newValue),
                onEnvironmentChanged: (newValue) =>
                    setState(() => selectedEnvironment = newValue),
              ),
              SizedBox(
                height: 5,
              ),
              TabBarComponent(
                tabs: tabs,
                selectedTabIndex: selectedTabIndex,
                onTabSelected: (index) =>
                    setState(() => selectedTabIndex = index),
                onAddNewTab: _addNewTab,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
