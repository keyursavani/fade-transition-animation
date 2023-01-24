import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: Scaffold(
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyHomePageState();
  }
}

class MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  final Image starsBackground = Image(
    fit: BoxFit.cover,
    height: double.infinity,
    width: double.infinity,
    image: NetworkImage(
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSeD3RydyEA4u8qy7o74V9674lhQ-Ch61WXcQ&usqp=CAU'),
  );
  // final Image ufo = Image(
  //   height: 250,
  //   width: 250,
  //   image:
  //       NetworkImage('https://cdn-icons-png.flaticon.com/512/190/190276.png'),
  // );
  late final AnimationController controller;
  late final Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: true);
    //  animation = CurvedAnimation(
    //   parent: controller,
    //   curve: Curves.easeIn,
    // );
    animation = Tween<double>(begin: 0,end: 250).animate(controller)
    ..addStatusListener((status) {
    if (status == AnimationStatus.completed) {
      Future.delayed(Duration(seconds: 30), () {
        controller.reverse();
      });
    }
    else if (status == AnimationStatus.dismissed) {
      controller.forward();
    }
    });
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return
        // Using AnimatedBuilder
        Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        starsBackground,
        AnimatedBuilder(
          animation: controller,
          builder: (_, __) {
            return ClipPath(
              clipper: const BeamClipper(),
              child: Container(
                height: 1000,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    radius: 1.5,
                    colors: [
                      Colors.yellow,
                      Colors.transparent,
                    ],
                    stops: [0, controller.value],
                  ),
                ),
              ),
            );
          },
        ),
        // FadeTransition(
        //   opacity: animation,
        //   child: const Padding(
        //     padding: EdgeInsets.all(8),
        //     child: Image(
        //       height: 250,
        //       width: 250,
        //       image:
        //       NetworkImage('https://cdn-icons-png.flaticon.com/512/190/190276.png'),
        //     ),
        //   ),
        // ),
        Growing(),
      ],
    );
  }
}

class BeamClipper extends CustomClipper<Path> {
  const BeamClipper();

  @override
  getClip(Size size) {
    return Path()
      ..lineTo(size.width, 0.0)
      ..lineTo(size.width, size.height)
      ..lineTo(0.0, size.height)
      ..close();
  }

  // Return false always because we always clip the same area.
  @override
  bool shouldReclip(CustomClipper oldClipper) => false;
}

class Growing extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
   return GrowingState();
  }
}

class GrowingState extends State<Growing> with SingleTickerProviderStateMixin{
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds:35),
      vsync: this,
    );
    animation = Tween<double>(begin: 0, end:250).animate(controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
            controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
      // ..addStatusListener((status) => print('$status'));
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GrowTransition(
      animation: animation,
      child: const LogoWidget(),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      // child: const FlutterLogo(),
      child: const Image(
          image: NetworkImage('https://cdn-icons-png.flaticon.com/512/190/190276.png')
      ),
    );
  }
}

class GrowTransition extends StatelessWidget {
  const GrowTransition(
  {required this.child, required this.animation, super.key});

final Widget child;
final Animation<double> animation;

@override
Widget build(BuildContext context) {
  return Center(
    child: AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return SizedBox(
          height: animation.value,
          width: animation.value,
          child: child,
        );
      },
      child: child,
    ),
  );
}
}
