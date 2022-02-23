Example usage of `accessibility_test`.

## Theme test

```dart
testTheme(themeData, accessibilityLevel: ThemeAccessibilityLevel.normal);
```

If any text-background pair does not meet a minimum contrast ratio requirement
for given `accessibilityLevel`, the test will fail with details about the issue, eg:

> Contrast ratio of primaryColorLight (Color(0xffbbdefb))
> and primaryTextTheme.bodyLarge?.color (Color(0xffffffff)) is 1.40:1,
> which is not sufficient for specified ThemeAccessibilityLevel.normal.
> ThemeAccessibilityLevel.normal's lowest acceptable contrast ratio is 4.5:1.

# Contrast test

```dart
contrastTest(backgroundColor, textColor, readabilityLevel: ReadabilityLevel.normal);
```

If the contrast ratio of given colors does not meet specified `readabilityLevel` minimum requirement, the test will fails with details about the issue, eg:

> 1.0:1 contrast ratio of Color(0xffffffff) and Color(0xffffffff)
> does not meet minimum acceptable contrast ratio
> for ReadabilityLevel.normal, which is 4.5:1.
