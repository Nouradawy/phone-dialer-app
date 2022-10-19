package com.phone.dialer.dialer_app.services

import android.annotation.TargetApi
import android.os.Build
import android.telecom.Call
import android.telecom.CallScreeningService
import com.phone.dialer.dialer_app.BackgroundService
import com.phone.dialer.dialer_app.helpers.CallManager

var BLockList:MutableList<String>  = mutableListOf()

@TargetApi(Build.VERSION_CODES.N)
class MyCallScreeningService : CallScreeningService() {


    @TargetApi(Build.VERSION_CODES.N)
    override fun onScreenCall(callDetails: Call.Details) {
        val phoneNumber = getPhoneNumber(callDetails)
        var response = CallResponse.Builder()
        response = handlePhoneCall(response,phoneNumber)
        respondToCall(callDetails, response.build())
    }

    private fun handlePhoneCall(
        response: CallResponse.Builder,
        phoneNumber: String
    ): CallResponse.Builder {

        response.apply {
            for(element in BLockList) {
                if (phoneNumber == element) {
                    setDisallowCall(true)
                    setSkipCallLog(true)
                }
            }
        }
        return response
    }

    private fun getPhoneNumber(callDetails: Call.Details): String {
        return callDetails.handle.toString().removeTelPrefix().parseCountryCode()
    }



}