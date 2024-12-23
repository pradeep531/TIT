package com.quick.quickensolcrm

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.provider.ContactsContract
import android.telephony.TelephonyManager
import android.widget.Toast
import android.os.Build

class IncomingCallReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context?, intent: Intent?) {
        // Ensure that the intent is not null and contains the necessary information
        val receivedData = intent?.getStringExtra("data")

        intent?.let {
            val state = it.getStringExtra(TelephonyManager.EXTRA_STATE)

            if (state == TelephonyManager.EXTRA_STATE_RINGING) {
                val callerNumber = it.getStringExtra(TelephonyManager.EXTRA_INCOMING_NUMBER)

                // Optionally, retrieve the caller's name using the Phone's contact database
                val callerName = getCallerName(context, callerNumber)

                if (callerNumber != null) {
                    // Ensure sendIncomingCallNumber is a static method or properly accessed
                   // MainActivity.sendIncomingCallNumber(callerNumber, callerName ?: "Unknown")
                    val serviceIntent = Intent(context, CallService::class.java).apply {
                        putExtra("CALLER_NUMBER", callerNumber)
                        putExtra("CALLER_NAME", callerName)
                    }

                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        context?.startForegroundService(serviceIntent)
                    } else {
                        context?.startService(serviceIntent)
                    }
                }
            }

            if (state == TelephonyManager.EXTRA_STATE_IDLE) {
                // Call has ended, start CallEndService to show the summary popup
                val callerNumber = it.getStringExtra(TelephonyManager.EXTRA_INCOMING_NUMBER)

                // Optionally, retrieve the caller's name using the Phone's contact database
                val callerName = getCallerName(context, callerNumber)

                if (callerNumber != null) {
                    val serviceIntent = Intent(context, CallEndService::class.java).apply {
                        putExtra("CALLER_NUMBER", callerNumber)
                        putExtra("CALLER_NAME", callerName)
                    }
                    
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        context?.startForegroundService(serviceIntent)
                    } else {
                        context?.startService(serviceIntent)
                    }
                }
            }
        }
    }

    private fun getCallerName(context: Context?, number: String?): String? {
        if (number == null) return null
        // Use ContentResolver to get the contact name
        val uri = Uri.withAppendedPath(ContactsContract.PhoneLookup.CONTENT_FILTER_URI, Uri.encode(number))
        val projection = arrayOf(ContactsContract.PhoneLookup.DISPLAY_NAME)
        val cursor = context?.contentResolver?.query(uri, projection, null, null, null)
        var callerName: String? = null
        cursor?.use {
            if (it.moveToFirst()) {
                callerName = it.getString(it.getColumnIndex(ContactsContract.PhoneLookup.DISPLAY_NAME))
            }
        }
        return callerName
    }
}
