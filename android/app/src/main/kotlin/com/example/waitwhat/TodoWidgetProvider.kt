package com.example.waitwhat

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.graphics.Color
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider
import org.json.JSONArray

class TodoWidgetProvider : HomeWidgetProvider() {

    private data class Slot(
        val container: Int,
        val priorityBar: Int,
        val title: Int,
        val due: Int,
    )

    private val slots = listOf(
        Slot(R.id.slot_0, R.id.priority_0, R.id.title_0, R.id.due_0),
        Slot(R.id.slot_1, R.id.priority_1, R.id.title_1, R.id.due_1),
        Slot(R.id.slot_2, R.id.priority_2, R.id.title_2, R.id.due_2),
        Slot(R.id.slot_3, R.id.priority_3, R.id.title_3, R.id.due_3),
        Slot(R.id.slot_4, R.id.priority_4, R.id.title_4, R.id.due_4),
    )

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        val json = widgetData.getString("widget_todos", "[]") ?: "[]"
        val todos = try { JSONArray(json) } catch (e: Exception) { JSONArray() }

        val openIntent = Intent(context, MainActivity::class.java).apply {
            action = "OPEN_TODOS"
            flags = Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }
        val pendingIntent = PendingIntent.getActivity(
            context, 0, openIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )

        appWidgetIds.forEach { id ->
            val views = RemoteViews(context.packageName, R.layout.todo_widget)
            views.setOnClickPendingIntent(R.id.widget_root, pendingIntent)

            views.setViewVisibility(
                R.id.empty_view,
                if (todos.length() == 0) View.VISIBLE else View.GONE,
            )

            slots.forEachIndexed { i, slot ->
                if (i < todos.length()) {
                    val todo = todos.getJSONObject(i)
                    val due = todo.optString("due", "")

                    views.setViewVisibility(slot.container, View.VISIBLE)
                    views.setTextViewText(slot.title, todo.optString("title", ""))
                    views.setInt(
                        slot.priorityBar,
                        "setBackgroundColor",
                        priorityColor(todo.optString("priority", "medium")),
                    )

                    if (due.isNotEmpty()) {
                        views.setViewVisibility(slot.due, View.VISIBLE)
                        views.setTextViewText(slot.due, due)
                    } else {
                        views.setViewVisibility(slot.due, View.GONE)
                    }
                } else {
                    views.setViewVisibility(slot.container, View.GONE)
                }
            }

            appWidgetManager.updateAppWidget(id, views)
        }
    }

    private fun priorityColor(priority: String): Int = when (priority) {
        "high" -> Color.parseColor("#D32F2F")
        "low" -> Color.parseColor("#388E3C")
        else -> Color.parseColor("#F57C00")
    }
}
