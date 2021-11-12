package com.phone.dialer.dialer_app.models

import android.telecom.PhoneAccountHandle

data class SIMAccount(val id: Int, val handle: PhoneAccountHandle, val label: String, val phoneNumber: String)
