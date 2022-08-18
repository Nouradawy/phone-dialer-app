package com.phone.dialer.dialer_app.activities

import android.telecom.CallAudioState
import com.phone.dialer.dialer_app.helpers.CallManager

class CallActivity {

    companion object {
        private var isSpeakerOn = false
        private var isMicrophoneOn = true
        private var isHold = false


        fun toggleSpeaker() {

            isSpeakerOn = !isSpeakerOn
            val newRoute = if (isSpeakerOn) CallAudioState.ROUTE_SPEAKER else CallAudioState.ROUTE_EARPIECE
            CallManager.inCallService?.setAudioRoute(newRoute)
        }

        fun toggleMicrophone() {
            isMicrophoneOn = !isMicrophoneOn
            CallManager.inCallService?.setMuted(!isMicrophoneOn)
        }



        fun toggleHold(){
            isHold = !isHold
            if(isHold == true)
            {
                CallManager.call?.unhold()
            } else {
                CallManager.call?.hold()
            }

        }
    }



}
