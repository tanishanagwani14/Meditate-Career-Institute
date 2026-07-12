allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// On Windows, projects inside OneDrive often fail to clean/build because files
// in `build/` are held open by sync/AV/indexers. Write build outputs outside
// the OneDrive-managed folder when possible.
val projectPathLower = rootProject.projectDir.absolutePath.lowercase()
val outsideOneDriveBuildDir: Directory? =
    if (projectPathLower.contains("\\onedrive\\")) {
        val userHome = System.getProperty("user.home")
        rootProject.layout.buildDirectory
            .dir("$userHome\\AppData\\Local\\classplus_builds\\edulearn_student_app")
            .get()
    } else {
        null
    }

val newBuildDir: Directory =
    (outsideOneDriveBuildDir
        ?: rootProject.layout.buildDirectory.dir("../../build").get())

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
