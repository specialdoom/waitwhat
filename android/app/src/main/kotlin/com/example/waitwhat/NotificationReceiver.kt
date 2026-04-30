package com.example.waitwhat

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import androidx.core.app.NotificationCompat

class NotificationReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val title = intent.getStringExtra("title") ?: "Pending todos"
        val body = intent.getStringExtra("body") ?: "You have todos waiting for your attention"
        showNotification(context, DAILY_REMINDER_ID, title, body)
    }

    companion object {
        const val DAILY_REMINDER_ID = 1
        private const val CHANNEL_ID = "waitwhat_todos"
        private const val CHANNEL_NAME = "Todos"

        fun showNotification(context: Context, id: Int, title: String, body: String) {
            val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

            val channel = NotificationChannel(
                CHANNEL_ID,
                CHANNEL_NAME,
                NotificationManager.IMPORTANCE_DEFAULT,
            )
            manager.createNotificationChannel(channel)

            val notification = NotificationCompat.Builder(context, CHANNEL_ID)
                .setSmallIcon(R.mipmap.ic_launcher)
                .setContentTitle(title)
                .setContentText(body)
                .setAutoCancel(true)
                .build()

            manager.notify(id, notification)
        }
    }
}
