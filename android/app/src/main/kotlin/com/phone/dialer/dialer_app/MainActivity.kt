package com.phone.dialer.dialer_app
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.location.GnssAntennaInfo
import android.provider.ContactsContract
import android.provider.Telephony
import android.telecom.Call
import android.telecom.InCallService
import android.telephony.TelephonyCallback
import android.telephony.TelephonyManager

import androidx.annotation.NonNull
import androidx.constraintlayout.motion.widget.Debug.getState
import com.phone.dialer.dialer_app.activities.CallActivity

import com.phone.dialer.dialer_app.helpers.CallManager
import com.phone.dialer.dialer_app.helpers.CallManager.Companion.getState
//import com.phone.dialer.dialer_app.services.Callcallback
import com.phone.dialer.dialer_app.services.PhoneID

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel


var eventSink : EventChannel.EventSink? = null
class MainActivity : FlutterActivity() {
    val RejectCall = "RejectCallMethod"
    val getdailpad = "Dialpad"
    val Answer = "answer"
    val TMic = "toMic"
    val TSpeaker = "toSpeaker"
    val THold = "toHold"
    private  val EVEENT_CHANNEL = "PhoneStatsEvents"
    private lateinit var eventChannel : EventChannel
//    val telephonyManager = context.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
    private var number: String? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        eventChannel = EventChannel(flutterEngine.dartExecutor.binaryMessenger,EVEENT_CHANNEL)
        eventChannel.setStreamHandler(MyStreamHandler(context))




        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, RejectCall).setMethodCallHandler {
            // Note: this method is invoked on the main thread.
                call, result ->
            if (call.method.equals("EndCall"))
                {
                    CallManager.reject()
//                    MethodChannel(flutterEngine.dartExecutor.binaryMessenger,RejectCall).setMethodCallHandler(null)
                    result.success("Done")
//                    result.success(CallManager.cancel())
                    result.error("unavilable", "faild to Reject", null)

                }
                else {
                result.notImplemented()

            }
        }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, getdailpad).setMethodCallHandler {
            // Note: this method is invoked on the main thread.
                call, result ->
            if (call.method.equals("Dialpad"))
                {
                    CallManager.keypad('1')
//                    MethodChannel(flutterEngine.dartExecutor.binaryMessenger,getdailpad).setMethodCallHandler(null)
                    result.success("Done")
//                    result.success(CallManager.cancel())
                    result.error("unavilable", "faild to Reject", null)

                }
                else {
                result.notImplemented()

            }
        }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, Answer).setMethodCallHandler {
            // Note: this method is invoked on the main thread.
                call, result ->
            if (call.method.equals("answer"))
                {
                    CallManager.accept()
//                    MethodChannel(flutterEngine.dartExecutor.binaryMessenger,Answer).setMethodCallHandler(null)
                    result.success("Done")
//                    result.success(CallManager.cancel())
                    result.error("unavilable", "faild to Reject", null)

                }
                else {
                result.notImplemented()

            }
        }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, TMic).setMethodCallHandler {
            // Note: this method is invoked on the main thread.
                call, result ->
            if (call.method.equals("toMic"))
                {
                    CallActivity.toggleMicrophone()
//                    MethodChannel(flutterEngine.dartExecutor.binaryMessenger,Answer).setMethodCallHandler(null)
                    result.success("Done")
//                    result.success(CallManager.cancel())
                    result.error("unavilable", "faild to Reject", null)

                }
                else {
                result.notImplemented()

            }
        }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, TSpeaker).setMethodCallHandler {
            // Note: this method is invoked on the main thread.
                call, result ->
            if (call.method.equals("toSpeaker"))
                {
                    CallActivity.toggleSpeaker()
//                    MethodChannel(flutterEngine.dartExecutor.binaryMessenger,Answer).setMethodCallHandler(null)
                    result.success("Done")
//                    result.success(CallManager.cancel())
                    result.error("unavilable", "faild to Reject", null)

                }
                else {
                result.notImplemented()

            }
        }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, THold).setMethodCallHandler {
            // Note: this method is invoked on the main thread.
                call, result ->
            if (call.method.equals("toHold"))
                {
                    CallActivity.toggleHold()
//                    MethodChannel(flutterEngine.dartExecutor.binaryMessenger,Answer).setMethodCallHandler(null)
                    result.success("Done")
//                    result.success(CallManager.cancel())
                    result.error("unavilable", "faild to Reject", null)

                }
                else {
                result.notImplemented()

            }
        }



    }



}

class MyStreamHandler(private val context: Context) : EventChannel.StreamHandler {
//private var receiver : BroadcastReceiver? = null
    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        eventSink = events
//        CallManager.registerCallback(Callcallback.callListener)
//        receiver = initReceiver(events)
//        context.registerReceiver(receiver, IntentFilter())
    }

    override fun onCancel(arguments: Any?) {
//        context.unregisterReceiver(receiver)
//        receiver = null
        TODO("Not yet implemented")
    }

//    private fun initReceiver(events:EventChannel.EventSink):BroadcastReceiver{
//        return object : BroadcastReceiver(){
//            override fun onReceive(context: Context?, intent: Intent?) {
//
//                when (statev) {
//                    /** Device call state: No activity.  */
//                    Call.STATE_NEW -> events.success("STATE_NEW")
//                    /** Device call state: Off-hook. At least one call exists
//                     * that is dialing, active, or on hold, and no calls are ringing
//                     * or waiting. */
//                    Call.STATE_DISCONNECTED -> events.success("STATE_DISCONNECTED")
//                    /** Device call state: Ringing. A new call arrived and is
//                     * ringing or waiting. In the latter case, another call is
//                     * already active.  */
//                    Call.STATE_RINGING -> events.success("STATE_RINGING")
//                }
//
//
//            }
//        }
//    }
    data class PhoneCallEvent(var phoneNumber: String?, val type: String, val state : Int?) {
        fun toMap(): Map<String, String?> {
            val map = mutableMapOf<String, String?>()
            map["phoneNumber"] = phoneNumber
            map["state"] = CallManager.stateToString(state!!)
            map["type"] = type
            return map
        }
    }
}




