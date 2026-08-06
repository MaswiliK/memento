// lib/core/services/overlay_service.dart
import 'dart:async';
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
      positionGravity: PositionGravity.none,
    );
  }

  static Future<void> close() async {
    await FlutterOverlayWindow.closeOverlay();
  }

  static Future<bool> isActive() async {
    return await FlutterOverlayWindow.isActive();
  }

  /// Expands the overlay and enables keyboard interaction.
  static Future<void> enterEditMode() async {
    await FlutterOverlayWindow.resizeOverlay(
      _editWidth,
      _editHeight,
      false, // Disable dragging while editing
    );
    await FlutterOverlayWindow.updateFlag(OverlayFlag.focusPointer);
  }

  /// Restores the normal viewing mode.
  static Future<void> exitEditMode() async {
    await FlutterOverlayWindow.updateFlag(OverlayFlag.defaultFlag);
    await FlutterOverlayWindow.resizeOverlay(
      _viewWidth,
      _viewHeight,
      true, // Dragging enabled again
    );
  }

  /// Sends live data from the main app to the overlay window.
  static Future<void> sendData(String data) async {
    await FlutterOverlayWindow.shareData(data);
  }

  /// Minimizes the overlay to a small floating action bubble.
  static Future<void> minimizeToBubble() async {
    await FlutterOverlayWindow.resizeOverlay(_bubbleSize, _bubbleSize, true);
  }

  /// Restores the overlay to standard dimensions from a bubble state.
  static Future<void> restoreFromBubble() async {
    await FlutterOverlayWindow.resizeOverlay(_viewWidth, _viewHeight, true);
  }

  /// Listens to data streams sent across the overlay isolates.
  /// Call this method inside your overlay entrypoint widget state.
  static StreamSubscription<dynamic> registerOverlayListener(
    Function(dynamic data) onDataReceived,
  ) {
    return FlutterOverlayWindow.overlayListener.listen((dynamic data) {
      if (data != null) {
        onDataReceived(data);
      }
    });
  }

  /// Listens to data streams sent from the overlay back to the main application.
  static StreamSubscription<dynamic> registerMainAppListener(
    Function(dynamic data) onDataReceived,
  ) {
    return FlutterOverlayWindow.overlayListener.listen((dynamic data) {
      if (data != null) {
        onDataReceived(data);
      }
    });
  }
}
