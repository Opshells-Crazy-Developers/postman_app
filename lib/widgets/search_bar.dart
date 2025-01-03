import 'package:flutter/material.dart';

class Searchbar extends StatelessWidget {
  final TextEditingController? controller;
  final Function(String)? onChanged;

  const Searchbar({
    super.key,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
              controller: controller,
              onChanged: onChanged,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(width: 8),
          Icon(
            Icons.api,
            color: Colors.orange,
            size: 20,
          ),
        ],
      ),
    );
  }
}
