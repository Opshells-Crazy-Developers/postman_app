import 'dart:math';

import 'package:flutter/material.dart';



class FlowBuilder extends StatefulWidget {
  const FlowBuilder({super.key});

  @override
  _FlowBuilderState createState() => _FlowBuilderState();
}

class _FlowBuilderState extends State<FlowBuilder> {
  List<WidgetData> widgets = [];
  List<Connection> connections = [];
  Offset startPosition = Offset(100, 100);

  @override
  void initState() {
    super.initState();
    widgets.add(WidgetData(
      id: 'start',
      offset: startPosition,
      child: FlowWidget(
        title: "Start",
        onOptionSelected: (option) {
          addNewWidget(option, widgets[0]);
        },
      ),
    ));
  }

  void addNewWidget(String title, WidgetData parent) {
    Offset newPosition = Offset(parent.offset.dx + 200, parent.offset.dy + (widgets.length * 150));

    setState(() {
      late WidgetData newWidget;
      newWidget = WidgetData(
        id: 'widget-${widgets.length}',
        offset: newPosition,
        child: FlowWidget(
          title: title,
          onOptionSelected: (option) {
            addNewWidget(option, newWidget);
          },
        ),
      );
      widgets.add(newWidget);
      connections.add(Connection(start: parent.offset, end: newPosition));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flow Builder'),
      ),
      body: Stack(
        children: [
          // Draw arrows between connected widgets
          CustomPaint(
            size: Size.infinite,
            painter: ArrowPainter(connections),
          ),
          // Display draggable widgets
          ...widgets.map((widgetData) {
            return Positioned(
              left: widgetData.offset.dx,
              top: widgetData.offset.dy,
              child: Draggable<WidgetData>(
                data: widgetData,
                feedback: Material(
                  child: widgetData.child,
                  elevation: 4,
                ),
                childWhenDragging: Container(),
                onDragEnd: (details) {
                  setState(() {
                    widgetData.offset = details.offset;
                    updateConnections();
                  });
                },
                child: widgetData.child,
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  void updateConnections() {
    setState(() {
      connections = [];
      for (int i = 1; i < widgets.length; i++) {
        connections.add(Connection(
          start: widgets[i - 1].offset,
          end: widgets[i].offset,
        ));
      }
    });
  }
}

class FlowWidget extends StatelessWidget {
  final String title;
  final Function(String) onOptionSelected;

  const FlowWidget({Key? key, required this.title, required this.onOptionSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => onOptionSelected("Send a request"),
            child: Text("Send a request"),
          ),
          ElevatedButton(
            onPressed: () => onOptionSelected("Add blocks"),
            child: Text("Add blocks"),
          ),
          ElevatedButton(
            onPressed: () => onOptionSelected("Explore Catalog"),
            child: Text("Explore Catalog"),
          ),
        ],
      ),
    );
  }
}

class WidgetData {
  final String id;
  Offset offset;
  final Widget child;

  WidgetData({required this.id, required this.offset, required this.child});
}

class Connection {
  final Offset start;
  final Offset end;

  Connection({required this.start, required this.end});
}

class ArrowPainter extends CustomPainter {
  final List<Connection> connections;

  ArrowPainter(this.connections);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2;

    for (var connection in connections) {
      final start = connection.start + Offset(75, 25); // Adjust to center of the widget
      final end = connection.end + Offset(0, 25); // Adjust to center of the widget
      final arrowSize = 10;

      // Draw the line
      canvas.drawLine(start, end, paint);

      // Draw the arrowhead
      final angle = (end - start).direction;
      final arrow1 = Offset(
        end.dx - arrowSize * cos(angle - pi / 6),
        end.dy - arrowSize * sin(angle - pi / 6),
      );
      final arrow2 = Offset(
        end.dx - arrowSize * cos(angle + pi / 6),
        end.dy - arrowSize * sin(angle + pi / 6),
      );
      canvas.drawLine(end, arrow1, paint);
      canvas.drawLine(end, arrow2, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
