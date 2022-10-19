package com.phone.dialer.dialer_app.services;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import com.phone.dialer.dialer_app.R;
import com.phone.dialer.dialer_app.activities.CallActivity;
import com.phone.dialer.dialer_app.helpers.CallManager;

import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.media.AudioAttributes;
import android.media.RingtoneManager;
import android.net.Uri;
import android.os.Build;
import android.telecom.Connection;

import androidx.annotation.RequiresApi;
import androidx.core.app.NotificationCompat;


public class CallConnection extends Connection {

    private Context context;

    @RequiresApi(api = Build.VERSION_CODES.N_MR1)
    public CallConnection(Context con) {
        context = con;
        setConnectionProperties(PROPERTY_SELF_MANAGED);
    }

    @Override
    public void onAnswer() {
        CallManager.Companion.accept();


    }

    @Override
    public void onReject() {
        CallManager.Companion.reject();

    }

    @Override
    public void onDisconnect() {
        CallManager.Companion.reject();

    }


    @Override
    public void onShowIncomingCallUi() {

        super.onShowIncomingCallUi();

        //        MainActivity con = new MainActivity();
        //        Context context = con.getApplicationContext();

        NotificationChannel channel = new NotificationChannel("channel", "Incoming Calls",
                NotificationManager.IMPORTANCE_HIGH);
        channel.setImportance(NotificationManager.IMPORTANCE_HIGH);
        // other channel setup stuff goes here.


        PendingIntent fullScreenPendingIntent = PendingIntent.getActivity(context,0,context.getPackageManager().getLaunchIntentForPackage("com.phone.dialer.dialer_app"),PendingIntent.FLAG_UPDATE_CURRENT);


        // Build the notification as an ongoing high priority item; this ensures it will show as
        // a heads up notification which slides down over top of the current content.
        final Notification.Builder builder = new Notification.Builder(context);
        builder.setOngoing(true);
        builder.setPriority(Notification.PRIORITY_HIGH);

        // Set notification content intent to take user to fullscreen UI if user taps on the
        // notification body.

        // Setup notification content.
        builder.setSmallIcon(R.mipmap.ic_launcher);
        builder.setContentTitle("Notification title");
        builder.setContentText("Notif text.");
//        builder.setFullScreenIntent(fullScreenPendingIntent, true);
        builder.setCategory(NotificationCompat.CATEGORY_CALL);
        builder.addAction(R.mipmap.ic_launcher,"f",fullScreenPendingIntent);
        // Set notification as insistent to cause your ringtone to loop.
        Notification notification = builder.build();
        notification.flags |= Notification.FLAG_INSISTENT;

        // Use builder.addAction(..) to add buttons to answer or reject the call.
        NotificationManager notificationManager = context.getSystemService(NotificationManager.class);
        notificationManager.notify("Call Notification",37, notification);

        //        context.startActivity(intent);


    }



}
