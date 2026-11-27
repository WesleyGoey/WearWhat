import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Pratinjau kamera langsung. Layar induk memegang `GlobalKey<LiveCameraState>`
/// lalu memanggil [LiveCameraState.takePicture], [flip], dan [toggleFlash].
class LiveCamera extends StatefulWidget {
  const LiveCamera({super.key, this.front = false});

  /// Kamera awal: depan (selfie) atau belakang (baju).
  final bool front;

  @override
  State<LiveCamera> createState() => LiveCameraState();
}

class LiveCameraState extends State<LiveCamera> with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription> _cameras = const [];
  late bool _front = widget.front;
  bool _torch = false;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _start();
  }

  CameraDescription? _pick() {
    final dir = _front ? CameraLensDirection.front : CameraLensDirection.back;
    for (final c in _cameras) {
      if (c.lensDirection == dir) return c;
    }
    return _cameras.isEmpty ? null : _cameras.first;
  }

  Future<void> _start() async {
    try {
      if (_cameras.isEmpty) _cameras = await availableCameras();
      final desc = _pick();
      if (desc == null) throw CameraException('none', 'No camera');
      final old = _controller;
      final next = CameraController(
        desc,
        ResolutionPreset.high,
        enableAudio: false,
      );
      _controller = next;
      await old?.dispose();
      await next.initialize();
      _torch = false;
      if (mounted) setState(() => _failed = false);
    } catch (_) {
      // Izin ditolak atau tidak ada kamera: tampilkan pesan, galeri tetap bisa.
      if (mounted) setState(() => _failed = true);
    }
  }

  /// Ambil foto, atau null kalau kamera belum siap.
  Future<Uint8List?> takePicture() async {
    final c = _controller;
    if (c == null || !c.value.isInitialized || c.value.isTakingPicture) {
      return null;
    }
    final file = await c.takePicture();
    return file.readAsBytes();
  }

  Future<void> flip() async {
    _front = !_front;
    await _start();
  }

  /// Nyalakan atau matikan senter. Mengembalikan keadaan terbaru.
  Future<bool> toggleFlash() async {
    final c = _controller;
    if (c == null || !c.value.isInitialized) return _torch;
    try {
      await c.setFlashMode(_torch ? FlashMode.off : FlashMode.torch);
      _torch = !_torch;
    } catch (_) {
      // Kamera depan biasanya tidak punya senter.
    }
    return _torch;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final c = _controller;
    if (c == null || !c.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      c.dispose();
      _controller = null;
    } else if (state == AppLifecycleState.resumed) {
      _start();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = _controller;
    if (_failed) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            'Camera unavailable. Allow camera access in Settings, or pick from the gallery.',
            textAlign: TextAlign.center,
            style: AppText.body(13, color: AppColors.textTertiary),
          ),
        ),
      );
    }
    if (c == null || !c.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    // Isi penuh bingkai tanpa gepeng (seperti BoxFit.cover).
    final portrait = MediaQuery.orientationOf(context) == Orientation.portrait;
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          clipBehavior: Clip.hardEdge,
          child: SizedBox(
            // CameraPreview memakai 1/aspectRatio di layar portrait; kotak ini
            // harus berbanding sama supaya gambar tidak gepeng.
            width: portrait ? 100 : c.value.aspectRatio * 100,
            height: portrait ? 100 * c.value.aspectRatio : 100,
            child: CameraPreview(c),
          ),
        ),
      ),
    );
  }
}
