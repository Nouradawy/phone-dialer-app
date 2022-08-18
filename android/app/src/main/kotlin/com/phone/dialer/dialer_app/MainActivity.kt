package com.phone.dialer.dialer_app


//import com.phone.dialer.dialer_app.services.Callcallback

import android.app.role.RoleManager
import android.content.Context
import android.content.Context.ROLE_SERVICE
import android.content.Intent
import android.os.PowerManager
import android.os.PowerManager.PROXIMITY_SCREEN_OFF_WAKE_LOCK
import android.os.PowerManager.RELEASE_FLAG_WAIT_FOR_NO_PROXIMITY
import android.telecom.Call
import android.telephony.TelephonyManager
import androidx.annotation.NonNull
import com.phone.dialer.dialer_app.activities.CallActivity
import com.phone.dialer.dialer_app.helpers.CallManager
import com.phone.dialer.dialer_app.services.PhoneID
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel


var eventSink : EventChannel.EventSink? = null
class MainActivity : FlutterActivity() {


//    private fun createNotificationChannel() {
//        // Create the NotificationChannel, but only on API 26+ because
//        // the NotificationChannel class is new and not in the support library
//
//            val importance = NotificationManager.IMPORTANCE_DEFAULT
//            val channel = NotificationChannel(
//                "backgrouund_service_New",
//                "backgrouund_service_New",
//                NotificationManager.IMPORTANCE_HIGH).apply {
//                description = "descriptionText"
//            }
//            // Register the channel with the system
//            val manager  =
//                    context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
//            manager.createNotificationChannel(channel)
//
//    }






    // For SIM card, use the getSimSerialNumber()
//---get the SIM card ID---

    private val platform = "NativeBridge"   //MethodChannel  for sending events from flutter to android.
    private  val EVEENT_CHANNEL = "PhoneStatsEvents" //EventChannel for sending events from android to flutter.
    private lateinit var eventChannel : EventChannel


    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        eventChannel = EventChannel(flutterEngine.dartExecutor.binaryMessenger,EVEENT_CHANNEL)
        eventChannel.setStreamHandler(MyStreamHandler(context))

        val binaryMessenger = flutterEngine.dartExecutor.binaryMessenger
        val tm = getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
        val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager

//        if (ContextCompat.checkSelfPermission(context, Manifest.permission.READ_PHONE_NUMBERS) != PackageManager.PERMISSION_GRANTED) {
//            // Permission is not granted
//            // Ask for permision
//            if (ActivityCompat.shouldShowRequestPermissionRationale(this,
//                            android.Manifest.permission.READ_PHONE_NUMBERS)) {
//
//
//            } else {
//                ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.READ_PHONE_NUMBERS), 1)
//            }
//        }
//        else {
//// Permission has already been granted
//        }

//        createNotificationChannel()

        MethodChannel(binaryMessenger, "com.example/background_service").apply {
            setMethodCallHandler { method, result ->
                if (method.method == "startService") {

                    val callbackRawHandle = method.arguments as Long
                    BackgroundService.startService(this@MainActivity, callbackRawHandle)
                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, platform).setMethodCallHandler {

            // Note: this method is invoked on the main thread.
                call, result ->
            val states = call.method
            if (states.equals("num1"))  {

                CallManager.keypad('1')
//                result.success("num1")
//                result.error("unavilable", "faild to Reject", null)
            }
            if (states.equals("num2")) {
                CallManager.keypad('2')
//                result.success("num2")
//                result.error("unavilable", "faild to Reject", null)
            }
            if (states.equals("num3"))  {
                CallManager.keypad('3')
//                result.success("num3")
//                result.error("unavilable", "faild to Reject", null)
            }
            if (states.equals("num4"))  {
                CallManager.keypad('4')
//                result.success("num4")
//                result.error("unavilable", "faild to Reject", null)
            }
            if (states.equals("num5"))  {
                CallManager.keypad('5')
//                result.success("num5")
//                result.error("unavilable", "faild to Reject", null)
            }
            if (states.equals("num6"))  {
                CallManager.keypad('6')
//                result.success("num6")
//                result.error("unavilable", "faild to Reject", null)
            }
            if (states.equals("num7"))  {
                CallManager.keypad('7')
//                result.success("num7")
//                result.error("unavilable", "faild to Reject", null)
            }
            if (states.equals("num8"))  {
                CallManager.keypad('8')
//                result.success("num8")
//                result.error("unavilable", "faild to Reject", null)
            }
            if (states.equals("num9"))  {
                CallManager.keypad('9')
//                result.success("num9")
//                result.error("unavilable", "faild to Reject", null)

            }
            if (states.equals("num0"))  {
                CallManager.keypad('0')
//                result.success("num0")
//                result.error("unavilable", "faild to Reject", null)
            }
            if (states.equals("num*"))  {
                CallManager.keypad('*')
//                result.success("num*")
//                result.error("unavilable", "faild to Reject", null)
            }
            if (states.equals("num#"))  {
                CallManager.keypad('#')
//                result.success("num#")
//                result.error("unavilable", "faild to Reject", null)
            }
            if (states.equals("RejectCall"))  {
                CallManager.reject()
//                    result.success("RejectCallMethodSuccess")
//                    result.error("unavilable", "faild to Reject", null)
                    }

            if (states.equals("AcceptCall")) {
                CallManager.accept()
//                    result.success("AcceptCallMethodSuccess")
//                    result.error("unavilable", "faild to Reject", null)
                }
            if (states.equals("MicToggle")) {
                CallActivity.toggleMicrophone()
//                    result.success("MICtoggle")
//                    result.error("unavilable", "faild to Reject", null)
                }
            if (states.equals("SpeakerToggle")){
                CallActivity.toggleSpeaker()
//                    result.success("SpeakerToggle")
//                    result.error("unavilable", "faild to Reject", null)
                }
            if (states.equals("HoldToggle")) {
                CallActivity.toggleHold()
//                    result.success("CallOnHold")
//                    result.error("unavilable", "faild to Reject", null)
                }
            if (states.equals("GetCallList")) {
                CallManager.getCalls()
//                    result.success("CallOnHold")
//                    result.error("unavilable", "faild to Reject", null)
                }
            if (states.equals("sendToBackground")) {
                moveTaskToBack(true)
                result.success(null)
//                    result.success("CallOnHold")
//                    result.error("unavilable", "faild to Reject", null)
                }
            if (states.equals("FlutterStart")) {

                if(CallManager.call!!.state == Call.STATE_RINGING) {
                    println("it's ringing from invoed method : " + PhoneID.toString())
                    eventSink!!.success(MyStreamHandler.PhoneCallEvent(PhoneID.toString(), "disconnected", state = Call.STATE_RINGING).toMap())
                }

                if(CallManager.call!!.state == Call.STATE_ACTIVE) {
                    println("it's ringing from invoed method : " + PhoneID.toString())
                    eventSink!!.success(MyStreamHandler.PhoneCallEvent(PhoneID.toString(), "inbound", state = Call.STATE_ACTIVE).toMap())
                }

            }
            if(states.equals("ScreenOff"))
                {
                    powerManager.newWakeLock(PROXIMITY_SCREEN_OFF_WAKE_LOCK,"myapp:Screenon").acquire()
                }
            if(states.equals("ScreenOn"))
            {
                powerManager.newWakeLock(RELEASE_FLAG_WAIT_FOR_NO_PROXIMITY,"myapp:Screenon").release()
            }
            if(states.equals("conference"))
            {
                CallManager.CreateConfrence()

            }
            if(states.equals("Swapconference"))
            {
                CallManager.SwapConfrence()

            }
            if(states.equals("Mergconference"))
            {
                CallManager.MergeConfrence()

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


    data class PhoneCallEvent(var phoneNumber: String?, val type: String? , val state : Int?) {
        fun toMap(): Map<String, String?> {
            val map = mutableMapOf<String, String?>()
            map["phoneNumber"] = phoneNumber
            map["state"] = CallManager.stateToString(state!!)
            map["type"] = type
            return map
        }
    }
}




