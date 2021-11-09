package com.phone.dialer.dialer_app.services

import android.telecom.Call
import android.telecom.CallScreeningService
import com.phone.dialer.dialer_app.End_Call
import com.phone.dialer.dialer_app.RejectCall
import com.phone.dialer.dialer_app.commons.FORBIDDEN_PHONE_CALL_NUMBER
import com.phone.dialer.dialer_app.commons.events.MessageEvent
import com.phone.dialer.dialer_app.commons.extensions.parseCountryCode
import com.phone.dialer.dialer_app.commons.extensions.removeTelPrefix
import com.phone.dialer.dialer_app.commons.utils.NotificationManagerImpl
import io.flutter.plugin.common.MethodChannel
import org.greenrobot.eventbus.EventBus

class MyCallScreeningService : CallScreeningService() {
    private val notificationManager = NotificationManagerImpl()

    override fun onScreenCall(callDetails: Call.Details) {
        val phoneNumber = getPhoneNumber(callDetails)
        var response = CallResponse.Builder()
        response = handlePhoneCall(response,phoneNumber)

        respondToCall(callDetails, response.build())
        End_Call = false

    }



    private fun handlePhoneCall(
            response: CallResponse.Builder,
            phoneNumber: String
    ): CallResponse.Builder {
            response.apply {
                if((End_Call)){
                    setRejectCall(true)
                    setDisallowCall(true)
                    setSkipNotification(true)
                    //
                    displayToast(String.format("Rejected call from %s", phoneNumber))
                }
            }

        return response
    }

    private fun getPhoneNumber(callDetails: Call.Details): String {
        return callDetails.handle.toString().removeTelPrefix().parseCountryCode()
    }

    private fun displayToast(message: String) {
        notificationManager.showToastNotification(applicationContext, message)
        EventBus.getDefault().post(MessageEvent(message))
    }

}