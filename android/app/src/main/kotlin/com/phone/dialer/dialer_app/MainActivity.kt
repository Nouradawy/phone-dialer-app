package com.phone.dialer.dialer_app


import android.app.PendingIntent
import android.content.Intent
import androidx.annotation.NonNull
import com.phone.dialer.dialer_app.helpers.CallManager
import com.phone.dialer.dialer_app.receivers.CallActionReceiver
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

var End_Call : Boolean = false
val RejectCall = "RejectCallMethod"


class MainActivity : FlutterActivity() {




    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

//        fun GetBatteryLevel(): Int {
//            val batteryLevel: Int
//            if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
//                val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
//                batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
//            } else {
//                val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
//                batteryLevel = intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
//            }
//
//            return batteryLevel
//        }


        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, RejectCall).setMethodCallHandler {
            // Note: this method is invoked on the main thread.
                call, result ->
            if (call.method.equals("EndCall"))
                {
                    CallManager.reject()
                    result.success("test")
                    result.error("unavilable", "faild to Reject", null)

                }
                else {
                    End_Call = false
                result.notImplemented()

            }
        }



    }



}


