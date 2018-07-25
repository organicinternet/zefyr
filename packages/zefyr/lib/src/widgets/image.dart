// Copyright (c) 2018, the Zefyr project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:notus/notus.dart';
import 'package:image_picker/image_picker.dart';

import 'editable_box.dart';

abstract class ZefyrImageDelegate<S> {
  /// Builds image widget for specified [imageSource] and [context].
  Widget buildImage(BuildContext context, String imageSource);

  /// Picks an image from specified [source].
  ///
  /// Returns unique string key for the selected image. Returned key is stored
  /// in the document.
  Future<String> pickImage(S source);
}

class ZefyrDefaultImageDelegate implements ZefyrImageDelegate<ImageSource> {
  @override
  Widget buildImage(BuildContext context, String imageSource) {
    final file = new File.fromUri(Uri.parse(imageSource));
    final image = new FileImage(file);
    return new Image(image: image);
  }

  @override
  Future<String> pickImage(ImageSource source) async {
    final file = await ImagePicker.pickImage(source: source);
    if (file == null) return null;
    return file.uri.toString();
  }
}

class ZefyrImage extends StatefulWidget {
  const ZefyrImage({Key key, @required this.node, @required this.delegate})
      : super(key: key);

  final EmbedNode node;
  final ZefyrImageDelegate delegate;

  @override
  _ZefyrImageState createState() => _ZefyrImageState();
}

class _ZefyrImageState extends State<ZefyrImage> {
  String get imageSource {
    EmbedAttribute attribute = widget.node.style.get(NotusAttribute.embed);
    return attribute.value['source'];
  }

  @override
  Widget build(BuildContext context) {
    final image = widget.delegate.buildImage(context, imageSource);
    return _EditableImage(
      child: image,
      node: widget.node,
    );
  }
}

class _EditableImage extends SingleChildRenderObjectWidget {
  _EditableImage({@required Widget child, @required this.node})
      : assert(node != null),
        super(child: child);

  final EmbedNode node;

  @override
  RenderEditableImage createRenderObject(BuildContext context) {
    return new RenderEditableImage(node: node);
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderEditableImage renderObject) {
    renderObject..node = node;
  }
}

class RenderEditableImage extends RenderBox
    with RenderObjectWithChildMixin<RenderBox>, RenderProxyBoxMixin<RenderBox>
    implements RenderEditableBox {
  static const kPaddingBottom = 24.0;

  RenderEditableImage({
    RenderImage child,
    @required EmbedNode node,
  }) : _node = node {
    this.child = child;
  }

  @override
  EmbedNode get node => _node;
  EmbedNode _node;
  void set node(EmbedNode value) {
    _node = value;
  }

  @override
  double get preferredLineHeight => size.height;

  @override
  SelectionOrder get selectionOrder => SelectionOrder.background;

  @override
  TextSelection getLocalSelection(TextSelection documentSelection) {
    if (!intersectsWithSelection(documentSelection)) return null;

    int nodeBase = node.documentOffset;
    int nodeExtent = nodeBase + node.length;
    int base = math.max(0, documentSelection.baseOffset - nodeBase);
    int extent =
        math.min(documentSelection.extentOffset, nodeExtent) - nodeBase;
    return documentSelection.copyWith(baseOffset: base, extentOffset: extent);
  }

  @override
  List<ui.TextBox> getEndpointsForSelection(TextSelection selection) {
    TextSelection local = getLocalSelection(selection);
    if (local.isCollapsed) {
      final dx = local.extentOffset == 0 ? 0.0 : size.width;
      return [
        new ui.TextBox.fromLTRBD(dx, 0.0, dx, size.height, TextDirection.ltr),
      ];
    }

    return [
      new ui.TextBox.fromLTRBD(0.0, 0.0, 0.0, size.height, TextDirection.ltr),
      new ui.TextBox.fromLTRBD(
          size.width, 0.0, size.width, size.height, TextDirection.ltr),
    ];
  }

  @override
  TextPosition getPositionForOffset(Offset offset) {
    int position = _node.documentOffset;

    if (offset.dx > size.width / 2) {
      position++;
    }
    return new TextPosition(offset: position);
  }

  @override
  TextRange getWordBoundary(TextPosition position) {
    final start = _node.documentOffset;
    return new TextRange(start: start, end: start + 1);
  }

  @override
  bool intersectsWithSelection(TextSelection selection) {
    final int base = node.documentOffset;
    final int extent = base + node.length;
    return base <= selection.extentOffset && selection.baseOffset <= extent;
  }

  @override
  Offset getOffsetForCaret(TextPosition position, Rect caretPrototype) {
    final pos = position.offset - node.documentOffset;
    Offset caretOffset = Offset.zero;
    if (pos == 1) {
      caretOffset = caretOffset + new Offset(size.width - 1.0, 0.0);
    }
    return caretOffset;
  }

  @override
  void paintSelection(PaintingContext context, ui.Offset offset,
      TextSelection selection, ui.Color selectionColor) {
    final localSelection = getLocalSelection(selection);
    assert(localSelection != null);
    if (!localSelection.isCollapsed) {
      final Paint paint = new Paint()..color = selectionColor;
      final rect = new Rect.fromLTWH(0.0, 0.0, size.width, size.height);
      context.canvas.drawRect(rect.shift(offset), paint);
    }
  }

  @override
  void performLayout() {
    assert(constraints.hasBoundedWidth);
    if (child != null) {
      // Make constraints use 16:9 aspect ratio.
      final childConstraints = constraints.copyWith(
        maxHeight: (constraints.maxWidth * 9 / 16).floorToDouble(),
      );
      child.layout(childConstraints, parentUsesSize: true);
      size = new Size(child.size.width, child.size.height + kPaddingBottom);
    } else {
      performResize();
    }
  }
}
