import 'dart:ui';

import 'package:flutter/widgets.dart';

/// Interval Progress Bar
class IntervalProgressBar extends StatelessWidget {
  /// Time progress
  final int max;
  /// Number progress
  final int progress;
  /// Time interval
  final int intervalSize;
  /// size of progress: Size(350, 30),
  final Size size;
  /// Highlight color
  final Color highlightColor;
  /// default color
  final Color defaultColor;
  /// interval color
  final Color intervalColor;
  /// interval hightlight color
  final Color intervalHighlightColor;
  /// reverse
  final bool reverse;

  /// Constructor
  const IntervalProgressBar(
      {Key key,
      @required this.max,
      @required this.progress,
      @required this.intervalSize,
      @required this.size,
      @required this.highlightColor,
      @required this.defaultColor,
      @required this.intervalColor,
      @required this.intervalHighlightColor,
      this.reverse = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        painter: HorizontalProgressPainter(
          max,
          progress,
          intervalSize,
          highlightColor,
          defaultColor,
          intervalColor,
          intervalHighlightColor,
        ),
        size: size);
  }
}

/// Interval Progress Painter
abstract class IntervalProgressPainter extends CustomPainter {
  /// Time progress
  final int max;
  /// Number progress
  final int progress;
  /// Time interval
  final int intervalSize;
  /// Highlight color
  final Color highlightColor;
  /// default color
  final Color defaultColor;
  /// interval color
  final Color intervalColor;
  /// interval hightlight color
  final Color intervalHighlightColor;

  final Paint _paint = Paint()
    ..style = PaintingStyle.fill
    ..isAntiAlias = true;
  /// An immutable, 2D, axis-aligned, floating-point rectangle whose coordinates
  /// are relative to a given origin.
  Rect bound;

  /// Constructor
  IntervalProgressPainter(
      this.max,
      this.progress,
      this.intervalSize,
      this.highlightColor,
      this.defaultColor,
      this.intervalColor,
      this.intervalHighlightColor);

  @override
  @mustCallSuper
  void paint(Canvas canvas, Size size) {
    if (progress > max) {
      throw Exception("progress must <= max");
    }
    bound = Offset.zero & size;
    // ignore: omit_local_variable_types
    Size blockSize = calBlockSize();
    for (var i = 0; i < max; i++) {
      _paintBlock(canvas, i, blockSize);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final old = oldDelegate as IntervalProgressPainter;
    return old.max != max ||
        old.progress != progress ||
        old.intervalSize != intervalSize ||
        old.intervalColor != intervalColor ||
        old.defaultColor != defaultColor ||
        old.highlightColor != highlightColor ||
        old.intervalHighlightColor != intervalHighlightColor;
  }
  /// check value of highlight block
  bool highlightBlock(int index) => index < progress;
  /// check value of highlight interval
  bool highlightInterval(int index) => index < progress - 1;
  /// paint block
  void paintBlock(Canvas canvas, int blockIndex, Size blockSize);

  // ignore: public_member_api_docs
  Size calBlockSize();

  void _paintBlock(Canvas canvas, int i, Size blockSize) {
    final blockWidth = blockSize.width;
    final highlight = i < progress;
    final dx = (blockWidth + intervalSize) * i;

    _paint.color = highlight ? highlightColor : defaultColor;
    canvas.save();
    canvas.translate(dx, 0);

    final roundRect =
        RRect.fromLTRBR(0, 0, blockWidth, bound.height, Radius.circular(5));
    canvas.drawRRect(roundRect, _paint);
    canvas.restore();
  }
}

/// Horizontal Progress Painter
class HorizontalProgressPainter extends IntervalProgressPainter {
  // ignore: public_member_api_docs
  HorizontalProgressPainter(
    int max,
    int progress,
    int intervalWidth,
    Color highlightColor,
    Color defaultColor,
    Color intervalColor,
    Color intervalHighlightColor,
  ) : super(max, progress, intervalWidth, highlightColor, defaultColor,
            intervalColor, intervalHighlightColor);

  @override
  Size calBlockSize() =>
      Size(((bound.width - intervalSize * (max - 1)) / max), bound.height);

  @override
  void paintBlock(Canvas canvas, int i, Size blockSize) {
    final blockWidth = blockSize.width;
    final highlight = highlightBlock(i);
    final dx = (blockWidth + intervalSize) * i;

    _paint.color = highlight ? highlightColor : defaultColor;
    canvas.save();
    canvas.translate(dx, 0);

    final roundRect =
        RRect.fromLTRBR(0, 0, blockWidth, bound.height, Radius.circular(5));
    canvas.drawRRect(roundRect, _paint);
    canvas.restore();
  }
}
