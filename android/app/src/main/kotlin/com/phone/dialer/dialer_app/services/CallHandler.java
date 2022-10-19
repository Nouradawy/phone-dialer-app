package com.phone.dialer.dialer_app.services;


import android.content.Context;
import android.os.Build;
import android.os.Bundle;
import android.telecom.Connection;
import android.telecom.ConnectionRequest;
import android.telecom.ConnectionService;
import android.telecom.PhoneAccountHandle;
import android.telecom.TelecomManager;

import androidx.annotation.RequiresApi;

import com.phone.dialer.dialer_app.MainActivity;
import com.phone.dialer.dialer_app.helpers.CallManager;

import io.flutter.Log;

public class CallHandler extends ConnectionService {

    public static final String TAG = CallHandler.class.getName();

    @RequiresApi(api = Build.VERSION_CODES.N_MR1)
    @Override
    public Connection onCreateIncomingConnection(PhoneAccountHandle connectionManagerPhoneAccount, ConnectionRequest request) {

        Context context = getApplicationContext();
        CallConnection callConnection = new CallConnection(context);
        callConnection.setInitializing();
        callConnection.setCallerDisplayName("Manik", TelecomManager.PRESENTATION_ALLOWED);
        callConnection.setActive();

        return callConnection;

    }


    @Override
    public void onCreateIncomingConnectionFailed(PhoneAccountHandle connectionManagerPhoneAccount, ConnectionRequest request) {
        super.onCreateIncomingConnectionFailed(connectionManagerPhoneAccount, request);
    }

    @Override
    public void onCreateOutgoingConnectionFailed(PhoneAccountHandle connectionManagerPhoneAccount, ConnectionRequest request) {
        super.onCreateOutgoingConnectionFailed(connectionManagerPhoneAccount, request);
    }

    @Override
    public Connection onCreateOutgoingConnection(PhoneAccountHandle connectionManagerPhoneAccount, ConnectionRequest request) {
        return super.onCreateOutgoingConnection(connectionManagerPhoneAccount, request);
    }
}
