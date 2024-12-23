package com.quick.quickensolcrm

import android.content.Context
import android.os.Build
import android.os.Bundle
import android.telephony.SubscriptionManager
import android.telephony.TelephonyManager
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import android.content.pm.PackageManager
import android.widget.Toast
import android.telephony.PhoneStateListener
import android.provider.ContactsContract
import android.telephony.SubscriptionInfo
import android.Manifest
import io.flutter.plugins.GeneratedPluginRegistrant
import com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin
import android.content.pm.PackageInfo
import android.content.Intent
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor

class MainActivity : FlutterActivity() {
    private val CHANNEL = "quickensolcrm"
    private val REQUEST_CODE_PHONE_STATE_PERMISSION = 124
    private lateinit var telephonyManager: TelephonyManager


    companion object {
        const val CHANNEL = "quickensolcrm"
        private lateinit var channel: MethodChannel

        // Static method to send data to Flutter
        fun sendCallSummary(callInfo: Map<String, String>) {
            channel.invokeMethod("sendCallSummary", callInfo)
        }

        fun sendIncomingCallNumber(callerNumber: String, callerName: String) {
            channel.invokeMethod("sendcallernumber", mapOf(
                "callerNumber" to callerNumber,
                "callerName" to callerName 
            ))

        }

        fun sendcallend(callerNumber: String, callerName: String) {
            channel.invokeMethod("sendcallend", mapOf(
                "callerNumber" to callerNumber,
                "callerName" to callerName 
            ))
            
        }
    }  
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Initialize and cache the Flutter engine if it's not already cached
        val flutterEngine = FlutterEngine(this)
       // flutterEngine.navigationChannel.setInitialRoute("/secondPage")
        flutterEngine.dartExecutor.executeDartEntrypoint(
            DartExecutor.DartEntrypoint.createDefault()
        )

        // Cache the engine for reuse
        FlutterEngineCache.getInstance().put("my_engine_id", flutterEngine)
    }


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)
       
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "sendData" -> {
                   
                    val callerNumber = call.argument<String>("callerNumber")
                    val callerName = call.argument<String>("callerName")
                    val data1 = call.argument<String>("data1")
                    val callDate1 = call.argument<String>("callDate1")
                    val callTime1 = call.argument<String>("callTime1")
                    val callDuration1 = call.argument<String>("callDuration1")
                    val data2 = call.argument<String>("data2")
                    val callDate2 = call.argument<String>("callDate2")
                    val callTime2 = call.argument<String>("callTime2")
                    val callDuration2 = call.argument<String>("callDuration2")

                    result.success("Data received successfully")
                    //sendToBroadcastReceiver(callerNumber, callerName, data1, callDate1, callTime1, callDuration1, data2, callDate2, callTime2, callDuration2)
                }
                "getSimNumbers" -> {
                    val simNumbers = getSimNumbers()
                    result.success(simNumbers)
                }
                "showsummary" -> {
                    val data = call.argument<String>("usertype")
                    val callerNumber = call.argument<String>("callerNumber")
                    val callerName = call.argument<String>("callerName")
                    val isTrackingAllowedToAdmin = call.argument<String>("istrackingallowed")
                    result.success("Data received successfully")
                    if (isTrackingAllowedToAdmin == "1") {
                        sendToBroadcastReceiverForEnd(data, callerNumber, callerName)
                    }
                }

                "getAppVersion" ->{
                    val version = getAppVersion()
                    if (version != null) {
                        result.success(version)
                    } else {
                        result.error("UNAVAILABLE", "Version not available.", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }
    private fun getAppVersion(): String? {
        return try {
            val packageInfo: PackageInfo = packageManager.getPackageInfo(packageName, 0)
            packageInfo.versionName
        } catch (e: PackageManager.NameNotFoundException) {
            null
        }
    }


    private fun openFlutterPage(route: String) {
        val intent = FlutterActivity
            .withCachedEngine("my_engine_id")
            
            .build(this)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        startActivity(intent)
    }

    private fun sendToBroadcastReceiver(callerNumber: String?, callerName: String?, data1: String?, callDate1: String?, callTime1: String?, callDuration1: String?, data2: String?, callDate2: String?, callTime2: String?, callDuration2: String?) {
        val serviceIntent = Intent(this, CallService::class.java).apply {
            putExtra("CALLER_NUMBER", callerNumber)
            putExtra("CALLER_NAME", callerName)
            putExtra("CALL_SUMMARY1", data1)
            putExtra("CALL_DATE1", callDate1)
            putExtra("CALL_TIME1", callTime1)
            putExtra("CALL_DURATION1", callDuration1)
            putExtra("CALL_SUMMARY2", data2)
            putExtra("CALL_DATE2", callDate2)
            putExtra("CALL_TIME2", callTime2)
            putExtra("CALL_DURATION2", callDuration2)
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(serviceIntent)
        } else {
            startService(serviceIntent)
        }
    }

    private fun sendToBroadcastReceiverForEnd(data: String?, callerNumber: String?, callerName: String?) {
        val serviceIntent = Intent(this, CallEndService::class.java).apply {
            putExtra("CALLER_NUMBER", callerNumber)
            putExtra("CALLER_NAME", callerName)
        }
        startForegroundService(serviceIntent)
    }

    // Request permission result handler
    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == REQUEST_CODE_PHONE_STATE_PERMISSION) {
            if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                Toast.makeText(this, "Phone state permission granted", Toast.LENGTH_SHORT).show()
            } else {
                Toast.makeText(this, "Phone state permission is required", Toast.LENGTH_SHORT).show()
            }
        }
    }   

    private fun getSimNumbers(): List<String> {
        val simNumbers = mutableListOf<String>()
        
        // Check if the app has permission to read phone state
        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.READ_PHONE_STATE) != PackageManager.PERMISSION_GRANTED) {
            // Return empty list if permission is not granted
            return simNumbers
        }

        val subscriptionManager = getSystemService(Context.TELEPHONY_SUBSCRIPTION_SERVICE) as SubscriptionManager

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP_MR1) {
            // Get active SIM subscription information
            val activeSubscriptionInfoList = subscriptionManager.activeSubscriptionInfoList
            for (subscriptionInfo: SubscriptionInfo in activeSubscriptionInfoList) {
                val number = subscriptionInfo.number ?: "Unknown"
                val strippedNumber = removeCountryCode(number)
                simNumbers.add(strippedNumber)
            }
        } else {
            // For older Android versions, retrieve only the first SIM's number
            val telephonyManager = getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
            val number = telephonyManager.line1Number ?: "Unknown"
            val strippedNumber = removeCountryCode(number)
            simNumbers.add(strippedNumber)
        }

        return simNumbers
    }

    private fun removeCountryCode(number: String): String {
        return when {
            number.startsWith("+91") -> number.substring(3) // Skips the first 3 characters (+91)
            number.isNotEmpty() -> number.substring(2) // Skips the first 2 characters for other cases
            else -> number // Returns the original number if it's empty
        }
    }
}
