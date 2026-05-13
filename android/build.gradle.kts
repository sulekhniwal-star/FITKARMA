allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

subprojects {
    val configureNamespace: Project.() -> Unit = {
        val isAndroid = plugins.hasPlugin("com.android.application") || 
                        plugins.hasPlugin("com.android.library")
        if (isAndroid) {
            extensions.configure<com.android.build.gradle.BaseExtension> {
                if (namespace == null) {
                    namespace = group.toString().takeIf { it.isNotEmpty() } 
                                ?: "com.example.${name.replace("-", ".")}"
                }
            }
        }
    }
    if (state.executed) {
        configureNamespace()
    } else {
        afterEvaluate { configureNamespace() }
    }
}
