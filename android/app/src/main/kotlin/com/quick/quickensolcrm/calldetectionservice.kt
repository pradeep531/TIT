package com.quick.quickensolcrm

import android.app.Service
import android.content.Intent
import android.os.IBinder
import android.telephony.PhoneStateListener
import android.telephony.TelephonyManager
import io.flutter.plugin.common.MethodChannel
import android.provider.ContactsContract

class CallDetectionService : Service() {
    private lateinit var telephonyManager: TelephonyManager
    private val CHANNEL = "quickensolcrm"

    override fun onCreate() {
        super.onCreate()
        // Initialize TelephonyManager and start listening to phone state changes
        telephonyManager = getSystemService(TELEPHONY_SERVICE) as TelephonyManager
        telephonyManager.listen(object : PhoneStateListener() {
            override fun onCallStateChanged(state: Int, phoneNumber: String?) {
                super.onCallStateChanged(state, phoneNumber)
                when (state) {
                    TelephonyManager.CALL_STATE_RINGING -> {
                        // Get caller name
                        val callerName = getCallerName(phoneNumber)

                        // Prepare call data
                        val callData = mapOf(
                            "callerName" to callerName,
                            "phoneNumber" to (phoneNumber ?: "Unknown")
                        )

                        // Use the method channel to notify Flutter
                        //val messenger = (application as FlutterApplication).flutterEngine?.dartExecutor?.binaryMessenger
                        //messenger?.let {
                          //  MethodChannel(it, CHANNEL).invokeMethod("getIncomingCall", callData)
                        //}
                        // MainActivity.sendCallDataToFlutter(callData)
                    }
                    TelephonyManager.CALL_STATE_IDLE, TelephonyManager.CALL_STATE_OFFHOOK -> {
                        // Handle other states if necessary
                    }
                }
            }
        }, PhoneStateListener.LISTEN_CALL_STATE)
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        // Handle service restart logic, if required
        return START_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? {
        // No binding to activity in this service
        return null
    }

    private fun getCallerName(phoneNumber: String?): String {
        val uri = ContactsContract.CommonDataKinds.Phone.CONTENT_URI
        val projection = arrayOf(ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME)
        val selection = "${ContactsContract.CommonDataKinds.Phone.NUMBER} = ?"
        val selectionArgs = arrayOf(phoneNumber)

        val cursor = contentResolver.query(uri, projection, selection, selectionArgs, null)
        cursor?.use {
            if (it.moveToFirst()) {
                return it.getString(0) // Return the display name
            }
        }
        return "Unknown"
    }
}
