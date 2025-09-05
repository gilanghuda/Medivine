import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../provider/analisis_provider.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  List<CameraDescription>? _cameras;
  int _selectedCameraIdx = 0;
  bool _flashOn = false;
  XFile? _capturedImage;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera([int cameraIdx = 0]) async {
    _cameras = await availableCameras();
    _selectedCameraIdx = cameraIdx;
    _controller = CameraController(
      _cameras![_selectedCameraIdx],
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    _initializeControllerFuture = _controller!.initialize().then((_) {
      _controller!.setFlashMode(_flashOn ? FlashMode.torch : FlashMode.off);
    });
    setState(() {});
  }

  Future<void> _toggleCamera() async {
    if (_cameras == null || _cameras!.length < 2) return;
    _selectedCameraIdx = (_selectedCameraIdx + 1) % _cameras!.length;
    await _initCamera(_selectedCameraIdx);
  }

  Future<void> _toggleFlash() async {
    if (_controller == null) return;
    _flashOn = !_flashOn;
    await _controller!.setFlashMode(_flashOn ? FlashMode.torch : FlashMode.off);
    setState(() {});
  }

  Future<void> _captureImage() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    try {
      if (_capturedImage != null) return;
      final image = await _controller!.takePicture();
      setState(() {
        _capturedImage = image;
      });
      await _controller!.pausePreview();
      _showConfirmDialog(image);
    } catch (e) {}
  }

  void _showConfirmDialog(XFile image) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(image.path),
                  width: 180,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Gunakan foto ini?",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () async {
                      Navigator.of(dialogContext).pop();
                      setState(() {
                        _capturedImage = null;
                      });
                      await _controller?.resumePreview();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.pink,
                      side: const BorderSide(color: Colors.pink),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text("Ulangi"),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.of(dialogContext).pop();

                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (loadingContext) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                      await Provider.of<AnalisisProvider>(context,
                              listen: false)
                          .analyze(File(image.path));
                      if (mounted) {
                        Navigator.of(context, rootNavigator: true).pop();
                        context.push('/analisis', extra: {
                          'imagePath': image.path,
                        });
                        setState(() {
                          _capturedImage = null;
                        });
                        await _controller?.resumePreview();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text("Gunakan"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Widget _buildOverlay() {
    return Center(
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 3),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: _cornerWidget(alignment: Alignment.topLeft),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: _cornerWidget(alignment: Alignment.topRight),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: _cornerWidget(alignment: Alignment.bottomLeft),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: _cornerWidget(alignment: Alignment.bottomRight),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cornerWidget({required Alignment alignment}) {
    double size = 32;
    double thickness = 4;
    return Align(
      alignment: alignment,
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _CornerPainter(alignment: alignment, thickness: thickness),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => context.go('/'),
        ),
        centerTitle: true,
        title: const Text(
          "Scan Rongga Mulut",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: _controller == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    children: [
                      Expanded(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CameraPreview(_controller!),
                            Container(
                              color: Colors.black.withOpacity(0.25),
                            ),
                            _buildOverlay(),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.grey[900],
                        padding: const EdgeInsets.only(top: 24, bottom: 32),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: Icon(
                                _flashOn ? Icons.flash_on : Icons.flash_off,
                                color: Colors.white,
                                size: 32,
                              ),
                              onPressed: _toggleFlash,
                            ),
                            GestureDetector(
                              onTap: _captureImage,
                              child: Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 5,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.cameraswitch,
                                color: Colors.white,
                                size: 32,
                              ),
                              onPressed: _toggleCamera,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 120,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.white38,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final Alignment alignment;
  final double thickness;
  _CornerPainter({required this.alignment, required this.thickness});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke;

    final path = Path();
    if (alignment == Alignment.topLeft) {
      path.moveTo(0, size.height);
      path.lineTo(0, 0);
      path.lineTo(size.width, 0);
    } else if (alignment == Alignment.topRight) {
      path.moveTo(size.width, size.height);
      path.lineTo(size.width, 0);
      path.lineTo(0, 0);
    } else if (alignment == Alignment.bottomLeft) {
      path.moveTo(0, 0);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
    } else if (alignment == Alignment.bottomRight) {
      path.moveTo(size.width, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
