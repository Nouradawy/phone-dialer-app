package com.phone.dialer.dialer_app.services

import android.telecom.Call
import android.telecom.InCallService
import com.phone.dialer.dialer_app.helpers.CallManager


class CallService : InCallService() {

//    private val callListener = object : Call.Callback() {
//        override fun onStateChanged(call: Call, state: Int) {
//            super.onStateChanged(call, state)
//            if (state != Call.STATE_DISCONNECTED) {
//                callNotificationManager.setupNotification()
//            }
//
//            if (state == Call.STATE_ACTIVE) {
////                callDurationHelper.start()
//            } else if (state == Call.STATE_DISCONNECTED || state == Call.STATE_DISCONNECTING) {
//                callDurationHelper.cancel()
//            }
//        }
//    }

    override fun onCallAdded(call: Call) {
        super.onCallAdded(call)
        CallManager.call = call
        CallManager.inCallService = this

    }

    override fun onCallRemoved(call: Call) {
        super.onCallRemoved(call)
        CallManager.call = null
        CallManager.inCallService = null

    }

    override fun onDestroy() {
        super.onDestroy()

    }
}
