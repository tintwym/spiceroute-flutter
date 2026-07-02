pluginManagement {
    val flutterSdkPath =
        run {
            val properties = java.util.Properties()
            file("local.properties").inputStream().use { properties.load(it) }
            val flutterSdkPath = properties.getProperty("flutter.sdk")
            require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
            flutterSdkPath
        }

    // iCloud Desktop sync copies build artifacts as `Foo 2.png` /
    // `Foo 2.class`, which breaks Gradle resource parsing and Kotlin
    // incremental hashing.
    run {
        fun purgeIcloudDuplicates(dir: java.io.File) {
            if (!dir.isDirectory) return
            dir.walkTopDown()
                .filter { it.isFile && (it.name.contains(" 2.") || it.name.contains(" 3.")) }
                .forEach { it.delete() }
        }
        purgeIcloudDuplicates(settings.rootDir.parentFile.resolve("build"))
        val gradleModule = file("$flutterSdkPath/packages/flutter_tools/gradle")
        purgeIcloudDuplicates(gradleModule.resolve("build"))
        purgeIcloudDuplicates(gradleModule.resolve(".gradle"))
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.11.1" apply false
    id("org.jetbrains.kotlin.android") version "2.2.20" apply false
}

include(":app")
