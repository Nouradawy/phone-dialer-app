package com.phone.dialer.dialer_app.helpers

import android.database.Observable
import android.net.Uri
import android.telecom.Call
import android.telecom.Call.Details
import android.telecom.Conference
import android.telecom.InCallService
import android.telecom.VideoProfile
import android.telecom.CallScreeningService
import android.os.Build
import android.os.Looper
import android.telecom.ConnectionService
import androidx.annotation.RequiresApi

// inspired by https://github.com/Chooloo/call_manage


class CallManager {




    companion object {

        var call: Call? = null
        var inCallService: InCallService? = null

        fun accept() {
            call?.answer(VideoProfile.STATE_AUDIO_ONLY)
        }
//        fun cancel(){
//            if(call!!.state == Call.STATE_DIALING)
//                call!!.disconnect()
//
//        }

        fun reject() {
            if (call != null) {
                if (call!!.state == Call.STATE_RINGING) {
                    call!!.reject(false, null)
                } else {
                    call!!.disconnect()
                }
            }
        }

        fun registerCallback(callback: Call.Callback) {
            call?.registerCallback(callback)
        }

        fun unregisterCallback(callback: Call.Callback) {
            call?.unregisterCallback(callback)
        }


        fun keypad(c: Char) {
            call?.playDtmfTone(c)
            call?.stopDtmfTone()
        }



        fun getCallerID():String {
            val handle = call?.details?.handle?.toString()

            var phoneNumber : String = Uri.decode(handle)
            val uri = Uri.decode(handle)

            if (uri.startsWith("tel:")) {
                    val number = uri.substringAfter("tel:")
                    phoneNumber = number
                }
            return phoneNumber
        }

         fun stateToString(state: Int): String {
            return when (state) {
                Call.STATE_NEW -> "NEW"
                Call.STATE_RINGING -> "RINGING"
                Call.STATE_DIALING -> "DIALING"
                Call.STATE_ACTIVE -> "ACTIVE"
                Call.STATE_HOLDING -> "HOLDING"
                Call.STATE_DISCONNECTED -> "DISCONNECTED"
                Call.STATE_CONNECTING -> "CONNECTING"
                Call.STATE_DISCONNECTING -> "DISCONNECTING"
                Call.STATE_SELECT_PHONE_ACCOUNT -> "SELECT_PHONE_ACCOUNT"
                Call.STATE_SIMULATED_RINGING -> "SIMULATED_RINGING"
                Call.STATE_AUDIO_PROCESSING -> "AUDIO_PROCESSING"
                else -> {"UNKOWN"}
            }
        }



    }

}

class PhoneAccount {
    companion object{
        var ConnectionService : ConnectionService? =null
    }
}
