import 'package:flutter/material.dart';
import 'package:postman_app/components/main_drawer.dart';

class Workflow extends StatefulWidget {
  const Workflow({super.key});

  @override
  State<Workflow> createState() => _WorkflowState();
}

class _WorkflowState extends State<Workflow> {
  List<CanvasElement> elements = [];
  CanvasElement? selectedElement;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workflow'),
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            icon: const Icon(Icons.crop_square),
            onPressed: () => _addElement(ShapeType.rectangle),
          ),
          IconButton(
            icon: const Icon(Icons.circle_outlined),
            onPressed: () => _addElement(ShapeType.circle),
          ),
          IconButton(
            icon: const Icon(Icons.text_fields),
            onPressed: () => _addElement(ShapeType.text),
            tooltip: 'Add Text',
          ),
        ],
      ),
      drawer: const MainDrawer(),
      body: GestureDetector(
        onTapDown: (details) {
          // Deselect shape if tapping outside
          setState(() {
            selectedElement = null;
          });
        },
        onPanUpdate: (details) {
          // Drag selected element
          if (selectedElement != null) {
            setState(() {
              selectedElement!.position += details.delta;
            });
          }
        },
        child: Stack(
          children: [
            // Custom background canvas
            CustomPaint(
              size: Size.infinite,
              painter: BackgroundPainter(),
            ),
            // Custom connections between elements
            CustomPaint(
              size: Size.infinite,
              painter: ConnectionPainter(elements),
            ),
            // Render draggable elements
            ...elements.map((element) => _buildElementWidget(element)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildElementWidget(CanvasElement element) {
    if (element.shapeType == ShapeType.text) {
      return Positioned(
        left: element.position.dx - element.size.width / 2,
        top: element.position.dy - element.size.height / 2,
        child: GestureDetector(
          onTap: () async {
            String? newText = await _editTextDialog(element.text);
            if (newText != null) {
              setState(() {
                element.text = newText;
              });
            }
          },
          onPanUpdate: (details) {
            setState(() {
              element.position += details.delta;

              if (element.position.dy >
                  MediaQuery.of(context).size.height - 100) {
                element.deleteMode = true;
              } else {
                element.deleteMode = false;
              }
            });
          },
          onPanEnd: (details) {
            if (element.deleteMode == true) {
              setState(() {
                for (var e in elements) {
                  e.connectedTo.remove(element);
                }
                elements.remove(element);
                if (selectedElement == element) {
                  selectedElement = null;
                }
              });
            }
          },
          child: Text(
            element.text,
            style: TextStyle(
              fontSize: 16,
              color: element.deleteMode
                  ? Colors.red
                  : selectedElement == element
                      ? Colors.blue
                      : Colors.white,
            ),
          ),
        ),
      );
    }
    final containerSize = element.shapeType == ShapeType.rectangle
        ? Size(element.size.width * 1.5,
            element.size.height) // Increased width for rectangle
        : element.size;

    return Positioned(
      left: element.position.dx - containerSize.width / 2,
      top: element.position.dy - containerSize.height / 2,
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedElement = element;
          });
        },
        onPanUpdate: (details) {
          setState(() {
            element.position += details.delta;

            // Check if the element is dragged below a certain threshold
            if (element.position.dy >
                MediaQuery.of(context).size.height - 100) {
              element.deleteMode = true; // Add visual feedback
            } else {
              element.deleteMode = false;
            }
          });
        },
        onPanEnd: (details) {
          if (element.deleteMode == true) {
            setState(() {
              for (var e in elements) {
                e.connectedTo.remove(element); // Remove connections
              }
              elements.remove(element); // Remove the element
              if (selectedElement == element) {
                selectedElement = null;
              }
            });
          }
        },
        child: Stack(
          children: [
            Container(
              width: element.size.width,
              height: element.size.height,
              decoration: BoxDecoration(
                color: element.deleteMode
                    // ignore: deprecated_member_use
                    ? Colors.red.withOpacity(0.5)
                    : selectedElement == element
                        ? Colors.blueAccent
                        : Colors.grey[800],
                shape: element.shapeType == ShapeType.circle
                    ? BoxShape.circle
                    : BoxShape.rectangle,
                border: Border.all(color: Colors.black),
              ),
              alignment: Alignment.center,
              child: element.shapeType == ShapeType.circle
                  ? _buildCircleContent(element)
                  : _buildRectangleContent(element),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleContent(CanvasElement element) {
    return Center(
      child: GestureDetector(
        onTap: () async {
          String? newText = await _editTextDialog(element.text);
          if (newText != null) {
            setState(() {
              element.text = newText;
            });
          }
        },
        child: Text(
          element.text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildRectangleContent(CanvasElement element) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () async {
                String? newText = await _editTextDialog(element.text);
                if (newText != null) {
                  setState(() {
                    element.text = newText;
                  });
                }
              },
              child: Text(
                element.text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          TextField(
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Enter URL..',
              hintStyle: TextStyle(color: Colors.white54),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white54),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            onChanged: (value) {
              // Handle text field changes if needed
            },
          ),
          TextField(
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Success/failure',
              hintStyle: TextStyle(color: Colors.white54),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white54),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            onChanged: (value) {
              // Handle text field changes if needed
            },
          ),
          TextField(
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Zip Code...',
              hintStyle: TextStyle(color: Colors.white54),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white54),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            onChanged: (value) {
              // Handle text field changes if needed
            },
          ),
        ],
      ),
    );
  }

  void _addElement(ShapeType shapeType) {
    setState(() {
      final Size elementSize;
      final String defaultText;

      switch (shapeType) {
        case ShapeType.rectangle:
          elementSize = const Size(300, 200);
          defaultText = 'Edit Me';
          break;
        case ShapeType.circle:
          elementSize = const Size(100, 100);
          defaultText = 'Edit Me';
          break;
        case ShapeType.text:
          elementSize = const Size(100, 30); // Smaller size for text
          defaultText = 'New Text';
          break;
      }

      final newElement = CanvasElement(
        position: Offset(200, 200),
        size: elementSize,
        text: defaultText,
        shapeType: shapeType,
      );
      elements.add(newElement);

      if (selectedElement != null) {
        selectedElement!.connectedTo.add(newElement);
      }
    });
  }

  Future<String?> _editTextDialog(String currentText) async {
    TextEditingController controller = TextEditingController(text: currentText);
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Text'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

// Background painter to draw the canvas
class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[400]! // Dot color
      ..style = PaintingStyle.fill; // Solid fill for dots

    const double dotSpacing = 40.0; // Distance between dots
    const double dotRadius = 2.0; // Radius of each dot

    for (double x = 0; x < size.width; x += dotSpacing) {
      for (double y = 0; y < size.height; y += dotSpacing) {
        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Connection painter to draw lines between elements
class ConnectionPainter extends CustomPainter {
  final List<CanvasElement> elements;

  ConnectionPainter(this.elements);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0;

    for (var element in elements) {
      for (var connectedElement in element.connectedTo) {
        canvas.drawLine(
          element.position,
          connectedElement.position,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class CanvasElement {
  Offset position;
  Size size;
  String text;
  ShapeType shapeType;
  bool deleteMode = false;
  List<CanvasElement> connectedTo = [];

  CanvasElement({
    required this.position,
    required this.size,
    required this.text,
    required this.shapeType,
  });
}

enum ShapeType { rectangle, circle, text }
