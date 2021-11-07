package com.phone.dialer.dialer_app
import android.Manifest
import android.content.*
import android.content.pm.PackageManager
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.os.Bundle
import android.telecom.Call
import android.telecom.CallScreeningService



import androidx.annotation.NonNull

import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


public
class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?){
        super.onCreate(savedInstanceState)

        if(ContextCompat.checkSelfPermission(
                        this, Manifest.permission.READ_PHONE_STATE
                )!= PackageManager.PERMISSION_GRANTED){
            ActivityCompat.requestPermissions(this,
            arrayOf(Manifest.permission.READ_PHONE_STATE),369)
        }

        if(ContextCompat.checkSelfPermission(
                        this, Manifest.permission.READ_CONTACTS
                )!= PackageManager.PERMISSION_GRANTED){
            ActivityCompat.requestPermissions(this,
                    arrayOf(Manifest.permission.READ_CONTACTS),370)
        }


        if(ContextCompat.checkSelfPermission(
                        this, Manifest.permission.WRITE_CONTACTS
                )!= PackageManager.PERMISSION_GRANTED){
            ActivityCompat.requestPermissions(this,
                    arrayOf(Manifest.permission.WRITE_CONTACTS),371)
        }
    }


    private val CHANNEL = "ReadBatteryMethod"
    private val RejectCall = "RejectCallMethod"


    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)



       fun handlePhoneCall(
           response: CallScreeningService.CallResponse.Builder
       ):CallScreeningService.CallResponse.Builder {
            response.apply { setRejectCall(true) }
           return response
       }



        fun GetBatteryLevel(): Int {
            val batteryLevel: Int
            if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
                val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
                batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
            } else {
                val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
                batteryLevel = intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
            }

            return batteryLevel
        }

//        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
//            // Note: this method is invoked on the main thread.
//            call, result ->
//            if (call.method == "GetBatteryLevel") {
//                val batteryLevel = GetBatteryLevel()
//
//                if (batteryLevel != -1) {
//                    result.success(batteryLevel)
//                } else {
//                    result.error("UNAVAILABLE", "Battery level not available.", null)
//                }
//            } else {
//                result.notImplemented()
//            }
//        }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, RejectCall).setMethodCallHandler {
            // Note: this method is invoked on the main thread.
            call, result ->
            if (call.method == "RejectCallA") {
                val response = CallScreeningService.CallResponse.Builder()
                result.success(handlePhoneCall(response.build()))
                result.error("unavilable","faild to Reject",null)
            } else {
                result.notImplemented()
            }
        }


    }



}

