package com.phone.dialer.dialer_app.receivers

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.phone.dialer.dialer_app.helpers.ACCEPT_CALL
import com.phone.dialer.dialer_app.helpers.CallManager
import com.phone.dialer.dialer_app.helpers.DECLINE_CALL


class CallActionReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        when (intent.action) {
            ACCEPT_CALL -> {
                CallManager.accept()
            }
            DECLINE_CALL -> CallManager.reject()
        }
    }
}


