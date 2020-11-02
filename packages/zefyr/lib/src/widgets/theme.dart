import 'package:flutter/material.dart';

/// Applies a Zefyr editor theme to descendant widgets.
///
/// Describes colors and typographic styles.
///
/// Descendant widgets obtain the current theme's [ZefyrThemeData] object using
/// [ZefyrTheme.of].
class ZefyrTheme extends InheritedWidget {
  final ZefyrThemeData data;

  /// Applies the given theme [data] to [child].
  ///
  /// The [data] and [child] arguments must not be null.
  ZefyrTheme({
    Key key,
    @required this.data,
    @required Widget child,
  })  : assert(data != null),
        assert(child != null),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(ZefyrTheme oldWidget) {
    return data != oldWidget.data;
  }

  /// The data from the closest [ZefyrTheme] instance that encloses the given
  /// context.
  ///
  /// Returns `null` if there is no [ZefyrTheme] in the given build context
  /// and [nullOk] is set to `true`. If [nullOk] is set to `false` (default)
  /// then this method asserts.
  static ZefyrThemeData of(BuildContext context, {bool nullOk = false}) {
    final widget = context.dependOnInheritedWidgetOfExactType<ZefyrTheme>();
    if (widget == null && nullOk) return null;
    assert(widget != null,
        '$ZefyrTheme.of() called with a context that does not contain a ZefyrEditor.');
    return widget.data;
  }
}

/// Holds colors and typography values for a Zefyr design theme.
///
/// To obtain the current theme, use [ZefyrTheme.of].
@immutable
class ZefyrThemeData {
  /// Default theme used for document lines in Zefyr editor.
  ///
  /// Defines text style and spacing for regular paragraphs of text with
  /// no style attributes applied.
  final LineTheme defaultLineTheme;

  /// The text styles, padding and decorations used to render text with
  /// different style attributes.
  final AttributeTheme attributeTheme;

  /// The width of indentation used for blocks (lists, quotes, code).
  final double indentWidth;

  /// The colors used to render editor toolbar.
  final ToolbarTheme toolbarTheme;

  /// Creates a [ZefyrThemeData] given a set of exact values.
  const ZefyrThemeData({
    this.defaultLineTheme,
    this.attributeTheme,
    this.indentWidth,
    this.toolbarTheme,
  });

  /// The default editor theme.
  factory ZefyrThemeData.fallback(BuildContext context) {
    final defaultStyle = DefaultTextStyle.of(context);
    final defaultLineTheme = LineTheme(
      textStyle: defaultStyle.style.copyWith(
        fontSize: 16.0,
        height: 1.3,
      ),
      padding: EdgeInsets.symmetric(vertical: 8.0),
    );
    return ZefyrThemeData(
      defaultLineTheme: defaultLineTheme,
      attributeTheme: AttributeTheme.fallback(context, defaultLineTheme),
      indentWidth: 16.0,
      toolbarTheme: ToolbarTheme.fallback(context),
    );
  }

  /// Creates a copy of this theme but with the given fields replaced with
  /// the new values.
  ZefyrThemeData copyWith({
    LineTheme defaultLineTheme,
    AttributeTheme attributeTheme,
    double indentWidth,
    ToolbarTheme toolbarTheme,
  }) {
    return ZefyrThemeData(
      defaultLineTheme: defaultLineTheme ?? this.defaultLineTheme,
      attributeTheme: attributeTheme ?? this.attributeTheme,
      indentWidth: indentWidth ?? this.indentWidth,
      toolbarTheme: toolbarTheme ?? this.toolbarTheme,
    );
  }

  /// Creates a new [ZefyrThemeData] where each property from this object has
  /// been merged with the matching text style from the `other` object.
  ZefyrThemeData merge(ZefyrThemeData other) {
    if (other == null) return this;
    return copyWith(
      defaultLineTheme: defaultLineTheme?.merge(other.defaultLineTheme) ??
          other.defaultLineTheme,
      attributeTheme:
          attributeTheme?.merge(other.attributeTheme) ?? other.attributeTheme,
      indentWidth: other.indentWidth ?? indentWidth,
      toolbarTheme:
          toolbarTheme?.merge(other.toolbarTheme) ?? other.toolbarTheme,
    );
  }

  @override
  bool operator ==(other) {
    if (other.runtimeType != runtimeType) return false;
    final ZefyrThemeData otherData = other;
    return (otherData.defaultLineTheme == defaultLineTheme) &&
        (otherData.attributeTheme == attributeTheme) &&
        (otherData.indentWidth == indentWidth) &&
        (otherData.toolbarTheme == toolbarTheme);
  }

  @override
  int get hashCode {
    return hashList([
      defaultLineTheme,
      attributeTheme,
      indentWidth,
      toolbarTheme,
    ]);
  }
}

/// Holds typography values for a document line in Zefyr editor.
///
/// Applicable for regular paragraphs, headings and lines within blocks
/// (lists, quotes). Blocks may override some of these values using [BlockTheme].
@immutable
class LineTheme {
  /// Default text style for a document line.
  final TextStyle textStyle;

  /// Additional space around a document line.
  final EdgeInsets padding;

  /// Creates a [LineTheme] given a set of exact values.
  LineTheme({@required this.textStyle, @required this.padding})
      : assert(textStyle != null),
        assert(padding != null);

  /// Creates a copy of this theme but with the given fields replaced with
  /// the new values.
  LineTheme copyWith({TextStyle textStyle, EdgeInsets padding}) {
    return LineTheme(
      textStyle: textStyle ?? this.textStyle,
      padding: padding ?? this.padding,
    );
  }

  /// Creates a new [LineTheme] where each property from this object has
  /// been merged with the matching property from the `other` object.
  ///
  /// Text style is merged using [TextStyle.merge] when this and other
  /// theme have this value set.
  ///
  /// If padding property is set in other then it replaces value of this
  /// theme.
  LineTheme merge(LineTheme other) {
    if (other == null) return this;
    return copyWith(
      textStyle: textStyle?.merge(other.textStyle) ?? other.textStyle,
      padding: other.padding ?? padding,
    );
  }

  @override
  bool operator ==(other) {
    if (other.runtimeType != runtimeType) return false;
    final LineTheme otherTheme = other;
    return (otherTheme.textStyle == textStyle) &&
        (otherTheme.padding == padding);
  }

  @override
  int get hashCode => hashValues(textStyle, padding);
}

/// Holds typography values for a block of lines in Zefyr editor.
@immutable
class BlockTheme {
  /// Default text style for all text within a block, can be null.
  ///
  /// Takes precedence over line-level text style set by [LineTheme] if
  /// [inheritLineTextStyle] is set to `false`. Otherwise this text style
  /// is merged with the line's style.
  final TextStyle textStyle;

  /// Whether [textStyle] specified by this block theme should be merged with
  /// text style of each individual line.
  ///
  /// Only applicable if [textStyle] is not null.
  ///
  /// If set to `true` then [textStyle] is merged with text style specified
  /// by [LineTheme] of each line within a block. Otherwise [textStyle]
  /// takes precedence and replaces style of [LineTheme].
  final bool inheritLineTextStyle;

  /// Space around the block.
  final EdgeInsets padding;

  /// Space around each individual line within a block, can be null.
  ///
  /// Takes precedence over line padding set in [LineTheme].
  final EdgeInsets linePadding;

  /// Creates a [BlockTheme] given a set of exact values.
  const BlockTheme({
    this.textStyle,
    this.inheritLineTextStyle = true,
    this.padding,
    this.linePadding,
  });

  /// Creates a copy of this theme but with the given fields replaced with
  /// the new values.
  BlockTheme copyWith({
    TextStyle textStyle,
    EdgeInsets padding,
    bool inheritLineTextStyle,
    EdgeInsets linePadding,
  }) {
    return BlockTheme(
      textStyle: textStyle ?? this.textStyle,
      inheritLineTextStyle: inheritLineTextStyle ?? this.inheritLineTextStyle,
      padding: padding ?? this.padding,
      linePadding: linePadding ?? this.linePadding,
    );
  }

  /// Creates a new [BlockTheme] where each property from this object has
  /// been merged with the matching property from the `other` object.
  ///
  /// Text style is merged using [TextStyle.merge] when this and other
  /// theme have this field set.
  ///
  /// If padding property is set in other then it replaces value of this
  /// theme. [linePadding] follows the same logic.
  BlockTheme merge(BlockTheme other) {
    if (other == null) return this;
    return copyWith(
      textStyle: textStyle?.merge(other.textStyle) ?? other.textStyle,
      inheritLineTextStyle: other.inheritLineTextStyle ?? inheritLineTextStyle,
      padding: other.padding ?? padding,
      linePadding: other.linePadding ?? linePadding,
    );
  }

  @override
  bool operator ==(other) {
    if (other.runtimeType != runtimeType) return false;
    final BlockTheme otherTheme = other;
    return (otherTheme.textStyle == textStyle) &&
        (otherTheme.inheritLineTextStyle == inheritLineTextStyle) &&
        (otherTheme.padding == padding) &&
        (otherTheme.linePadding == linePadding);
  }

  @override
  int get hashCode =>
      hashValues(textStyle, inheritLineTextStyle, padding, linePadding);
}

/// Holds style information for all format attributes supported by Zefyr editor.
@immutable
class AttributeTheme {
  /// Style used to render "bold" text.
  final TextStyle bold;

  /// Style used to render "italic" text.
  final TextStyle italic;

  /// Style used to render "underline" text.
  final TextStyle underline;

  /// Style used to render text containing links.
  final TextStyle link;

  final TextStyle fontQl1;
  final TextStyle fontQl2;
  final TextStyle fontQl3;
  final TextStyle fontQl4;
  final TextStyle fontQl5;
  final TextStyle fontQl6;
  final TextStyle fontQl7;
  final TextStyle fontQl8;
  final TextStyle fontQl9;
  final TextStyle fontQl10;

  final LineTheme screedStyleLightHeading1;
  final LineTheme screedStyleLightHeading2;
  final LineTheme screedStyleLightHeading3;

  final LineTheme screedStyleBody1;
  final LineTheme screedStyleBody2;
  final LineTheme screedStyleBody3;
  final LineTheme screedStyleBody4;

  final LineTheme screedStyleListed;

  /// Style theme used to render largest headings.
  final LineTheme heading1;

  /// Style theme used to render medium headings.
  final LineTheme heading2;

  /// Style theme used to render smaller headings.
  final LineTheme heading3;

  /// Style theme used to render bullet lists.
  final BlockTheme bulletList;

  /// Style theme used to render number lists.
  final BlockTheme numberList;

  /// Style theme used to render quote blocks.
  final BlockTheme quote;

  /// Style theme used to render code blocks.
  final BlockTheme code;

  /// Creates a [AttributeTheme] given a set of exact values.
  AttributeTheme({
    this.bold,
    this.italic,
    this.underline,
    this.link,
    this.heading1,
    this.heading2,
    this.heading3,
    this.bulletList,
    this.numberList,
    this.quote,
    this.code,
    this.fontQl1,
    this.fontQl2,
    this.fontQl3,
    this.fontQl4,
    this.fontQl5,
    this.fontQl6,
    this.fontQl7,
    this.fontQl8,
    this.fontQl9,
    this.fontQl10,
    this.screedStyleLightHeading1,
    this.screedStyleLightHeading2,
    this.screedStyleLightHeading3,
    this.screedStyleBody1,
    this.screedStyleBody2,
    this.screedStyleBody3,
    this.screedStyleBody4,
    this.screedStyleListed,
  });

  /// The default attribute theme.
  factory AttributeTheme.fallback(
      BuildContext context, LineTheme defaultLineTheme) {
    final theme = Theme.of(context);

    String monospaceFontFamily;
    switch (theme.platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        monospaceFontFamily = 'Menlo';
        break;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        monospaceFontFamily = 'Roboto Mono';
        break;
      default:
        throw UnimplementedError('Platform ${theme.platform} not implemented.');
    }

    return AttributeTheme(
      bold: TextStyle(fontWeight: FontWeight.bold),
      italic: TextStyle(fontStyle: FontStyle.italic),
      underline: TextStyle(decoration: TextDecoration.underline),
      link: TextStyle(
        decoration: TextDecoration.underline,
        color: theme.accentColor,
      ),
      heading1: LineTheme(
        textStyle: defaultLineTheme.textStyle.copyWith(
          fontSize: 30.0,
          height: 1.19,
          fontWeight: FontWeight.w900,
        ),
        padding: EdgeInsets.symmetric(vertical: 16.5),
      ),
      heading2: LineTheme(
        textStyle: defaultLineTheme.textStyle.copyWith(
          fontSize: 24.0,
          height: 1.19,
          fontWeight: FontWeight.w900,
        ),
        padding: EdgeInsets.symmetric(vertical: 13.2),
      ),
      heading3: LineTheme(
        textStyle: defaultLineTheme.textStyle.copyWith(
          fontSize: 18.0,
          height: 1.19,
          fontWeight: FontWeight.w900,
        ),
        padding: EdgeInsets.symmetric(vertical: 9.9),
      ),
      bulletList: BlockTheme(
        padding: EdgeInsets.fromLTRB(24, 0, 0, 16),
        linePadding: EdgeInsets.only(bottom: 8.0),
      ),
      numberList: BlockTheme(
        padding: EdgeInsets.fromLTRB(24, 0, 0, 16),
        linePadding: EdgeInsets.only(bottom: 8.0),
      ),
      quote: BlockTheme(
        padding: EdgeInsets.fromLTRB(54, 0, 0, 18),
        textStyle: TextStyle(
          color: defaultLineTheme.textStyle.color,
          fontSize: 18.0,
          fontStyle: FontStyle.italic,
        ),
        inheritLineTextStyle: true,
      ),
      code: BlockTheme(
        padding: EdgeInsets.fromLTRB(54, 0, 0, 16),
        textStyle: TextStyle(
          fontFamily: monospaceFontFamily,
          fontSize: 16.0,
          color: defaultLineTheme.textStyle.color,
          height: 1.25,
        ),
        inheritLineTextStyle: false,
        linePadding: EdgeInsets.zero,
      ),
      fontQl1: TextStyle(
        fontSize: 16.0,
        color: defaultLineTheme.textStyle.color,
      ),
      fontQl2: TextStyle(
        fontSize: 18.0,
        color: defaultLineTheme.textStyle.color,
      ),
      fontQl3: TextStyle(
        fontSize: 20.0,
        color: defaultLineTheme.textStyle.color,
      ),
      fontQl4: TextStyle(
        fontSize: 22.0,
        color: defaultLineTheme.textStyle.color,
      ),
      fontQl5: TextStyle(
        fontSize: 24.0,
        color: defaultLineTheme.textStyle.color,
      ),
      fontQl6: TextStyle(
        fontSize: 26.0,
        color: defaultLineTheme.textStyle.color,
      ),
      fontQl7: TextStyle(
        fontSize: 28.0,
        color: defaultLineTheme.textStyle.color,
      ),
      fontQl8: TextStyle(
        fontSize: 38.0,
        color: defaultLineTheme.textStyle.color,
      ),
      fontQl9: TextStyle(
        fontSize: 48.0,
        color: defaultLineTheme.textStyle.color,
      ),
      fontQl10: TextStyle(
        fontSize: 72.0,
        color: defaultLineTheme.textStyle.color,
      ),
      screedStyleLightHeading1: LineTheme(
        textStyle: defaultLineTheme.textStyle.copyWith(
          fontSize: 30.0,
          height: 1.19,
          fontWeight: FontWeight.normal,
        ),
        padding: EdgeInsets.symmetric(vertical: 16.5),
      ),
      screedStyleLightHeading2: LineTheme(
        textStyle: defaultLineTheme.textStyle.copyWith(
          fontSize: 24.0,
          height: 1.19,
          fontWeight: FontWeight.normal,
        ),
        padding: EdgeInsets.symmetric(vertical: 13.2),
      ),
      screedStyleLightHeading3: LineTheme(
        textStyle: defaultLineTheme.textStyle.copyWith(
          fontSize: 18.0,
          height: 1.19,
          fontWeight: FontWeight.normal,
        ),
        padding: EdgeInsets.symmetric(vertical: 9.9),
      ),
      screedStyleBody1: LineTheme(
        textStyle: defaultLineTheme.textStyle.copyWith(
          fontSize: 18.0,
          color: defaultLineTheme.textStyle.color,
          height: 1.24,
          fontWeight: FontWeight.normal,
        ),
        padding: EdgeInsets.only(bottom: 18.0),
      ),
      screedStyleBody2: LineTheme(
        textStyle: defaultLineTheme.textStyle.copyWith(
          fontSize: 16.0,
          color: defaultLineTheme.textStyle.color,
          height: 1.24,
          fontWeight: FontWeight.normal,
        ),
        padding: EdgeInsets.only(bottom: 16.0),
      ),
      screedStyleBody3: LineTheme(
        textStyle: defaultLineTheme.textStyle.copyWith(
          fontSize: 14.0,
          color: defaultLineTheme.textStyle.color,
          height: 1.24,
          fontWeight: FontWeight.normal,
        ),
        padding: EdgeInsets.only(bottom: 14.0),
      ),
      screedStyleBody4: LineTheme(
        textStyle: defaultLineTheme.textStyle.copyWith(
          fontSize: 12.0,
          color: defaultLineTheme.textStyle.color,
          height: 1.24,
          fontWeight: FontWeight.normal,
        ),
        padding: EdgeInsets.only(bottom: 12.0),
      ),
      screedStyleListed: LineTheme(
        textStyle: defaultLineTheme.textStyle.copyWith(
          fontSize: 16.0,
          color: defaultLineTheme.textStyle.color,
          height: 1.24,
          fontWeight: FontWeight.normal,
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }

  /// Creates a new [AttributeTheme] where each property from this object has
  /// been merged with the matching property from the `other` object.
  AttributeTheme copyWith({
    TextStyle bold,
    TextStyle italic,
    TextStyle underline,
    TextStyle link,
    LineTheme heading1,
    LineTheme heading2,
    LineTheme heading3,
    BlockTheme bulletList,
    BlockTheme numberList,
    BlockTheme quote,
    BlockTheme code,
    TextStyle fontQl1,
    TextStyle fontQl2,
    TextStyle fontQl3,
    TextStyle fontQl4,
    TextStyle fontQl5,
    TextStyle fontQl6,
    TextStyle fontQl7,
    TextStyle fontQl8,
    TextStyle fontQl9,
    TextStyle fontQl10,
    LineTheme screedStyleLightHeading1,
    LineTheme screedStyleLightHeading2,
    LineTheme screedStyleLightHeading3,
    LineTheme screedStyleBody1,
    LineTheme screedStyleBody2,
    LineTheme screedStyleBody3,
    LineTheme screedStyleBody4,
    LineTheme screedStyleListed,
  }) {
    return AttributeTheme(
      bold: bold ?? this.bold,
      italic: italic ?? this.italic,
      underline: underline ?? this.underline,
      link: link ?? this.link,
      heading1: heading1 ?? this.heading1,
      heading2: heading2 ?? this.heading2,
      heading3: heading3 ?? this.heading3,
      bulletList: bulletList ?? this.bulletList,
      numberList: numberList ?? this.numberList,
      quote: quote ?? this.quote,
      code: code ?? this.code,
      fontQl1: fontQl1 ?? this.fontQl1,
      fontQl2: fontQl2 ?? this.fontQl2,
      fontQl3: fontQl3 ?? this.fontQl3,
      fontQl4: fontQl4 ?? this.fontQl4,
      fontQl5: fontQl5 ?? this.fontQl5,
      fontQl6: fontQl6 ?? this.fontQl6,
      fontQl7: fontQl7 ?? this.fontQl7,
      fontQl8: fontQl8 ?? this.fontQl8,
      fontQl9: fontQl9 ?? this.fontQl9,
      fontQl10: fontQl10 ?? this.fontQl10,
      screedStyleLightHeading1:
          screedStyleLightHeading1 ?? this.screedStyleLightHeading1,
      screedStyleLightHeading2:
          screedStyleLightHeading2 ?? this.screedStyleLightHeading2,
      screedStyleLightHeading3:
          screedStyleLightHeading3 ?? this.screedStyleLightHeading3,
      screedStyleBody1: screedStyleBody1 ?? this.screedStyleBody1,
      screedStyleBody2: screedStyleBody2 ?? this.screedStyleBody2,
      screedStyleBody3: screedStyleBody3 ?? this.screedStyleBody3,
      screedStyleBody4: screedStyleBody4 ?? this.screedStyleBody4,
      screedStyleListed: screedStyleListed ?? this.screedStyleListed,
    );
  }

  /// Creates a new [AttributeTheme] where each property from this object has
  /// been merged with the matching property from the `other` object.
  AttributeTheme merge(AttributeTheme other) {
    if (other == null) return this;
    return copyWith(
      bold: bold?.merge(other.bold) ?? other.bold,
      italic: italic?.merge(other.italic) ?? other.italic,
      underline: underline?.merge(other.underline) ?? other.underline,
      link: link?.merge(other.link) ?? other.link,
      heading1: heading1?.merge(other.heading1) ?? other.heading1,
      heading2: heading2?.merge(other.heading2) ?? other.heading2,
      heading3: heading3?.merge(other.heading3) ?? other.heading3,
      bulletList: bulletList?.merge(other.bulletList) ?? other.bulletList,
      numberList: numberList?.merge(other.numberList) ?? other.numberList,
      quote: quote?.merge(other.quote) ?? other.quote,
      code: code?.merge(other.code) ?? other.code,
      fontQl1: fontQl1?.merge(other.fontQl1) ?? other.fontQl1,
      fontQl2: fontQl2?.merge(other.fontQl2) ?? other.fontQl2,
      fontQl3: fontQl3?.merge(other.fontQl3) ?? other.fontQl3,
      fontQl4: fontQl4?.merge(other.fontQl4) ?? other.fontQl4,
      fontQl5: fontQl5?.merge(other.fontQl5) ?? other.fontQl5,
      fontQl6: fontQl6?.merge(other.fontQl6) ?? other.fontQl6,
      fontQl7: fontQl7?.merge(other.fontQl7) ?? other.fontQl7,
      fontQl8: fontQl8?.merge(other.fontQl8) ?? other.fontQl8,
      fontQl9: fontQl9?.merge(other.fontQl9) ?? other.fontQl9,
      fontQl10: fontQl10?.merge(other.fontQl10) ?? other.fontQl10,
      screedStyleLightHeading1:
          screedStyleLightHeading1?.merge(other.screedStyleLightHeading1) ??
              other.screedStyleLightHeading1,
      screedStyleLightHeading2:
          screedStyleLightHeading2?.merge(other.screedStyleLightHeading2) ??
              other.screedStyleLightHeading2,
      screedStyleLightHeading3:
          screedStyleLightHeading3?.merge(other.screedStyleLightHeading3) ??
              other.screedStyleLightHeading3,
      screedStyleBody1: screedStyleBody1?.merge(other.screedStyleBody1) ??
          other.screedStyleBody1,
      screedStyleBody2: screedStyleBody2?.merge(other.screedStyleBody2) ??
          other.screedStyleBody2,
      screedStyleBody3: screedStyleBody3?.merge(other.screedStyleBody3) ??
          other.screedStyleBody3,
      screedStyleBody4: screedStyleBody4?.merge(other.screedStyleBody4) ??
          other.screedStyleBody4,
      screedStyleListed: screedStyleListed?.merge(other.screedStyleListed) ??
          other.screedStyleListed,
    );
  }

  @override
  bool operator ==(other) {
    if (other.runtimeType != runtimeType) return false;
    final AttributeTheme otherTheme = other;
    return (otherTheme.bold == bold) &&
        (otherTheme.italic == italic) &&
        (otherTheme.underline == underline) &&
        (otherTheme.link == link) &&
        (otherTheme.heading1 == heading1) &&
        (otherTheme.heading2 == heading2) &&
        (otherTheme.heading3 == heading3) &&
        (otherTheme.bulletList == bulletList) &&
        (otherTheme.numberList == numberList) &&
        (otherTheme.quote == quote) &&
        (otherTheme.code == code) &&
        (otherTheme.fontQl1 == fontQl1) &&
        (otherTheme.fontQl2 == fontQl2) &&
        (otherTheme.fontQl3 == fontQl3) &&
        (otherTheme.fontQl4 == fontQl4) &&
        (otherTheme.fontQl5 == fontQl5) &&
        (otherTheme.fontQl6 == fontQl6) &&
        (otherTheme.fontQl7 == fontQl7) &&
        (otherTheme.fontQl8 == fontQl8) &&
        (otherTheme.fontQl9 == fontQl9) &&
        (otherTheme.fontQl10 == fontQl10) &&
        (otherTheme.screedStyleLightHeading1 == screedStyleLightHeading1) &&
        (otherTheme.screedStyleLightHeading2 == screedStyleLightHeading2) &&
        (otherTheme.screedStyleLightHeading3 == screedStyleLightHeading3) &&
        (otherTheme.screedStyleBody1 == screedStyleBody1) &&
        (otherTheme.screedStyleBody2 == screedStyleBody2) &&
        (otherTheme.screedStyleBody3 == screedStyleBody3) &&
        (otherTheme.screedStyleBody4 == screedStyleBody4) &&
        (otherTheme.screedStyleListed == screedStyleListed);
  }

  @override
  int get hashCode {
    return hashList([
      bold,
      italic,
      link,
      heading1,
      heading2,
      heading3,
      bulletList,
      numberList,
      quote,
      code,
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
      screedStyleLightHeading1,
      screedStyleLightHeading2,
      screedStyleLightHeading3,
      screedStyleBody1,
      screedStyleBody2,
      screedStyleBody3,
      screedStyleBody4,
      screedStyleListed,
    ]);
  }
}

/// Defines styles and colors for Zefyr editor toolbar.
class ToolbarTheme {
  /// The background color of the toolbar.
  final Color color;

  /// Color of buttons in toggled state.
  final Color toggleColor;

  /// Color of button icons.
  final Color iconColor;

  /// Color of button icons in disabled state.
  final Color disabledIconColor;

  /// Creates default theme for editor toolbar.
  factory ToolbarTheme.fallback(BuildContext context) {
    final theme = Theme.of(context);
    return ToolbarTheme._(
      color: theme.primaryColorBrightness == Brightness.light
          ? Colors.grey.shade300
          : Colors.grey.shade800,
      toggleColor: theme.primaryColorBrightness == Brightness.light
          ? Colors.grey.shade400
          : Colors.grey.shade900,
      iconColor: theme.primaryIconTheme.color,
      disabledIconColor: theme.disabledColor,
    );
  }

  ToolbarTheme._({
    @required this.color,
    @required this.toggleColor,
    @required this.iconColor,
    @required this.disabledIconColor,
  });

  /// Creates a new [ToolbarTheme] where each property from this object has
  /// been merged with the matching property from the `other` object.
  ToolbarTheme copyWith({
    Color color,
    Color toggleColor,
    Color iconColor,
    Color disabledIconColor,
  }) {
    return ToolbarTheme._(
      color: color ?? this.color,
      toggleColor: toggleColor ?? this.toggleColor,
      iconColor: iconColor ?? this.iconColor,
      disabledIconColor: disabledIconColor ?? this.disabledIconColor,
    );
  }

  /// Creates a new [ToolbarTheme] where each property from this object has
  /// been merged with the matching property from the `other` object.
  ToolbarTheme merge(ToolbarTheme other) {
    if (other == null) return this;
    return copyWith(
      color: other.color ?? color,
      toggleColor: other.toggleColor ?? toggleColor,
      iconColor: other.iconColor ?? iconColor,
      disabledIconColor: other.disabledIconColor ?? disabledIconColor,
    );
  }

  @override
  bool operator ==(other) {
    if (other.runtimeType != runtimeType) return false;
    final ToolbarTheme otherTheme = other;
    return (otherTheme.color == color) &&
        (otherTheme.toggleColor == toggleColor) &&
        (otherTheme.iconColor == iconColor) &&
        (otherTheme.disabledIconColor == disabledIconColor);
  }

  @override
  int get hashCode =>
      hashValues(color, toggleColor, iconColor, disabledIconColor);
}
