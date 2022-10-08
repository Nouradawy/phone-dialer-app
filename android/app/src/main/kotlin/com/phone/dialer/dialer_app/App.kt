package com.phone.dialer.dialer_app

import android.annotation.SuppressLint
import android.app.Application

class App : Application() {
    override fun onCreate() {
        super.onCreate()
        registerActivityLifecycleCallbacks(LifecycleDetector.activityLifecycleCallbacks)
    }
}