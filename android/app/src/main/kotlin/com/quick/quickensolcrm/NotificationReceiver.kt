// NotificationReceiver.kt
package com.quick.quickensolcrm
import android.net.Uri
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import android.util.Log

class NotificationReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val name =  "Schedule Reminder"
        val description =  "You have scheduled a call with $name after 15 mins"
        //val soundUri = Uri.parse("android.resource://${context.packageName}/raw/notification")
       // Log.d("Sound URI", soundUri.toString())
        val notificationBuilder = NotificationCompat.Builder(context, "reminderChannel2")
            .setSmallIcon(R.drawable.ic_launcher) // replace with your app's notification icon
            .setContentTitle(name)
            .setContentText(description)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setAutoCancel(true)
           // .setSound(soundUri) 

        with(NotificationManagerCompat.from(context)) {
            notify(100, notificationBuilder.build())
        }
    }
}
