import 'dart:math';

import 'package:flutter/material.dart';
import 'package:postman_app/components/failureContainer.dart';
import 'package:postman_app/components/sendRequest_widgetContainer.dart';
import 'package:postman_app/components/start_widgetcontainer.dart';
import 'package:postman_app/components/successContainer.dart';

class CanvasScreen extends StatefulWidget {
  const CanvasScreen({super.key});

  @override
  _CanvasScreenState createState() => _CanvasScreenState();
}

class _CanvasScreenState extends State<CanvasScreen> {
  late TransformationController _transformationController;
  double _scale = 1.0;
  Offset _offset = Offset.zero;
  bool showGrid = false; // Add this variable to control grid visibility

  Offset startWidgetPosition = Offset(300, 300);
  Offset sendRequestPosition = Offset(100, 100);
  Offset successPosition = const Offset(600, 100);
  Offset failurePosition = const Offset(600, 300);

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[50],
      appBar: AppBar(
        elevation: 1,
        title: const Text(
          'Workflow',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                // Add export functionality here
              },
              icon: const Icon(
                Icons.file_download_outlined,
                color: Colors.white,
                size: 20,
              ),
              label: const Text(
                'Export',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onScaleStart: (details) {
          _offset = _transformationController.toScene(details.focalPoint);
        },
        onScaleUpdate: (details) {
          setState(() {
            _scale *= details.scale;
            _transformationController.value = Matrix4.identity()
              ..translate(details.focalPoint.dx - _offset.dx,
                  details.focalPoint.dy - _offset.dy)
              ..scale(_scale);
          });
        },
        child: InteractiveViewer(
          transformationController: _transformationController,
          boundaryMargin: const EdgeInsets.all(double.infinity),
          constrained: false,
          minScale: 0.1,
          maxScale: 10.0,
          child: SizedBox(
            width: 50000, // Large width to allow for more space
            height: 50000,
            child: Stack(
              children: [
                CustomPaint(
                  painter: ArrowPainter(
                    startPoint: startWidgetPosition +
                        const Offset(75,
                            35), // Adjust these offsets based on your widget sizes
                    endPoint: sendRequestPosition + const Offset(150, 100),
                  ),
                  child: Container(),
                ),
                CustomPaint(
                  painter: ArrowPainter(
                    startPoint: sendRequestPosition + const Offset(300, 140),
                    endPoint: successPosition + const Offset(0, 100),
                  ),
                ),
                CustomPaint(
                  painter: ArrowPainter(
                    startPoint: sendRequestPosition + const Offset(300, 170),
                    endPoint: failurePosition + const Offset(0, 100),
                  ),
                ),
                DraggableWidget(
                  initialX: sendRequestPosition.dx,
                  initialY: sendRequestPosition.dy,
                  type: 'sendRequest',
                  onDrag: (Offset position) {
                    setState(() {
                      sendRequestPosition = position;
                    });
                  },
                ),
                DraggableWidget(
                  initialX: startWidgetPosition.dx,
                  initialY: startWidgetPosition.dy,
                  type: 'start',
                  onDrag: (Offset position) {
                    setState(() {
                      startWidgetPosition = position;
                    });
                  },
                ),
                DraggableWidget(
                  initialX: successPosition.dx,
                  initialY: successPosition.dy,
                  type: 'success',
                  onDrag: (Offset position) {
                    setState(() {
                      successPosition = position;
                    });
                  },
                ),

                // Failure path
                DraggableWidget(
                  initialX: failurePosition.dx,
                  initialY: failurePosition.dy,
                  type: 'failure',
                  onDrag: (Offset position) {
                    setState(() {
                      failurePosition = position;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 0.5;

    const double step = 20.0;

    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DraggableWidget extends StatefulWidget {
  final double initialX;
  final double initialY;
  final String type; // To differentiate between SendRequest and Start
  final Function(Offset) onDrag;

  const DraggableWidget({
    super.key,
    this.initialX = 0,
    this.initialY = 0,
    required this.type,
    required this.onDrag,
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

  Widget _buildSendRequestContainer() {
    return SendrequestWidgetcontainer();
  }

  Widget _buildStartContainer() {
    return StartWidgetcontainer();
  }

  Widget _buildSuccessContainer() {
    return SuccessResponseWidget();
  }

  Widget _buildFailureContainer() {
    return FailureResponseWidget();
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
        child: _buildContainer(),
      ),
    );
  }

  Widget _buildContainer() {
    switch (widget.type) {
      case 'sendRequest':
        return _buildSendRequestContainer();
      case 'start':
        return _buildStartContainer();
      case 'success':
        return _buildSuccessContainer();
      case 'failure':
        return _buildFailureContainer();
      default:
        return _buildStartContainer();
    }
  }
}

class ArrowPainter extends CustomPainter {
  final Offset startPoint;
  final Offset endPoint;

  ArrowPainter({
    required this.startPoint,
    required this.endPoint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Calculate control points for the curved line
    final controlPoint1 = Offset(
      startPoint.dx + (endPoint.dx - startPoint.dx) * 0.5,
      startPoint.dy,
    );
    final controlPoint2 = Offset(
      startPoint.dx + (endPoint.dx - startPoint.dx) * 0.5,
      endPoint.dy,
    );

    // Create path for curved line
    final path = Path()
      ..moveTo(startPoint.dx, startPoint.dy)
      ..cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        endPoint.dx,
        endPoint.dy,
      );

    // Draw the curved path
    canvas.drawPath(path, paint);

    // Calculate the middle point on the curve for the arrow
    final middlePoint = Offset(
      (controlPoint1.dx + controlPoint2.dx) / 2,
      (controlPoint1.dy + controlPoint2.dy) / 2,
    );

    // Draw arrow at the middle point
    drawArrowHead(canvas, middlePoint, startPoint);
  }

  void drawArrowHead(Canvas canvas, Offset tip, Offset start) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final double arrowSize = 10; // Size of the arrow head

    // Calculate the angle for the arrow
    double angle;
    if (tip.dy > start.dy) {
      angle = atan2(1, 0); // Point downward if going down
    } else if (tip.dy < start.dy) {
      angle = atan2(-1, 0); // Point upward if going up
    } else {
      angle = atan2(0, 1); // Point right if horizontal
    }

    final path = Path();

    // Create a wider arrow head
    path.moveTo(
      tip.dx - arrowSize * cos(angle - pi / 3),
      tip.dy - arrowSize * sin(angle - pi / 3),
    );
    path.lineTo(
      tip.dx + (arrowSize * 0.5) * cos(angle),
      tip.dy + (arrowSize * 0.5) * sin(angle),
    );
    path.lineTo(
      tip.dx - arrowSize * cos(angle + pi / 3),
      tip.dy - arrowSize * sin(angle + pi / 3),
    );
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
