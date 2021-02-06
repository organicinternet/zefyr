// Copyright (c) 2018, the Zefyr project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'package:collection/collection.dart';
import 'package:quiver_hashcode/hashcode.dart';

/// Scope of a style attribute, defines context in which an attribute can be
/// applied.
enum NotusAttributeScope {
  /// Inline-scoped attributes are applicable to all characters within a line.
  ///
  /// Inline attributes cannot be applied to the line itself.
  inline,

  /// Line-scoped attributes are only applicable to a line of text as a whole.
  ///
  /// Line attributes do not have any effect on any character within the line.
  line,
}

/// Interface for objects which provide access to an attribute key.
///
/// Implemented by [NotusAttribute] and [NotusAttributeBuilder].
abstract class NotusAttributeKey<T> {
  /// Unique key of this attribute.
  String get key;
}

/// Builder for style attributes.
///
/// Useful in scenarios when an attribute value is not known upfront, for
/// instance, link attribute.
///
/// See also:
///   * [LinkAttributeBuilder]
///   * [BlockAttributeBuilder]
///   * [HeadingAttributeBuilder]
abstract class NotusAttributeBuilder<T> implements NotusAttributeKey<T> {
  const NotusAttributeBuilder._(this.key, this.scope);

  @override
  final String key;
  final NotusAttributeScope scope;
  NotusAttribute<T> get unset => NotusAttribute<T>._(key, scope, null);
  NotusAttribute<T> withValue(T value) =>
      NotusAttribute<T>._(key, scope, value);
}

/// Style attribute applicable to a segment of a Notus document.
///
/// All supported attributes are available via static fields on this class.
/// Here is an example of applying styles to a document:
///
///     void makeItPretty(Notus document) {
///       // Format 5 characters at position 0 as bold
///       document.format(0, 5, NotusAttribute.bold);
///       // Similarly for italic
///       document.format(0, 5, NotusAttribute.italic);
///       // Format first line as a heading (h1)
///       // Note that there is no need to specify character range of the whole
///       // line. Simply set index position to anywhere within the line and
///       // length to 0.
///       document.format(0, 0, NotusAttribute.h1);
///     }
///
/// List of supported attributes:
///
///   * [NotusAttribute.bold]
///   * [NotusAttribute.italic]
///   * [NotusAttribute.underline]
///   * [NotusAttribute.strikethrough]
///   * [NotusAttribute.color]
///   * [NotusAttribute.backgroundColor]
///   * [NotusAttribute.span]
///   * [NotusAttribute.div]
///   * [NotusAttribute.link]
///   * [NotusAttribute.heading]
///   * [NotusAttribute.block]
class NotusAttribute<T> implements NotusAttributeBuilder<T> {
  static final Map<String, NotusAttributeBuilder> _registry = {
    NotusAttribute.bold.key: NotusAttribute.bold,
    NotusAttribute.italic.key: NotusAttribute.italic,
    NotusAttribute.underline.key: NotusAttribute.underline,
    NotusAttribute.strikethrough.key: NotusAttribute.strikethrough,
    NotusAttribute.color.key: NotusAttribute.color,
    NotusAttribute.backgroundColor.key: NotusAttribute.backgroundColor,
    NotusAttribute.alignment.key: NotusAttribute.alignment,
    NotusAttribute.span.key: NotusAttribute.span,
    NotusAttribute.div.key: NotusAttribute.div,
    NotusAttribute.link.key: NotusAttribute.link,
    NotusAttribute.heading.key: NotusAttribute.heading,
    NotusAttribute.block.key: NotusAttribute.block,
    NotusAttribute.embed.key: NotusAttribute.embed,
  };

  // Inline attributes

  /// Bold style attribute.
  static const bold = _BoldAttribute();

  /// Italic style attribute.
  static const italic = _ItalicAttribute();

  /// Underline style attribute.
  static const underline = _UnderlineAttribute();

  /// Underline style attribute.
  static const strikethrough = _StrikethroughAttribute();

  //color style attribute
  static const color = ColorAttributeBuilder._();

  //color style attribute
  static const backgroundColor = BackgroundColorAttributeBuilder._();

  /// Aliases for [NotusAttribute.color.<color_foo>].
  static NotusAttribute<String> get cPink => color.pink;
  static NotusAttribute<String> get cNeonPink => color.neonPink;
  static NotusAttribute<String> get cMaroonRed => color.maroonRed;
  static NotusAttribute<String> get cCherryRed => color.cherryRed;
  static NotusAttribute<String> get cCoralRed => color.coralRed;
  static NotusAttribute<String> get cMahogany => color.mahogany;

  static NotusAttribute<String> get cOrange => color.orange;

  static NotusAttribute<String> get cYellow => color.yellow;
  static NotusAttribute<String> get cNeonYellow => color.neonYellow;

  static NotusAttribute<String> get cForestGreen => color.forestGreen;
  static NotusAttribute<String> get cAppleGreen => color.appleGreen;
  static NotusAttribute<String> get cTeaGreen => color.teaGreen;
  static NotusAttribute<String> get cNeonGreen => color.neonGreen;
  static NotusAttribute<String> get cTealGreen => color.tealGreen;

  static NotusAttribute<String> get cLBlue => color.lightBlue;
  static NotusAttribute<String> get cOceanBlue => color.oceanBlue;
  static NotusAttribute<String> get cLilBlue => color.lilBlue;
  static NotusAttribute<String> get cNavyBlue => color.navyBlue;

  static NotusAttribute<String> get cPlum => color.plum;
  static NotusAttribute<String> get cNeonPurple => color.neonPurple;
  static NotusAttribute<String> get cSuedePurple => color.suedePurple;
  static NotusAttribute<String> get cOrchidPurple => color.orchidPurple;

  /// Aliases for [NotusAttribute.backgroundColor.<color_foo>].
  static NotusAttribute<String> get bcPink => backgroundColor.pink;
  static NotusAttribute<String> get bcNeonPink => backgroundColor.neonPink;
  static NotusAttribute<String> get bcMaroonRed => backgroundColor.maroonRed;
  static NotusAttribute<String> get bcCherryRed => backgroundColor.cherryRed;
  static NotusAttribute<String> get bcCoralRed => backgroundColor.coralRed;
  static NotusAttribute<String> get bcMahogany => backgroundColor.mahogany;

  static NotusAttribute<String> get bcOrange => backgroundColor.orange;

  static NotusAttribute<String> get bcYellow => backgroundColor.yellow;
  static NotusAttribute<String> get bcNeonYellow => backgroundColor.neonYellow;

  static NotusAttribute<String> get bcForestGreen =>
      backgroundColor.forestGreen;
  static NotusAttribute<String> get bcAppleGreen => backgroundColor.appleGreen;
  static NotusAttribute<String> get bcTeaGreen => backgroundColor.teaGreen;
  static NotusAttribute<String> get bcNeonGreen => backgroundColor.neonGreen;
  static NotusAttribute<String> get bcTealGreen => backgroundColor.tealGreen;

  static NotusAttribute<String> get bcLBlue => backgroundColor.lightBlue;
  static NotusAttribute<String> get bcOceanBlue => backgroundColor.oceanBlue;
  static NotusAttribute<String> get bcLilBlue => backgroundColor.lilBlue;
  static NotusAttribute<String> get bcNavyBlue => backgroundColor.navyBlue;

  static NotusAttribute<String> get bcPlum => backgroundColor.plum;
  static NotusAttribute<String> get bcNeonPurple => backgroundColor.neonPurple;
  static NotusAttribute<String> get bcSuedePurple =>
      backgroundColor.suedePurple;
  static NotusAttribute<String> get bcOrchidPurple =>
      backgroundColor.orchidPurple;

  /// Link style attribute.
  // ignore: const_eval_throws_exception
  static const link = LinkAttributeBuilder._();

  static const span = SpanAttributeBuilder._();
  static const div = DivAttributeBuilder._();

  // Line attributes

  /// Heading style attribute.
  // ignore: const_eval_throws_exception
  static const heading = HeadingAttributeBuilder._();

  /// Alias for [NotusAttribute.heading.level1].
  static NotusAttribute<int> get h1 => heading.level1;

  /// Alias for [NotusAttribute.heading.level2].
  static NotusAttribute<int> get h2 => heading.level2;

  /// Alias for [NotusAttribute.heading.level3].
  static NotusAttribute<int> get h3 => heading.level3;

  /// Block attribute
  // ignore: const_eval_throws_exception
  static const block = BlockAttributeBuilder._();

  /// Alias for [NotusAttribute.block.bulletList].
  static NotusAttribute<String> get ul => block.bulletList;

  /// Alias for [NotusAttribute.block.numberList].
  static NotusAttribute<String> get ol => block.numberList;

  /// Alias for [NotusAttribute.block.quote].
  static NotusAttribute<String> get bq => block.quote;

  /// Alias for [NotusAttribute.block.code].
  static NotusAttribute<String> get code => block.code;

  /// Embed style attribute.
  // ignore: const_eval_throws_exception
  static const embed = EmbedAttributeBuilder._();

  /// Alignment attribute
  static const alignment = AlignmentAttributeBuilder._();

  /// Alias for [NotusAttribute.alignment.right]
  static NotusAttribute<String> get rightAlignment => alignment.right;

  /// Alias for [NotusAttribute.alignment.left]
  static NotusAttribute<String> get leftAlignment => alignment.left;

  /// Alias for [NotusAttribute.alignment.center]
  static NotusAttribute<String> get centerAlignment => alignment.center;

  /// Alias for [NotusAttribute.alignment.justify]
  static NotusAttribute<String> get justifyAlignment => alignment.justify;

  static NotusAttribute _fromKeyValue(String key, dynamic value) {
    if (!_registry.containsKey(key)) {
      throw ArgumentError.value(
          key, 'No attribute with key "$key" registered.');
    }
    final builder = _registry[key];
    return builder.withValue(value);
  }

  const NotusAttribute._(this.key, this.scope, this.value);

  /// Unique key of this attribute.
  @override
  final String key;

  /// Scope of this attribute.
  @override
  final NotusAttributeScope scope;

  /// Value of this attribute.
  ///
  /// If value is `null` then this attribute represents a transient action
  /// of removing associated style and is never persisted in a resulting
  /// document.
  ///
  /// See also [unset], [NotusStyle.merge] and [NotusStyle.put]
  /// for details.
  final T value;

  /// Returns special "unset" version of this attribute.
  ///
  /// Unset attribute's [value] is always `null`.
  ///
  /// When composed into a rich text document, unset attributes remove
  /// associated style.
  @override
  NotusAttribute<T> get unset => NotusAttribute<T>._(key, scope, null);

  /// Returns `true` if this attribute is an unset attribute.
  bool get isUnset => value == null;

  /// Returns `true` if this is an inline-scoped attribute.
  bool get isInline => scope == NotusAttributeScope.inline;

  @override
  NotusAttribute<T> withValue(T value) =>
      NotusAttribute<T>._(key, scope, value);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! NotusAttribute<T>) return false;
    NotusAttribute<T> typedOther = other;
    return key == typedOther.key &&
        scope == typedOther.scope &&
        value == typedOther.value;
  }

  @override
  int get hashCode => hash3(key, scope, value);

  @override
  String toString() => '$key: $value';

  Map<String, dynamic> toJson() => <String, dynamic>{key: value};
}

/// Collection of style attributes.
class NotusStyle {
  NotusStyle._(this._data);

  final Map<String, NotusAttribute> _data;

  static NotusStyle fromJson(Map<String, dynamic> data) {
    if (data == null) return NotusStyle();

    final result = data.map((String key, dynamic value) {
      var attr = NotusAttribute._fromKeyValue(key, value);
      return MapEntry<String, NotusAttribute>(key, attr);
    });
    return NotusStyle._(result);
  }

  NotusStyle() : _data = <String, NotusAttribute>{};

  /// Returns `true` if this attribute set is empty.
  bool get isEmpty => _data.isEmpty;

  /// Returns `true` if this attribute set is note empty.
  bool get isNotEmpty => _data.isNotEmpty;

  /// Returns `true` if this style is not empty and contains only inline-scoped
  /// attributes and is not empty.
  bool get isInline => isNotEmpty && values.every((item) => item.isInline);

  /// Checks that this style has only one attribute, and returns that attribute.
  NotusAttribute get single => _data.values.single;

  /// Returns `true` if attribute with [key] is present in this set.
  ///
  /// Only checks for presence of specified [key] regardless of the associated
  /// value.
  ///
  /// To test if this set contains an attribute with specific value consider
  /// using [containsSame].
  bool contains(NotusAttributeKey key) => _data.containsKey(key.key);

  /// Returns `true` if this set contains attribute with the same value as
  /// [attribute].
  bool containsSame(NotusAttribute attribute) {
    assert(attribute != null);
    return get<dynamic>(attribute) == attribute;
  }

  /// Returns value of specified attribute [key] in this set.
  T value<T>(NotusAttributeKey<T> key) => get(key).value;

  /// Returns [NotusAttribute] from this set by specified [key].
  NotusAttribute<T> get<T>(NotusAttributeKey<T> key) =>
      _data[key.key] as NotusAttribute<T>;

  /// Returns collection of all attribute keys in this set.
  Iterable<String> get keys => _data.keys;

  /// Returns collection of all attributes in this set.
  Iterable<NotusAttribute> get values => _data.values;

  /// Puts [attribute] into this attribute set and returns result as a new set.
  NotusStyle put(NotusAttribute attribute) {
    final result = Map<String, NotusAttribute>.from(_data);
    result[attribute.key] = attribute;
    return NotusStyle._(result);
  }

  /// Merges this attribute set with [attribute] and returns result as a new
  /// attribute set.
  ///
  /// Performs compaction if [attribute] is an "unset" value, e.g. removes
  /// corresponding attribute from this set completely.
  ///
  /// See also [put] method which does not perform compaction and allows
  /// constructing styles with "unset" values.
  NotusStyle merge(NotusAttribute attribute) {
    final merged = Map<String, NotusAttribute>.from(_data);
    if (attribute.isUnset) {
      merged.remove(attribute.key);
    } else {
      merged[attribute.key] = attribute;
    }
    return NotusStyle._(merged);
  }

  /// Merges all attributes from [other] into this style and returns result
  /// as a new instance of [NotusStyle].
  NotusStyle mergeAll(NotusStyle other) {
    var result = NotusStyle._(_data);
    for (var value in other.values) {
      result = result.merge(value);
    }
    return result;
  }

  /// Removes [attributes] from this style and returns new instance of
  /// [NotusStyle] containing result.
  NotusStyle removeAll(Iterable<NotusAttribute> attributes) {
    final merged = Map<String, NotusAttribute>.from(_data);
    attributes.map((item) => item.key).forEach(merged.remove);
    return NotusStyle._(merged);
  }

  /// Returns JSON-serializable representation of this style.
  Map<String, dynamic> toJson() => _data.isEmpty
      ? null
      : _data.map<String, dynamic>((String _, NotusAttribute value) =>
          MapEntry<String, dynamic>(value.key, value.value));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! NotusStyle) return false;
    NotusStyle typedOther = other;
    final eq = const MapEquality<String, NotusAttribute>();
    return eq.equals(_data, typedOther._data);
  }

  @override
  int get hashCode {
    final hashes = _data.entries.map((entry) => hash2(entry.key, entry.value));
    return hashObjects(hashes);
  }

  @override
  String toString() => "{${_data.values.join(', ')}}";
}

/// Applies bold style to a text segment.
class _BoldAttribute extends NotusAttribute<bool> {
  const _BoldAttribute() : super._('b', NotusAttributeScope.inline, true);
}

/// Applies italic style to a text segment.
class _ItalicAttribute extends NotusAttribute<bool> {
  const _ItalicAttribute() : super._('i', NotusAttributeScope.inline, true);
}

/// Applies underline style to a text segment.
class _UnderlineAttribute extends NotusAttribute<bool> {
  const _UnderlineAttribute() : super._('u', NotusAttributeScope.inline, true);
}

/// Applies strikethrough style to a text segment.
class _StrikethroughAttribute extends NotusAttribute<bool> {
  const _StrikethroughAttribute()
      : super._('s', NotusAttributeScope.inline, true);
}

/// Builder for color attribute styles.
class ColorAttributeBuilder extends NotusAttributeBuilder<String> {
  static const _kColor = 'color';
  const ColorAttributeBuilder._()
      : super._(_kColor, NotusAttributeScope.inline);

  NotusAttribute<String> get pink =>
      NotusAttribute<String>._(key, scope, "ffbcbc");
  NotusAttribute<String> get neonPink =>
      NotusAttribute<String>._(key, scope, "ff3796");
  NotusAttribute<String> get maroonRed =>
      NotusAttribute<String>._(key, scope, "751011");
  NotusAttribute<String> get cherryRed =>
      NotusAttribute<String>._(key, scope, "e43f5a");
  NotusAttribute<String> get coralRed =>
      NotusAttribute<String>._(key, scope, "f47c7c");
  NotusAttribute<String> get mahogany =>
      NotusAttribute<String>._(key, scope, "B64003");

  NotusAttribute<String> get orange =>
      NotusAttribute<String>._(key, scope, "FE8C03");

  NotusAttribute<String> get yellow =>
      NotusAttribute<String>._(key, scope, "f7f48b");
  NotusAttribute<String> get neonYellow =>
      NotusAttribute<String>._(key, scope, "fdff38");

  NotusAttribute<String> get forestGreen =>
      NotusAttribute<String>._(key, scope, "004a18");
  NotusAttribute<String> get appleGreen =>
      NotusAttribute<String>._(key, scope, "a1de93");
  NotusAttribute<String> get teaGreen =>
      NotusAttribute<String>._(key, scope, "acecd5");
  NotusAttribute<String> get neonGreen =>
      NotusAttribute<String>._(key, scope, "00faac");
  NotusAttribute<String> get tealGreen =>
      NotusAttribute<String>._(key, scope, "048481");

  NotusAttribute<String> get lightBlue =>
      NotusAttribute<String>._(key, scope, "beebe9");
  NotusAttribute<String> get oceanBlue =>
      NotusAttribute<String>._(key, scope, "2ECFFF");
  NotusAttribute<String> get lilBlue =>
      NotusAttribute<String>._(key, scope, "70a1d7");
  NotusAttribute<String> get navyBlue =>
      NotusAttribute<String>._(key, scope, "162447");

  NotusAttribute<String> get plum =>
      NotusAttribute<String>._(key, scope, "d7aefc");
  NotusAttribute<String> get neonPurple =>
      NotusAttribute<String>._(key, scope, "dc2ade");
  NotusAttribute<String> get suedePurple =>
      NotusAttribute<String>._(key, scope, "834c69");
  NotusAttribute<String> get orchidPurple =>
      NotusAttribute<String>._(key, scope, "543864");
}

/// Builder for color attribute styles.
class BackgroundColorAttributeBuilder extends NotusAttributeBuilder<String> {
  static const _kColor = 'backgroundColor';
  const BackgroundColorAttributeBuilder._()
      : super._(_kColor, NotusAttributeScope.inline);

  NotusAttribute<String> get pink =>
      NotusAttribute<String>._(key, scope, "ffbcbc");
  NotusAttribute<String> get neonPink =>
      NotusAttribute<String>._(key, scope, "ff3796");
  NotusAttribute<String> get maroonRed =>
      NotusAttribute<String>._(key, scope, "751011");
  NotusAttribute<String> get cherryRed =>
      NotusAttribute<String>._(key, scope, "e43f5a");
  NotusAttribute<String> get coralRed =>
      NotusAttribute<String>._(key, scope, "f47c7c");
  NotusAttribute<String> get mahogany =>
      NotusAttribute<String>._(key, scope, "B64003");

  NotusAttribute<String> get orange =>
      NotusAttribute<String>._(key, scope, "FE8C03");

  NotusAttribute<String> get yellow =>
      NotusAttribute<String>._(key, scope, "f7f48b");
  NotusAttribute<String> get neonYellow =>
      NotusAttribute<String>._(key, scope, "fdff38");

  NotusAttribute<String> get forestGreen =>
      NotusAttribute<String>._(key, scope, "004a18");
  NotusAttribute<String> get appleGreen =>
      NotusAttribute<String>._(key, scope, "a1de93");
  NotusAttribute<String> get teaGreen =>
      NotusAttribute<String>._(key, scope, "acecd5");
  NotusAttribute<String> get neonGreen =>
      NotusAttribute<String>._(key, scope, "00faac");
  NotusAttribute<String> get tealGreen =>
      NotusAttribute<String>._(key, scope, "048481");

  NotusAttribute<String> get lightBlue =>
      NotusAttribute<String>._(key, scope, "beebe9");
  NotusAttribute<String> get oceanBlue =>
      NotusAttribute<String>._(key, scope, "2ECFFF");
  NotusAttribute<String> get lilBlue =>
      NotusAttribute<String>._(key, scope, "70a1d7");
  NotusAttribute<String> get navyBlue =>
      NotusAttribute<String>._(key, scope, "162447");

  NotusAttribute<String> get plum =>
      NotusAttribute<String>._(key, scope, "d7aefc");
  NotusAttribute<String> get neonPurple =>
      NotusAttribute<String>._(key, scope, "dc2ade");
  NotusAttribute<String> get suedePurple =>
      NotusAttribute<String>._(key, scope, "834c69");
  NotusAttribute<String> get orchidPurple =>
      NotusAttribute<String>._(key, scope, "543864");
}

/// Builder for link attribute values.
///
/// There is no need to use this class directly, consider using
/// [NotusAttribute.link] instead.
class LinkAttributeBuilder extends NotusAttributeBuilder<String> {
  static const _kLink = 'a';
  const LinkAttributeBuilder._() : super._(_kLink, NotusAttributeScope.inline);

  /// Creates a link attribute with specified link [value].
  NotusAttribute<String> fromString(String value) =>
      NotusAttribute<String>._(key, scope, value);
}

/// Builder for heading attribute styles.
///
/// There is no need to use this class directly, consider using
/// [NotusAttribute.heading] instead.
class HeadingAttributeBuilder extends NotusAttributeBuilder<int> {
  static const _kHeading = 'heading';
  const HeadingAttributeBuilder._()
      : super._(_kHeading, NotusAttributeScope.line);

  /// Level 1 heading, equivalent of `H1` in HTML.
  NotusAttribute<int> get level1 => NotusAttribute<int>._(key, scope, 1);

  /// Level 2 heading, equivalent of `H2` in HTML.
  NotusAttribute<int> get level2 => NotusAttribute<int>._(key, scope, 2);

  /// Level 3 heading, equivalent of `H3` in HTML.
  NotusAttribute<int> get level3 => NotusAttribute<int>._(key, scope, 3);
}

class SpanAttributeBuilder extends NotusAttributeBuilder<String> {
  static const _kSpan = 'span';
  const SpanAttributeBuilder._() : super._(_kSpan, NotusAttributeScope.inline);

  NotusAttribute<String> get fontQl1 =>
      NotusAttribute<String>._(key, scope, "ql-font-1");
  NotusAttribute<String> get fontQl2 =>
      NotusAttribute<String>._(key, scope, "ql-font-2");
  NotusAttribute<String> get fontQl3 =>
      NotusAttribute<String>._(key, scope, "ql-font-3");
  NotusAttribute<String> get fontQl4 =>
      NotusAttribute<String>._(key, scope, "ql-font-4");
  NotusAttribute<String> get fontQl5 =>
      NotusAttribute<String>._(key, scope, "ql-font-5");
  NotusAttribute<String> get fontQl6 =>
      NotusAttribute<String>._(key, scope, "ql-font-6");
  NotusAttribute<String> get fontQl7 =>
      NotusAttribute<String>._(key, scope, "ql-font-7");
  NotusAttribute<String> get fontQl8 =>
      NotusAttribute<String>._(key, scope, "ql-font-8");
  NotusAttribute<String> get fontQl9 =>
      NotusAttribute<String>._(key, scope, "ql-font-9");
  NotusAttribute<String> get fontQl10 =>
      NotusAttribute<String>._(key, scope, "ql-font-10");
}

class DivAttributeBuilder extends NotusAttributeBuilder<String> {
  static const _kDiv = 'div';
  const DivAttributeBuilder._() : super._(_kDiv, NotusAttributeScope.line);

  // NotusAttribute<String> get heading1 =>
  //     NotusAttribute<String>._(key, scope, "heading-1");
  // NotusAttribute<String> get heading2 =>
  //     NotusAttribute<String>._(key, scope, "heading-2");
  // NotusAttribute<String> get heading3 =>
  //     NotusAttribute<String>._(key, scope, "heading-3");
  NotusAttribute<String> get lightHeading1 =>
      NotusAttribute<String>._(key, scope, "lightheader-one");
  NotusAttribute<String> get lightHeading2 =>
      NotusAttribute<String>._(key, scope, "lightheader-two");
  NotusAttribute<String> get lightHeading3 =>
      NotusAttribute<String>._(key, scope, "lightheader-three");
  NotusAttribute<String> get body1 =>
      NotusAttribute<String>._(key, scope, "body-one");
  NotusAttribute<String> get body2 =>
      NotusAttribute<String>._(key, scope, "body-two");
  NotusAttribute<String> get body3 =>
      NotusAttribute<String>._(key, scope, "body-three");
  NotusAttribute<String> get body4 =>
      NotusAttribute<String>._(key, scope, "body-four");
  NotusAttribute<String> get listed =>
      NotusAttribute<String>._(key, scope, "listed");
}

/// Builder for block attribute styles (number/bullet lists, code and quote).
///
/// There is no need to use this class directly, consider using
/// [NotusAttribute.block] instead.
class BlockAttributeBuilder extends NotusAttributeBuilder<String> {
  static const _kBlock = 'block';
  const BlockAttributeBuilder._() : super._(_kBlock, NotusAttributeScope.line);

  /// Formats a block of lines as a bullet list.
  NotusAttribute<String> get bulletList =>
      NotusAttribute<String>._(key, scope, 'ul');

  /// Formats a block of lines as a number list.
  NotusAttribute<String> get numberList =>
      NotusAttribute<String>._(key, scope, 'ol');

  /// Formats a block of lines as a code snippet, using monospace font.
  NotusAttribute<String> get code =>
      NotusAttribute<String>._(key, scope, 'code');

  /// Formats a block of lines as a quote.
  NotusAttribute<String> get quote =>
      NotusAttribute<String>._(key, scope, 'quote');
}

class AlignmentAttributeBuilder extends NotusAttributeBuilder<String> {
  static const _kKey = 'alignment';

  const AlignmentAttributeBuilder._()
      : super._(_kKey, NotusAttributeScope.line);

  NotusAttribute<String> get right =>
      NotusAttribute<String>._(key, scope, 'right');

  NotusAttribute<String> get left =>
      NotusAttribute<String>._(key, scope, 'left');

  NotusAttribute<String> get center =>
      NotusAttribute<String>._(key, scope, 'center');

  NotusAttribute<String> get justify =>
      NotusAttribute<String>._(key, scope, 'justify');
}

class EmbedAttributeBuilder
    extends NotusAttributeBuilder<Map<String, dynamic>> {
  const EmbedAttributeBuilder._()
      : super._(EmbedAttribute._kEmbed, NotusAttributeScope.inline);

  NotusAttribute<Map<String, dynamic>> get horizontalRule =>
      EmbedAttribute.horizontalRule();

  NotusAttribute<Map<String, dynamic>> image(String source) =>
      EmbedAttribute.image(source);

  @override
  NotusAttribute<Map<String, dynamic>> get unset => EmbedAttribute._(null);

  @override
  NotusAttribute<Map<String, dynamic>> withValue(Map<String, dynamic> value) =>
      EmbedAttribute._(value);
}

/// Type of embedded content.
enum EmbedType { horizontalRule, image }

class EmbedAttribute extends NotusAttribute<Map<String, dynamic>> {
  static const _kValueEquality = MapEquality<String, dynamic>();
  static const _kEmbed = 'embed';
  static const _kHorizontalRuleEmbed = 'hr';
  static const _kImageEmbed = 'image';

  EmbedAttribute._(Map<String, dynamic> value)
      : super._(_kEmbed, NotusAttributeScope.inline, value);

  EmbedAttribute.horizontalRule()
      : this._(<String, dynamic>{'type': _kHorizontalRuleEmbed});

  EmbedAttribute.image(String source)
      : this._(<String, dynamic>{'type': _kImageEmbed, 'source': source});

  /// Type of this embed.
  EmbedType get type {
    if (value['type'] == _kHorizontalRuleEmbed) return EmbedType.horizontalRule;
    if (value['type'] == _kImageEmbed) return EmbedType.image;
    assert(false, 'Unknown embed attribute value $value.');
    return null;
  }

  @override
  NotusAttribute<Map<String, dynamic>> get unset => EmbedAttribute._(null);

  @override
  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (other is! EmbedAttribute) return false;
    EmbedAttribute typedOther = other;
    return key == typedOther.key &&
        scope == typedOther.scope &&
        _kValueEquality.equals(value, typedOther.value);
  }

  @override
  int get hashCode {
    final objects = [key, scope];
    if (value != null) {
      final valueHashes =
          value.entries.map((entry) => hash2(entry.key, entry.value));
      objects.addAll(valueHashes);
    } else {
      objects.add(value);
    }
    return hashObjects(objects);
  }
}
