import 'package:accessibility_test/src/contrast_test.dart';
import 'package:accessibility_test/src/wcag_21_guidelines.dart';
import 'package:flutter/material.dart';
import 'package:test/test.dart';
import 'package:tuple/tuple.dart';

void main() {
  test('Calculates correct contrast values', () {
    const maxContrast = 21;
    const minContrast = 1;

    final testCases = [
      // Tuple3(backgroundColors, textColor, expectedContrast)
      const Tuple3(Colors.black, Colors.white, maxContrast),
      const Tuple3(Colors.white, Colors.black, maxContrast),
      Tuple3(Colors.white.withOpacity(0.5), Colors.black, maxContrast / 2),
      Tuple3(Colors.white, Colors.black.withOpacity(0.5), maxContrast / 2),
      const Tuple3(Colors.black, Colors.black, minContrast),
      const Tuple3(Colors.white, Colors.white, minContrast),
    ];

    for (final testCase in testCases) {
      final contrast = calculateContrast(testCase.item1, testCase.item2);
      expect(
        contrast,
        closeTo(
          testCase.item3,
          0.05 /* Providing delta value for binary-decimal errors */,
        ),
        reason: 'Calculated contrast of ${testCase.item1} (bg) and'
            '${testCase.item2} (fg) was $contrast:1.'
            'Expected ${testCase.item3}:1.',
      );
    }
  });

  test(
    'doesMatchMinContrastRatio returns false when given ratio'
    'does not reach required value',
    () {
      const maxContrast = 21;
      const minContrast = 1;
      final testCases = [
        // Tuple3(contrastRatio, accessibilityLevel, expectedResponse)
        const Tuple3(maxContrast, ReadabilityLevel.normal, true),
        const Tuple3(maxContrast, ReadabilityLevel.normalLargeText, true),
        const Tuple3(maxContrast, ReadabilityLevel.high, true),
        const Tuple3(maxContrast, ReadabilityLevel.highLargeText, true),
        const Tuple3(minContrast, ReadabilityLevel.normal, false),
        const Tuple3(minContrast, ReadabilityLevel.normalLargeText, false),
        const Tuple3(minContrast, ReadabilityLevel.high, false),
        const Tuple3(minContrast, ReadabilityLevel.highLargeText, false),
        const Tuple3(Wcag2Guidelines.aaBodyTextContrastRatio,
            ReadabilityLevel.normal, true),
        const Tuple3(Wcag2Guidelines.aaLargeTextContrastRatio,
            ReadabilityLevel.normalLargeText, true),
        const Tuple3(Wcag2Guidelines.aaaBodyTextContrastRatio,
            ReadabilityLevel.high, true),
        const Tuple3(Wcag2Guidelines.aaaLargeTextContrastRatio,
            ReadabilityLevel.highLargeText, true),
        const Tuple3(Wcag2Guidelines.aaBodyTextContrastRatio - .1,
            ReadabilityLevel.normal, false),
        const Tuple3(Wcag2Guidelines.aaLargeTextContrastRatio - .1,
            ReadabilityLevel.normalLargeText, false),
        const Tuple3(Wcag2Guidelines.aaaBodyTextContrastRatio - .1,
            ReadabilityLevel.high, false),
        const Tuple3(Wcag2Guidelines.aaaLargeTextContrastRatio - .1,
            ReadabilityLevel.highLargeText, false),
      ];

      for (final testCase in testCases) {
        final doesMatch = doesMatchMinContrastRatio(testCase.item1,
            readabilityLevel: testCase.item2);

        final contrastRating = doesMatch ? 'above' : 'below';
        expect(
          doesMatch,
          equals(testCase.item3),
          reason: '${testCase.item1}:1 was considered $contrastRating minimum '
              'acceptable contrast ratio for ${testCase.item2} when it should not.',
        );
      }
    },
  );

  test(
      'Throws assertion error when colors does not meet min contrast ratio for given accessibility level',
      () {
    final testCases = [
      // Tuple4(backgroundColors, textColor, accessibilityLevel, shouldThrow)
      const Tuple4(Colors.black, Colors.white, ReadabilityLevel.normal, false),
      const Tuple4(
          Colors.black, Colors.white, ReadabilityLevel.normalLargeText, false),
      const Tuple4(Colors.black, Colors.white, ReadabilityLevel.high, false),
      const Tuple4(
          Colors.black, Colors.white, ReadabilityLevel.highLargeText, false),
      const Tuple4(Colors.white, Colors.white, ReadabilityLevel.normal, true),
      const Tuple4(
          Colors.white, Colors.white, ReadabilityLevel.normalLargeText, true),
      const Tuple4(Colors.white, Colors.white, ReadabilityLevel.high, true),
      const Tuple4(
          Colors.white, Colors.white, ReadabilityLevel.highLargeText, true),
    ];

    for (final testCase in testCases) {
      if (testCase.item4) {
        expect(
          () => runContrastTest(testCase.item1, testCase.item2,
              readabilityLevel: testCase.item3),
          throwsA(isA<AssertionError>()),
          reason:
              'Assertion error not thrown for colors (${testCase.item1}, ${testCase.item2}) '
              'with contrast ratio lower than minimum acceptable value.',
        );
      } else {
        expect(
            () => runContrastTest(testCase.item1, testCase.item2,
                readabilityLevel: testCase.item3),
            returnsNormally,
            reason:
                'Assertion error thrown for colors (${testCase.item1}, ${testCase.item2}) '
                'with contrast ratio above minimum acceptable value.');
      }
    }
  });

  contrastTest(
    'Readable contrast passes contrastTest of ReadabilityLevel.normal',
    Colors.black,
    Colors.white,
    readabilityLevel: ReadabilityLevel.normal,
  );
  contrastTest(
    'Readable contrast passes contrastTest of ReadabilityLevel.normalLargeText',
    Colors.black,
    Colors.white,
    readabilityLevel: ReadabilityLevel.normalLargeText,
  );
  contrastTest(
    'Readable contrast passes contrastTest of ReadabilityLevel.high',
    Colors.black,
    Colors.white,
    readabilityLevel: ReadabilityLevel.high,
  );
  contrastTest(
    'Readable contrast passes contrastTest of ReadabilityLevel.highLargeText',
    Colors.black,
    Colors.white,
    readabilityLevel: ReadabilityLevel.highLargeText,
  );
}
