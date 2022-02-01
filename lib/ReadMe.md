Project start date = 11Nov 2021

ChangeLog

android/app/src/main/AndroidManifest.xml added activity android:exported="true" to run over 32 SDK

build.gradel (android/app/build.gradle) adding workruntime as debendances
//    implementation 'androidx.work:work-runtime:2.7.1'
    implementation 'androidx.work:work-runtime-ktx:2.7.1'

    and updating SDK version from 31 to 32