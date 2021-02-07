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
  const ZefyrLine({
    Key key,
    @required this.node,
    this.style,
    this.padding,
  })  : assert(node != null),
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

  TextAlign getTextAlign(LineNode node) {
    final alignment = node.style.get(NotusAttribute.alignment);
    if (alignment == NotusAttribute.alignment.left) {
      return TextAlign.left;
    } else if (alignment == NotusAttribute.alignment.center) {
      return TextAlign.center;
    } else if (alignment == NotusAttribute.alignment.right) {
      return TextAlign.right;
    } else if (alignment == NotusAttribute.alignment.justify) {
      return TextAlign.justify;
    }
    return TextAlign.start;
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
    TextStyle result = TextStyle();
    final rgbStringToColor = (String rgb) {
      rgb = rgb.replaceFirst('rgb(', '');
      rgb = rgb.replaceAll(')', '');
      var values = rgb.split(', ');
      return Color.fromARGB(
        255,
        int.parse(values[0]),
        int.parse(values[1]),
        int.parse(values[2]),
      );
    };
    if (style.containsSame(NotusAttribute.bold)) {
      result = result.merge(theme.attributeTheme.bold);
    }
    if (style.containsSame(NotusAttribute.italic)) {
      result = result.merge(theme.attributeTheme.italic);
    }
    if (style.containsSame(NotusAttribute.underline)) {
      result = result.merge(theme.attributeTheme.underline);
    }
    if (style.containsSame(NotusAttribute.strikethrough)) {
      result = result.merge(theme.attributeTheme.strikethrough);
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
    if (style.containsSame(NotusAttribute.lightH1)) {
      result =
          result.merge(theme.attributeTheme.screedStyleLightHeading1.textStyle);
    }
    if (style.containsSame(NotusAttribute.lightH2)) {
      result =
          result.merge(theme.attributeTheme.screedStyleLightHeading2.textStyle);
    }
    if (style.containsSame(NotusAttribute.lightH3)) {
      result =
          result.merge(theme.attributeTheme.screedStyleLightHeading3.textStyle);
    }
    if (style.containsSame(NotusAttribute.p.body1)) {
      result = result.merge(theme.attributeTheme.screedStyleBody1.textStyle);
    }
    if (style.containsSame(NotusAttribute.p.body2)) {
      result = result.merge(theme.attributeTheme.screedStyleBody2.textStyle);
    }
    if (style.containsSame(NotusAttribute.p.body3)) {
      result = result.merge(theme.attributeTheme.screedStyleBody3.textStyle);
    }
    if (style.containsSame(NotusAttribute.p.body4)) {
      result = result.merge(theme.attributeTheme.screedStyleBody4.textStyle);
    }
    if (style.containsSame(NotusAttribute.p.listed)) {
      result = result.merge(theme.attributeTheme.screedStyleListed.textStyle);
    }
    if (style.contains(NotusAttribute.link)) {
      result = result.merge(theme.attributeTheme.link);
    }
    //Colors
    if (style.contains(NotusAttribute.black)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.black));
      result = result.copyWith(color: textColor);
    }

    if (style.contains(NotusAttribute.red)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.red));
      result = result.copyWith(color: textColor);
    }

    if (style.contains(NotusAttribute.orange)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.orange));
      result = result.copyWith(color: textColor);
    }

    if (style.contains(NotusAttribute.yellow)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.yellow));
      result = result.copyWith(color: textColor);
    }

    if (style.contains(NotusAttribute.green)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.green));
      result = result.copyWith(color: textColor);
    }

    if (style.contains(NotusAttribute.blue)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.blue));
      result = result.copyWith(color: textColor);
    }

    if (style.contains(NotusAttribute.purple)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.purple));
      result = result.copyWith(color: textColor);
    }

    if (style.contains(NotusAttribute.white)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.white));
      result = result.copyWith(color: textColor);
    }

    if (style.contains(NotusAttribute.pink)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.pink));
      result = result.copyWith(color: textColor);
    }

    if (style.contains(NotusAttribute.magnolia)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.magnolia));
      result = result.copyWith(color: textColor);
    }

    if (style.contains(NotusAttribute.cream)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.cream));
      result = result.copyWith(color: textColor);
    }

    if (style.contains(NotusAttribute.mint)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.mint));
      result = result.copyWith(color: textColor);
    }

    if (style.contains(NotusAttribute.eggshell)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.eggshell));
      result = result.copyWith(color: textColor);
    }

    if (style.contains(NotusAttribute.mauve)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.mauve));
      result = result.copyWith(color: textColor);
    }

    if (style.contains(NotusAttribute.lightGrey)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.lightGrey));
      result = result.copyWith(color: textColor);
    }

    if (style.contains(NotusAttribute.rosy)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.rosy));
      result = result.copyWith(color: textColor);
    }

    if (style.contains(NotusAttribute.amber)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.amber));
      result = result.copyWith(color: textColor);
    }

    if (style.contains(NotusAttribute.canary)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.canary));
      result = result.copyWith(color: textColor);
    }

    if (style.contains(NotusAttribute.regent)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.regent));
      result = result.copyWith(color: textColor);
    }

    if (style.contains(NotusAttribute.euston)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.euston));
      result = result.copyWith(color: textColor);
    }

    if (style.contains(NotusAttribute.premier)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.premier));
      result = result.copyWith(color: textColor);
    }

    if (style.contains(NotusAttribute.midGrey)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.midGrey));
      result = result.copyWith(color: textColor);
    }

    if (style.contains(NotusAttribute.maroon)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.maroon));
      result = result.copyWith(color: textColor);
    }

    if (style.contains(NotusAttribute.mustard)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.mustard));
      result = result.copyWith(color: textColor);
    }

    if (style.contains(NotusAttribute.sick)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.sick));
      result = result.copyWith(color: textColor);
    }

    if (style.contains(NotusAttribute.snooker)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.snooker));
      result = result.copyWith(color: textColor);
    }

    if (style.contains(NotusAttribute.everton)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.everton));
      result = result.copyWith(color: textColor);
    }

    if (style.contains(NotusAttribute.lenny)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.lenny));
      result = result.copyWith(color: textColor);
    }

    if (style.contains(NotusAttribute.charcoal)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.charcoal));
      result = result.copyWith(color: textColor);
    }

    if (style.contains(NotusAttribute.budget)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.budget));
      result = result.copyWith(color: textColor);
    }

    if (style.contains(NotusAttribute.brown)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.brown));
      result = result.copyWith(color: textColor);
    }

    if (style.contains(NotusAttribute.bean)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.bean));
      result = result.copyWith(color: textColor);
    }

    if (style.contains(NotusAttribute.aftereight)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.aftereight));
      result = result.copyWith(color: textColor);
    }

    if (style.contains(NotusAttribute.ocean)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.ocean));
      result = result.copyWith(color: textColor);
    }

    if (style.contains(NotusAttribute.bruise)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.bruise));
      result = result.copyWith(color: textColor);
    }

    //Background Colors
    if (style.contains(NotusAttribute.bcblack)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.bcblack));
      result = result.copyWith(backgroundColor: textColor);
    }

    if (style.contains(NotusAttribute.bcred)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.bcred));
      result = result.copyWith(backgroundColor: textColor);
    }

    if (style.contains(NotusAttribute.bcorange)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.bcorange));
      result = result.copyWith(backgroundColor: textColor);
    }

    if (style.contains(NotusAttribute.bcyellow)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.bcyellow));
      result = result.copyWith(backgroundColor: textColor);
    }

    if (style.contains(NotusAttribute.bcgreen)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.bcgreen));
      result = result.copyWith(backgroundColor: textColor);
    }

    if (style.contains(NotusAttribute.bcblue)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.bcblue));
      result = result.copyWith(backgroundColor: textColor);
    }

    if (style.contains(NotusAttribute.bcpurple)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.bcpurple));
      result = result.copyWith(backgroundColor: textColor);
    }

    if (style.contains(NotusAttribute.bcwhite)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.bcwhite));
      result = result.copyWith(backgroundColor: textColor);
    }

    if (style.contains(NotusAttribute.bcpink)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.bcpink));
      result = result.copyWith(backgroundColor: textColor);
    }

    if (style.contains(NotusAttribute.bcmagnolia)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.bcmagnolia));
      result = result.copyWith(backgroundColor: textColor);
    }

    if (style.contains(NotusAttribute.bccream)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.bccream));
      result = result.copyWith(backgroundColor: textColor);
    }

    if (style.contains(NotusAttribute.bcmint)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.bcmint));
      result = result.copyWith(backgroundColor: textColor);
    }

    if (style.contains(NotusAttribute.bceggshell)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.bceggshell));
      result = result.copyWith(backgroundColor: textColor);
    }

    if (style.contains(NotusAttribute.bcmauve)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.bcmauve));
      result = result.copyWith(backgroundColor: textColor);
    }

    if (style.contains(NotusAttribute.bclightGrey)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.bclightGrey));
      result = result.copyWith(backgroundColor: textColor);
    }

    if (style.contains(NotusAttribute.bcrosy)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.bcrosy));
      result = result.copyWith(backgroundColor: textColor);
    }

    if (style.contains(NotusAttribute.bcamber)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.bcamber));
      result = result.copyWith(backgroundColor: textColor);
    }

    if (style.contains(NotusAttribute.bccanary)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.bccanary));
      result = result.copyWith(backgroundColor: textColor);
    }

    if (style.contains(NotusAttribute.bcregent)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.bcregent));
      result = result.copyWith(backgroundColor: textColor);
    }

    if (style.contains(NotusAttribute.bceuston)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.bceuston));
      result = result.copyWith(backgroundColor: textColor);
    }

    if (style.contains(NotusAttribute.bcpremier)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.bcpremier));
      result = result.copyWith(backgroundColor: textColor);
    }

    if (style.contains(NotusAttribute.bcmidGrey)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.bcmidGrey));
      result = result.copyWith(backgroundColor: textColor);
    }

    if (style.contains(NotusAttribute.bcmaroon)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.bcmaroon));
      result = result.copyWith(backgroundColor: textColor);
    }

    if (style.contains(NotusAttribute.bcmustard)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.bcmustard));
      result = result.copyWith(backgroundColor: textColor);
    }

    if (style.contains(NotusAttribute.bcsick)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.bcsick));
      result = result.copyWith(backgroundColor: textColor);
    }

    if (style.contains(NotusAttribute.bcsnooker)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.bcsnooker));
      result = result.copyWith(backgroundColor: textColor);
    }

    if (style.contains(NotusAttribute.bceverton)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.bceverton));
      result = result.copyWith(backgroundColor: textColor);
    }

    if (style.contains(NotusAttribute.bclenny)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.bclenny));
      result = result.copyWith(backgroundColor: textColor);
    }

    if (style.contains(NotusAttribute.bccharcoal)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.bccharcoal));
      result = result.copyWith(backgroundColor: textColor);
    }

    if (style.contains(NotusAttribute.bcbudget)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.bcbudget));
      result = result.copyWith(backgroundColor: textColor);
    }

    if (style.contains(NotusAttribute.bcbrown)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.bcbrown));
      result = result.copyWith(backgroundColor: textColor);
    }

    if (style.contains(NotusAttribute.bcbean)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.bcbean));
      result = result.copyWith(backgroundColor: textColor);
    }

    if (style.contains(NotusAttribute.bcaftereight)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.bcaftereight));
      result = result.copyWith(backgroundColor: textColor);
    }

    if (style.contains(NotusAttribute.bcocean)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.bcocean));
      result = result.copyWith(backgroundColor: textColor);
    }

    if (style.contains(NotusAttribute.bcbruise)) {
      final textColor =
          rgbStringToColor(style.value<String>(NotusAttribute.bcbruise));
      result = result.copyWith(backgroundColor: textColor);
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
