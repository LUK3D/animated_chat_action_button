import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:do_tween/do_tween.dart';

/// ## Animated Action Button
/// Ceates a button that can be dragged like whatsapp audio recording button
///
/// ### Example usage:
/// ```dart
/// AnimatedChatActionButton(
///   onHold: (){
///     //Start recording audio
///   },
///   onHoldEnd: (){
///     ///Stop recording the audio
///   },
/// )
///```
class AnimatedChatActionButton extends StatefulWidget {
  const AnimatedChatActionButton({
    super.key,
    required this.onHold,
    required this.onHoldEnd,
    this.onDragEnd,
    this.debugMode,
    this.backgroundColor,
    this.foregroundColor,
    this.activeForegroundColor,
    this.icon,
    this.isActive = false,
    this.activeBackgroundColor,
  });

  final Function(bool startRecording)? onDragEnd;

  ///### onHold()
  ///Triggered when the button is hold down
  final Function() onHold;

  ///### onHoldEnd()
  /// Triggered when the button is released
  final Function() onHoldEnd;

  ///### debugMode
  /// If `ture` the button boundaries will be displayede to see the space that this widget takes.
  final bool? debugMode;

  ///### backgroundColor
  /// Defines the button background color
  final Color? backgroundColor;

  ///### foregroundColor
  /// The button foreground color
  final Color? foregroundColor;

  ///### activeBackgroundColor
  /// if `isActive` property is `true`, this color will be used for the background
  final Color? activeBackgroundColor;

  ///### activeForegroundColor
  /// if `isActive` property is `true`, this color will be used for the foreground color
  final Color? activeForegroundColor;

  ///### icon
  final IconData? icon;

  ///### isActive
  /// changes the button state to active
  final bool isActive;

  @override
  State<AnimatedChatActionButton> createState() =>
      _AnimatedChatActionButtonState();
}

class _AnimatedChatActionButtonState extends State<AnimatedChatActionButton> {
  double scale = 25;
  double maxScale = 25;
  double position = 145;
  double maxHeight = 200;
  double backgroundOpacity = 0;
  late Color activeBackgroundColor;
  Do? tween;
  Do? colorTween;
  Do? positionTween;
  Do? scaleTween;

  @override
  void initState() {
    super.initState();
    activeBackgroundColor =
        widget.activeBackgroundColor ?? widget.backgroundColor ?? Colors.purple;
  }

  void reset() {
    tween?.stop();
    colorTween?.stop();
    scaleTween?.stop();
    tween = Do({"val": position})
        .to({"val": 145}, 500)
        .easing(Do.ease.elastic.easeOut)
        .onUpdate((val) {
          setState(() {
            position = val["val"];
          });
        })
        .tween();
    colorTween = Do({"val": backgroundOpacity})
        .to({"val": 0}, 500)
        .easing(Do.ease.elastic.easeOut)
        .onUpdate((val) {
          setState(() {
            backgroundOpacity = clampDouble(val["val"], 0, 1);
          });
        })
        .tween();

    setState(() {
      scale = 25;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        positionTween?.stop();
        setState(() {
          scale = clampDouble(scale + ((details.delta.dy * 0.05)), 0.5, 25);
          position = clampDouble(position + (details.delta.dy * 0.5), 10, 145);
          backgroundOpacity =
              clampDouble(backgroundOpacity - (details.delta.dy * 0.5), 0, 1);
        });
      },
      onVerticalDragEnd: (details) {
        if (widget.onDragEnd != null) {
          widget.onDragEnd!(scale < 20);
        }
        reset();
      },
      onTapDown: (d) {
        tween?.stop();
        backgroundOpacity = 1;

        scaleTween = Do({"val": scale})
            .to({"val": 35}, 100)
            .easing(Do.ease.elastic.easeOut)
            .onUpdate((val) {
              setState(() {
                scale = val["val"];
              });
            })
            .tween();

        positionTween = Do({"val": position})
            .to({"val": position - 10}, 50)
            .easing(Do.ease.linear.easeIn)
            .onUpdate((val) {
              setState(() {
                position = val["val"];
              });
            })
            .tween();
      },
      onTapUp: (d) {
        reset();
      },
      onTap: () {
        reset();
      },
      onLongPress: () {
        widget.onHold();
      },
      onLongPressEnd: (details) {
        reset();
      },
      child: SizedBox(
        height: maxHeight,
        width: 60,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
              top: position,
              // right: 5,
              child: CircleAvatar(
                radius: scale,
                backgroundColor: widget.isActive
                    ? activeBackgroundColor
                    : (widget.backgroundColor ?? Colors.purple)
                        .withOpacity(backgroundOpacity),
                foregroundColor: widget.isActive
                    ? widget.activeForegroundColor
                    : widget.activeForegroundColor ??
                        widget.foregroundColor ??
                        Colors.white,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.antiAlias,
                  children: [
                    Icon(
                      widget.icon ?? Icons.mic_none_outlined,
                      size: scale,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 60,
              height: 60,
              color: Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
