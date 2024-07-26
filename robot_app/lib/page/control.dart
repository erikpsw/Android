import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

void main() {
  runApp(const MaterialApp(home: PhysicsCardDragDemo()));
}

Offset currentPosition = Offset.zero;
double strength = 1.0;

class PhysicsCardDragDemo extends StatelessWidget {
  const PhysicsCardDragDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 100,
          ),
          StrengthSlider(),
          DraggableCard(
            child: FloatingActionButton(
              onPressed: null,
            ),
          ),
          Positioned(
            bottom: 20,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [ClearButton()],
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: WebSocketPage(),
          ),
        ],
      ),
    );
  }
}

class DraggableCard extends StatefulWidget {
  const DraggableCard({required this.child, super.key});

  final Widget child;

  @override
  State<DraggableCard> createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  /// The alignment of the card as it is dragged or being animated.
  ///
  /// While the card is being dragged, this value is set to the values computed
  /// in the GestureDetector onPanUpdate callback. If the animation is running,
  /// this value is set to the value of the [_animation].
  Alignment _dragAlignment = Alignment.center;

  late Animation<Alignment> _animation;

  /// Calculates and runs a [SpringSimulation].
  void _runAnimation(Offset pixelsPerSecond, Size size) {
    _animation = _controller.drive(
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment.center,
      ),
    );
    // Calculate the velocity relative to the unit interval, [0,1],
    // used by the animation controller.
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _controller.animateWith(simulation);
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
    _controller.addListener(() {
      setState(() {
        _dragAlignment = _animation.value;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final webSocketPageState =
        context.findAncestorStateOfType<WebSocketPageState>();
    return GestureDetector(
      onPanDown: (details) {
        _controller.stop();
      },
      onPanUpdate: (details) {
        setState(() {
          _dragAlignment += Alignment(
            details.delta.dx / (size.width / 2),
            details.delta.dy / (size.height / 2),
          );
          currentPosition += details.delta * strength;
          if (webSocketPageState != null) {
            webSocketPageState.sendCoordinates(
                currentPosition.dx, currentPosition.dy);
          } else {
            print("null");
          }
        });
      },
      onPanEnd: (details) {
        _runAnimation(details.velocity.pixelsPerSecond, size);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: _dragAlignment,
            child: Card(
              child: widget.child,
            ),
          ),
          Column(
            children: [
              const SizedBox(
                height: 55,
              ),
              Text(
                  'Position: (${currentPosition.dx.toStringAsFixed(2)}, ${currentPosition.dy.toStringAsFixed(2)})'),
            ],
          )
        ],
      ),
    );
  }
}

class ClearButton extends StatefulWidget {
  const ClearButton({super.key});

  @override
  State<ClearButton> createState() => _ClearButtonState();
}

class _ClearButtonState extends State<ClearButton> {
  void _clearPosition() {
    setState(() {
      currentPosition = Offset.zero;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _clearPosition,
          child: const Text('Clear Position'),
        ),
        const SizedBox(height: 30)
      ],
    );
  }
}

class StrengthSlider extends StatefulWidget {
  const StrengthSlider({super.key});

  @override
  State<StrengthSlider> createState() => _StrengthSliderState();
}

class _StrengthSliderState extends State<StrengthSlider> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 80),
        Text('Strength: ${strength.toStringAsFixed(1)}'),
        Slider(
          value: strength,
          min: 0,
          max: 10.0,
          divisions: 100,
          label: strength.toStringAsFixed(1),
          onChanged: (value) {
            setState(() {
              strength = value;
            });
          },
          onChangeEnd: (value) {
            // final draggableCardState =
            //     context.findAncestorStateOfType<_DraggableCardState>();
            // if (draggableCardState != null) {
            //   draggableCardState.setState(() {
            //     draggableCardState._strength = value;
            //   });
            // }
          },
        ),
      ],
    );
  }
}

class WebSocketPage extends StatefulWidget {
  const WebSocketPage({super.key});

  @override
  WebSocketPageState createState() => WebSocketPageState();
}

class WebSocketPageState extends State<WebSocketPage> {
  late WebSocketChannel channel;
  String message = "";

  @override
  void initState() {
    super.initState();
    // 使用计算机的 IP 地址
    channel = WebSocketChannel.connect(Uri.parse('ws://192.168.0.102:8765'));
  }

  void sendCoordinates(double x, double y) {
    final coordinates = jsonEncode({'x': x, 'y': y});
    channel.sink.add(coordinates);
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 如果不需要展示UI，这里可以返回一个空容器或者其他占位组件
    return
        // StreamBuilder(
        //   stream: channel.stream,
        //   builder: (context, snapshot) {
        //     if (snapshot.hasData) {
        //       message = snapshot.data.toString();
        //     }
        //     return Text(message);
        //   },
        // );
        Container();
  }
}
