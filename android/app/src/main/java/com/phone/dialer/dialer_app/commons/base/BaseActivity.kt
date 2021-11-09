package com.phone.dialer.dialer_app.commons.base

import androidx.appcompat.app.AppCompatActivity
import com.phone.dialer.dialer_app.commons.events.SingleLiveEvent
import com.phone.dialer.dialer_app.commons.events.UiEvent

abstract class BaseActivity : AppCompatActivity() {


    /**
     * Event that can be received in every activity that extends [BaseActivity]
     */
    val uiEvent = SingleLiveEvent<UiEvent>()

}