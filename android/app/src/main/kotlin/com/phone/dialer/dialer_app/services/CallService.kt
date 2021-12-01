package com.phone.dialer.dialer_app.services

import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Telephony
import android.telecom.Call
import android.telecom.InCallService
import android.telephony.PhoneStateListener
import android.telephony.TelephonyCallback
import android.telephony.TelephonyManager
import androidx.annotation.RequiresApi
import com.phone.dialer.dialer_app.MyStreamHandler
import com.phone.dialer.dialer_app.eventSink
import com.phone.dialer.dialer_app.helpers.CallManager
import io.flutter.plugin.common.EventChannel

var PhoneID : String? = null

class CallService : InCallService() {

    val callListener = object : Call.Callback() {
        override fun onStateChanged(call: Call?, state: Int) {
            super.onStateChanged(call, state)
            when (state) {
                /** Device call state: No activity.  */
                Call.STATE_RINGING-> {
                    eventSink!!.success(MyStreamHandler.PhoneCallEvent(PhoneID, "disconnected", state).toMap())
                }
                /** Device call state: Off-hook. At least one call exists
                 * that is dialing, active, or on hold, and no calls are ringing
                 * or waiting. */
                Call.STATE_DISCONNECTED -> {
                    eventSink!!.success(MyStreamHandler.PhoneCallEvent(PhoneID, "disconnected", state).toMap())
                }
                /** Device call state: Ringing. A new call arrived and is
                 * ringing or waiting. In the latter case, another call is
                 * already active.  */
                Call.STATE_DIALING -> {
                    println("heyIt's ringing")
                    eventSink!!.success(MyStreamHandler.PhoneCallEvent(PhoneID, "inbound", state).toMap())
                }
            }
        }
    }
    override fun onCallAdded(call: Call) {

        super.onCallAdded(call)
        CallManager.call = call
        CallManager.inCallService = this
        CallManager.registerCallback(callListener)
        PhoneID = CallManager.call?.details?.handle?.toString()?.removeTelPrefix()?.parseCountryCode()
        if (CallManager.call!!.state == Call.STATE_RINGING){
            Callcallback.PhoneRinging()
        }

    }

    override fun onCallRemoved(call: Call) {
        super.onCallRemoved(call)
        CallManager.call = null
        CallManager.inCallService = null


    }

    override fun onDestroy() {
        super.onDestroy()
        CallManager.unregisterCallback(callListener)
    }
}

fun String.removeTelPrefix() = this.replace("tel:", "")

/**
 * Phone call numbers can contain prefix of country like '+385' and '+' sign will be interpreted
 * like '%2B', so this must be decoded.
 */
fun String.parseCountryCode(): String = Uri.decode(this)

class Callcallback(eventSink: EventChannel.EventSink?) {

    companion object {
        fun PhoneRinging(){
            println("it's ringing")
            eventSink!!.success(MyStreamHandler.PhoneCallEvent(PhoneID, "disconnected", state = Call.STATE_RINGING).toMap())
        }
    }
}