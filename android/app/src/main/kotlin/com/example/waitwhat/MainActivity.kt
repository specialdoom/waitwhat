package com.example.waitwhat

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Intent
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.Calendar

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.example.waitwhat/settings",
        ).setMethodCallHandler { call, result ->
            if (call.method == "openNotificationListenerSettings") {
                startActivity(Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS))
                result.success(null)
            } else {
                result.notImplemented()
            }
        }

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.example.waitwhat/notifications",
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "requestPermission" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                        requestPermissions(
                            arrayOf(android.Manifest.permission.POST_NOTIFICATIONS),
                            0,
                        )
                    }
                    result.success(null)
                }
                "showNotification" -> {
                    val id = call.argument<Int>("id") ?: 0
                    val title = call.argument<String>("title") ?: ""
                    val body = call.argument<String>("body") ?: ""
                    NotificationReceiver.showNotification(this, id, title, body)
                    result.success(null)
                }
                "scheduleDailyReminder" -> {
                    val hour = call.argument<Int>("hour") ?: 9
                    val minute = call.argument<Int>("minute") ?: 0
                    scheduleDailyAlarm(hour, minute)
                    result.success(null)
                }
                "cancelDailyReminder" -> {
                    cancelDailyAlarm()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun alarmPendingIntent(): PendingIntent {
        val intent = Intent(this, NotificationReceiver::class.java).apply {
            putExtra("title", "Pending todos")
            putExtra("body", "You have todos waiting for your attention")
        }
        return PendingIntent.getBroadcast(
            this,
            NotificationReceiver.DAILY_REMINDER_ID,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
    }

    private fun scheduleDailyAlarm(hour: Int, minute: Int) {
        val alarmManager = getSystemService(ALARM_SERVICE) as AlarmManager
        val triggerTime = Calendar.getInstance().apply {
            set(Calendar.HOUR_OF_DAY, hour)
            set(Calendar.MINUTE, minute)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
            if (timeInMillis <= System.currentTimeMillis()) add(Calendar.DATE, 1)
        }.timeInMillis
        alarmManager.setInexactRepeating(
            AlarmManager.RTC_WAKEUP,
            triggerTime,
            AlarmManager.INTERVAL_DAY,
            alarmPendingIntent(),
        )
    }

    private fun cancelDailyAlarm() {
        val alarmManager = getSystemService(ALARM_SERVICE) as AlarmManager
        alarmManager.cancel(alarmPendingIntent())
    }
}
