import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class OverlayService {
  OverlayService._();

  static Future<bool> hasPermission() async {
    return await FlutterOverlayWindow.isPermissionGranted();
  }

  static Future<bool> requestPermission() async {
    final granted = await FlutterOverlayWindow.requestPermission();

    return granted ?? false;
  }

  static Future<void> show() async {
    await FlutterOverlayWindow.showOverlay(
      height: 80,
      width: 80,
      enableDrag: true,
      overlayTitle: "Memento",
      overlayContent: "Floating Bubble",
      flag: OverlayFlag.defaultFlag,
      visibility: NotificationVisibility.visibilityPublic,
      positionGravity: PositionGravity.auto,
    );
  }

  static Future<void> close() async {
    await FlutterOverlayWindow.closeOverlay();
  }
}
