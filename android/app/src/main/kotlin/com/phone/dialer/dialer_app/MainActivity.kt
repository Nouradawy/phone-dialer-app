package com.phone.dialer.dialer_app

import android.Manifest
import android.content.*
import android.content.pm.PackageManager
import android.os.Bundle
import android.telephony.TelephonyManager
import androidx.annotation.NonNull
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat

import androidx.lifecycle.Observer
import com.phone.dialer.dialer_app.commons.base.BaseActivity
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

import com.phone.dialer.dialer_app.commons.events.*
import com.phone.dialer.dialer_app.commons.utils.CapabilitiesRequestorImpl
import com.phone.dialer.dialer_app.commons.utils.ManifestPermissionRequesterImpl
import com.phone.dialer.dialer_app.services.MyCallScreeningService
import io.flutter.plugin.common.MethodChannel

import org.greenrobot.eventbus.EventBus
import org.greenrobot.eventbus.Subscribe
import org.greenrobot.eventbus.ThreadMode
import pub.devrel.easypermissions.AppSettingsDialog

import java.lang.ref.WeakReference
var End_Call : Boolean = false
val RejectCall = "RejectCallMethod"
class MainActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (ContextCompat.checkSelfPermission(
                this, Manifest.permission.READ_PHONE_STATE
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            ActivityCompat.requestPermissions(
                this,
                arrayOf(Manifest.permission.READ_PHONE_STATE), 369
            )
        }

    }
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
                { End_Call =  true

                    result.success("End_Call set to True")
                    result.error("unavilable", "faild to Reject", null)

                }
                else {
                    End_Call = false
                result.notImplemented()

            }
        }



    }


}


