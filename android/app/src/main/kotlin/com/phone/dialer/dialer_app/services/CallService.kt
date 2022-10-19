package com.phone.dialer.dialer_app.services

import android.annotation.TargetApi
import android.app.ActivityManager
import android.app.PendingIntent
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.telecom.Call
import android.telecom.InCallService
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import com.phone.dialer.dialer_app.MyStreamHandler
import com.phone.dialer.dialer_app.R
import com.phone.dialer.dialer_app.eventSink
import com.phone.dialer.dialer_app.helpers.CallManager


var PhoneID : String? = null

class CallService : InCallService() {

//    fun isUserIsOnHomeScreen(): String {
//        val manager: ActivityManager = this.getSystemService(InCallService.ACTIVITY_SERVICE) as ActivityManager
//        val processes: MutableList<ActivityManager.AppTask>? = manager.
//        if (processes != null) {
//            println("LastIndex Process list : "+processes.size)
//            println("LastIndex Process list : "+processes)
//        }
//
//        return "false"
//    }

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
                                    eventSink!!.success(MyStreamHandler.PhoneCallEvent(PhoneID, "false","false", state).toMap())
                                }
                                /** Device call state: Ringing. A new call arrived and is
                                 * ringing or waiting. In the latter case, another call is
                                 * already active.  */
                                Call.STATE_DIALING -> {
                                    println("DialingState-MainMethod")
                                   
                                    eventSink!!.success(MyStreamHandler.PhoneCallEvent(PhoneID, "false","false", state).toMap())
                                }

                                Call.STATE_ACTIVE -> {
                                    println("ActiveState-MainMethod")
                                    println("Confrencelist : " + CallManager.call?.conferenceableCalls?.toString())
                                    println("calls size : " + CallManager.inCallService?.calls?.size?.toString())
                                    for(element in CallManager.inCallService!!.calls)
                                    {
                                        println("Call caps: " + element.details)
                                    }
                                    eventSink!!.success(MyStreamHandler.PhoneCallEvent(PhoneID, "false","false", state).toMap())
                                }

                                Call.STATE_CONNECTING -> {
                                    println("ConnectingState-MainMethod")
                                    eventSink!!.success(MyStreamHandler.PhoneCallEvent(PhoneID, "false","false", state).toMap())
                                }
                                Call.STATE_HOLDING -> {
                                    println("onHold-MainMethod")
                                  eventSink!!.success(MyStreamHandler.PhoneCallEvent(PhoneID, "false","false", state).toMap())
                                }


                            }
                        }
                    }



    @TargetApi(Build.VERSION_CODES.M)
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
//                .setOngoing(false)
//                .setFullScreenIntent(fullScreenPendingIntent, true)
//            .setCategory(NotificationCompat.CATEGORY_CALL)




        PhoneID = CallManager.call?.details?.handle?.toString()?.removeTelPrefix()?.parseCountryCode()
        if (CallManager.call!!.state == Call.STATE_RINGING){
//            with(NotificationManagerCompat.from(this)) {
//                // notificationId is a unique int for each notification that you must define
//                notify(1, builder.build())
//            }

            Callcallback.PhoneRinging("isUserIsOnHomeScreen().toString()")


        }

    }

    @TargetApi(Build.VERSION_CODES.M)
    override fun onCallRemoved(call: Call) {
        super.onCallRemoved(call)
       println(call.details.disconnectCause.toString())

        if(CallManager.inCallService?.calls?.isNotEmpty() == true)
        {
            CallManager.call = CallManager.inCallService?.calls!!.last()
        }


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
        fun PhoneRinging(isHome:String){
            println("it's ringing : " +PhoneID.toString())
            eventSink!!.success(MyStreamHandler.PhoneCallEvent(PhoneID.toString(), if(CallManager.call?.conferenceableCalls?.isEmpty() == true) "false" else "true",isHome, state = Call.STATE_RINGING).toMap())
        }
    }
}

