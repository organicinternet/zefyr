// Copyright (c) 2018, the Zefyr project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:notus/notus.dart';

import 'common.dart';
import 'theme.dart';

/// Represents regular paragraph line in a Zefyr editor.
class ZefyrParagraph extends StatelessWidget {
  ZefyrParagraph({
    Key key,
    @required this.node,
    this.blockStyle,
  }) : super(key: key);

  final LineNode node;
  final TextStyle blockStyle;

  @override
  Widget build(BuildContext context) {
    final theme = ZefyrTheme.of(context);
    TextAlign textAlign = TextAlign.left;
    var style = theme.defaultLineTheme.textStyle;
    if (blockStyle != null) {
      style = style.merge(blockStyle);
    }
    if (node.style.contains(NotusAttribute.div)) {
      var padding = theme.defaultLineTheme.padding;

      if (node.style.get(NotusAttribute.div) ==
          NotusAttribute.div.lightHeading1) {
        style = style
            .merge(theme.attributeTheme.screedStyleLightHeading1.textStyle);
        padding = theme.attributeTheme.screedStyleLightHeading1.padding;
      }
      if (node.style.get(NotusAttribute.div) ==
          NotusAttribute.div.lightHeading2) {
        style = style
            .merge(theme.attributeTheme.screedStyleLightHeading2.textStyle);
        padding = theme.attributeTheme.screedStyleLightHeading2.padding;
      }
      if (node.style.get(NotusAttribute.div) ==
          NotusAttribute.div.lightHeading3) {
        style = style
            .merge(theme.attributeTheme.screedStyleLightHeading3.textStyle);
        padding = theme.attributeTheme.screedStyleLightHeading3.padding;
      }
      if (node.style.get(NotusAttribute.div) == NotusAttribute.div.body1) {
        style = style.merge(theme.attributeTheme.screedStyleBody1.textStyle);
        padding = theme.attributeTheme.screedStyleBody1.padding;
      }
      if (node.style.get(NotusAttribute.div) == NotusAttribute.div.body2) {
        style = style.merge(theme.attributeTheme.screedStyleBody2.textStyle);
        padding = theme.attributeTheme.screedStyleBody2.padding;
      }
      if (node.style.get(NotusAttribute.div) == NotusAttribute.div.body3) {
        style = style.merge(theme.attributeTheme.screedStyleBody3.textStyle);
        padding = theme.attributeTheme.screedStyleBody3.padding;
      }
      if (node.style.get(NotusAttribute.div) == NotusAttribute.div.body4) {
        style = style.merge(theme.attributeTheme.screedStyleBody4.textStyle);
        padding = theme.attributeTheme.screedStyleBody4.padding;
      }
      if (node.style.get(NotusAttribute.div) == NotusAttribute.div.listed) {
        style = style.merge(theme.attributeTheme.screedStyleListed.textStyle);
        padding = theme.attributeTheme.screedStyleListed.padding;
      }
      if (node.style.get(NotusAttribute.alignment) ==
          NotusAttribute.alignment.center) {
        textAlign = TextAlign.center;
      }
      if (node.style.get(NotusAttribute.alignment) ==
          NotusAttribute.alignment.right) {
        textAlign = TextAlign.right;
      }
      if (node.style.get(NotusAttribute.alignment) ==
          NotusAttribute.alignment.justify) {
        textAlign = TextAlign.justify;
      }
      return ZefyrLine(
        node: node,
        style: style,
        padding: padding,
      );
    } else if (node.style.contains(NotusAttribute.bq)) {
      style = style.merge(theme.attributeTheme.quote.textStyle);
      return ZefyrLine(
        node: node,
        style: style,
        padding: EdgeInsets.zero,
      );
    } else {
      return ZefyrLine(
        node: node,
        style: style.merge(theme.attributeTheme.screedStyleBody2.textStyle),
        padding: theme.attributeTheme.screedStyleBody2.padding,
      );
    }
  }
}

/// Represents heading-styled line in [ZefyrEditor].
class ZefyrHeading extends StatelessWidget {
  ZefyrHeading({Key key, @required this.node, this.blockStyle})
      : assert(node.style.contains(NotusAttribute.heading)),
        super(key: key);

  final LineNode node;
  final TextStyle blockStyle;

  @override
  Widget build(BuildContext context) {
    final theme = themeOf(node, context);
    var style = theme.textStyle;
    if (blockStyle != null) {
      style = style.merge(blockStyle);
    }
    return ZefyrLine(
      node: node,
      style: style,
      padding: theme.padding,
    );
  }

  static LineTheme themeOf(LineNode node, BuildContext context) {
    final theme = ZefyrTheme.of(context);
    final style = node.style.get(NotusAttribute.heading);
    if (style == NotusAttribute.heading.level1) {
      return theme.attributeTheme.heading1;
    } else if (style == NotusAttribute.heading.level2) {
      return theme.attributeTheme.heading2;
    } else if (style == NotusAttribute.heading.level3) {
      return theme.attributeTheme.heading3;
    }
    throw UnimplementedError('Unsupported heading style $style');
  }
}
