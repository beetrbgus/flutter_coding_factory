import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  XFile? video;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: video == null ? renderEmpty() : renderVideo(),
    );
  }

  Widget renderEmpty() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: getBoxDecoration(),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _Logo(),
          SizedBox(height: 30),
          _AppName(),
        ],
      ),
    );
  }

  Widget renderVideo() {
    return Container();
  }
}

class _Logo extends StatelessWidget {
  const _Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset('asset/images/logo.png');
  }
}

class _AppName extends StatelessWidget {
  const _AppName({super.key});
  final TextStyle textStyle = const TextStyle(
    color: Colors.white,
    fontSize: 30,
    fontWeight: FontWeight.w300,
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("VIDEO", style: textStyle),
        Text(
          "PLAYER",
          style: textStyle.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

BoxDecoration getBoxDecoration() {
  return const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF2A3A7C),
        Color(0xFF000118),
      ],
    ),
  );
}
