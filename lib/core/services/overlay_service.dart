// lib/core/services/overlay_service.dart
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class OverlayService {
  OverlayService._();

  static const int _viewWidth = 280;
  static const int _viewHeight = 120;

  static const int _editWidth = 340;
  static const int _editHeight = 220;

  static const int _bubbleSize = 64;

  static Future<bool> hasPermission() async {
    return await FlutterOverlayWindow.isPermissionGranted();
  }

  static Future<bool> requestPermission() async {
    final granted = await FlutterOverlayWindow.requestPermission();
    return granted ?? false;
  }

  static Future<void> show() async {
    await FlutterOverlayWindow.showOverlay(
      width: _viewWidth,
      height: _viewHeight,
      enableDrag: true,
      overlayTitle: "Memento",
      overlayContent: "Floating Note",
      flag: OverlayFlag.defaultFlag,
      visibility: NotificationVisibility.visibilityPublic,
      positionGravity: PositionGravity.auto,
    );
  }

  static Future<void> close() async {
    await FlutterOverlayWindow.closeOverlay();
  }

  /// Expands the overlay and enables keyboard interaction.
  static Future<void> enterEditMode() async {
    await FlutterOverlayWindow.resizeOverlay(
      _editWidth.toInt(),
      _editHeight.toInt(),
      false, // 🔒 Disable dragging while editing
    );

    await FlutterOverlayWindow.updateFlag(OverlayFlag.focusPointer);
  }

  /// Restores the normal viewing mode.
  static Future<void> exitEditMode() async {
    await FlutterOverlayWindow.updateFlag(OverlayFlag.defaultFlag);

    await FlutterOverlayWindow.resizeOverlay(
      _viewWidth.toInt(),
      _viewHeight.toInt(),
      true, // 🔓 Dragging enabled again
    );
  }

  /// Sends live data from the main app to the overlay.
  static Future<void> sendData(String data) async {
    await FlutterOverlayWindow.shareData(data);
    exitEditMode();
  }

  static Future<void> minimizeToBubble() async {
    await FlutterOverlayWindow.resizeOverlay(_bubbleSize, _bubbleSize, true);
  }

  static Future<void> restoreFromBubble() async {
    await FlutterOverlayWindow.resizeOverlay(_viewWidth, _viewHeight, true);
  }
}
