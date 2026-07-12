plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    // The Flutter Gradle Plugin must be applied after the Android Gradle plugin.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.edulearn.student.edulearn_student_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.edulearn.student.edulearn_student_app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

// When android/build.gradle.kts redirects outputs outside OneDrive, Flutter still
// looks for APKs under <project>/build/app/outputs/flutter-apk/.
val flutterApkOutputDir =
    rootProject.projectDir.parentFile.resolve("build/app/outputs/flutter-apk")

tasks.configureEach {
    if (name == "assembleDebug" || name == "assembleRelease") {
        doLast {
            val sourceDir =
                layout.buildDirectory.dir("outputs/flutter-apk").get().asFile
            if (!sourceDir.isDirectory) return@doLast
            flutterApkOutputDir.mkdirs()
            sourceDir.listFiles()?.filter { it.extension == "apk" }?.forEach { apk ->
                apk.copyTo(flutterApkOutputDir.resolve(apk.name), overwrite = true)
            }
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_11
    }
}
