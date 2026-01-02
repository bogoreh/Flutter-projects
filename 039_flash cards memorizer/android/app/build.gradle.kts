plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.flash"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

  defaultConfig {
        applicationId "com.yourcompany.flashcardmemorizer" // Change this!
        minSdkVersion 21 // Minimum Android version
        targetSdkVersion 34 // Should match compileSdkVersion
        versionCode 1 // Increase this for each release
        versionName "1.0.0" // Version name for users
    }
    
    buildTypes {
        release {
            // Add these lines for release build
            signingConfig signingConfigs.debug // Temporary - change for production
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}

flutter {
    source = "../.."
}
