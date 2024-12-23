package com.quick.quickensolcrm

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.telephony.TelephonyManager

class CallReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context?, intent: Intent?) {
        // Ensure that the intent is not null using a safe call
        if (intent?.action == TelephonyManager.ACTION_PHONE_STATE_CHANGED) {
            // Get the phone state safely
            val state = intent.getStringExtra(TelephonyManager.EXTRA_STATE)
            
            // Check if the phone is ringing
            if (state == TelephonyManager.EXTRA_STATE_RINGING) {
                // Get the incoming number safely
                val phoneNumber = intent.getStringExtra(TelephonyManager.EXTRA_INCOMING_NUMBER)

                // Proceed if context and phone number are not null
                if (context != null && phoneNumber != null) {
                    // Start the MainActivity and pass the phone number to it
                    val activityIntent = Intent(context, MainActivity::class.java)
                    activityIntent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                    activityIntent.putExtra("phone_number", phoneNumber)
                    context.startActivity(activityIntent)
                }
            }
        }
    }
}
