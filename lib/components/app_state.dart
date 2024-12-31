// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:postman_app/new.dart';
import 'package:postman_app/overview.dart';

class AppState extends InheritedWidget {
  final List<String> tabs;
  final List<Widget> tabPages;
  final int selectedTabIndex;
  final Function(String) addTab;
  final Function(int) selectTab;

  const AppState({
    super.key,
    required super.child,
    required this.tabs,
    required this.tabPages,
    required this.selectedTabIndex,
    required this.addTab,
    required this.selectTab,
  });

  static AppState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppState>()!;
  }

  @override
  bool updateShouldNotify(AppState oldWidget) {
    return tabs != oldWidget.tabs ||
        tabPages != oldWidget.tabPages ||
        selectedTabIndex != oldWidget.selectedTabIndex;
  }
}

class AppStateContainer extends StatefulWidget {
  final Widget child;

  const AppStateContainer({super.key, required this.child});

  @override
  _AppStateContainerState createState() => _AppStateContainerState();
}

class _AppStateContainerState extends State<AppStateContainer> {
  final List<String> _tabs = ['Overview'];
  final List<Widget> _tabPages = [Overview()];
  int _selectedTabIndex = 0;

  void addTab(String tabName) {
    setState(() {
      _tabs.add(tabName);
      _tabPages.add(NewFile());
      _selectedTabIndex = _tabs.length - 1;
    });
  }

  void selectTab(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppState(
      tabs: _tabs,
      tabPages: _tabPages,
      selectedTabIndex: _selectedTabIndex,
      addTab: addTab,
      selectTab: selectTab,
      child: widget.child,
    );
  }
}
