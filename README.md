Accessibility testing library for automated app tests.
Use `themeTest()` and `contrastTest()` functions to make sure that your app
does meet minimum required contrast ratio values to be accessible for wide
range of people. Implemented contrast ratio rules follow [the WCAG 2.1 standard](https://www.w3.org/TR/WCAG21/).

## Usage

Check an entire theme data your app uses:

```dart
themeTest(
  'Theme accessibility test',
  themeData,
  accessibilityLevel: ThemeAccessibilityLevel.normal,
);
```

If any text-background pair does not meet a minimum contrast ratio requirement
for given `accessibilityLevel`, the test will fail with details about the issue, eg:

> Contrast ratio of primaryColorLight (Color(0xffbbdefb))
> and primaryTextTheme.bodyLarge?.color (Color(0xffffffff)) is 1.40:1,
> which is not sufficient for specified ThemeAccessibilityLevel.normal.
> ThemeAccessibilityLevel.normal's lowest acceptable contrast ratio is 4.5:1.

Available theme accessibility levels:

- normal - for regular apps ([level AA WCAG 2.1](https://www.w3.org/TR/WCAG21/#contrast-minimum)),
- high - for high-availability solutions, like government apps ([level AAA WCAG 2.1](https://www.w3.org/TR/WCAG21/#contrast-enhanced)).

### Contrast test

It is possible to create tests for specific background-text color combos:

```dart
contrastTest(
  'Contrast readability test',
  backgroundColor,
  textColor,
  readabilityLevel: ReadabilityLevel.normal,
);
```

If the contrast ratio of given colors does not meet specified `readabilityLevel` minimum requirement, the test will fails with details about the issue, eg:

> 1.0:1 contrast ratio of Color(0xffffffff) and Color(0xffffffff)
> does not meet minimum acceptable contrast ratio
> for ReadabilityLevel.normal, which is 4.5:1.

Available theme accessibility levels:

- normal - meant for text used as a body of a document ([level AA WCAG 2.1](https://www.w3.org/TR/WCAG21/#contrast-minimum)),
- normalLargeText - meant for text used as a title of a document or other headers ([level AA WCAG 2.1](https://www.w3.org/TR/WCAG21/#contrast-minimum) for large text),
- high - meant for text used as a body of a document ([level AAA WCAG 2.1](https://www.w3.org/TR/WCAG21/#contrast-enhanced)).
It's demanding design-wise but very accessible,
- normalLargeText - meant for text used as a title
of a document or other headers ([level AAA WCAG 2.1](https://www.w3.org/TR/WCAG21/#contrast-enhanced) for large text).
It's demanding design-wise but very accessible.

## Disclaimer

Passing tests included in this library does not make your app ([WCAG 2.1](https://www.w3.org/TR/WCAG21/)) compliant.
This library provides only contrast checks, which is a small fraction of ([WCAG 2.1](https://www.w3.org/TR/WCAG21/)).

Also, there are cases when even passing included tests does not confirm that your app
have proper contrast ratios, since the app can overwrite given color values in runtime
or could not use the theme data provided to the test function at all.

The goal of this package is to make developing ([WCAG 2.1](https://www.w3.org/TR/WCAG21/)) compliant app easier, not automatic.
