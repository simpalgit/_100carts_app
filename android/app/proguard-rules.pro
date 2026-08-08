# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Google Play Core (Fix R8 missing classes error)
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }

# Add your project specific ProGuard rules here.
