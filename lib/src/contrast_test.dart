import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:test/test.dart' as test;

/// Supported readability levels.
///
/// [ReadabilityLevel.normal] is meant for text used as a body of a document.
///
/// [ReadabilityLevel.normalLargeText] is meant for text used as a title
/// of a document or other headers.
///
/// [ReadabilityLevel.high] is meant for text used as a body of a document.
/// It's demanding design-wise but very accessible.
///
/// [ReadabilityLevel.normalLargeText] is meant for text used as a title
/// of a document or other headers.
/// It's demanding design-wise but very accessible.
enum ReadabilityLevel { normal, normalLargeText, high, highLargeText }

/// Utilities for providing numeric values of guidelines.
extension MinimumAcceptableContrast on ReadabilityLevel {
  /// Provides minimum acceptable ratio for given [ReadabilityLevel].
  num get minimumAcceptableContrastRatio {
    const minAcceptableContrastForLevel = {
      ReadabilityLevel.normal: 4.5,
      ReadabilityLevel.normalLargeText: 3,
      ReadabilityLevel.high: 7,
      ReadabilityLevel.highLargeText: 4.5,
    };
    return minAcceptableContrastForLevel[this]!;
  }
}

/// Creates a new contrast test case with the given [description].
///
/// Checks if given [backgroundColor] and [foregroundColor] meet minimum
/// contrast ratio value for given [readabilityLevel].
///
/// Example error message:
///
/// ```
/// 1.0:1 contrast ratio of Color(0xffffffff) and Color(0xffffffff)
/// does not meet minimum acceptable contrast ratio
/// for ReadabilityLevel.normal, which is 4.5:1.
/// ```
///
/// If [tags] is passed, it declares user-defined tags that are applied to the
/// test. These tags can be used to select or skip the test on the command line,
/// or to do bulk test configuration. All tags should be declared in the
/// [package configuration file][configuring tags]. The parameter can be an
/// [Iterable] of tag names, or a [String] representing a single tag.
///
/// [configuring tags]: https://github.com/dart-lang/test/blob/master/pkgs/test/doc/configuration.md#configuring-tags
@isTest
void contrastTest(
  dynamic description,
  Color backgroundColor,
  Color foregroundColor, {
  ReadabilityLevel readabilityLevel = ReadabilityLevel.normal,
  dynamic tags,
}) {
  test.test(
    description,
    () => runContrastTest(backgroundColor, foregroundColor,
        readabilityLevel: readabilityLevel),
    tags: tags,
  );
}

/// Checks if given [backgroundColor] and [foregroundColor] meet minimum
/// contrast ratio value for given [readabilityLevel].
///
/// Throws an [AssertionError] if contrast ratio is lower than minimum required
/// value for given [readabilityLevel].
///
/// Example error message:
///
/// ```
/// 1.0:1 contrast ratio of Color(0xffffffff) and Color(0xffffffff)
/// does not meet minimum acceptable contrast ratio
/// for ReadabilityLevel.normal, which is 4.5:1.
/// ```
void runContrastTest(
  Color backgroundColor,
  Color foregroundColor, {
  ReadabilityLevel readabilityLevel = ReadabilityLevel.normal,
}) {
  final contrastRatio = calculateContrast(backgroundColor, foregroundColor);
  assert(
    doesMatchMinContrastRatio(
          contrastRatio,
          readabilityLevel: readabilityLevel,
        ) ==
        true,
    '${contrastRatio.toStringAsFixed(2)}:1 contrast ratio of $backgroundColor and $foregroundColor '
    'does not meet minimum acceptable contrast ratio for '
    '$readabilityLevel, which is ${readabilityLevel.minimumAcceptableContrastRatio}:1',
  );
}

/// Check whether given contrast [ratio] meet the minimum required value
/// for given [readabilityLevel].
bool doesMatchMinContrastRatio(
  num ratio, {
  ReadabilityLevel readabilityLevel = ReadabilityLevel.normal,
}) =>
    ratio >= readabilityLevel.minimumAcceptableContrastRatio;

/// Calculates contrast ratio of given [backgroundColor] and [foregroundColor].
///
/// The ratio will be in range from 0 to 21.
/// Typically the ratio starts at 1, but in this implementation we do
/// use color's opacity into account: if the color's opacity is 0, meaning
/// full transparency, the ratio is considered 0:1.
///
/// An order in which colors to compare are provided do not affect resulting
/// contrast ratio.
num calculateContrast(Color backgroundColor, Color foregroundColor) {
  final backgroundLuminance = backgroundColor.computeLuminance();
  final foregroundLuminance = foregroundColor.computeLuminance();

  final lighterColorLuminance = backgroundLuminance > foregroundLuminance
      ? backgroundLuminance
      : foregroundLuminance;
  final darkerColorLuminance = backgroundLuminance < foregroundLuminance
      ? backgroundLuminance
      : foregroundLuminance;

  final opacityUnawareContrast =
      (lighterColorLuminance + 0.05) / (darkerColorLuminance + 0.05);
  return opacityUnawareContrast *
      foregroundColor.opacity *
      backgroundColor.opacity;
}
