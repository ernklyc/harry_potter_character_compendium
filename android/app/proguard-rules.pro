# Dio için ProGuard kuralları
-keep class io.flutter.plugin.** { *; }
-dontwarn io.flutter.embedding.**

# Retrofit/OkHttp için kurallar
-dontwarn retrofit.**
-keep class retrofit.** { *; }
-keepattributes Signature
-keepattributes Exceptions

# OkHttp
-keepattributes Signature
-keepattributes *Annotation*
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }
-dontwarn okhttp3.**
-dontwarn okio.**

# Model sınıfları için kurallar (JSON serialization)
-keep class com.example.harry_potter_character_compendium.** { *; }
-keep class * implements java.io.Serializable { *; } 