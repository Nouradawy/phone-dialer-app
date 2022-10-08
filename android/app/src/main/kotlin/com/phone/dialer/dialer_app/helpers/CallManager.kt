package com.phone.dialer.dialer_app.helpers

import android.annotation.TargetApi
import android.database.Observable
import android.net.Uri
import android.telecom.Call.Details
import android.os.Build
import android.os.Looper
import android.telecom.*
import android.telecom.Call.Details.PROPERTY_CONFERENCE
import androidx.annotation.RequiresApi
import com.phone.dialer.dialer_app.MyStreamHandler
import com.phone.dialer.dialer_app.eventSink
import com.phone.dialer.dialer_app.services.CallService
import com.phone.dialer.dialer_app.services.PhoneID


// inspired by https://github.com/Chooloo/call_manage


class CallManager {
    companion object {

        var call: Call? = null
        var inCallService: InCallService? = null
        var conference : Conference? = null

        fun accept() {
            call?.answer(VideoProfile.STATE_AUDIO_ONLY)
        }
//        fun cancel(){
//            if(call!!.state == Call.STATE_DIALING)
//                call!!.disconnect()
//
//        }
        fun reject() {
            if (call != null) {
                if (call!!.state == Call.STATE_RINGING) {
                    call!!.reject(false, null)
                } else {
                    call!!.disconnect()
                }
            }
        }

        fun registerCallback(callback: Call.Callback) {
            call?.registerCallback(callback)
        }

        fun unregisterCallback(callback: Call.Callback) {
            call?.unregisterCallback(callback)
        }




        @TargetApi(Build.VERSION_CODES.M)
        fun CreateConfrence()
        {
            for(element in inCallService!!.calls)
            {

                if(element.state == Call.STATE_HOLDING)
                {
                        call?.conference(element)



                }
            }

            for(element in inCallService!!.calls)
            {

                if(element.details.hasProperty(PROPERTY_CONFERENCE))
                {
                    eventSink!!.success(MyStreamHandler.PhoneCallEvent(PhoneID.toString(), if(call?.conferenceableCalls?.isEmpty() == true) "false" else "true", Call.STATE_NEW).toMap())
                }
            }


        }


        @TargetApi(Build.VERSION_CODES.M)
        fun SwapConfrence()
        {
            for(element in inCallService!!.calls)
            {

                if(element.details.hasProperty(PROPERTY_CONFERENCE))
                {
                    element.hold()
                    element.swapConference()
                }
            }
//            inCallService?.calls?.get(inCallService!!.calls.size-2)?.hold()
//            inCallService?.calls?.get(inCallService!!.calls.size-2)?.swapConference()

            println("SwapCalls Trial initiated????")
        }


        @TargetApi(Build.VERSION_CODES.M)
        fun MergeConfrence(){
            for(element in inCallService!!.calls)
            {
                if(element.details.hasProperty(PROPERTY_CONFERENCE))
                {
                    element.conference(inCallService?.calls?.get(inCallService!!.calls.size-1))
                    inCallService?.calls?.get(inCallService!!.calls.size-1)?.mergeConference()
                }
            }
//            inCallService?.calls?.get(inCallService!!.calls.size-2)?.conference(inCallService?.calls?.get(inCallService!!.calls.size-1))
//            inCallService?.calls?.get(inCallService!!.calls.size-1)?.mergeConference()
            println("Merge Trial initiated????")
        }
        fun keypad(c: Char) {
            call?.playDtmfTone(c)
            call?.stopDtmfTone()
        }

        fun getCalls(){
            println("List of calls = "+call?.getConferenceableCalls().toString())
        }


        fun getCallerID():String {
            val handle = call?.details?.handle?.toString()

            var phoneNumber : String = Uri.decode(handle)
            val uri = Uri.decode(handle)

            if (uri.startsWith("tel:")) {
                val number = uri.substringAfter("tel:")
                phoneNumber = number
            }
            return phoneNumber
        }

        fun stateToString(state: Int): String {
            return when (state) {
                Call.STATE_NEW -> "NEW"
                Call.STATE_RINGING -> "RINGING"
                Call.STATE_DIALING -> "DIALING"
                Call.STATE_ACTIVE -> "ACTIVE"
                Call.STATE_HOLDING -> "HOLDING"
                Call.STATE_DISCONNECTED -> "DISCONNECTED"
                Call.STATE_CONNECTING -> "CONNECTING"
                Call.STATE_DISCONNECTING -> "DISCONNECTING"
                Call.STATE_SELECT_PHONE_ACCOUNT -> "SELECT_PHONE_ACCOUNT"
                Call.STATE_SIMULATED_RINGING -> "SIMULATED_RINGING"
                Call.STATE_AUDIO_PROCESSING -> "AUDIO_PROCESSING"
                else -> {"UNKOWN"}
            }
        }



    }

}

class PhoneAccount {
    companion object{
        var ConnectionService : ConnectionService? =null
    }
}