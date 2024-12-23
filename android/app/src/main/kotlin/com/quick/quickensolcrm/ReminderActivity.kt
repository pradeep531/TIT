package com.quick.quickensolcrm
import android.os.Bundle
import android.widget.Button
import android.widget.ImageButton
import android.widget.EditText
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import com.quick.quickensolcrm.R
import android.app.Activity
import android.app.DatePickerDialog
import java.util.Calendar
import android.app.TimePickerDialog
import android.app.AlarmManager
import android.app.NotificationChannel
import android.app.NotificationManager
import android.media.AudioAttributes

import android.app.PendingIntent
import android.content.Context
import android.os.Build
import android.widget.Toast
import org.json.JSONObject
import android.content.SharedPreferences
import android.os.AsyncTask
import org.json.JSONArray
import java.io.*
import java.net.HttpURLConnection
import java.net.URL
import android.util.Log
import java.text.SimpleDateFormat
import java.util.*
import android.net.Uri

class ReminderActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
          if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            createNotificationChannel()
        }
        setContentView(R.layout.reminder_popup)
        val mobile = intent.getStringExtra("mobile") ?: "Unknown"  // Default to "Unknown" if not provided
        val name = intent.getStringExtra("name") ?: "Unknown"    
        val user_id=intent.getStringExtra("user_id") ?: "Unknown"

        val btnClose = findViewById<ImageButton>(R.id.btnClose)
        val btnSetReminder = findViewById<Button>(R.id.btnSetReminder)
        val dateEditText = findViewById<EditText>(R.id.editTextDate)
        val timeEditText = findViewById<EditText>(R.id.editTextTime)
        val nameTextView  = findViewById<EditText>(R.id.editTextName)
        val mobileTextView  = findViewById<EditText>(R.id.editTextMobile)
        val date = findViewById<EditText>(R.id.editTextDate).text.toString()
        val time = findViewById<EditText>(R.id.editTextTime).text.toString()
        val description = findViewById<EditText>(R.id.editTextDescription).text.toString()
    
     
        nameTextView.setText(name)
        mobileTextView.setText(mobile)
        nameTextView.isFocusable = false
        nameTextView.isClickable = false
        mobileTextView.isFocusable = false
        mobileTextView.isClickable = false  
        btnClose.setOnClickListener {
            // Close the activity when the "Close" button is clicked
            finish()
        }

        btnSetReminder.setOnClickListener {
    // Get the date and time from the EditTexts
    val dateText = dateEditText.text.toString()
    val timeText = timeEditText.text.toString()

    // Ensure both date and time are selected
    if (dateText.isEmpty() || timeText.isEmpty()) {
        dateEditText?.error = "Please select a date first"
        timeEditText?.error = "Please select a time first"
        Toast.makeText(this, "Please select both date and time", Toast.LENGTH_SHORT).show()
        return@setOnClickListener
    }

    // Parse date and time to set a Calendar instance
    val calendar = Calendar.getInstance()
    val dateParts = dateText.split("/")
    val timeParts = timeText.split(":")
    val amPm = timeParts[1].split(" ")[1]
    val hour = timeParts[0].toInt() + if (amPm == "PM" && timeParts[0].toInt() < 12) 12 else 0
    val minute = timeParts[1].split(" ")[0].toInt()

    calendar.set(Calendar.YEAR, dateParts[2].toInt())
    calendar.set(Calendar.MONTH, dateParts[1].toInt() - 1)
    calendar.set(Calendar.DAY_OF_MONTH, dateParts[0].toInt())
    calendar.set(Calendar.HOUR_OF_DAY, hour)
    calendar.set(Calendar.MINUTE, minute)
    calendar.set(Calendar.SECOND, 0)
    val dateFormat = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
    val formattedDate = dateFormat.format(calendar.time)
    val selectedTime = calendar.timeInMillis
    val currentTime = System.currentTimeMillis()

    if (selectedTime <= currentTime + 15 * 60 * 1000) {
        timeEditText?.error = "Time should be greater than 15 minutes from current time"
        Toast.makeText(this, "Time should be greater than 15 minutes from current time", Toast.LENGTH_SHORT).show()
        return@setOnClickListener
    }
    val reminderTime = selectedTime - 15 * 60 * 1000
    // Get the description from the EditText
    val descriptionText = findViewById<EditText>(R.id.editTextDescription).text.toString()

    // Schedule the notification
    scheduleNotification(reminderTime, name, descriptionText)
    val json = JSONObject()
    json.put("schedule_call_date", formattedDate)
    json.put("schedule_call_time", timeText)
    json.put("number", mobile)
    json.put("name", name)
    json.put("user_id", user_id)
    json.put("schedule_call_description", descriptionText)

    // Log or send the JSON object to your server/API
    Log.d("ReminderJSON", json.toString())
      val urlString = "https://staginglink.org/twice/add_call_schedule_api"  // API URL
       CallSummaryAsyncTask(this).execute(urlString, json.toString())
    // Finish the activity
    finish()
}


        dateEditText.setOnClickListener  {
            val calendar = Calendar.getInstance()  // Get today's date
            val datePicker = DatePickerDialog(
            this, // Context
                { _, year, month, dayOfMonth ->
                val selectedDate = String.format("%02d/%02d/%d", dayOfMonth, month + 1, year)
                dateEditText.setText(selectedDate)  // Set the selected date in the EditText
                },
                calendar.get(Calendar.YEAR),       // Current year
                calendar.get(Calendar.MONTH),      // Current month (0-indexed)
                calendar.get(Calendar.DAY_OF_MONTH) // Current day of the month
            )
            datePicker.datePicker.minDate = calendar.timeInMillis
            datePicker.show() // Show the DatePicker
        }
        timeEditText?.setOnClickListener {
    // Check if a date has been selected
    val selectedDate = dateEditText?.text.toString()
    if (selectedDate.isEmpty()) {
        // If date is not selected, set an error on the dateEditText
        dateEditText?.error = "Please select a date first"
    } else {
        // If date is selected, allow time selection
        val calendar = Calendar.getInstance()
        val timePicker = TimePickerDialog(
            this,
            { _, hourOfDay, minute ->
                // Convert the hour to 12-hour format
                val isAM = hourOfDay < 12
                val hour12 = if (hourOfDay % 12 == 0) 12 else hourOfDay % 12
                val selectedTime = String.format("%02d:%02d %s", hour12, minute, if (isAM) "AM" else "PM")
                timeEditText?.setText(selectedTime)
            },
            calendar.get(Calendar.HOUR_OF_DAY),  // Get the current hour (24-hour format)
            calendar.get(Calendar.MINUTE),       // Get the current minute
            false  // Set false for 12-hour format
        )
        timePicker.show()
        }
    }   
    }

    private fun createNotificationChannel() {
    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
        val soundUri = Uri.parse("android.resource://${this.packageName}/raw/notification")
        val channelId = "reminderChannel2"
        val channelName = "Reminder Channel"

        val audioAttributes = AudioAttributes.Builder()
            .setUsage(AudioAttributes.USAGE_NOTIFICATION)
            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
            .build()

        // Create the notification channel
        val channel = NotificationChannel(channelId, channelName, NotificationManager.IMPORTANCE_HIGH).apply {
            setSound(soundUri, audioAttributes) // Set custom sound with attributes
            enableVibration(true)
        }

        // Register the channel with the system
        val notificationManager = this.getSystemService(NotificationManager::class.java)
        notificationManager.createNotificationChannel(channel)
    }
}

private fun scheduleNotification(triggerTime: Long, name: String, description: String) {
    val intent = Intent(this, NotificationReceiver::class.java).apply {
        putExtra("name", name)
        putExtra("description", description)
    }
    val pendingIntent = PendingIntent.getBroadcast(this, 0, intent, PendingIntent.FLAG_IMMUTABLE)

    val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
    alarmManager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, triggerTime, pendingIntent)
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
                println("set reminder response ${response.toString()}")
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
                    Toast.makeText(context, "Call schedule successfully", Toast.LENGTH_LONG).show()
                } else {
                    Toast.makeText(context, "Failed to schedule call", Toast.LENGTH_LONG).show()
                }
            } catch (e: Exception) {
                e.printStackTrace()
                
                Toast.makeText(context, "Error in response", Toast.LENGTH_LONG).show()
            }
        }
    } 
}
