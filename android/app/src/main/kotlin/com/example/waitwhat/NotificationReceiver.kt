package com.example.waitwhat

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.PowerManager
import androidx.core.app.NotificationCompat

class NotificationReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val wl = (context.getSystemService(Context.POWER_SERVICE) as PowerManager)
            .newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "waitwhat:dailyreminder")
        wl.acquire(60_000L)
        try {
            val title = intent.getStringExtra("title") ?: "Pending todos"
            val body = intent.getStringExtra("body") ?: "You have todos waiting for your attention"
            showNotification(context, DAILY_REMINDER_ID, title, body)
        } finally {
            wl.release()
        }
    }

    companion object {
        const val DAILY_REMINDER_ID = 1
        private const val CHANNEL_ID = "waitwhat_todos"
        private const val CHANNEL_NAME = "Todos"

        fun createChannel(context: Context) {
            val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            manager.createNotificationChannel(
                NotificationChannel(CHANNEL_ID, CHANNEL_NAME, NotificationManager.IMPORTANCE_DEFAULT)
            )
        }

        fun showNotification(context: Context, id: Int, title: String, body: String) {
            val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

            val openIntent = android.content.Intent(context, MainActivity::class.java).apply {
                action = "OPEN_TODOS"
                flags = android.content.Intent.FLAG_ACTIVITY_SINGLE_TOP or
                        android.content.Intent.FLAG_ACTIVITY_CLEAR_TOP
            }
            val contentIntent = android.app.PendingIntent.getActivity(
                context, 0, openIntent,
                android.app.PendingIntent.FLAG_UPDATE_CURRENT or
                        android.app.PendingIntent.FLAG_IMMUTABLE,
            )

            val notification = NotificationCompat.Builder(context, CHANNEL_ID)
                .setSmallIcon(R.mipmap.ic_launcher)
                .setContentTitle(title)
                .setContentText(body)
                .setAutoCancel(true)
                .setContentIntent(contentIntent)
                .build()

            manager.notify(id, notification)
        }
    }
}
