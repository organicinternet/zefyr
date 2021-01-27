// Copyright (c) 2018, the Zefyr project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'package:flutter/gestures.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:notus/notus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'editable_box.dart';
import 'horizontal_rule.dart';
import 'image.dart';
import 'rich_text.dart';
import 'scope.dart';
import 'theme.dart';

/// Represents single line of rich text document in Zefyr editor.
class ZefyrLine extends StatefulWidget {
  const ZefyrLine({Key key, @required this.node, this.style, this.padding})
      : assert(node != null),
        super(key: key);

  /// Line in the document represented by this widget.
  final LineNode node;

  /// Style to apply to this line. Required for lines with text contents,
  /// ignored for lines containing embeds.
  final TextStyle style;

  /// Padding to add around this paragraph.
  final EdgeInsets padding;

  @override
  _ZefyrLineState createState() => _ZefyrLineState();
}

class _ZefyrLineState extends State<ZefyrLine> {
  final LayerLink _link = LayerLink();

  @override
  Widget build(BuildContext context) {
    final scope = ZefyrScope.of(context);
    if (scope.isEditable) {
      ensureVisible(context, scope);
    }
    final theme = Theme.of(context);

    Widget content;
    if (widget.node.hasEmbed) {
      content = buildEmbed(context, scope);
    } else {
      assert(widget.style != null);
      content = ZefyrRichText(
        node: widget.node,
        text: buildText(context),
      );
    }

    if (scope.isEditable) {
      Color cursorColor;
      switch (theme.platform) {
        case TargetPlatform.iOS:
        case TargetPlatform.macOS:
          cursorColor ??= CupertinoTheme.of(context).primaryColor;
          break;

        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
        case TargetPlatform.windows:
        case TargetPlatform.linux:
          cursorColor = theme.cursorColor;
          break;
      }

      content = EditableBox(
        child: content,
        node: widget.node,
        layerLink: _link,
        renderContext: scope.renderContext,
        showCursor: scope.showCursor,
        selection: scope.selection,
        selectionColor: theme.textSelectionColor,
        cursorColor: cursorColor,
      );
      content = CompositedTransformTarget(link: _link, child: content);
    }

    if (widget.padding != null) {
      return Padding(padding: widget.padding, child: content);
    }
    return content;
  }

  void ensureVisible(BuildContext context, ZefyrScope scope) {
    if (scope.selection.isCollapsed &&
        widget.node.containsOffset(scope.selection.extentOffset)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        bringIntoView(context);
      });
    }
  }

  void bringIntoView(BuildContext context) {
    final scrollable = Scrollable.of(context);
    final object = context.findRenderObject();
    assert(object.attached);
    final viewport = RenderAbstractViewport.of(object);
    assert(viewport != null);

    final offset = scrollable.position.pixels;
    var target = viewport.getOffsetToReveal(object, 0.0).offset;
    if (target - offset < 0.0) {
      scrollable.position.jumpTo(target);
      return;
    }
    target = viewport.getOffsetToReveal(object, 1.0).offset;
    if (target - offset > 0.0) {
      scrollable.position.jumpTo(target);
    }
  }

  TextSpan buildText(BuildContext context) {
    final theme = ZefyrTheme.of(context);
    final children = widget.node.children
        .map((node) => _segmentToTextSpan(node, theme))
        .toList(growable: false);
    return TextSpan(style: widget.style, children: children);
  }

  TextSpan _segmentToTextSpan(Node node, ZefyrThemeData theme) {
    final TextNode segment = node;
    final attrs = segment.style;
    GestureRecognizer recognizer;
    if (attrs.contains(NotusAttribute.link)) {
      final tapGestureRecognizer = TapGestureRecognizer();
      tapGestureRecognizer.onTap = () {
        launch(attrs.get(NotusAttribute.link).value);
      };
      recognizer = tapGestureRecognizer;
    }

    return TextSpan(
      text: segment.value,
      recognizer: recognizer,
      style: _getTextStyle(attrs, theme),
    );
  }

  TextStyle _getTextStyle(NotusStyle style, ZefyrThemeData theme) {
    var result = TextStyle();
    if (style.containsSame(NotusAttribute.bold)) {
      result = result.merge(theme.attributeTheme.bold);
    }
    if (style.containsSame(NotusAttribute.italic)) {
      result = result.merge(theme.attributeTheme.italic);
    }
    if (style.containsSame(NotusAttribute.underline)) {
      result = result.merge(theme.attributeTheme.underline);
    }
    if (style.containsSame(NotusAttribute.span.fontQl1)) {
      result = result.merge(theme.attributeTheme.fontQl1);
    }
    if (style.containsSame(NotusAttribute.span.fontQl2)) {
      result = result.merge(theme.attributeTheme.fontQl2);
    }
    if (style.containsSame(NotusAttribute.span.fontQl3)) {
      result = result.merge(theme.attributeTheme.fontQl3);
    }
    if (style.containsSame(NotusAttribute.span.fontQl4)) {
      result = result.merge(theme.attributeTheme.fontQl4);
    }
    if (style.containsSame(NotusAttribute.span.fontQl5)) {
      result = result.merge(theme.attributeTheme.fontQl5);
    }
    if (style.containsSame(NotusAttribute.span.fontQl6)) {
      result = result.merge(theme.attributeTheme.fontQl6);
    }
    if (style.containsSame(NotusAttribute.span.fontQl7)) {
      result = result.merge(theme.attributeTheme.fontQl7);
    }
    if (style.containsSame(NotusAttribute.span.fontQl8)) {
      result = result.merge(theme.attributeTheme.fontQl8);
    }
    if (style.containsSame(NotusAttribute.span.fontQl9)) {
      result = result.merge(theme.attributeTheme.fontQl9);
    }
    if (style.containsSame(NotusAttribute.span.fontQl10)) {
      result = result.merge(theme.attributeTheme.fontQl10);
    }
    if (style.containsSame(NotusAttribute.div.lightHeading1)) {
      result =
          result.merge(theme.attributeTheme.screedStyleLightHeading1.textStyle);
    }
    if (style.containsSame(NotusAttribute.div.lightHeading2)) {
      result =
          result.merge(theme.attributeTheme.screedStyleLightHeading2.textStyle);
    }
    if (style.containsSame(NotusAttribute.div.lightHeading3)) {
      result =
          result.merge(theme.attributeTheme.screedStyleLightHeading3.textStyle);
    }
    if (style.containsSame(NotusAttribute.div.body1)) {
      result = result.merge(theme.attributeTheme.screedStyleBody1.textStyle);
    }
    if (style.containsSame(NotusAttribute.div.body2)) {
      result = result.merge(theme.attributeTheme.screedStyleBody2.textStyle);
    }
    if (style.containsSame(NotusAttribute.div.body3)) {
      result = result.merge(theme.attributeTheme.screedStyleBody3.textStyle);
    }
    if (style.containsSame(NotusAttribute.div.body4)) {
      result = result.merge(theme.attributeTheme.screedStyleBody4.textStyle);
    }
    if (style.containsSame(NotusAttribute.div.listed)) {
      result = result.merge(theme.attributeTheme.screedStyleListed.textStyle);
    }
    if (style.contains(NotusAttribute.link)) {
      result = result.merge(theme.attributeTheme.link);
    }
    return result;
  }

  Widget buildEmbed(BuildContext context, ZefyrScope scope) {
    EmbedNode node = widget.node.children.single;
    EmbedAttribute embed = node.style.get(NotusAttribute.embed);

    if (embed.type == EmbedType.horizontalRule) {
      return ZefyrHorizontalRule(node: node);
    } else if (embed.type == EmbedType.image) {
      return ZefyrImage(node: node, delegate: scope.imageDelegate);
    } else {
      throw UnimplementedError('Unimplemented embed type ${embed.type}');
    }
  }
}
