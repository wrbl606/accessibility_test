import 'package:accessibility_test/accessibility_test.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:test/test.dart' as test;

/// Supported accessibility levels.
///
/// [ThemeAccessibilityLevel.normal] is meant for regular apps.
///
/// [ThemeAccessibilityLevel.high] is meant for high-availability solutions,
/// like government apps.
/// It's demanding design-wise but very accessible.
enum ThemeAccessibilityLevel { normal, high }

/// Utilities for providing numeric values of guidelines.
extension on ThemeAccessibilityLevel {
  /// Maps [ThemeAccessibilityLevel] to [ReadabilityLevel] for contrast tests.
  ReadabilityLevel get readabilityLevel {
    const map = {
      ThemeAccessibilityLevel.normal: ReadabilityLevel.normal,
      ThemeAccessibilityLevel.high: ReadabilityLevel.high,
    };
    return map[this]!;
  }
}

/// Creates a new theme test case with the given [description].
///
/// Scans through given [themeData], looking for insufficient contrast values
/// between text and background colors.
///
/// Example error message:
///
/// ```plain
/// Contrast ratio of primaryColorLight (Color(0xffbbdefb))
/// and primaryTextTheme.bodyLarge?.color (Color(0xffffffff)) is 1.40:1,
/// which is not sufficient for specified ThemeAccessibilityLevel.normal.
/// ThemeAccessibilityLevel.normal's lowest acceptable contrast ratio is 4.5:1.
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
void themeTest(
  dynamic description,
  ThemeData themeData, {
  ThemeAccessibilityLevel accessibilityLevel = ThemeAccessibilityLevel.normal,
  dynamic tags,
}) {
  test.test(
    description,
    () => runThemeTest(themeData, accessibilityLevel: accessibilityLevel),
    tags: tags,
  );
}

/// Scans through given [themeData], looking for insufficient contrast values
/// between text and background colors.
///
/// Throws an [AssertionError] if any text-background combo's contrast ratio
/// is lower than minimum required value for given [accessibilityLevel].
///
/// Example error message:
///
/// ```
/// Contrast ratio of primaryColorLight (Color(0xffbbdefb))
/// and primaryTextTheme.bodyLarge?.color (Color(0xffffffff)) is 1.40:1,
/// which is not sufficient for specified ThemeAccessibilityLevel.normal.
/// ThemeAccessibilityLevel.normal's lowest acceptable contrast ratio is 4.5:1.
/// ```
@visibleForTesting
void runThemeTest(
  ThemeData themeData, {
  ThemeAccessibilityLevel accessibilityLevel = ThemeAccessibilityLevel.normal,
}) {
  final backgroundColors = <String, Color?>{
    'backgroundColor': themeData.backgroundColor,
    'dialogBackgroundColor': themeData.dialogBackgroundColor,
    'scaffoldBackgroundColor': themeData.scaffoldBackgroundColor,
    'cardColor': themeData.cardColor,
    'bottomAppBarColor': themeData.bottomAppBarColor,
    'canvasColor': themeData.canvasColor,
    'selectedRowColor': themeData.selectedRowColor,
    'textSelectionTheme.selectionColor':
        themeData.textSelectionTheme.selectionColor,
    'textTheme.bodyLarge?.backgroundColor':
        themeData.textTheme.bodyLarge?.backgroundColor,
    'textTheme.bodyMedium?.backgroundColor':
        themeData.textTheme.bodyMedium?.backgroundColor,
    'textTheme.bodySmall?.backgroundColor':
        themeData.textTheme.bodySmall?.backgroundColor,
    'textTheme.bodyText1?.backgroundColor':
        themeData.textTheme.bodyText1?.backgroundColor,
    'textTheme.bodyText2?.backgroundColor':
        themeData.textTheme.bodyText2?.backgroundColor,
    'textTheme.button?.backgroundColor':
        themeData.textTheme.button?.backgroundColor,
    'textTheme.caption?.backgroundColor':
        themeData.textTheme.caption?.backgroundColor,
    'textTheme.displayLarge?.backgroundColor':
        themeData.textTheme.displayLarge?.backgroundColor,
    'textTheme.displayMedium?.backgroundColor':
        themeData.textTheme.displayMedium?.backgroundColor,
    'textTheme.displaySmall?.backgroundColor':
        themeData.textTheme.displaySmall?.backgroundColor,
    'textTheme.headline1?.backgroundColor':
        themeData.textTheme.headline1?.backgroundColor,
    'textTheme.headline2?.backgroundColor':
        themeData.textTheme.headline2?.backgroundColor,
    'textTheme.headline3?.backgroundColor':
        themeData.textTheme.headline3?.backgroundColor,
    'textTheme.headline4?.backgroundColor':
        themeData.textTheme.headline4?.backgroundColor,
    'textTheme.headline5?.backgroundColor':
        themeData.textTheme.headline5?.backgroundColor,
    'textTheme.headline6?.backgroundColor':
        themeData.textTheme.headline6?.backgroundColor,
    'textTheme.headlineLarge?.backgroundColor':
        themeData.textTheme.headlineLarge?.backgroundColor,
    'textTheme.headlineMedium?.backgroundColor':
        themeData.textTheme.headlineMedium?.backgroundColor,
    'textTheme.headlineSmall?.backgroundColor':
        themeData.textTheme.headlineSmall?.backgroundColor,
    'textTheme.labelLarge?.backgroundColor':
        themeData.textTheme.labelLarge?.backgroundColor,
    'textTheme.labelMedium?.backgroundColor':
        themeData.textTheme.labelMedium?.backgroundColor,
    'textTheme.labelSmall?.backgroundColor':
        themeData.textTheme.labelSmall?.backgroundColor,
    'textTheme.overline?.backgroundColor':
        themeData.textTheme.overline?.backgroundColor,
    'textTheme.subtitle1?.backgroundColor':
        themeData.textTheme.subtitle1?.backgroundColor,
    'textTheme.subtitle2?.backgroundColor':
        themeData.textTheme.subtitle2?.backgroundColor,
    'textTheme.titleLarge?.backgroundColor':
        themeData.textTheme.titleLarge?.backgroundColor,
    'textTheme.titleMedium?.backgroundColor':
        themeData.textTheme.titleMedium?.backgroundColor,
    'textTheme.titleSmall?.backgroundColor':
        themeData.textTheme.titleSmall?.backgroundColor,
    'textButtonTheme.style?.textStyle': themeData
        .textButtonTheme.style?.textStyle
        ?.resolve(MaterialState.values.toSet())
        ?.backgroundColor,
  };

  final textColors = <String, Color?>{
    'hintColor': themeData.hintColor,
    'errorColor': themeData.errorColor,
    'textTheme.bodyLarge?.color': themeData.textTheme.bodyLarge?.color,
    'textTheme.bodyMedium?.color': themeData.textTheme.bodyMedium?.color,
    'textTheme.bodySmall?.color': themeData.textTheme.bodySmall?.color,
    'textTheme.bodyText1?.color': themeData.textTheme.bodyText1?.color,
    'textTheme.bodyText2?.color': themeData.textTheme.bodyText2?.color,
    'textTheme.button?.color': themeData.textTheme.button?.color,
    'textTheme.caption?.color': themeData.textTheme.caption?.color,
    'textTheme.displayLarge?.color': themeData.textTheme.displayLarge?.color,
    'textTheme.displayMedium?.color': themeData.textTheme.displayMedium?.color,
    'textTheme.displaySmall?.color': themeData.textTheme.displaySmall?.color,
    'textTheme.headline1?.color': themeData.textTheme.headline1?.color,
    'textTheme.headline2?.color': themeData.textTheme.headline2?.color,
    'textTheme.headline3?.color': themeData.textTheme.headline3?.color,
    'textTheme.headline4?.color': themeData.textTheme.headline4?.color,
    'textTheme.headline5?.color': themeData.textTheme.headline5?.color,
    'textTheme.headline6?.color': themeData.textTheme.headline6?.color,
    'textTheme.headlineLarge?.color': themeData.textTheme.headlineLarge?.color,
    'textTheme.headlineMedium?.color':
        themeData.textTheme.headlineMedium?.color,
    'textTheme.headlineSmall?.color': themeData.textTheme.headlineSmall?.color,
    'textTheme.labelLarge?.color': themeData.textTheme.labelLarge?.color,
    'textTheme.labelMedium?.color': themeData.textTheme.labelMedium?.color,
    'textTheme.labelSmall?.color': themeData.textTheme.labelSmall?.color,
    'textTheme.overline?.color': themeData.textTheme.overline?.color,
    'textTheme.subtitle1?.color': themeData.textTheme.subtitle1?.color,
    'textTheme.subtitle2?.color': themeData.textTheme.subtitle2?.color,
    'textTheme.titleLarge?.color': themeData.textTheme.titleLarge?.color,
    'textTheme.titleMedium?.color': themeData.textTheme.titleMedium?.color,
    'textTheme.titleSmall?.color': themeData.textTheme.titleSmall?.color,
    'textButtonTheme.style?.textStyle': themeData
        .textButtonTheme.style?.textStyle
        ?.resolve(MaterialState.values.toSet())
        ?.color,
  };

  for (final backgroundColor in backgroundColors.entries) {
    for (final textColor in textColors.entries) {
      if (backgroundColor.value == null || textColor.value == null) {
        continue;
      }
      final contrast =
          calculateContrast(backgroundColor.value!, textColor.value!);
      final doesMatchMinContrast = doesMatchMinContrastRatio(
        contrast,
        readabilityLevel: accessibilityLevel.readabilityLevel,
      );
      assert(
        doesMatchMinContrast == true,
        'Contrast ratio of ${backgroundColor.key} (${backgroundColor.value}) and ${textColor.key} (${textColor.value}) '
        'is $contrast:1, which is not sufficient for specified $accessibilityLevel. '
        '$accessibilityLevel\'s lowest acceptable contrast ratio is ${accessibilityLevel.readabilityLevel.minimumAcceptableContrastRatio}:1.',
      );
    }
  }

  final primaryColors = <String, Color?>{
    'primaryColor': themeData.primaryColor,
    'primaryColorLight': themeData.primaryColorLight,
    'primaryColorDark': themeData.primaryColorDark,
    'primaryTextTheme.bodyLarge?.backgroundColor':
        themeData.primaryTextTheme.bodyLarge?.backgroundColor,
    'primaryTextTheme.bodyMedium?.backgroundColor':
        themeData.primaryTextTheme.bodyMedium?.backgroundColor,
    'primaryTextTheme.bodySmall?.backgroundColor':
        themeData.primaryTextTheme.bodySmall?.backgroundColor,
    'primaryTextTheme.bodyText1?.backgroundColor':
        themeData.primaryTextTheme.bodyText1?.backgroundColor,
    'primaryTextTheme.bodyText2?.backgroundColor':
        themeData.primaryTextTheme.bodyText2?.backgroundColor,
    'primaryTextTheme.button?.backgroundColor':
        themeData.primaryTextTheme.button?.backgroundColor,
    'primaryTextTheme.caption?.backgroundColor':
        themeData.primaryTextTheme.caption?.backgroundColor,
    'primaryTextTheme.displayLarge?.backgroundColor':
        themeData.primaryTextTheme.displayLarge?.backgroundColor,
    'primaryTextTheme.displayMedium?.backgroundColor':
        themeData.primaryTextTheme.displayMedium?.backgroundColor,
    'primaryTextTheme.displaySmall?.backgroundColor':
        themeData.primaryTextTheme.displaySmall?.backgroundColor,
    'primaryTextTheme.headline1?.backgroundColor':
        themeData.primaryTextTheme.headline1?.backgroundColor,
    'primaryTextTheme.headline2?.backgroundColor':
        themeData.primaryTextTheme.headline2?.backgroundColor,
    'primaryTextTheme.headline3?.backgroundColor':
        themeData.primaryTextTheme.headline3?.backgroundColor,
    'primaryTextTheme.headline4?.backgroundColor':
        themeData.primaryTextTheme.headline4?.backgroundColor,
    'primaryTextTheme.headline5?.backgroundColor':
        themeData.primaryTextTheme.headline5?.backgroundColor,
    'primaryTextTheme.headline6?.backgroundColor':
        themeData.primaryTextTheme.headline6?.backgroundColor,
    'primaryTextTheme.headlineLarge?.backgroundColor':
        themeData.primaryTextTheme.headlineLarge?.backgroundColor,
    'primaryTextTheme.headlineMedium?.backgroundColor':
        themeData.primaryTextTheme.headlineMedium?.backgroundColor,
    'primaryTextTheme.headlineSmall?.backgroundColor':
        themeData.primaryTextTheme.headlineSmall?.backgroundColor,
    'primaryTextTheme.labelLarge?.backgroundColor':
        themeData.primaryTextTheme.labelLarge?.backgroundColor,
    'primaryTextTheme.labelMedium?.backgroundColor':
        themeData.primaryTextTheme.labelMedium?.backgroundColor,
    'primaryTextTheme.labelSmall?.backgroundColor':
        themeData.primaryTextTheme.labelSmall?.backgroundColor,
    'primaryTextTheme.overline?.backgroundColor':
        themeData.primaryTextTheme.overline?.backgroundColor,
    'primaryTextTheme.subtitle1?.backgroundColor':
        themeData.primaryTextTheme.subtitle1?.backgroundColor,
    'primaryTextTheme.subtitle2?.backgroundColor':
        themeData.primaryTextTheme.subtitle2?.backgroundColor,
    'primaryTextTheme.titleLarge?.backgroundColor':
        themeData.primaryTextTheme.titleLarge?.backgroundColor,
    'primaryTextTheme.titleMedium?.backgroundColor':
        themeData.primaryTextTheme.titleMedium?.backgroundColor,
    'primaryTextTheme.titleSmall?.backgroundColor':
        themeData.primaryTextTheme.titleSmall?.backgroundColor,
  };

  final primaryTextColors = <String, Color?>{
    'primaryTextTheme.bodyLarge?.color':
        themeData.primaryTextTheme.bodyLarge?.color,
    'primaryTextTheme.bodyMedium?.color':
        themeData.primaryTextTheme.bodyMedium?.color,
    'primaryTextTheme.bodySmall?.color':
        themeData.primaryTextTheme.bodySmall?.color,
    'primaryTextTheme.bodyText1?.color':
        themeData.primaryTextTheme.bodyText1?.color,
    'primaryTextTheme.bodyText2?.color':
        themeData.primaryTextTheme.bodyText2?.color,
    'primaryTextTheme.button?.color': themeData.primaryTextTheme.button?.color,
    'primaryTextTheme.caption?.color':
        themeData.primaryTextTheme.caption?.color,
    'primaryTextTheme.displayLarge?.color':
        themeData.primaryTextTheme.displayLarge?.color,
    'primaryTextTheme.displayMedium?.color':
        themeData.primaryTextTheme.displayMedium?.color,
    'primaryTextTheme.displaySmall?.color':
        themeData.primaryTextTheme.displaySmall?.color,
    'primaryTextTheme.headline1?.color':
        themeData.primaryTextTheme.headline1?.color,
    'primaryTextTheme.headline2?.color':
        themeData.primaryTextTheme.headline2?.color,
    'primaryTextTheme.headline3?.color':
        themeData.primaryTextTheme.headline3?.color,
    'primaryTextTheme.headline4?.color':
        themeData.primaryTextTheme.headline4?.color,
    'primaryTextTheme.headline5?.color':
        themeData.primaryTextTheme.headline5?.color,
    'primaryTextTheme.headline6?.color':
        themeData.primaryTextTheme.headline6?.color,
    'primaryTextTheme.headlineLarge?.color':
        themeData.primaryTextTheme.headlineLarge?.color,
    'primaryTextTheme.headlineMedium?.color':
        themeData.primaryTextTheme.headlineMedium?.color,
    'primaryTextTheme.headlineSmall?.color':
        themeData.primaryTextTheme.headlineSmall?.color,
    'primaryTextTheme.labelLarge?.color':
        themeData.primaryTextTheme.labelLarge?.color,
    'primaryTextTheme.labelMedium?.color':
        themeData.primaryTextTheme.labelMedium?.color,
    'primaryTextTheme.labelSmall?.color':
        themeData.primaryTextTheme.labelSmall?.color,
    'primaryTextTheme.overline?.color':
        themeData.primaryTextTheme.overline?.color,
    'primaryTextTheme.subtitle1?.color':
        themeData.primaryTextTheme.subtitle1?.color,
    'primaryTextTheme.subtitle2?.color':
        themeData.primaryTextTheme.subtitle2?.color,
    'primaryTextTheme.titleLarge?.color':
        themeData.primaryTextTheme.titleLarge?.color,
    'primaryTextTheme.titleMedium?.color':
        themeData.primaryTextTheme.titleMedium?.color,
    'primaryTextTheme.titleSmall?.color':
        themeData.primaryTextTheme.titleSmall?.color,
  };

  for (final backgroundColor in primaryColors.entries) {
    for (final textColor in primaryTextColors.entries) {
      if (backgroundColor.value == null || textColor.value == null) {
        continue;
      }
      final contrast =
          calculateContrast(backgroundColor.value!, textColor.value!);
      final doesMatchMinContrast = doesMatchMinContrastRatio(
        contrast,
        readabilityLevel: accessibilityLevel.readabilityLevel,
      );
      assert(
        doesMatchMinContrast == true,
        'Contrast ratio of ${backgroundColor.key} (${backgroundColor.value}) and ${textColor.key} (${textColor.value}) '
        'is ${contrast.toStringAsFixed(2)}:1, which is not sufficient for specified $accessibilityLevel. '
        '$accessibilityLevel\'s lowest acceptable contrast ratio is ${accessibilityLevel.readabilityLevel.minimumAcceptableContrastRatio}:1.',
      );
    }
  }
}
