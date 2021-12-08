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
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StringCodec


var eventSink : EventChannel.EventSink? = null
class MainActivity : FlutterActivity() {
    private val platform = "NativeBridge"
    private  val EVEENT_CHANNEL = "PhoneStatsEvents"
    private lateinit var eventChannel : EventChannel
//    val telephonyManager = context.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
    private var number: String? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        eventChannel = EventChannel(flutterEngine.dartExecutor.binaryMessenger,EVEENT_CHANNEL)
        eventChannel.setStreamHandler(MyStreamHandler(context))





        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, platform).setMethodCallHandler {
            // Note: this method is invoked on the main thread.
                call, result ->
            val states = call.method
                if (states.equals("RejectCall"))  {
                    CallManager.reject()
                    result.success("Done")
                    result.error("unavilable", "faild to Reject", null)
                    }
            if (states.equals("num1"))  {
                    CallManager.keypad('1')
                    result.success("Done")
                    result.error("unavilable", "faild to Reject", null)
                }
            if (states.equals("AcceptCall")) {
                    CallManager.accept()
                    result.success("Done")
                    result.error("unavilable", "faild to Reject", null)
                }
            if (states.equals("MicToggle")) {
                    CallActivity.toggleMicrophone()
                    result.success("Done")
                    result.error("unavilable", "faild to Reject", null)
                }
            if (states.equals("SpeakerToggle")){
                    CallActivity.toggleSpeaker()
                    result.success("Done")
                    result.error("unavilable", "faild to Reject", null)
                }
            if (states.equals("HoldToggle")) {
                    CallActivity.toggleHold()
                    result.success("Done")
                    result.error("unavilable", "faild to Reject", null)
                }
                else  result.notImplemented()
            }

        }
}

class MyStreamHandler(private val context: Context) : EventChannel.StreamHandler {

    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        eventSink = events

    }

    override fun onCancel(arguments: Any?) {

        TODO("Not yet implemented")
    }

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




