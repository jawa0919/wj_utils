import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_scankit/flutter_scankit.dart';

class QrScanView extends StatefulWidget {
  const QrScanView({super.key});

  @override
  State<QrScanView> createState() => _QrScanViewState();
}

class _QrScanViewState extends State<QrScanView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarDividerColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        scrolledUnderElevation: 0,
        // leading: UnconstrainedBox(
        //   child: GestureDetector(
        //     onTap: () => {Navigator.of(context).pop()},
        //     child: Container(
        //       padding: EdgeInsets.all(10.w),
        //       child: Image.asset(
        //         'assets/images/icon_back.png',
        //         width: 24.w,
        //         height: 24.w,
        //         color: Colors.black,
        //       ),
        //     ),
        //   ),
        // ),
        centerTitle: true,
        shadowColor: null,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(children: [_buildScanning(context), _buildTips(context)]),
    );
  }

  final boxSize = 250.0;
  final ScanKitController _controller = ScanKitController();

  @override
  initState() {
    super.initState();
    _controller.onResult.listen((result) {
      debugPrint(
        'scanning result:value=${result.originalValue} scanType=${result.scanType}',
      );
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop(result.originalValue);
    });
  }

  Widget _buildScanning(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var left = screenWidth / 2 - boxSize / 2;
    var top = screenHeight / 2 - boxSize / 2;
    var rect = Rect.fromLTWH(left, top, boxSize, boxSize);
    return ScanKitWidget(controller: _controller, boundingBox: rect);
  }

  Widget _buildTips(BuildContext context) {
    return QrCodeScanAnimation(boxSize: boxSize);
  }
}

class QrCodeScanAnimation extends StatefulWidget {
  final double boxSize;
  const QrCodeScanAnimation({super.key, this.boxSize = 250});
  @override
  // ignore: library_private_types_in_public_api
  _QrCodeScanAnimation createState() => _QrCodeScanAnimation();
}

class _QrCodeScanAnimation extends State<QrCodeScanAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        painter: ScannerPainter(
          _controller,
          Theme.of(context).colorScheme.primary,
        ),
        size: Size(widget.boxSize, widget.boxSize),
      ),
    );
  }
}

class ScannerPainter extends CustomPainter {
  final Animation<double> animation;
  final Color paintColor;

  ScannerPainter(this.animation, this.paintColor) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final borderPaint = Paint()
      ..color = paintColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // 绘制四角边框
    final cornerLength = 25.0;

    // 左上角
    canvas.drawLine(Offset.zero, Offset(cornerLength, 0), borderPaint);
    canvas.drawLine(Offset.zero, Offset(0, cornerLength), borderPaint);

    // 右上角
    canvas.drawLine(
      Offset(width, 0),
      Offset(width - cornerLength, 0),
      borderPaint,
    );
    canvas.drawLine(Offset(width, 0), Offset(width, cornerLength), borderPaint);

    // 左下角
    canvas.drawLine(
      Offset(0, height),
      Offset(cornerLength, height),
      borderPaint,
    );
    canvas.drawLine(
      Offset(0, height),
      Offset(0, height - cornerLength),
      borderPaint,
    );

    // 右下角
    canvas.drawLine(
      Offset(width, height),
      Offset(width - cornerLength, height),
      borderPaint,
    );
    canvas.drawLine(
      Offset(width, height),
      Offset(width, height - cornerLength),
      borderPaint,
    );

    // 绘制扫描线
    final linePaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.transparent, paintColor, Colors.transparent],
        stops: [0.1, 0.5, 0.9],
      ).createShader(Rect.fromLTWH(0, 0, width, 3))
      ..strokeWidth = 3;

    final lineY = height * animation.value;
    canvas.drawLine(Offset(0, lineY), Offset(width, lineY), linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
