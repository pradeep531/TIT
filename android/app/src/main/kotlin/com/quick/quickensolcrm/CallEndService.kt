package com.quick.quickensolcrm

import android.widget.ImageButton
import android.widget.TextView
import android.app.Service
import android.content.Context
import android.os.IBinder
import android.provider.CallLog
import android.telephony.SubscriptionInfo
import android.telephony.SubscriptionManager
import android.view.LayoutInflater
import android.view.View
import android.view.WindowManager
import android.widget.Button
import android.widget.EditText
import android.widget.Toast
import android.graphics.PixelFormat
import android.view.Gravity
import android.view.inputmethod.InputMethodManager
import io.flutter.plugin.common.MethodChannel
import java.text.SimpleDateFormat
import java.util.Locale
import androidx.core.app.NotificationCompat
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.os.Build
import org.json.JSONObject
import android.content.SharedPreferences
import android.os.AsyncTask
import org.json.JSONArray
import java.io.*
import java.net.HttpURLConnection
import java.net.URL
import android.os.Handler
import android.os.Looper
import java.util.Date
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import java.io.BufferedInputStream
import java.io.BufferedReader
import java.io.DataOutputStream
import java.io.InputStreamReader
import java.util.concurrent.Executors
import java.util.*
import android.app.AlertDialog
import android.app.DatePickerDialog
import android.app.TimePickerDialog
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import android.content.Intent


// Data class for call details
data class CallDetails(
    val callerNumber: String,
    val callType: String,
    val callDuration: String,
    val callDate: String // New field for the call date
)

class CallEndService : Service() {

    private var windowManager: WindowManager? = null
    private var popupView: View? = null
    private val CHANNEL_ID = "ForegroundServiceChannel";
    private val NOTIFICATION_ID = 1;
    private var reminderpopupView: View? = null

        override fun onCreate() {
            super.onCreate()
            // Create notification channel (for Android O and above)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val channelId = "call_service_channel"
                val channelName = "Call End Service"
                val channelDescription = "Channel for Call End Service"
                val channel = NotificationChannel(channelId, channelName, NotificationManager.IMPORTANCE_LOW).apply {
                    description = channelDescription
                }
                val notificationManager = getSystemService(NotificationManager::class.java)
                notificationManager.createNotificationChannel(channel)
            }
        }
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val notification = NotificationCompat.Builder(this, "call_service_channel")
            .setContentTitle("Call End")
            .setContentText("")
            .setSmallIcon(R.drawable.ic_launcher) // Replace with your app's icon
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .build()

        // Call startForeground() with the notification
        startForeground(1, notification)

        val callerNumber = intent?.getStringExtra("CALLER_NUMBER")
        val callerName = intent?.getStringExtra("CALLER_NAME")
        //showNotification(callerName, callerNumber)
        val  istrackingallowed=getFlutterSharedPrefValue(this,"flutter.istrackingallowed")
        if(istrackingallowed=="1"){
            if (popupView == null && callerNumber != null) {
                val callDetails = getCallDetails(callerNumber)
                val simInfo = getSimInfo()
                showCallSummaryPopup(callDetails, simInfo, callerName ?: "Unknown")
            }
        }
        return START_NOT_STICKY
    }

    fun getFlutterSharedPrefValue(context: Context,key : String?): String? {
        val prefs: SharedPreferences = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        return prefs.getString(key, "default_value") // Accessing with "flutter." prefix
    }

    
    private fun showNotification(callerName: String?, callerNumber: String?) {
        val notificationIntent = Intent(this, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(
            this, 0, notificationIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val notification: Notification = NotificationCompat.Builder(this, "CALL_SERVICE_CHANNEL")
            .setContentTitle("Call Ended")
            .setContentText("From: $callerName\nNumber: $callerNumber")
            .setSmallIcon(R.drawable.ic_launcher)
            .setContentIntent(pendingIntent)
            .setAutoCancel(true)
            .build()

        startForeground(NOTIFICATION_ID, notification)
    }

    private fun getCallDetails(callerNumber: String): CallDetails {
        var callType: String = "Unknown"
        var callDuration: String = "0"
        var callDate: String = "Unknown"
        val callLogs = contentResolver.query(
            CallLog.Calls.CONTENT_URI,
            null,
            "${CallLog.Calls.NUMBER} = ?",
            arrayOf(callerNumber),
            CallLog.Calls.DATE + " DESC"
        )

        if (callLogs != null && callLogs.moveToFirst()) {
            val duration = callLogs.getString(callLogs.getColumnIndexOrThrow(CallLog.Calls.DURATION))
            val type = callLogs.getInt(callLogs.getColumnIndexOrThrow(CallLog.Calls.TYPE))
            val dateMillis = callLogs.getLong(callLogs.getColumnIndexOrThrow(CallLog.Calls.DATE))

            // Format the date from milliseconds to a readable format
            val dateFormat = SimpleDateFormat("dd-MM-yyyy", Locale.getDefault())
            callDate = dateFormat.format(dateMillis)

            callDuration = "$duration"
            callType = when (type) {
                CallLog.Calls.INCOMING_TYPE -> "Incoming"
                CallLog.Calls.OUTGOING_TYPE -> "Outgoing"
                CallLog.Calls.MISSED_TYPE -> "Missed"
                else -> "Incoming"
            }
            callLogs.close()
        }

        return CallDetails(callerNumber, callType, callDuration, callDate)
    }

    private fun getSimInfo(): String {
        val subscriptionManager = getSystemService(Context.TELEPHONY_SUBSCRIPTION_SERVICE) as SubscriptionManager
        val activeSubscriptions: List<SubscriptionInfo> = subscriptionManager.activeSubscriptionInfoList
        var simInfo = "Unknown"

        if (activeSubscriptions.isNotEmpty()) {
            // Get the first active subscription info
            val subInfo = activeSubscriptions[0]
            
            // Get display name and carrier name
            val displayName = subInfo.displayName
            val carrierName = subInfo.carrierName
            
            // Try to get the SIM number (phone number)
            val simNumber = subInfo.number ?: "Not Available"

            // Combine the information into a single string
            simInfo = "$displayName - $carrierName - SIM Number: $simNumber"
            
        }
        
        return simInfo
    }

    private fun showCallSummaryPopup(callDetails: CallDetails, simInfo: String, callerName: String) {
        windowManager = getSystemService(WINDOW_SERVICE) as WindowManager
        val inflater = LayoutInflater.from(this)
        popupView = inflater.inflate(R.layout.popup_call_summary, null)

        val submitButton = popupView?.findViewById<Button>(R.id.submitButton)
        val summaryEditText = popupView?.findViewById<EditText>(R.id.summaryEditText)
        val closeButton = popupView?.findViewById<Button>(R.id.closeButton)
        val reminderButton = popupView?.findViewById<Button>(R.id.reminderButton)
        val callername= popupView?.findViewById<TextView>(R.id.callerName)

        callername?.text = callerName ?: "Unknown"
        summaryEditText?.requestFocus()
        summaryEditText?.post {
            showKeyboard(summaryEditText)
        }

        val params = WindowManager.LayoutParams(
            WindowManager.LayoutParams.MATCH_PARENT,
            WindowManager.LayoutParams.WRAP_CONTENT,
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
            WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL or WindowManager.LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH,
            PixelFormat.TRANSLUCENT
        ).apply {
            gravity = Gravity.CENTER
        }

        windowManager?.addView(popupView, params)

        submitButton?.setOnClickListener {
            val summary = summaryEditText?.text.toString()
            if (summary.isNotEmpty()) {
                val callInfo = mapOf(
                    "summary" to summary,
                    "callerNumber" to callDetails.callerNumber,
                    "callType" to callDetails.callType,
                    "callDuration" to callDetails.callDuration,
                    "callDate" to callDetails.callDate, // Added callDate to the map
                    "simInfo" to simInfo,
                    "callerName" to (callerName ?: "Unknown")
                )
                Toast.makeText(this, "Summary popup open and click on submit", Toast.LENGTH_SHORT).show()
             //   MainActivity.sendCallSummary(callInfo)
                val  user_id=getFlutterSharedPrefValue(this,"flutter.user_id")
                val  parts = simInfo.split("SIM Number: ")
                val sim_name = parts[0].trim() 
                val receiver_number = parts[1].trim() 

                createJson("1",callDetails.callDuration,callDetails.callDate,callDetails.callDate, callDetails.callerNumber,
                sim_name,(callerName ?: "Unknown"),callDetails.callType,receiver_number, user_id,summary,this)
                //Toast.makeText(this, "Summary submitted", Toast.LENGTH_SHORT).show()
                removePopup()
            } else {
                Toast.makeText(this, "Please enter a summary", Toast.LENGTH_SHORT).show()
            }
        }

        closeButton?.setOnClickListener {
            val callInfo = mapOf(
                    "summary" to  "",
                    "callerNumber" to callDetails.callerNumber,
                    "callType" to callDetails.callType,
                    "callDuration" to callDetails.callDuration,
                    "callDate" to callDetails.callDate, // Added callDate to the map
                    "simInfo" to simInfo,
                    "callerName" to (callerName ?: "Unknown")
                )
                val  user_id=getFlutterSharedPrefValue(this,"flutter.user_id")
                val  parts = simInfo.split("SIM Number: ")
                val sim_name = parts[0].trim() 
                val receiver_number = parts[1].trim() 

                createJson("1",callDetails.callDuration,callDetails.callDate,callDetails.callDate, callDetails.callerNumber,
                sim_name,(callerName ?: "Unknown"),callDetails.callType,receiver_number, user_id,"close button press",this)
               // Toast.makeText(this, "Summary popup open and click on close", Toast.LENGTH_SHORT).show()
                //MainActivity.sendCallSummary(callInfo)
               // Toast.makeText(this, "Without Summary submitted", Toast.LENGTH_SHORT).show()
            removePopup()
        }
        reminderButton?.setOnClickListener {
           
            val  user_id=getFlutterSharedPrefValue(this,"flutter.user_id")
                val  parts = simInfo.split("SIM Number: ")
                val sim_name = parts[0].trim() 
                val receiver_number = parts[1].trim()
            createJson("1",callDetails.callDuration,callDetails.callDate,callDetails.callDate, callDetails.callerNumber,
                sim_name,(callerName ?: "Unknown"),callDetails.callType,receiver_number, user_id,"Reminder set",this)
          removePopup() // Remove the existing popup (if any)
            val intent = Intent(this, ReminderActivity::class.java)
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            intent.putExtra("mobile", callDetails.callerNumber)
            intent.putExtra("name", (callerName ?: "Unknown"))
            intent.putExtra("user_id", user_id)
            startActivity(intent)
        }
    }

    private fun showKeyboard(editText: EditText) {
        val imm = getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
        imm.showSoftInput(editText, InputMethodManager.SHOW_IMPLICIT)
    }

    private fun removePopup() {
        if (popupView != null) {
            windowManager?.removeView(popupView)
            popupView = null
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        removePopup()
    }

   private fun showReminderPopup(callDetails: CallDetails, callerName: String) {
    // Inflate the custom layout
    windowManager = getSystemService(WINDOW_SERVICE) as WindowManager
    val inflater = LayoutInflater.from(this)
    reminderpopupView = inflater.inflate(R.layout.reminder_popup, null)

    val nameEditText = reminderpopupView?.findViewById<EditText>(R.id.editTextName)
    val mobileEditText = reminderpopupView?.findViewById<EditText>(R.id.editTextMobile)
    val dateEditText = reminderpopupView?.findViewById<EditText>(R.id.editTextDate)
    val timeEditText = reminderpopupView?.findViewById<EditText>(R.id.editTextTime)
    val descriptionEditText = reminderpopupView?.findViewById<EditText>(R.id.editTextDescription)
    val btnClose = reminderpopupView?.findViewById<Button>(R.id.btnClose)
    val btnSetReminder = reminderpopupView?.findViewById<Button>(R.id.btnSetReminder)

    // Set up the close button
    btnClose?.setOnClickListener {
        if (reminderpopupView != null) {
            windowManager?.removeView(reminderpopupView)
            reminderpopupView = null
        }
    }

    // Set up the set reminder button
    btnSetReminder?.setOnClickListener {
        // Handle reminder setting logic
        val name = nameEditText?.text.toString()
        val mobileNumber = mobileEditText?.text.toString()
        // Retrieve and use other input fields as needed
    }

    // Set initial text values
    nameEditText?.setText(callerName ?: "Unknown")
    mobileEditText?.setText(callDetails.callerNumber)

    // Set up layout parameters for the popup
    val params = WindowManager.LayoutParams(
        WindowManager.LayoutParams.MATCH_PARENT,
        WindowManager.LayoutParams.WRAP_CONTENT,
        WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
        WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL or WindowManager.LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH,
        PixelFormat.TRANSLUCENT
    ).apply {
        gravity = Gravity.CENTER
    }

    // Display the popup view
    windowManager?.addView(reminderpopupView, params)

    // Handle date selection with EditText (inside the popup view)
    dateEditText?.setOnClickListener {
        val calendar = Calendar.getInstance()
        val datePicker = DatePickerDialog(
            this, // Make sure you're passing the correct context
            { _, year, month, dayOfMonth ->
                val selectedDate = String.format("%02d/%02d/%d", dayOfMonth, month + 1, year)
                dateEditText.setText(selectedDate)
            },
            calendar.get(Calendar.YEAR),
            calendar.get(Calendar.MONTH),
            calendar.get(Calendar.DAY_OF_MONTH)
        )
        // Make sure the DatePickerDialog appears in the context of the current window (popup)
        datePicker.show()
    }

    // Handle time selection with EditText (inside the popup view)
    timeEditText?.setOnClickListener {
        val calendar = Calendar.getInstance()
        val timePicker = TimePickerDialog(
            this,
            { _, hourOfDay, minute ->
                val selectedTime = String.format("%02d:%02d", hourOfDay, minute)
                timeEditText?.setText(selectedTime)
            },
            calendar.get(Calendar.HOUR_OF_DAY),
            calendar.get(Calendar.MINUTE),
            true
        )
        timePicker.show()
    }
}





    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

     private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val serviceChannel = NotificationChannel(
                CHANNEL_ID,
                "Call Service Channel",
                NotificationManager.IMPORTANCE_DEFAULT
            )
            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(serviceChannel)
        }
    }

    fun createJson(sim_slot : String?,call_duration : String?,call_from: String?,call_to: String?, caller_number:String?,sim_name:String?, caller_name: String?,call_type:String?,receiver_number:String?, user_id: String?,call_summary:String?,context: Context) {
        // Create a JSON object
        val jsonObject = JSONObject()

        // Add key-value pairs to the JSON object
        jsonObject.put("sim_slot", sim_slot)
        jsonObject.put("call_duration", call_duration)
        jsonObject.put("call_from", call_from)
        jsonObject.put("call_to", call_to)
        jsonObject.put("caller_number", caller_number)
        jsonObject.put("sim_name", sim_name)
        jsonObject.put("caller_name", caller_name)
        jsonObject.put("call_type", call_type)
        jsonObject.put("receiver_number", receiver_number)
        jsonObject.put("user_id", user_id)
        jsonObject.put("call_summary", call_summary)

        val jsonString = jsonObject.toString()
         println("Call end json ${jsonString.toString()}")
        
      // sendCallSummaryToServer(jsonObject, context)
       val urlString = "https://staginglink.org/twice/insert_call_record_api"  // API URL
       CallSummaryAsyncTask(context).execute(urlString, jsonObject.toString())
    }



    private class CallSummaryAsyncTask(val context: Context) : AsyncTask<String, Void, String>() {

    override fun doInBackground(vararg params: String?): String? {
        val urlString = params[0]  // URL
        val jsonBody = params[1]   // JSON data as a string

        try {
            // Create a URL object from the string URL
            val url = URL(urlString)
            // Open a connection to the URL
            val urlConnection = url.openConnection() as HttpURLConnection

            // Set request method and headers
            urlConnection.requestMethod = "POST"
            urlConnection.setRequestProperty("Content-Type", "application/json; charset=UTF-8")
            urlConnection.setRequestProperty("Accept", "application/json")
            urlConnection.doInput = true
            urlConnection.doOutput = true

            // Write the JSON data to the request body
            val outputStream = BufferedOutputStream(urlConnection.outputStream)
            val writer = BufferedWriter(OutputStreamWriter(outputStream, "UTF-8"))
            writer.write(jsonBody)
            writer.flush()
            writer.close()
            outputStream.close()

            // Get the response code
            val responseCode = urlConnection.responseCode

            // If the response code is 200 (HTTP OK)
            if (responseCode == HttpURLConnection.HTTP_OK) {
                // Read the response
                val inputStream = BufferedInputStream(urlConnection.inputStream)
                val reader = BufferedReader(InputStreamReader(inputStream))
                val response = StringBuilder()
                var line: String?

                while (reader.readLine().also { line = it } != null) {
                    response.append(line)
                }

                reader.close()
                inputStream.close()
                println("Call end response ${response.toString()}")
                // Return the response as a string
                return response.toString()
            } else {
                return "Error: $responseCode"
            }
        } catch (e: Exception) {
            e.printStackTrace()
            return e.message
        }
    }

    override fun onPostExecute(result: String?) {
        super.onPostExecute(result)

        try {
            // Parse the response JSON
            val jsonResponse = JSONObject(result)
            val status = jsonResponse.getString("status")
            val message = jsonResponse.getString("message")

            // Show a toast based on the response status
                if (status == "true") {
                    Toast.makeText(context, "Summary Submitted", Toast.LENGTH_LONG).show()
                } else {
                    Toast.makeText(context, "Failed to submit summary", Toast.LENGTH_LONG).show()
                }
            } catch (e: Exception) {
                e.printStackTrace()
                
                Toast.makeText(context, "Error in response", Toast.LENGTH_LONG).show()
            }
        }
    }  

     
}
