package com.quick.quickensolcrm

import android.app.Service
import android.content.Intent
import android.graphics.PixelFormat
import android.os.IBinder
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.view.WindowManager
import android.widget.TextView
import androidx.core.content.ContextCompat

class CallOverlayService : Service() {

    private lateinit var windowManager: WindowManager
    private lateinit var overlayView: View

    override fun onCreate() {
        super.onCreate()

        windowManager = getSystemService(WINDOW_SERVICE) as WindowManager

        val inflater = getSystemService(LAYOUT_INFLATER_SERVICE) as LayoutInflater
        overlayView = inflater.inflate(R.layout.overlay_popup, null)

        val layoutParams = WindowManager.LayoutParams(
            WindowManager.LayoutParams.MATCH_PARENT,
            WindowManager.LayoutParams.WRAP_CONTENT,
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,  // Permission needed
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
            PixelFormat.TRANSLUCENT
        )

        layoutParams.gravity = Gravity.TOP
        layoutParams.x = 0
        layoutParams.y = 100

        // Add the view to the window
        windowManager.addView(overlayView, layoutParams)

        // Dismiss the overlay on click
        overlayView.findViewById<View>(R.id.closeOverlay).setOnClickListener {
            windowManager.removeView(overlayView)
            stopSelf()
        }

        // Set the call information
        val callerName = overlayView.findViewById<TextView>(R.id.callerName)
        val callerNumber = overlayView.findViewById<TextView>(R.id.callerNumber)
        callerName.text = "Incoming Call"
        callerNumber.text = "John Doe"
    }

    override fun onDestroy() {
        super.onDestroy()
        if (this::overlayView.isInitialized) {
            windowManager.removeView(overlayView)
        }
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }
}
