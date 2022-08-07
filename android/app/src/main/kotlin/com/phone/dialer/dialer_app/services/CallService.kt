package com.phone.dialer.dialer_app.services

import android.app.PendingIntent
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.telecom.Call
import android.telecom.InCallService
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import com.phone.dialer.dialer_app.MyStreamHandler
import com.phone.dialer.dialer_app.R
import com.phone.dialer.dialer_app.activities.CallActivity
import com.phone.dialer.dialer_app.eventSink
import com.phone.dialer.dialer_app.helpers.CallManager


var PhoneID : String? = null

class CallService : InCallService() {

    val callListener = object : Call.Callback() {
                        override fun onStateChanged(call: Call?, state: Int) {
                            super.onStateChanged(call, state)
                            when (state) {

                                /** Device call state: No activity.  */
                                /** Device call state: Off-hook. At least one call exists
                                 * that is dialing, active, or on hold, and no calls are ringing
                                 * or waiting. */
                                Call.STATE_DISCONNECTED -> {
                                    println("Iam disconnected")
                                    eventSink!!.success(MyStreamHandler.PhoneCallEvent(PhoneID, "disconnected", state).toMap())
                                }
                                /** Device call state: Ringing. A new call arrived and is
                                 * ringing or waiting. In the latter case, another call is
                                 * already active.  */
                                Call.STATE_DIALING -> {
                                    println("DialingState-MainMethod")
                                    println("accountHandle : " + CallManager.call?.details?.accountHandle.toString())
                                    println("Extras : " + CallManager.call?.details?.intentExtras?.toString())
                                    println("state : " + CallManager.call?.state.toString())

                                    eventSink!!.success(MyStreamHandler.PhoneCallEvent(PhoneID, "inbound", state).toMap())
                                }

                                Call.STATE_ACTIVE -> {
                                    println("ActiveState-MainMethod")
                                    eventSink!!.success(MyStreamHandler.PhoneCallEvent(PhoneID, "inbound", state).toMap())
                                }

                                Call.STATE_CONNECTING -> {
                                    println("ConnectingState-MainMethod")
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



//        val fullScreenPendingIntent = PendingIntent.getActivity(this,0,getPackageManager().getLaunchIntentForPackage("com.phone.dialer.dialer_app"),PendingIntent.FLAG_UPDATE_CURRENT)
//        val builder = NotificationCompat
//                .Builder(this, "backgrouund_service_New")
//                .setSmallIcon(R.mipmap.ic_launcher)
//                .setContentTitle("NewCall")
//                .setContentText("Phone is ringing.")
//                .setPriority(NotificationCompat.PRIORITY_HIGH)
//                .setCategory(NotificationCompat.CATEGORY_CALL)
//                .setOngoing(true)
//                .setFullScreenIntent(fullScreenPendingIntent, true);


        PhoneID = CallManager.call?.details?.handle?.toString()?.removeTelPrefix()?.parseCountryCode()
        if (CallManager.call!!.state == Call.STATE_RINGING){
//            with(NotificationManagerCompat.from(this)) {
//                // notificationId is a unique int for each notification that you must define
//                notify(1, builder.build())
//            }

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

class Callcallback {

    companion object {
        fun PhoneRinging(){
            println("it's ringing : " +PhoneID.toString())
            println("accountHandle : " + CallManager.call?.details?.accountHandle?.toString())
            println("callproperties : " + CallManager.call?.details?.callProperties?.toString())
            eventSink!!.success(MyStreamHandler.PhoneCallEvent(PhoneID.toString(), "disconnected", state = Call.STATE_RINGING).toMap())
        }
    }
}

