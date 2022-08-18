package com.phone.dialer.dialer_app.services
import android.annotation.TargetApi
import android.os.Build
import android.telecom.Connection



@TargetApi(Build.VERSION_CODES.M)
class CallConnection : Connection() {


    override fun onShowIncomingCallUi() {}

}
