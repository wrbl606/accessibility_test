import 'package:accessibility_test/src/theme_test.dart';
import 'package:flutter/material.dart';
import 'package:test/test.dart';
import 'package:tuple/tuple.dart';

void main() {
  test(
      'Throws assertion error when theme values are not meeting min readability level',
      () {
    final testCases = [
      // Tuple3(themeData, readabilityLevel, shouldThrow)
      Tuple3(ThemeData(primaryColor: Colors.white, errorColor: Colors.white),
          ThemeAccessibilityLevel.normal, true),
      Tuple3(ThemeData(primaryColor: Colors.black, errorColor: Colors.black),
          ThemeAccessibilityLevel.normal, true),
      Tuple3(
          ThemeData(
            primaryColor: Colors.black,
            primaryColorLight: Colors.black,
            primaryColorDark: Colors.black,
            errorColor: Colors.black,
          ),
          ThemeAccessibilityLevel.normal,
          false),
    ];

    for (final testCase in testCases) {
      if (testCase.item3) {
        expect(
          () =>
              runThemeTest(testCase.item1, accessibilityLevel: testCase.item2),
          throwsA(isA<AssertionError>()),
          reason: 'Assertion error not thrown for theme (${testCase.item1}) '
              'with contrast ratio issues.',
        );
      } else {
        expect(
            () => runThemeTest(testCase.item1,
                accessibilityLevel: testCase.item2),
            returnsNormally,
            reason: 'Assertion error thrown for theme (${testCase.item1}) '
                'without contrast ratio issues.');
      }
    }
  });

  themeTest(
    'Accessible theme is passing themeTest',
    ThemeData(
      primaryColor: Colors.black,
      primaryColorLight: Colors.black,
      primaryColorDark: Colors.black,
      errorColor: Colors.black,
    ),
  );
}
