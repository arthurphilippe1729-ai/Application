kts
plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
}

android {
    namespace = "com.example.todo_schedule"
    compileSdk = 34

    defaultConfig {
        applicationId = "com.example.todo_schedule"
        minSdk = 21
        targetSdk = 34
        versionCode = 1
        versionName = "0.1.0"
        ndkVersion = "27.0.12077973"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
        debug {
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }

    packagingOptions {
        resources.excludes += "/META-INF/{AL2.0,LGPL2.1}"
    }

    buildFeatures { buildConfig = true }
}

dependencies {
    implementation(platform("org.jetbrains.kotlin:kotlin-bom:2.0.10"))
}