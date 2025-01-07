// ignore_for_file: library_private_types_in_public_api

import 'dart:math';
import 'package:flutter/material.dart';

class TabBarComponent extends StatefulWidget {
  final List<String> tabs;
  final int selectedTabIndex;
  final Function(int index) onTabSelected;
  final VoidCallback onAddNewTab; // Use VoidCallback here

  const TabBarComponent({
    super.key,
    required this.tabs,
    required this.selectedTabIndex,
    required this.onTabSelected,
    required this.onAddNewTab,
  });

  @override
  _TabBarComponentState createState() => _TabBarComponentState();
}

class _TabBarComponentState extends State<TabBarComponent> {
  final ScrollController _scrollController = ScrollController();
  bool _canScrollLeft = false;
  bool _canScrollRight = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateScrollButtons();
      _scrollController.addListener(_updateScrollButtons);
    });
  }

  void _updateScrollButtons() {
    if (_scrollController.hasClients) {
      setState(() {
        _canScrollLeft = _scrollController.position.pixels > 0;
        _canScrollRight = _scrollController.position.pixels <
            _scrollController.position.maxScrollExtent;
      });
    }
  }

  void _scrollLeft() {
    if (_scrollController.hasClients) {
      final currentPosition = _scrollController.position.pixels;
      _scrollController.animateTo(
        max(currentPosition - 100, 0),
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _scrollRight() {
    if (_scrollController.hasClients) {
      final currentPosition = _scrollController.position.pixels;
      _scrollController.animateTo(
        min(currentPosition + 100, _scrollController.position.maxScrollExtent),
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget buildTab(String title, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: () => widget.onTabSelected(index),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(
              color: widget.selectedTabIndex == index
                  ? Colors.orange
                  : Colors.grey[600]!,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  color: widget.selectedTabIndex == index
                      ? Colors.orange
                      : Colors.white,
                  fontSize: 14,
                ),
              ),
              SizedBox(width: 8),
              InkWell(
                onTap: () {
                  setState(() {
                    widget.tabs.removeAt(index);
                  });
                },
                child: Icon(Icons.close, size: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateScrollButtons);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    widget.tabs.length,
                    (index) => buildTab(widget.tabs[index], index),
                  ),
                ),
              ),
            ),
            
            IconButton(
              onPressed: widget.onAddNewTab,
              icon: Icon(Icons.add, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
