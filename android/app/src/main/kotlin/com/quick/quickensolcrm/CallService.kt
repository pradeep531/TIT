package com.quick.quickensolcrm

import androidx.cardview.widget.CardView
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.IBinder
import android.view.LayoutInflater
import android.view.View
import android.view.WindowManager
import android.widget.Button
import android.widget.TextView
import androidx.core.app.NotificationCompat
import android.graphics.PixelFormat
import android.view.Gravity
import android.widget.ImageButton
import org.json.JSONObject
import android.content.SharedPreferences
import android.widget.Toast
import android.os.AsyncTask
import org.json.JSONArray
import java.io.*
import java.net.HttpURLConnection
import java.net.URL
import android.os.Handler
import android.os.Looper
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class CallService : Service() {
private var isCallDataSent = false
    private var windowManager: WindowManager? = null
    private var popupView: View? = null
    private val CHANNEL_ID = "ForegroundServiceChannel";
    private val NOTIFICATION_ID = 1;
    

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            createNotificationChannel()
        }

        // Retrieve caller number and name from the Intent
        val callerNumber = intent?.getStringExtra("CALLER_NUMBER")
        val callerName = intent?.getStringExtra("CALLER_NAME")



        // Show notification
        showNotification(callerName, callerNumber)
        val  user_id=getFlutterSharedPrefValue(this,"flutter.user_id")
         
       
        createJson(callerNumber,user_id,this,callerName)
        
        // Show popup if it's not already displayed
       

        return START_NOT_STICKY
    }

    private fun showNotification(callerName: String?, callerNumber: String?) {
        val notificationIntent = Intent(this, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(
            this, 0, notificationIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val notification: Notification = NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Incoming Call")
            .setContentText("From: $callerName\nNumber: $callerNumber")
            .setSmallIcon(R.drawable.ic_launcher)
            .setContentIntent(pendingIntent)
            .setAutoCancel(true)
            .build()

        startForeground(NOTIFICATION_ID, notification)
    }

    fun getFlutterSharedPrefValue(context: Context,key : String?): String? {
        val prefs: SharedPreferences = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        return prefs.getString(key, "default_value") // Accessing with "flutter." prefix
    }

    fun createJson(callernumber:String?, user_id: String?,context: Context,callername: String?) {
        // Create a JSON object
        val jsonObject = JSONObject()

        // Add key-value pairs to the JSON object
        jsonObject.put("userId", user_id)
        jsonObject.put("caller_number", callernumber)
        jsonObject.put("summary_type", "prev")

        val jsonString = jsonObject.toString()
        println(jsonString)
         sendCallSummaryToServer(jsonObject,context,callernumber,callername)
    }


fun sendCallSummaryToServer(jsonObject: JSONObject,context: Context,callernumber:String?, callername: String?) {
    val urlString = "https://staginglink.org/twice/get_call_all_summary_api"
    
    // Create a new thread to handle network operations
    Thread {
        var urlConnection: HttpURLConnection? = null
        try {
            val url = URL(urlString)
            urlConnection = url.openConnection() as HttpURLConnection
            urlConnection.requestMethod = "POST"
            urlConnection.setRequestProperty("Content-Type", "application/json; utf-8")
            urlConnection.setRequestProperty("Accept", "application/json")
            urlConnection.doOutput = true
            urlConnection.doInput = true

            // Write JSON data to the request body
            val outputStream = DataOutputStream(urlConnection.outputStream)
            outputStream.writeBytes(jsonObject.toString())
            outputStream.flush()
            outputStream.close()

            // Check the response code
            val responseCode = urlConnection.responseCode
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

                // Parse the response (optional)
                val responseString = response.toString()
            
                // You can also handle the JSON response here
                val responseJson = JSONObject(responseString)
                val status = responseJson.getString("status")
                if (status == "true") {
                    val dataArray: JSONArray = responseJson.getJSONArray("data")
                    val item = dataArray.getJSONObject(0)
                    val callsummary1 = item.getString("call_summary")
                    val callduration1=item.getString("call_duration")
                    val (date1, time1) = parseDateTime(item.getString("created_on")) ?: Pair("Invalid date", "Invalid time")
                    val callDate1=date1
                    val callTime1=time1
                    val item1 = dataArray.getJSONObject(1)
                    val callsummary2 = item1.getString("call_summary")
                    val callduration2=item1.getString("call_duration")
                    val (date2, time2) = parseDateTime(item1.getString("created_on")) ?: Pair("Invalid date", "Invalid time")
                    val callDate2=date2
                    val callTime2=time2
                    Handler(Looper.getMainLooper()).post {   
                        if (popupView == null && callernumber!=null) {
                            showPopup(callername, callernumber,callsummary1,callDate1,callTime1,callduration1,callsummary2,callDate2,callTime2,callduration2)
                        }
                    }
                }else{
                    Handler(Looper.getMainLooper()).post {   
                        if (popupView == null && callernumber!=null) {
                            showPopup(callername, callernumber,"","","","","","","","")
                        }
                    }
                }     
            } else {
                Handler(Looper.getMainLooper()).post {   
                    if (popupView == null && callernumber!=null) {
                        showPopup(callername, callernumber,"","","","","","","","")
                    }
                }
            }
        } catch (e: Exception) {
                e.printStackTrace()
                Handler(Looper.getMainLooper()).post {   
                    if (popupView == null && callernumber!=null) {
                        showPopup(callername, callernumber,"","","","","","","","")
                    }
                }
        } finally {
            urlConnection?.disconnect()
        }
    }.start()
}

    fun parseDateTime(dateTimeString: String): Pair<String, String>? {
    val dateFormat = SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault())
    return try {
        val date: Date = dateFormat.parse(dateTimeString) ?: return null
        val outputDateFormat = SimpleDateFormat("dd-MM-yyyy", Locale.getDefault())
        val outputTimeFormat = SimpleDateFormat("hh:mm a", Locale.getDefault())
        
        val dateString = outputDateFormat.format(date)
        val timeString = outputTimeFormat.format(date)

        Pair(dateString, timeString)
    } catch (e: Exception) {
        e.printStackTrace()
        null
    }
    }


    private fun showPopup(callerName: String?, callerNumber: String?, callsummary1: String?, callDate1 : String? , callTime1 : String? ,callDuration1 : String?,callsummary2: String?, callDate2 : String? , callTime2 : String? ,callDuration2 : String?) {
        windowManager = getSystemService(WINDOW_SERVICE) as WindowManager
        val inflater = LayoutInflater.from(this)
        popupView = inflater.inflate(R.layout.popup_call_notification, null)

        val callerNameTextView = popupView?.findViewById<TextView>(R.id.callerName)
        val callerNumberTextView = popupView?.findViewById<TextView>(R.id.callerNumber)
        val closeButton = popupView?.findViewById<Button>(R.id.closeButton)

        val callSummaryTextView1=popupView?.findViewById<TextView>(R.id.callerSummary1)
        val calldateTextView1=popupView?.findViewById<TextView>(R.id.callDate1)
        val calltimeTextView1=popupView?.findViewById<TextView>(R.id.callTime1)
        val calldurationTextView1=popupView?.findViewById<TextView>(R.id.callDuration1)

        val callSummaryTextView2=popupView?.findViewById<TextView>(R.id.callerSummary2)
        val calldateTextView2=popupView?.findViewById<TextView>(R.id.callDate2)
        val calltimeTextView2=popupView?.findViewById<TextView>(R.id.callTime2)
        val calldurationTextView2=popupView?.findViewById<TextView>(R.id.callDuration2)

        val cardview1=popupView?.findViewById<CardView>(R.id.cardView1);
        val cardview2=popupView?.findViewById<CardView>(R.id.cardView2);

        callerNameTextView?.text = callerName ?: "Unknown"
        callerNumberTextView?.text = callerNumber ?: "Unknown"
     // Handle callSummary  
    callsummary1?.let {
        if (it.isNotEmpty()) {
            callSummaryTextView1?.text = "Last Call summary : $it"
            callSummaryTextView1?.visibility = View.VISIBLE // Show the TextView if it has text
       
        } else {
            callSummaryTextView1?.visibility = View.GONE // Hide the TextView if it is empty
        }
    } ?: run {
        callSummaryTextView1?.visibility = View.GONE // Hide the TextView if callsummary is null
    }

    callsummary2?.let {
        if (it.isNotEmpty()) {
            callSummaryTextView2?.text = "Last Call summary : $it"
            callSummaryTextView2?.visibility = View.VISIBLE // Show the TextView if it has text
        } else {
            callSummaryTextView2?.visibility = View.GONE // Hide the TextView if it is empty
        }
    } ?: run {
        callSummaryTextView2?.visibility = View.GONE // Hide the TextView if callsummary is null
    }

    // Handle callDate
    callDate1?.let {
        if (it.isNotEmpty()) {
            calldateTextView1?.text = "Date : $it"
            calldateTextView1?.visibility = View.VISIBLE // Show if not empty
            cardview1?.visibility=View.VISIBLE
        } else {
            calldateTextView1?.visibility = View.GONE // Hide if empty
        }
    } ?: run {
        calldateTextView1?.visibility = View.GONE // Hide if null
    }

    callDate2?.let {
        if (it.isNotEmpty()) {
            calldateTextView2?.text = "Date : $it"
            calldateTextView2?.visibility = View.VISIBLE // Show if not empty
            cardview2?.visibility=View.VISIBLE
        } else {
            calldateTextView2?.visibility = View.GONE // Hide if empty
        }
    } ?: run {
        calldateTextView2?.visibility = View.GONE // Hide if null
    }

// Handle callTime
    callTime1?.let {
        if (it.isNotEmpty()) {
            calltimeTextView1?.text = "Time : $it"
            calltimeTextView1?.visibility = View.VISIBLE // Show if not empty
        } else {
            calltimeTextView1?.visibility = View.GONE // Hide if empty
        }
    } ?: run {
        calltimeTextView1?.visibility = View.GONE // Hide if null
    }
    callTime2?.let {
        if (it.isNotEmpty()) {
            calltimeTextView2?.text = "Time : $it"
            calltimeTextView2?.visibility = View.VISIBLE // Show if not empty
        } else {
            calltimeTextView2?.visibility = View.GONE // Hide if empty
        }
    } ?: run {
        calltimeTextView2?.visibility = View.GONE // Hide if null
    }

// Handle callDuration
    callDuration1?.let {
        if (it.isNotEmpty()) {
            calldurationTextView1?.text = "Duration : $it"
            calldurationTextView1?.visibility = View.VISIBLE // Show if not empty
        } else {
            calldurationTextView1?.visibility = View.GONE // Hide if empty
        }
    } ?: run {
        calldurationTextView1?.visibility = View.GONE // Hide if null
    }

    callDuration2?.let {
        if (it.isNotEmpty()) {
            calldurationTextView2?.text = "Duration : $it"
            calldurationTextView2?.visibility = View.VISIBLE // Show if not empty
        } else {
            calldurationTextView2?.visibility = View.GONE // Hide if empty
        }
    } ?: run {
        calldurationTextView2?.visibility = View.GONE // Hide if null
    }
        // Define layout parameters for the popup
        val params = WindowManager.LayoutParams(
            WindowManager.LayoutParams.MATCH_PARENT, // Set width to match parent
            WindowManager.LayoutParams.WRAP_CONTENT,
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY, // Use TYPE_APPLICATION_OVERLAY for Android O and above
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
            PixelFormat.TRANSLUCENT
        ).apply {
            // Center the popup on the screen
            gravity = Gravity.CENTER
        }

        // Add the popup view to the window
        windowManager?.addView(popupView, params)

        // Set click listener for the close button
        closeButton?.setOnClickListener {
            removePopup()
        }
        
    }

    private fun removePopup() {
        // Remove the popup view if it exists
        if (popupView != null) {
            windowManager?.removeView(popupView)
            popupView = null // Nullify to avoid memory leaks
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        // Ensure the popup is removed when the service is destroyed
        removePopup()
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
}
