import 'package:flutter/material.dart';
import 'package:postman_app/components/failureContainer.dart';
import 'package:postman_app/components/sendRequest_widgetContainer.dart';
import 'package:postman_app/components/start_widgetcontainer.dart';
import 'package:postman_app/components/successContainer.dart';
import 'dart:math' as math;

class CanvasScreen extends StatefulWidget {
  const CanvasScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CanvasScreenState createState() => _CanvasScreenState();
}

class _CanvasScreenState extends State<CanvasScreen> {
  late TransformationController _transformationController;
  double _scale = 1.0;
  Offset _offset = Offset.zero;
  List<Map<String, dynamic>> dynamicWidgets =
      []; // Track widgets with unique IDs
  int containerCount = 0;

  Map<int, bool> selectedWidgets = {};
  List<Connection> connections = [];

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _transformationController.value = Matrix4.identity()
        ..translate(-500.0, -500.0);
    });
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void _addNewStartContainer() {
    setState(() {
      containerCount++;
      final center = _transformationController.toScene(Offset(
          MediaQuery.of(context).size.width / 2,
          MediaQuery.of(context).size.height / 2));
      dynamicWidgets.add({
        'id': containerCount,
        'type': 'start',
        'position': center,
      });
    });
  }

  void _addNewSendRequestContainer() {
  setState(() {
    containerCount++;
    final center = _transformationController.toScene(Offset(
      MediaQuery.of(context).size.width / 2,
      MediaQuery.of(context).size.height / 2,
    ));
    dynamicWidgets.add({
      'id': containerCount,
      'type': 'sendRequest',
      'position': center,
    });

    // Add connection if another widget is selected
    if (selectedWidgets.isNotEmpty) {
      final lastSelectedId = selectedWidgets.keys.first;
      final lastWidget = dynamicWidgets.firstWhere((w) => w['id'] == lastSelectedId);

      connections.add(Connection(
        startId: lastSelectedId,
        endId: containerCount,
        startPoint: lastWidget['position'],
        endPoint: center,
      ));
      selectedWidgets.clear();
    }
  });
}


  void _addNewSuccessContainer() {
    setState(() {
      containerCount++;
      final center = _transformationController.toScene(Offset(
          MediaQuery.of(context).size.width / 2,
          MediaQuery.of(context).size.height / 2));
      dynamicWidgets.add({
        'id': containerCount,
        'type': 'success',
        'position': center,
      });
    });
  }

  void _addNewFailureContainer() {
    setState(() {
      containerCount++;
      final center = _transformationController.toScene(Offset(
          MediaQuery.of(context).size.width / 2,
          MediaQuery.of(context).size.height / 2));
      dynamicWidgets.add({
        'id': containerCount,
        'type': 'failure',
        'position': center,
      });
    });
  }

  void _deleteWidget(int id) {
    setState(() {
      dynamicWidgets.removeWhere((widget) => widget['id'] == id);
      connections.removeWhere(
        (conn) => conn.startId == id || conn.endId == id,
      );
      selectedWidgets.remove(id);
    });
  }

  void _showAddOptions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Component'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.play_circle_outline),
                title: const Text('Add Start Container'),
                onTap: () {
                  Navigator.pop(context);
                  _addNewStartContainer();
                },
              ),
              ListTile(
                leading: const Icon(Icons.send),
                title: const Text('Add Send Request'),
                onTap: () {
                  Navigator.pop(context);
                  _addNewSendRequestContainer();
                },
              ),
              ListTile(
                leading: const Icon(Icons.check_circle_outline),
                title: const Text('Add Success Container'),
                onTap: () {
                  Navigator.pop(context);
                  _addNewSuccessContainer();
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel_outlined),
                title: const Text('Add Failure Container'),
                onTap: () {
                  Navigator.pop(context);
                  _addNewFailureContainer();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _handleWidgetSelection(int id) {
    setState(() {
      if (selectedWidgets.length < 2) {
        selectedWidgets[id] = true;

        if (selectedWidgets.length == 2) {
          // Create connection between selected widgets
          var firstWidget = dynamicWidgets
              .firstWhere((w) => w['id'] == selectedWidgets.keys.first);
          var secondWidget = dynamicWidgets
              .firstWhere((w) => w['id'] == selectedWidgets.keys.last);

          connections.add(Connection(
            startId: selectedWidgets.keys.first,
            endId: selectedWidgets.keys.last,
            startPoint: firstWidget['position'],
            endPoint: secondWidget['position'],
          ));

          // Clear selection after creating connection
          selectedWidgets.clear();
        }
      } else {
        selectedWidgets.clear();
      }
    });
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.cyan[50],
    appBar: AppBar(
      title: const Text('Workflow'),
    ),
    body: GestureDetector(
      child: InteractiveViewer(
        transformationController: _transformationController,
        boundaryMargin: const EdgeInsets.all(double.infinity),
        constrained: false,
        minScale: 0.1,
        maxScale: 10.0,
        child: SizedBox(
          width: 50000,
          height: 50000,
          child: Stack(
            children: [
              // CustomPaint for connections
              CustomPaint(
                size: Size.infinite,
                painter: ConnectionPainter(connections: connections),
              ),
              // Dynamic widgets
              ...dynamicWidgets.map((widget) {
                return DraggableWidget(
                  key: ValueKey(widget['id']),
                  id: widget['id'],
                  initialX: widget['position'].dx,
                  initialY: widget['position'].dy,
                  type: widget['type'],
                  isSelected: selectedWidgets.containsKey(widget['id']),
                  onSelect: _handleWidgetSelection,
                  onDrag: (Offset position) {
                    setState(() {
                      widget['position'] = position;
                      // Update connections
                      connections = connections.map((conn) {
                        if (conn.startId == widget['id']) {
                          return Connection(
                            startId: conn.startId,
                            endId: conn.endId,
                            startPoint: position,
                            endPoint: conn.endPoint,
                          );
                        } else if (conn.endId == widget['id']) {
                          return Connection(
                            startId: conn.startId,
                            endId: conn.endId,
                            startPoint: conn.startPoint,
                            endPoint: position,
                          );
                        }
                        return conn;
                      }).toList();
                    });
                  },
                  onDelete: () => _deleteWidget(widget['id']),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: _showAddOptions,
      child: const Icon(Icons.add),
    ),
  );
}

}

class DraggableWidget extends StatefulWidget {
  final double initialX;
  final double initialY;
  final String type;
  final Function(Offset) onDrag;
  final VoidCallback onDelete;
  final int id;
  final bool isSelected;
  final Function(int) onSelect;

  const DraggableWidget({
    super.key,
    required this.initialX,
    required this.initialY,
    required this.type,
    required this.onDrag,
    required this.onDelete,
    required this.id,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  State<DraggableWidget> createState() => _DraggableWidgetState();
}

class _DraggableWidgetState extends State<DraggableWidget> {
  late double xPosition;
  late double yPosition;

  @override
  void initState() {
    super.initState();
    xPosition = widget.initialX;
    yPosition = widget.initialY;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: xPosition,
      top: yPosition,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            xPosition += details.delta.dx;
            yPosition += details.delta.dy;
            widget.onDrag(Offset(xPosition, yPosition));
          });
        },
        onLongPress: () {
          _showDeleteDialog();
        },
        child: _buildContainer(),
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Widget'),
          content: const Text('Are you sure you want to delete this widget?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                widget.onDelete();
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContainer() {
    switch (widget.type) {
      case 'sendRequest':
        return SendrequestWidgetcontainer();
      case 'start':
        return StartWidgetcontainer();
      case 'success':
        return SuccessResponseWidget();
      case 'failure':
        return FailureResponseWidget();
      default:
        return StartWidgetcontainer();
    }
  }
}

class Connection {
  final int startId;
  final int endId;
  final Offset startPoint;
  final Offset endPoint;

  Connection({
    required this.startId,
    required this.endId,
    required this.startPoint,
    required this.endPoint,
  });
}

class ConnectionPainter extends CustomPainter {
  final List<Connection> connections;

  ConnectionPainter({required this.connections});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (var connection in connections) {
      // Draw the line
      canvas.drawLine(connection.startPoint, connection.endPoint, paint);

      // Draw an arrowhead
      final arrowPaint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.fill;

      const double arrowSize = 10.0;
      final angle = (connection.endPoint - connection.startPoint).direction;

      final arrowPoint1 = connection.endPoint.translate(
        -arrowSize * math.cos(angle - math.pi / 6),
        -arrowSize * math.sin(angle - math.pi / 6),
      );
      final arrowPoint2 = connection.endPoint.translate(
        -arrowSize * math.cos(angle + math.pi / 6),
        -arrowSize * math.sin(angle + math.pi / 6),
      );

      canvas.drawPath(
        Path()
          ..moveTo(connection.endPoint.dx, connection.endPoint.dy)
          ..lineTo(arrowPoint1.dx, arrowPoint1.dy)
          ..lineTo(arrowPoint2.dx, arrowPoint2.dy)
          ..close(),
        arrowPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

