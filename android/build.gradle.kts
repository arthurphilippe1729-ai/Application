kts
plugins {
    id("com.android.application") version "8.5.2" apply false
    id("org.jetbrains.kotlin.android") version "2.0.10" apply false
}

// Ensure Java 17 toolchain for Kotlin
kotlin {
    jvmToolchain(17)
}