// Copyright (c) 2018, the Zefyr project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:notus/notus.dart';

import 'buttons.dart';
import 'scope.dart';
import 'theme.dart';

/// List of all button actions supported by [ZefyrToolbar] buttons.
enum ZefyrToolbarAction {
  bold,
  italic,
  underline,
  strikethrough,
  link,
  unlink,
  clipboardCopy,
  openInBrowser,
  heading,
  headingLevel1,
  headingLevel2,
  headingLevel3,
  bulletList,
  numberList,
  code,
  quote,
  horizontalRule,
  image,
  cameraImage,
  galleryImage,
  hideKeyboard,
  close,
  confirm,

  fontQl,
  fontQl1,
  fontQl2,
  fontQl3,
  fontQl4,
  fontQl5,
  fontQl6,
  fontQl7,
  fontQl8,
  fontQl9,
  fontQl10,

  screedStyle,
  screedStyleHeading1,
  screedStyleHeading2,
  screedStyleHeading3,
  screedStyleLightHeading1,
  screedStyleLightHeading2,
  screedStyleLightHeading3,
  screedStyleBody1,
  screedStyleBody2,
  screedStyleBody3,
  screedStyleBody4,
  screedStyleListed,

  color,
  lightMode,
  darkMode,

  color_black,
  color_red,
  color_orange,
  color_yellow,
  color_green,
  color_blue,
  color_purple,
  color_white,
  color_pink,
  color_magnolia,
  color_cream,
  color_mint,
  color_eggshell,
  color_mauve,
  color_lightGrey,
  color_rosy,
  color_amber,
  color_canary,
  color_regent,
  color_euston,
  color_premier,
  color_midGrey,
  color_maroon,
  color_mustard,
  color_sick,
  color_snooker,
  color_everton,
  color_lenny,
  color_charcoal,
  color_budget,
  color_brown,
  color_bean,
  color_aftereight,
  color_ocean,
  color_bruise,

  backgroundColor,

  background_color_black,
  background_color_red,
  background_color_orange,
  background_color_yellow,
  background_color_green,
  background_color_blue,
  background_color_purple,
  background_color_white,
  background_color_pink,
  background_color_magnolia,
  background_color_cream,
  background_color_mint,
  background_color_eggshell,
  background_color_mauve,
  background_color_lightGrey,
  background_color_rosy,
  background_color_amber,
  background_color_canary,
  background_color_regent,
  background_color_euston,
  background_color_premier,
  background_color_midGrey,
  background_color_maroon,
  background_color_mustard,
  background_color_sick,
  background_color_snooker,
  background_color_everton,
  background_color_lenny,
  background_color_charcoal,
  background_color_budget,
  background_color_brown,
  background_color_bean,
  background_color_aftereight,
  background_color_ocean,
  background_color_bruise,

  textAlign,
  textAlignLeft,
  textAlignCenter,
  textAlignRight,
  textAlignJustify,
}

final kZefyrToolbarAttributeActions = <ZefyrToolbarAction, NotusAttributeKey>{
  ZefyrToolbarAction.bold: NotusAttribute.bold,
  ZefyrToolbarAction.italic: NotusAttribute.italic,
  ZefyrToolbarAction.underline: NotusAttribute.underline,
  ZefyrToolbarAction.strikethrough: NotusAttribute.strikethrough,
  ZefyrToolbarAction.link: NotusAttribute.link,
  ZefyrToolbarAction.heading: NotusAttribute.heading,
  ZefyrToolbarAction.headingLevel1: NotusAttribute.heading.level1,
  ZefyrToolbarAction.headingLevel2: NotusAttribute.heading.level2,
  ZefyrToolbarAction.headingLevel3: NotusAttribute.heading.level3,
  ZefyrToolbarAction.bulletList: NotusAttribute.block.bulletList,
  ZefyrToolbarAction.numberList: NotusAttribute.block.numberList,
  ZefyrToolbarAction.code: NotusAttribute.block.code,
  ZefyrToolbarAction.quote: NotusAttribute.block.quote,
  ZefyrToolbarAction.horizontalRule: NotusAttribute.embed.horizontalRule,
  ZefyrToolbarAction.fontQl: NotusAttribute.span,
  ZefyrToolbarAction.fontQl1: NotusAttribute.span.fontQl1,
  ZefyrToolbarAction.fontQl2: NotusAttribute.span.fontQl2,
  ZefyrToolbarAction.fontQl3: NotusAttribute.span.fontQl3,
  ZefyrToolbarAction.fontQl4: NotusAttribute.span.fontQl4,
  ZefyrToolbarAction.fontQl5: NotusAttribute.span.fontQl5,
  ZefyrToolbarAction.fontQl6: NotusAttribute.span.fontQl6,
  ZefyrToolbarAction.fontQl7: NotusAttribute.span.fontQl7,
  ZefyrToolbarAction.fontQl8: NotusAttribute.span.fontQl8,
  ZefyrToolbarAction.fontQl9: NotusAttribute.span.fontQl9,
  ZefyrToolbarAction.fontQl10: NotusAttribute.span.fontQl10,
  ZefyrToolbarAction.screedStyle: NotusAttribute.p,
  ZefyrToolbarAction.screedStyleLightHeading1: NotusAttribute.heading.light1,
  ZefyrToolbarAction.screedStyleLightHeading2: NotusAttribute.heading.light2,
  ZefyrToolbarAction.screedStyleLightHeading3: NotusAttribute.heading.light3,
  ZefyrToolbarAction.screedStyleBody1: NotusAttribute.p.body1,
  ZefyrToolbarAction.screedStyleBody2: NotusAttribute.p.body2,
  ZefyrToolbarAction.screedStyleBody3: NotusAttribute.p.body3,
  ZefyrToolbarAction.screedStyleBody4: NotusAttribute.p.body4,
  ZefyrToolbarAction.screedStyleListed: NotusAttribute.p.listed,
  ZefyrToolbarAction.color: NotusAttribute.color,
  ZefyrToolbarAction.color_black: NotusAttribute.color.black,
  ZefyrToolbarAction.color_red: NotusAttribute.color.red,
  ZefyrToolbarAction.color_orange: NotusAttribute.color.orange,
  ZefyrToolbarAction.color_yellow: NotusAttribute.color.yellow,
  ZefyrToolbarAction.color_green: NotusAttribute.color.green,
  ZefyrToolbarAction.color_blue: NotusAttribute.color.blue,
  ZefyrToolbarAction.color_purple: NotusAttribute.color.purple,
  ZefyrToolbarAction.color_white: NotusAttribute.color.white,
  ZefyrToolbarAction.color_pink: NotusAttribute.color.pink,
  ZefyrToolbarAction.color_magnolia: NotusAttribute.color.magnolia,
  ZefyrToolbarAction.color_cream: NotusAttribute.color.cream,
  ZefyrToolbarAction.color_mint: NotusAttribute.color.mint,
  ZefyrToolbarAction.color_eggshell: NotusAttribute.color.eggshell,
  ZefyrToolbarAction.color_mauve: NotusAttribute.color.mauve,
  ZefyrToolbarAction.color_lightGrey: NotusAttribute.color.lightGrey,
  ZefyrToolbarAction.color_rosy: NotusAttribute.color.rosy,
  ZefyrToolbarAction.color_amber: NotusAttribute.color.amber,
  ZefyrToolbarAction.color_canary: NotusAttribute.color.canary,
  ZefyrToolbarAction.color_regent: NotusAttribute.color.regent,
  ZefyrToolbarAction.color_euston: NotusAttribute.color.euston,
  ZefyrToolbarAction.color_premier: NotusAttribute.color.premier,
  ZefyrToolbarAction.color_midGrey: NotusAttribute.color.midGrey,
  ZefyrToolbarAction.color_maroon: NotusAttribute.color.maroon,
  ZefyrToolbarAction.color_mustard: NotusAttribute.color.mustard,
  ZefyrToolbarAction.color_sick: NotusAttribute.color.sick,
  ZefyrToolbarAction.color_snooker: NotusAttribute.color.snooker,
  ZefyrToolbarAction.color_everton: NotusAttribute.color.everton,
  ZefyrToolbarAction.color_lenny: NotusAttribute.color.lenny,
  ZefyrToolbarAction.color_charcoal: NotusAttribute.color.charcoal,
  ZefyrToolbarAction.color_budget: NotusAttribute.color.budget,
  ZefyrToolbarAction.color_brown: NotusAttribute.color.brown,
  ZefyrToolbarAction.color_bean: NotusAttribute.color.bean,
  ZefyrToolbarAction.color_aftereight: NotusAttribute.color.aftereight,
  ZefyrToolbarAction.color_ocean: NotusAttribute.color.ocean,
  ZefyrToolbarAction.color_bruise: NotusAttribute.color.bruise,
  ZefyrToolbarAction.background_color_black:
      NotusAttribute.backgroundColor.black,
  ZefyrToolbarAction.background_color_red: NotusAttribute.backgroundColor.red,
  ZefyrToolbarAction.background_color_orange:
      NotusAttribute.backgroundColor.orange,
  ZefyrToolbarAction.background_color_yellow:
      NotusAttribute.backgroundColor.yellow,
  ZefyrToolbarAction.background_color_green:
      NotusAttribute.backgroundColor.green,
  ZefyrToolbarAction.background_color_blue: NotusAttribute.backgroundColor.blue,
  ZefyrToolbarAction.background_color_purple:
      NotusAttribute.backgroundColor.purple,
  ZefyrToolbarAction.background_color_white:
      NotusAttribute.backgroundColor.white,
  ZefyrToolbarAction.background_color_pink: NotusAttribute.backgroundColor.pink,
  ZefyrToolbarAction.background_color_magnolia:
      NotusAttribute.backgroundColor.magnolia,
  ZefyrToolbarAction.background_color_cream:
      NotusAttribute.backgroundColor.cream,
  ZefyrToolbarAction.background_color_mint: NotusAttribute.backgroundColor.mint,
  ZefyrToolbarAction.background_color_eggshell:
      NotusAttribute.backgroundColor.eggshell,
  ZefyrToolbarAction.background_color_mauve:
      NotusAttribute.backgroundColor.mauve,
  ZefyrToolbarAction.background_color_lightGrey:
      NotusAttribute.backgroundColor.lightGrey,
  ZefyrToolbarAction.background_color_rosy: NotusAttribute.backgroundColor.rosy,
  ZefyrToolbarAction.background_color_amber:
      NotusAttribute.backgroundColor.amber,
  ZefyrToolbarAction.background_color_canary:
      NotusAttribute.backgroundColor.canary,
  ZefyrToolbarAction.background_color_regent:
      NotusAttribute.backgroundColor.regent,
  ZefyrToolbarAction.background_color_euston:
      NotusAttribute.backgroundColor.euston,
  ZefyrToolbarAction.background_color_premier:
      NotusAttribute.backgroundColor.premier,
  ZefyrToolbarAction.background_color_midGrey:
      NotusAttribute.backgroundColor.midGrey,
  ZefyrToolbarAction.background_color_maroon:
      NotusAttribute.backgroundColor.maroon,
  ZefyrToolbarAction.background_color_mustard:
      NotusAttribute.backgroundColor.mustard,
  ZefyrToolbarAction.background_color_sick: NotusAttribute.backgroundColor.sick,
  ZefyrToolbarAction.background_color_snooker:
      NotusAttribute.backgroundColor.snooker,
  ZefyrToolbarAction.background_color_everton:
      NotusAttribute.backgroundColor.everton,
  ZefyrToolbarAction.background_color_lenny:
      NotusAttribute.backgroundColor.lenny,
  ZefyrToolbarAction.background_color_charcoal:
      NotusAttribute.backgroundColor.charcoal,
  ZefyrToolbarAction.background_color_budget:
      NotusAttribute.backgroundColor.budget,
  ZefyrToolbarAction.background_color_brown:
      NotusAttribute.backgroundColor.brown,
  ZefyrToolbarAction.background_color_bean: NotusAttribute.backgroundColor.bean,
  ZefyrToolbarAction.background_color_aftereight:
      NotusAttribute.backgroundColor.aftereight,
  ZefyrToolbarAction.background_color_ocean:
      NotusAttribute.backgroundColor.ocean,
  ZefyrToolbarAction.background_color_bruise:
      NotusAttribute.backgroundColor.bruise,
  ZefyrToolbarAction.textAlign: NotusAttribute.alignment,
  ZefyrToolbarAction.textAlignLeft: NotusAttribute.leftAlignment,
  ZefyrToolbarAction.textAlignCenter: NotusAttribute.centerAlignment,
  ZefyrToolbarAction.textAlignRight: NotusAttribute.rightAlignment,
  ZefyrToolbarAction.textAlignJustify: NotusAttribute.justifyAlignment,
};

/// Allows customizing appearance of [ZefyrToolbar].
abstract class ZefyrToolbarDelegate {
  /// Builds toolbar button for specified [action].
  ///
  /// Returned widget is usually an instance of [ZefyrButton].
  Widget buildButton(BuildContext context, ZefyrToolbarAction action,
      {VoidCallback onPressed});
}

/// Scaffold for [ZefyrToolbar].
class ZefyrToolbarScaffold extends StatelessWidget {
  const ZefyrToolbarScaffold({
    Key key,
    @required this.body,
    this.trailing,
    this.autoImplyTrailing = true,
  }) : super(key: key);

  final Widget body;
  final Widget trailing;
  final bool autoImplyTrailing;

  @override
  Widget build(BuildContext context) {
    final theme = ZefyrTheme.of(context).toolbarTheme;
    final toolbar = ZefyrToolbar.of(context);
    final constraints =
        BoxConstraints.tightFor(height: ZefyrToolbar.kToolbarHeight);
    final children = <Widget>[
      Expanded(child: body),
    ];

    if (trailing != null) {
      children.add(trailing);
    } else if (autoImplyTrailing) {
      children.add(toolbar.buildButton(context, ZefyrToolbarAction.close));
    }
    return Container(
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: theme.iconColor))),
      constraints: constraints,
      child: Material(color: theme.color, child: Row(children: children)),
    );
  }
}

/// Toolbar for [ZefyrEditor].
class ZefyrToolbar extends StatefulWidget implements PreferredSizeWidget {
  static const kToolbarHeight = 50.0;

  const ZefyrToolbar({
    Key key,
    @required this.editor,
    this.autoHide = true,
    this.delegate,
  }) : super(key: key);

  final ZefyrToolbarDelegate delegate;
  final ZefyrScope editor;

  /// Whether to automatically hide this toolbar when editor loses focus.
  final bool autoHide;

  static ZefyrToolbarState of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<_ZefyrToolbarScope>();
    return scope?.toolbar;
  }

  @override
  ZefyrToolbarState createState() => ZefyrToolbarState();

  @override
  ui.Size get preferredSize => Size.fromHeight(ZefyrToolbar.kToolbarHeight);
}

class _ZefyrToolbarScope extends InheritedWidget {
  _ZefyrToolbarScope({Key key, @required Widget child, @required this.toolbar})
      : super(key: key, child: child);

  final ZefyrToolbarState toolbar;

  @override
  bool updateShouldNotify(_ZefyrToolbarScope oldWidget) {
    return toolbar != oldWidget.toolbar;
  }
}

class ZefyrToolbarState extends State<ZefyrToolbar>
    with SingleTickerProviderStateMixin {
  final Key _toolbarKey = UniqueKey();
  final Key _overlayKey = UniqueKey();

  ZefyrToolbarDelegate _delegate;
  AnimationController _overlayAnimation;
  WidgetBuilder _overlayBuilder;
  Completer<void> _overlayCompleter;

  TextSelection _selection;

  void markNeedsRebuild() {
    setState(() {
      if (_selection != editor.selection) {
        _selection = editor.selection;
        closeOverlay();
      }
    });
  }

  Widget buildButton(BuildContext context, ZefyrToolbarAction action,
      {VoidCallback onPressed}) {
    return _delegate.buildButton(context, action, onPressed: onPressed);
  }

  Future<void> showOverlay(WidgetBuilder builder) async {
    assert(_overlayBuilder == null);
    final completer = Completer<void>();
    setState(() {
      _overlayBuilder = builder;
      _overlayCompleter = completer;
      _overlayAnimation.forward();
    });
    return completer.future;
  }

  void closeOverlay() {
    if (!hasOverlay) return;
    _overlayAnimation.reverse().whenComplete(() {
      setState(() {
        _overlayBuilder = null;
        _overlayCompleter?.complete();
        _overlayCompleter = null;
      });
    });
  }

  bool get hasOverlay => _overlayBuilder != null;

  ZefyrScope get editor => widget.editor;

  @override
  void initState() {
    super.initState();
    _delegate = widget.delegate ?? _DefaultZefyrToolbarDelegate();
    _overlayAnimation =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    _selection = editor.selection;
  }

  @override
  void didUpdateWidget(ZefyrToolbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.delegate != oldWidget.delegate) {
      _delegate = widget.delegate ?? _DefaultZefyrToolbarDelegate();
    }
  }

  @override
  void dispose() {
    _overlayAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final layers = <Widget>[];

    // Must set unique key for the toolbar to prevent it from reconstructing
    // new state each time we toggle overlay.
    final toolbar = ZefyrToolbarScaffold(
      key: _toolbarKey,
      body: ZefyrButtonList(buttons: _buildButtons(context)),
      trailing: buildButton(context, ZefyrToolbarAction.hideKeyboard),
    );

    layers.add(toolbar);

    if (hasOverlay) {
      Widget widget = Builder(builder: _overlayBuilder);
      assert(widget != null);
      final overlay = FadeTransition(
        key: _overlayKey,
        opacity: _overlayAnimation,
        child: widget,
      );
      layers.add(overlay);
    }

    final constraints =
        BoxConstraints.tightFor(height: ZefyrToolbar.kToolbarHeight);
    return _ZefyrToolbarScope(
      toolbar: this,
      child: Container(
        constraints: constraints,
        child: Stack(children: layers),
      ),
    );
  }

  List<Widget> _buildButtons(BuildContext context) {
    final buttons = <Widget>[
      buildButton(context, ZefyrToolbarAction.bold),
      buildButton(context, ZefyrToolbarAction.italic),
      buildButton(context, ZefyrToolbarAction.underline),
      buildButton(context, ZefyrToolbarAction.strikethrough),
      ScreedStyleButton(),
      ModeColorButton(1),
      BackgroundColorButton(),
      LinkButton(),
      HeadingButton(),
      FontQlButton(),
      TextAlignmentButton(),
      buildButton(context, ZefyrToolbarAction.bulletList),
      buildButton(context, ZefyrToolbarAction.numberList),
      buildButton(context, ZefyrToolbarAction.quote),
      buildButton(context, ZefyrToolbarAction.code),
      buildButton(context, ZefyrToolbarAction.horizontalRule),
      if (editor.imageDelegate != null) ImageButton(),
    ];
    return buttons;
  }
}

/// Scrollable list of toolbar buttons.
class ZefyrButtonList extends StatefulWidget {
  const ZefyrButtonList({Key key, @required this.buttons}) : super(key: key);
  final List<Widget> buttons;

  @override
  _ZefyrButtonListState createState() => _ZefyrButtonListState();
}

class _ZefyrButtonListState extends State<ZefyrButtonList> {
  final ScrollController _controller = ScrollController();
  bool _showLeftArrow = false;
  bool _showRightArrow = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleScroll);
    // Workaround to allow scroll controller attach to our ListView so that
    // we can detect if overflow arrows need to be shown on init.
    // TODO: find a better way to detect overflow
    Timer.run(_handleScroll);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ZefyrTheme.of(context).toolbarTheme;
    final color = theme.iconColor;
    final list = ListView(
      scrollDirection: Axis.horizontal,
      controller: _controller,
      children: widget.buttons,
      physics: ClampingScrollPhysics(),
    );

    final leftArrow = _showLeftArrow
        ? Icon(Icons.arrow_left, size: 18.0, color: color)
        : null;
    final rightArrow = _showRightArrow
        ? Icon(Icons.arrow_right, size: 18.0, color: color)
        : null;
    return Row(
      children: <Widget>[
        SizedBox(
          width: 12.0,
          height: ZefyrToolbar.kToolbarHeight,
          child: Container(child: leftArrow, color: theme.color),
        ),
        Expanded(child: ClipRect(child: list)),
        SizedBox(
          width: 12.0,
          height: ZefyrToolbar.kToolbarHeight,
          child: Container(child: rightArrow, color: theme.color),
        ),
      ],
    );
  }

  void _handleScroll() {
    setState(() {
      _showLeftArrow =
          _controller.position.minScrollExtent != _controller.position.pixels;
      _showRightArrow =
          _controller.position.maxScrollExtent != _controller.position.pixels;
    });
  }
}

class _DefaultZefyrToolbarDelegate implements ZefyrToolbarDelegate {
  static const kDefaultButtonIcons = {
    ZefyrToolbarAction.bold: Icons.format_bold,
    ZefyrToolbarAction.italic: Icons.format_italic,
    ZefyrToolbarAction.underline: Icons.format_underlined,
    ZefyrToolbarAction.strikethrough: Icons.format_strikethrough,
    ZefyrToolbarAction.link: Icons.link,
    ZefyrToolbarAction.unlink: Icons.link_off,
    ZefyrToolbarAction.clipboardCopy: Icons.content_copy,
    ZefyrToolbarAction.openInBrowser: Icons.open_in_new,
    ZefyrToolbarAction.heading: Icons.format_size,
    ZefyrToolbarAction.bulletList: Icons.format_list_bulleted,
    ZefyrToolbarAction.numberList: Icons.format_list_numbered,
    ZefyrToolbarAction.code: Icons.code,
    ZefyrToolbarAction.quote: Icons.format_quote,
    ZefyrToolbarAction.horizontalRule: Icons.remove,
    ZefyrToolbarAction.image: Icons.photo,
    ZefyrToolbarAction.cameraImage: Icons.photo_camera,
    ZefyrToolbarAction.galleryImage: Icons.photo_library,
    ZefyrToolbarAction.hideKeyboard: Icons.keyboard_hide,
    ZefyrToolbarAction.close: Icons.close,
    ZefyrToolbarAction.confirm: Icons.check,
    ZefyrToolbarAction.fontQl: Icons.format_size,
    ZefyrToolbarAction.screedStyle: Icons.text_format,
    ZefyrToolbarAction.color: Icons.color_lens,
    ZefyrToolbarAction.darkMode: Icons.brightness_2,
    ZefyrToolbarAction.lightMode: Icons.format_color_text,
    ZefyrToolbarAction.backgroundColor: Icons.format_color_fill,
    ZefyrToolbarAction.textAlign: Icons.format_align_left,
    ZefyrToolbarAction.textAlignLeft: Icons.format_align_left,
    ZefyrToolbarAction.textAlignCenter: Icons.format_align_center,
    ZefyrToolbarAction.textAlignRight: Icons.format_align_right,
    ZefyrToolbarAction.textAlignJustify: Icons.format_align_justify,
  };

  static const kSpecialIconSizes = {
    ZefyrToolbarAction.unlink: 20.0,
    ZefyrToolbarAction.clipboardCopy: 20.0,
    ZefyrToolbarAction.openInBrowser: 20.0,
    ZefyrToolbarAction.close: 20.0,
    ZefyrToolbarAction.confirm: 20.0,
  };

  static const kDefaultButtonTexts = {
    ZefyrToolbarAction.headingLevel1: 'H1',
    ZefyrToolbarAction.headingLevel2: 'H2',
    ZefyrToolbarAction.headingLevel3: 'H3',
    ZefyrToolbarAction.screedStyleLightHeading1: 'Light H1',
    ZefyrToolbarAction.screedStyleLightHeading2: 'Light H2',
    ZefyrToolbarAction.screedStyleLightHeading3: 'Light H3',
    ZefyrToolbarAction.screedStyleBody1: 'Body 1',
    ZefyrToolbarAction.screedStyleBody2: 'Body 2',
    ZefyrToolbarAction.screedStyleBody3: 'Body 3',
    ZefyrToolbarAction.screedStyleBody4: 'Body 4',
    ZefyrToolbarAction.screedStyleListed: 'Listed',
    ZefyrToolbarAction.fontQl1: '16px',
    ZefyrToolbarAction.fontQl2: '18px',
    ZefyrToolbarAction.fontQl3: '20px',
    ZefyrToolbarAction.fontQl4: '22px',
    ZefyrToolbarAction.fontQl5: '24px',
    ZefyrToolbarAction.fontQl6: '26px',
    ZefyrToolbarAction.fontQl7: '28px',
    ZefyrToolbarAction.fontQl8: '38px',
    ZefyrToolbarAction.fontQl9: '48px',
    ZefyrToolbarAction.fontQl10: '72px',
  };

  static const kColorCircles = {
    ZefyrToolbarAction.color_black: Color.fromARGB(255, 0, 0, 0),
    ZefyrToolbarAction.color_red: Color.fromARGB(255, 230, 0, 0),
    ZefyrToolbarAction.color_orange: Color.fromARGB(255, 255, 153, 0),
    ZefyrToolbarAction.color_yellow: Color.fromARGB(255, 255, 255, 0),
    ZefyrToolbarAction.color_green: Color.fromARGB(255, 0, 138, 0),
    ZefyrToolbarAction.color_blue: Color.fromARGB(255, 0, 102, 204),
    ZefyrToolbarAction.color_purple: Color.fromARGB(255, 153, 51, 255),
    ZefyrToolbarAction.color_white: Color.fromARGB(255, 255, 255, 255),
    ZefyrToolbarAction.color_pink: Color.fromARGB(255, 250, 204, 204),
    ZefyrToolbarAction.color_magnolia: Color.fromARGB(255, 255, 235, 204),
    ZefyrToolbarAction.color_cream: Color.fromARGB(255, 255, 255, 204),
    ZefyrToolbarAction.color_mint: Color.fromARGB(255, 204, 232, 204),
    ZefyrToolbarAction.color_eggshell: Color.fromARGB(255, 204, 224, 245),
    ZefyrToolbarAction.color_mauve: Color.fromARGB(255, 235, 214, 255),
    ZefyrToolbarAction.color_lightGrey: Color.fromARGB(255, 187, 187, 187),
    ZefyrToolbarAction.color_rosy: Color.fromARGB(255, 240, 102, 102),
    ZefyrToolbarAction.color_amber: Color.fromARGB(255, 255, 194, 102),
    ZefyrToolbarAction.color_canary: Color.fromARGB(255, 255, 255, 102),
    ZefyrToolbarAction.color_regent: Color.fromARGB(255, 102, 185, 102),
    ZefyrToolbarAction.color_euston: Color.fromARGB(255, 102, 163, 224),
    ZefyrToolbarAction.color_premier: Color.fromARGB(255, 194, 133, 255),
    ZefyrToolbarAction.color_midGrey: Color.fromARGB(255, 136, 136, 136),
    ZefyrToolbarAction.color_maroon: Color.fromARGB(255, 161, 0, 0),
    ZefyrToolbarAction.color_mustard: Color.fromARGB(255, 178, 107, 0),
    ZefyrToolbarAction.color_sick: Color.fromARGB(255, 178, 178, 0),
    ZefyrToolbarAction.color_snooker: Color.fromARGB(255, 0, 97, 0),
    ZefyrToolbarAction.color_everton: Color.fromARGB(255, 0, 71, 178),
    ZefyrToolbarAction.color_lenny: Color.fromARGB(255, 107, 36, 178),
    ZefyrToolbarAction.color_charcoal: Color.fromARGB(255, 68, 68, 68),
    ZefyrToolbarAction.color_budget: Color.fromARGB(255, 92, 0, 0),
    ZefyrToolbarAction.color_brown: Color.fromARGB(255, 102, 61, 0),
    ZefyrToolbarAction.color_bean: Color.fromARGB(255, 102, 102, 0),
    ZefyrToolbarAction.color_aftereight: Color.fromARGB(255, 0, 55, 0),
    ZefyrToolbarAction.color_ocean: Color.fromARGB(255, 0, 41, 102),
    ZefyrToolbarAction.color_bruise: Color.fromARGB(255, 61, 20, 102),
    ZefyrToolbarAction.background_color_black: Color.fromARGB(255, 0, 0, 0),
    ZefyrToolbarAction.background_color_red: Color.fromARGB(255, 230, 0, 0),
    ZefyrToolbarAction.background_color_orange:
        Color.fromARGB(255, 255, 153, 0),
    ZefyrToolbarAction.background_color_yellow:
        Color.fromARGB(255, 255, 255, 0),
    ZefyrToolbarAction.background_color_green: Color.fromARGB(255, 0, 138, 0),
    ZefyrToolbarAction.background_color_blue: Color.fromARGB(255, 0, 102, 204),
    ZefyrToolbarAction.background_color_purple:
        Color.fromARGB(255, 153, 51, 255),
    ZefyrToolbarAction.background_color_white:
        Color.fromARGB(255, 255, 255, 255),
    ZefyrToolbarAction.background_color_pink:
        Color.fromARGB(255, 250, 204, 204),
    ZefyrToolbarAction.background_color_magnolia:
        Color.fromARGB(255, 255, 235, 204),
    ZefyrToolbarAction.background_color_cream:
        Color.fromARGB(255, 255, 255, 204),
    ZefyrToolbarAction.background_color_mint:
        Color.fromARGB(255, 204, 232, 204),
    ZefyrToolbarAction.background_color_eggshell:
        Color.fromARGB(255, 204, 224, 245),
    ZefyrToolbarAction.background_color_mauve:
        Color.fromARGB(255, 235, 214, 255),
    ZefyrToolbarAction.background_color_lightGrey:
        Color.fromARGB(255, 187, 187, 187),
    ZefyrToolbarAction.background_color_rosy:
        Color.fromARGB(255, 240, 102, 102),
    ZefyrToolbarAction.background_color_amber:
        Color.fromARGB(255, 255, 194, 102),
    ZefyrToolbarAction.background_color_canary:
        Color.fromARGB(255, 255, 255, 102),
    ZefyrToolbarAction.background_color_regent:
        Color.fromARGB(255, 102, 185, 102),
    ZefyrToolbarAction.background_color_euston:
        Color.fromARGB(255, 102, 163, 224),
    ZefyrToolbarAction.background_color_premier:
        Color.fromARGB(255, 194, 133, 255),
    ZefyrToolbarAction.background_color_midGrey:
        Color.fromARGB(255, 136, 136, 136),
    ZefyrToolbarAction.background_color_maroon: Color.fromARGB(255, 161, 0, 0),
    ZefyrToolbarAction.background_color_mustard:
        Color.fromARGB(255, 178, 107, 0),
    ZefyrToolbarAction.background_color_sick: Color.fromARGB(255, 178, 178, 0),
    ZefyrToolbarAction.background_color_snooker: Color.fromARGB(255, 0, 97, 0),
    ZefyrToolbarAction.background_color_everton:
        Color.fromARGB(255, 0, 71, 178),
    ZefyrToolbarAction.background_color_lenny:
        Color.fromARGB(255, 107, 36, 178),
    ZefyrToolbarAction.background_color_charcoal:
        Color.fromARGB(255, 68, 68, 68),
    ZefyrToolbarAction.background_color_budget: Color.fromARGB(255, 92, 0, 0),
    ZefyrToolbarAction.background_color_brown: Color.fromARGB(255, 102, 61, 0),
    ZefyrToolbarAction.background_color_bean: Color.fromARGB(255, 102, 102, 0),
    ZefyrToolbarAction.background_color_aftereight:
        Color.fromARGB(255, 0, 55, 0),
    ZefyrToolbarAction.background_color_ocean: Color.fromARGB(255, 0, 41, 102),
    ZefyrToolbarAction.background_color_bruise:
        Color.fromARGB(255, 61, 20, 102),
  };
  @override
  Widget buildButton(BuildContext context, ZefyrToolbarAction action,
      {VoidCallback onPressed}) {
    final theme = Theme.of(context);
    if (kDefaultButtonIcons.containsKey(action)) {
      final icon = kDefaultButtonIcons[action];
      final size = kSpecialIconSizes[action];
      return ZefyrButton.icon(
        action: action,
        icon: icon,
        iconSize: size,
        onPressed: onPressed,
      );
    } else if (kDefaultButtonTexts.containsKey(action)) {
      final text = kDefaultButtonTexts[action];
      assert(text != null);
      final style = theme.textTheme.caption
          .copyWith(fontWeight: FontWeight.bold, fontSize: 14.0);
      return ZefyrButton.text(
        action: action,
        text: text,
        style: style,
        onPressed: onPressed,
      );
    } else if (kColorCircles.containsKey(action)) {
      final color = kColorCircles[action];
      assert(color != null);
      return ZefyrButton.widget(
        action: action,
        circle: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            )),
        onPressed: onPressed,
      );
    } else {
      return Container();
    }
  }
}
