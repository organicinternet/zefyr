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
    NotusAttribute.p.key: NotusAttribute.p,
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
  static NotusAttribute<String> get black => color.black;
  static NotusAttribute<String> get red => color.red;
  static NotusAttribute<String> get orange => color.orange;
  static NotusAttribute<String> get yellow => color.yellow;
  static NotusAttribute<String> get green => color.green;
  static NotusAttribute<String> get blue => color.blue;
  static NotusAttribute<String> get purple => color.purple;
  static NotusAttribute<String> get white => color.white;
  static NotusAttribute<String> get pink => color.pink;
  static NotusAttribute<String> get magnolia => color.magnolia;
  static NotusAttribute<String> get cream => color.cream;
  static NotusAttribute<String> get mint => color.mint;
  static NotusAttribute<String> get eggshell => color.eggshell;
  static NotusAttribute<String> get mauve => color.mauve;
  static NotusAttribute<String> get lightGrey => color.lightGrey;
  static NotusAttribute<String> get rosy => color.rosy;
  static NotusAttribute<String> get amber => color.amber;
  static NotusAttribute<String> get canary => color.canary;
  static NotusAttribute<String> get regent => color.regent;
  static NotusAttribute<String> get euston => color.euston;
  static NotusAttribute<String> get premier => color.premier;
  static NotusAttribute<String> get midGrey => color.midGrey;
  static NotusAttribute<String> get maroon => color.maroon;
  static NotusAttribute<String> get mustard => color.mustard;
  static NotusAttribute<String> get sick => color.sick;
  static NotusAttribute<String> get snooker => color.snooker;
  static NotusAttribute<String> get everton => color.everton;
  static NotusAttribute<String> get lenny => color.lenny;
  static NotusAttribute<String> get charcoal => color.charcoal;
  static NotusAttribute<String> get budget => color.budget;
  static NotusAttribute<String> get brown => color.brown;
  static NotusAttribute<String> get bean => color.bean;
  static NotusAttribute<String> get aftereight => color.aftereight;
  static NotusAttribute<String> get ocean => color.ocean;
  static NotusAttribute<String> get bruise => color.bruise;

  /// Aliases for [NotusAttribute.backgroundColor.<color_foo>].
  static NotusAttribute<String> get bcblack => backgroundColor.black;
  static NotusAttribute<String> get bcred => backgroundColor.red;
  static NotusAttribute<String> get bcorange => backgroundColor.orange;
  static NotusAttribute<String> get bcyellow => backgroundColor.yellow;
  static NotusAttribute<String> get bcgreen => backgroundColor.green;
  static NotusAttribute<String> get bcblue => backgroundColor.blue;
  static NotusAttribute<String> get bcpurple => backgroundColor.purple;
  static NotusAttribute<String> get bcwhite => backgroundColor.white;
  static NotusAttribute<String> get bcpink => backgroundColor.pink;
  static NotusAttribute<String> get bcmagnolia => backgroundColor.magnolia;
  static NotusAttribute<String> get bccream => backgroundColor.cream;
  static NotusAttribute<String> get bcmint => backgroundColor.mint;
  static NotusAttribute<String> get bceggshell => backgroundColor.eggshell;
  static NotusAttribute<String> get bcmauve => backgroundColor.mauve;
  static NotusAttribute<String> get bclightGrey => backgroundColor.lightGrey;
  static NotusAttribute<String> get bcrosy => backgroundColor.rosy;
  static NotusAttribute<String> get bcamber => backgroundColor.amber;
  static NotusAttribute<String> get bccanary => backgroundColor.canary;
  static NotusAttribute<String> get bcregent => backgroundColor.regent;
  static NotusAttribute<String> get bceuston => backgroundColor.euston;
  static NotusAttribute<String> get bcpremier => backgroundColor.premier;
  static NotusAttribute<String> get bcmidGrey => backgroundColor.midGrey;
  static NotusAttribute<String> get bcmaroon => backgroundColor.maroon;
  static NotusAttribute<String> get bcmustard => backgroundColor.mustard;
  static NotusAttribute<String> get bcsick => backgroundColor.sick;
  static NotusAttribute<String> get bcsnooker => backgroundColor.snooker;
  static NotusAttribute<String> get bceverton => backgroundColor.everton;
  static NotusAttribute<String> get bclenny => backgroundColor.lenny;
  static NotusAttribute<String> get bccharcoal => backgroundColor.charcoal;
  static NotusAttribute<String> get bcbudget => backgroundColor.budget;
  static NotusAttribute<String> get bcbrown => backgroundColor.brown;
  static NotusAttribute<String> get bcbean => backgroundColor.bean;
  static NotusAttribute<String> get bcaftereight => backgroundColor.aftereight;
  static NotusAttribute<String> get bcocean => backgroundColor.ocean;
  static NotusAttribute<String> get bcbruise => backgroundColor.bruise;

  /// Link style attribute.
  // ignore: const_eval_throws_exception
  static const link = LinkAttributeBuilder._();

  static const span = SpanAttributeBuilder._();

  static const p = ParagraphAttributeBuilder._();

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

  /// Alias for [NotusAttribute.heading.light1].
  static NotusAttribute<int> get lightH1 => heading.light1;

  /// Alias for [NotusAttribute.heading.light2].
  static NotusAttribute<int> get lightH2 => heading.light2;

  /// Alias for [NotusAttribute.heading.light3].
  static NotusAttribute<int> get lightH3 => heading.light3;

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

  NotusAttribute<String> get black =>
      NotusAttribute<String>._(key, scope, "rgb(0, 0, 0)");
  NotusAttribute<String> get red =>
      NotusAttribute<String>._(key, scope, "rgb(230, 0, 0)");
  NotusAttribute<String> get orange =>
      NotusAttribute<String>._(key, scope, "rgb(255, 153, 0)");
  NotusAttribute<String> get yellow =>
      NotusAttribute<String>._(key, scope, "rgb(255, 255, 0)");
  NotusAttribute<String> get green =>
      NotusAttribute<String>._(key, scope, "rgb(0, 138, 0)");
  NotusAttribute<String> get blue =>
      NotusAttribute<String>._(key, scope, "rgb(0, 102, 204)");
  NotusAttribute<String> get purple =>
      NotusAttribute<String>._(key, scope, "rgb(153, 51, 255)");
  NotusAttribute<String> get white =>
      NotusAttribute<String>._(key, scope, "rgb(255, 255, 255)");
  NotusAttribute<String> get pink =>
      NotusAttribute<String>._(key, scope, "rgb(250, 204, 204)");
  NotusAttribute<String> get magnolia =>
      NotusAttribute<String>._(key, scope, "rgb(255, 235, 204)");
  NotusAttribute<String> get cream =>
      NotusAttribute<String>._(key, scope, "rgb(255, 255, 204)");
  NotusAttribute<String> get mint =>
      NotusAttribute<String>._(key, scope, "rgb(204, 232, 204)");
  NotusAttribute<String> get eggshell =>
      NotusAttribute<String>._(key, scope, "rgb(204, 224, 245)");
  NotusAttribute<String> get mauve =>
      NotusAttribute<String>._(key, scope, "rgb(235, 214, 255)");
  NotusAttribute<String> get lightGrey =>
      NotusAttribute<String>._(key, scope, "rgb(187, 187, 187)");
  NotusAttribute<String> get rosy =>
      NotusAttribute<String>._(key, scope, "rgb(240, 102, 102)");
  NotusAttribute<String> get amber =>
      NotusAttribute<String>._(key, scope, "rgb(255, 194, 102)");
  NotusAttribute<String> get canary =>
      NotusAttribute<String>._(key, scope, "rgb(255, 255, 102)");
  NotusAttribute<String> get regent =>
      NotusAttribute<String>._(key, scope, "rgb(102, 185, 102)");
  NotusAttribute<String> get euston =>
      NotusAttribute<String>._(key, scope, "rgb(102, 163, 224)");
  NotusAttribute<String> get premier =>
      NotusAttribute<String>._(key, scope, "rgb(194, 133, 255)");
  NotusAttribute<String> get midGrey =>
      NotusAttribute<String>._(key, scope, "rgb(136, 136, 136)");
  NotusAttribute<String> get maroon =>
      NotusAttribute<String>._(key, scope, "rgb(161, 0, 0)");
  NotusAttribute<String> get mustard =>
      NotusAttribute<String>._(key, scope, "rgb(178, 107, 0)");
  NotusAttribute<String> get sick =>
      NotusAttribute<String>._(key, scope, "rgb(178, 178, 0)");
  NotusAttribute<String> get snooker =>
      NotusAttribute<String>._(key, scope, "rgb(0, 97, 0)");
  NotusAttribute<String> get everton =>
      NotusAttribute<String>._(key, scope, "rgb(0, 71, 178)");
  NotusAttribute<String> get lenny =>
      NotusAttribute<String>._(key, scope, "rgb(107, 36, 178)");
  NotusAttribute<String> get charcoal =>
      NotusAttribute<String>._(key, scope, "rgb(68, 68, 68)");
  NotusAttribute<String> get budget =>
      NotusAttribute<String>._(key, scope, "rgb(92, 0, 0)");
  NotusAttribute<String> get brown =>
      NotusAttribute<String>._(key, scope, "rgb(102, 61, 0)");
  NotusAttribute<String> get bean =>
      NotusAttribute<String>._(key, scope, "rgb(102, 102, 0)");
  NotusAttribute<String> get aftereight =>
      NotusAttribute<String>._(key, scope, "rgb(0, 55, 0)");
  NotusAttribute<String> get ocean =>
      NotusAttribute<String>._(key, scope, "rgb(0, 41, 102)");
  NotusAttribute<String> get bruise =>
      NotusAttribute<String>._(key, scope, "rgb(61, 20, 102)");
}

/// Builder for color attribute styles.
class BackgroundColorAttributeBuilder extends NotusAttributeBuilder<String> {
  static const _kColor = 'backgroundColor';
  const BackgroundColorAttributeBuilder._()
      : super._(_kColor, NotusAttributeScope.inline);

  NotusAttribute<String> get black =>
      NotusAttribute<String>._(key, scope, "rgb(0, 0, 0)");
  NotusAttribute<String> get red =>
      NotusAttribute<String>._(key, scope, "rgb(230, 0, 0)");
  NotusAttribute<String> get orange =>
      NotusAttribute<String>._(key, scope, "rgb(255, 153, 0)");
  NotusAttribute<String> get yellow =>
      NotusAttribute<String>._(key, scope, "rgb(255, 255, 0)");
  NotusAttribute<String> get green =>
      NotusAttribute<String>._(key, scope, "rgb(0, 138, 0)");
  NotusAttribute<String> get blue =>
      NotusAttribute<String>._(key, scope, "rgb(0, 102, 204)");
  NotusAttribute<String> get purple =>
      NotusAttribute<String>._(key, scope, "rgb(153, 51, 255)");
  NotusAttribute<String> get white =>
      NotusAttribute<String>._(key, scope, "rgb(255, 255, 255)");
  NotusAttribute<String> get pink =>
      NotusAttribute<String>._(key, scope, "rgb(250, 204, 204)");
  NotusAttribute<String> get magnolia =>
      NotusAttribute<String>._(key, scope, "rgb(255, 235, 204)");
  NotusAttribute<String> get cream =>
      NotusAttribute<String>._(key, scope, "rgb(255, 255, 204)");
  NotusAttribute<String> get mint =>
      NotusAttribute<String>._(key, scope, "rgb(204, 232, 204)");
  NotusAttribute<String> get eggshell =>
      NotusAttribute<String>._(key, scope, "rgb(204, 224, 245)");
  NotusAttribute<String> get mauve =>
      NotusAttribute<String>._(key, scope, "rgb(235, 214, 255)");
  NotusAttribute<String> get lightGrey =>
      NotusAttribute<String>._(key, scope, "rgb(187, 187, 187)");
  NotusAttribute<String> get rosy =>
      NotusAttribute<String>._(key, scope, "rgb(240, 102, 102)");
  NotusAttribute<String> get amber =>
      NotusAttribute<String>._(key, scope, "rgb(255, 194, 102)");
  NotusAttribute<String> get canary =>
      NotusAttribute<String>._(key, scope, "rgb(255, 255, 102)");
  NotusAttribute<String> get regent =>
      NotusAttribute<String>._(key, scope, "rgb(102, 185, 102)");
  NotusAttribute<String> get euston =>
      NotusAttribute<String>._(key, scope, "rgb(102, 163, 224)");
  NotusAttribute<String> get premier =>
      NotusAttribute<String>._(key, scope, "rgb(194, 133, 255)");
  NotusAttribute<String> get midGrey =>
      NotusAttribute<String>._(key, scope, "rgb(136, 136, 136)");
  NotusAttribute<String> get maroon =>
      NotusAttribute<String>._(key, scope, "rgb(161, 0, 0)");
  NotusAttribute<String> get mustard =>
      NotusAttribute<String>._(key, scope, "rgb(178, 107, 0)");
  NotusAttribute<String> get sick =>
      NotusAttribute<String>._(key, scope, "rgb(178, 178, 0)");
  NotusAttribute<String> get snooker =>
      NotusAttribute<String>._(key, scope, "rgb(0, 97, 0)");
  NotusAttribute<String> get everton =>
      NotusAttribute<String>._(key, scope, "rgb(0, 71, 178)");
  NotusAttribute<String> get lenny =>
      NotusAttribute<String>._(key, scope, "rgb(107, 36, 178)");
  NotusAttribute<String> get charcoal =>
      NotusAttribute<String>._(key, scope, "rgb(68, 68, 68)");
  NotusAttribute<String> get budget =>
      NotusAttribute<String>._(key, scope, "rgb(92, 0, 0)");
  NotusAttribute<String> get brown =>
      NotusAttribute<String>._(key, scope, "rgb(102, 61, 0)");
  NotusAttribute<String> get bean =>
      NotusAttribute<String>._(key, scope, "rgb(102, 102, 0)");
  NotusAttribute<String> get aftereight =>
      NotusAttribute<String>._(key, scope, "rgb(0, 55, 0)");
  NotusAttribute<String> get ocean =>
      NotusAttribute<String>._(key, scope, "rgb(0, 41, 102)");
  NotusAttribute<String> get bruise =>
      NotusAttribute<String>._(key, scope, "rgb(61, 20, 102)");
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

  /// Level 1 light heading, equivalent of `H1` class="lightheading-one" in HTML.
  NotusAttribute<int> get light1 => NotusAttribute<int>._(key, scope, 11);

  /// Level 2 heading, equivalent of `H2` in HTML.
  NotusAttribute<int> get light2 => NotusAttribute<int>._(key, scope, 12);

  /// Level 3 heading, equivalent of `H3` in HTML.
  NotusAttribute<int> get light3 => NotusAttribute<int>._(key, scope, 13);
}

class ParagraphAttributeBuilder extends NotusAttributeBuilder<String> {
  static const _kTag = 'p';
  const ParagraphAttributeBuilder._()
      : super._(_kTag, NotusAttributeScope.line);

  NotusAttribute<String> get body1 =>
      NotusAttribute<String>._(key, scope, "body-one");
  NotusAttribute<String> get body2 =>
      NotusAttribute<String>._(key, scope, "body-two"); // body-two is default
  NotusAttribute<String> get body3 =>
      NotusAttribute<String>._(key, scope, "body-three");
  NotusAttribute<String> get body4 =>
      NotusAttribute<String>._(key, scope, "body-four");
  NotusAttribute<String> get listed =>
      NotusAttribute<String>._(key, scope, "listed");
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
