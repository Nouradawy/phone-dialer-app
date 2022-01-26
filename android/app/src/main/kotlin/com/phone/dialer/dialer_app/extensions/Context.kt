//package com.phone.dialer.dialer_app.extensions
//import android.telecom.PhoneAccountHandle
//import android.annotation.SuppressLint
//import android.content.Context
//import android.media.AudioManager
//import android.net.Uri
//import com.phone.dialer.dialer_app.models.SIMAccount
//
//val Context.config: Config get() = Config.newInstance(applicationContext)
//
//val Context.audioManager: AudioManager get() = getSystemService(Context.AUDIO_SERVICE) as AudioManager
//
//@SuppressLint("MissingPermission")
//fun Context.getAvailableSIMCardLabels(): ArrayList<SIMAccount> {
//    val SIMAccounts = ArrayList<SIMAccount>()
//    try {
//        telecomManager.callCapablePhoneAccounts.forEachIndexed { index, account ->
//            val phoneAccount = telecomManager.getPhoneAccount(account)
//            var label = phoneAccount.label.toString()
//            var address = phoneAccount.address.toString()
//            if (address.startsWith("tel:") && address.substringAfter("tel:").isNotEmpty()) {
//                address = Uri.decode(address.substringAfter("tel:"))
//                label += " ($address)"
//            }
//
//            val SIM = SIMAccount(index + 1, phoneAccount.accountHandle, label, address.substringAfter("tel:"))
//            SIMAccounts.add(SIM)
//        }
//    } catch (ignored: Exception) {
//    }
//    return SIMAccounts
//}
//
//@SuppressLint("MissingPermission")
//fun Context.areMultipleSIMsAvailable(): Boolean {
//    return try {
//        telecomManager.callCapablePhoneAccounts.size > 1
//    } catch (ignored: Exception) {
//        false
//    }
//}
