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

  colorPink,
  colorNeonPink,
  colorMaroonRed,
  colorCherryRed,
  colorCoralRed,
  colorMahogany,
  colorOrange,
  colorYellow,
  colorNeonYellow,
  colorForestGreen,
  colorAppleGreen,
  colorTeaGreen,
  colorNeonGreen,
  colorTealGreen,
  colorLightBlue,
  colorOceanBlue,
  colorLilBlue,
  colorNavyBlue,
  colorPlum,
  colorNeonPurple,
  colorSuedePurple,
  colorOrchidPurple,

  backgroundColor,

  backgroundColorPink,
  backgroundColorNeonPink,
  backgroundColorMaroonRed,
  backgroundColorCherryRed,
  backgroundColorCoralRed,
  backgroundColorMahogany,
  backgroundColorOrange,
  backgroundColorYellow,
  backgroundColorNeonYellow,
  backgroundColorForestGreen,
  backgroundColorAppleGreen,
  backgroundColorTeaGreen,
  backgroundColorNeonGreen,
  backgroundColorTealGreen,
  backgroundColorLightBlue,
  backgroundColorOceanBlue,
  backgroundColorLilBlue,
  backgroundColorNavyBlue,
  backgroundColorPlum,
  backgroundColorNeonPurple,
  backgroundColorSuedePurple,
  backgroundColorOrchidPurple,

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
  ZefyrToolbarAction.colorPink: NotusAttribute.color.pink,
  ZefyrToolbarAction.colorNeonPink: NotusAttribute.color.neonPink,
  ZefyrToolbarAction.colorMaroonRed: NotusAttribute.color.maroonRed,
  ZefyrToolbarAction.colorCherryRed: NotusAttribute.color.cherryRed,
  ZefyrToolbarAction.colorCoralRed: NotusAttribute.color.coralRed,
  ZefyrToolbarAction.colorMahogany: NotusAttribute.color.mahogany,
  ZefyrToolbarAction.colorOrange: NotusAttribute.color.orange,
  ZefyrToolbarAction.colorYellow: NotusAttribute.color.yellow,
  ZefyrToolbarAction.colorNeonYellow: NotusAttribute.color.neonYellow,
  ZefyrToolbarAction.colorForestGreen: NotusAttribute.color.forestGreen,
  ZefyrToolbarAction.colorAppleGreen: NotusAttribute.color.appleGreen,
  ZefyrToolbarAction.colorTeaGreen: NotusAttribute.color.teaGreen,
  ZefyrToolbarAction.colorNeonGreen: NotusAttribute.color.neonGreen,
  ZefyrToolbarAction.colorTealGreen: NotusAttribute.color.tealGreen,
  ZefyrToolbarAction.colorLightBlue: NotusAttribute.color.lightBlue,
  ZefyrToolbarAction.colorOceanBlue: NotusAttribute.color.oceanBlue,
  ZefyrToolbarAction.colorLilBlue: NotusAttribute.color.lilBlue,
  ZefyrToolbarAction.colorNavyBlue: NotusAttribute.color.navyBlue,
  ZefyrToolbarAction.colorPlum: NotusAttribute.color.plum,
  ZefyrToolbarAction.colorNeonPurple: NotusAttribute.color.neonPurple,
  ZefyrToolbarAction.colorSuedePurple: NotusAttribute.color.suedePurple,
  ZefyrToolbarAction.colorOrchidPurple: NotusAttribute.color.orchidPurple,
  ZefyrToolbarAction.backgroundColor: NotusAttribute.backgroundColor,
  ZefyrToolbarAction.backgroundColorPink: NotusAttribute.backgroundColor.pink,
  ZefyrToolbarAction.backgroundColorNeonPink:
      NotusAttribute.backgroundColor.neonPink,
  ZefyrToolbarAction.backgroundColorMaroonRed:
      NotusAttribute.backgroundColor.maroonRed,
  ZefyrToolbarAction.backgroundColorCherryRed:
      NotusAttribute.backgroundColor.cherryRed,
  ZefyrToolbarAction.backgroundColorCoralRed:
      NotusAttribute.backgroundColor.coralRed,
  ZefyrToolbarAction.backgroundColorMahogany:
      NotusAttribute.backgroundColor.mahogany,
  ZefyrToolbarAction.backgroundColorOrange:
      NotusAttribute.backgroundColor.orange,
  ZefyrToolbarAction.backgroundColorYellow:
      NotusAttribute.backgroundColor.yellow,
  ZefyrToolbarAction.backgroundColorNeonYellow:
      NotusAttribute.backgroundColor.neonYellow,
  ZefyrToolbarAction.backgroundColorForestGreen:
      NotusAttribute.backgroundColor.forestGreen,
  ZefyrToolbarAction.backgroundColorAppleGreen:
      NotusAttribute.backgroundColor.appleGreen,
  ZefyrToolbarAction.backgroundColorTeaGreen:
      NotusAttribute.backgroundColor.teaGreen,
  ZefyrToolbarAction.backgroundColorNeonGreen:
      NotusAttribute.backgroundColor.neonGreen,
  ZefyrToolbarAction.backgroundColorTealGreen:
      NotusAttribute.backgroundColor.tealGreen,
  ZefyrToolbarAction.backgroundColorLightBlue:
      NotusAttribute.backgroundColor.lightBlue,
  ZefyrToolbarAction.backgroundColorOceanBlue:
      NotusAttribute.backgroundColor.oceanBlue,
  ZefyrToolbarAction.backgroundColorLilBlue:
      NotusAttribute.backgroundColor.lilBlue,
  ZefyrToolbarAction.backgroundColorNavyBlue:
      NotusAttribute.backgroundColor.navyBlue,
  ZefyrToolbarAction.backgroundColorPlum: NotusAttribute.backgroundColor.plum,
  ZefyrToolbarAction.backgroundColorNeonPurple:
      NotusAttribute.backgroundColor.neonPurple,
  ZefyrToolbarAction.backgroundColorSuedePurple:
      NotusAttribute.backgroundColor.suedePurple,
  ZefyrToolbarAction.backgroundColorOrchidPurple:
      NotusAttribute.backgroundColor.orchidPurple,
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
      ModeColorButton(1),
      BackgroundColorButton(),
      LinkButton(),
      HeadingButton(),
      FontQlButton(),
      ScreedStyleButton(),
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
    ZefyrToolbarAction.colorPink: Color(0xFFffbcbc),
    ZefyrToolbarAction.colorNeonPink: Color(0xFFff3796),
    ZefyrToolbarAction.colorMaroonRed: Color(0xFF751011),
    ZefyrToolbarAction.colorCherryRed: Color(0xFFe43f5a),
    ZefyrToolbarAction.colorCoralRed: Color(0xFFf47c7c),
    ZefyrToolbarAction.colorMahogany: Color(0xFFB64003),
    ZefyrToolbarAction.colorOrange: Color(0xFFFE8C03),
    ZefyrToolbarAction.colorYellow: Color(0xFFf7f48b),
    ZefyrToolbarAction.colorNeonYellow: Color(0xFFfdff38),
    ZefyrToolbarAction.colorForestGreen: Color(0xFF004a18),
    ZefyrToolbarAction.colorAppleGreen: Color(0xFFa1de93),
    ZefyrToolbarAction.colorTeaGreen: Color(0xFFacecd5),
    ZefyrToolbarAction.colorNeonGreen: Color(0xFF00faac),
    ZefyrToolbarAction.colorTealGreen: Color(0xFF048481),
    ZefyrToolbarAction.colorLightBlue: Color(0xFFbeebe9),
    ZefyrToolbarAction.colorOceanBlue: Color(0xFF2ECFFF),
    ZefyrToolbarAction.colorLilBlue: Color(0xFF70a1d7),
    ZefyrToolbarAction.colorNavyBlue: Color(0xFF162447),
    ZefyrToolbarAction.colorPlum: Color(0xFFd7aefc),
    ZefyrToolbarAction.colorNeonPurple: Color(0xFFdc2ade),
    ZefyrToolbarAction.colorSuedePurple: Color(0xFF834c69),
    ZefyrToolbarAction.colorOrchidPurple: Color(0xFF543864),
    ZefyrToolbarAction.backgroundColorPink: Color(0xFFffbcbc),
    ZefyrToolbarAction.backgroundColorNeonPink: Color(0xFFff3796),
    ZefyrToolbarAction.backgroundColorMaroonRed: Color(0xFF751011),
    ZefyrToolbarAction.backgroundColorCherryRed: Color(0xFFe43f5a),
    ZefyrToolbarAction.backgroundColorCoralRed: Color(0xFFf47c7c),
    ZefyrToolbarAction.backgroundColorMahogany: Color(0xFFB64003),
    ZefyrToolbarAction.backgroundColorOrange: Color(0xFFFE8C03),
    ZefyrToolbarAction.backgroundColorYellow: Color(0xFFf7f48b),
    ZefyrToolbarAction.backgroundColorNeonYellow: Color(0xFFfdff38),
    ZefyrToolbarAction.backgroundColorForestGreen: Color(0xFF004a18),
    ZefyrToolbarAction.backgroundColorAppleGreen: Color(0xFFa1de93),
    ZefyrToolbarAction.backgroundColorTeaGreen: Color(0xFFacecd5),
    ZefyrToolbarAction.backgroundColorNeonGreen: Color(0xFF00faac),
    ZefyrToolbarAction.backgroundColorTealGreen: Color(0xFF048481),
    ZefyrToolbarAction.backgroundColorLightBlue: Color(0xFFbeebe9),
    ZefyrToolbarAction.backgroundColorOceanBlue: Color(0xFF2ECFFF),
    ZefyrToolbarAction.backgroundColorLilBlue: Color(0xFF70a1d7),
    ZefyrToolbarAction.backgroundColorNavyBlue: Color(0xFF162447),
    ZefyrToolbarAction.backgroundColorPlum: Color(0xFFd7aefc),
    ZefyrToolbarAction.backgroundColorNeonPurple: Color(0xFFdc2ade),
    ZefyrToolbarAction.backgroundColorSuedePurple: Color(0xFF834c69),
    ZefyrToolbarAction.backgroundColorOrchidPurple: Color(0xFF543864),
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
