package org.zp1ke.aquapact

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.os.Build
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

/**
 * Implementation of App Widget functionality.
 */
class StatusWidget : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
    }

    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
    }
}

internal fun updateAppWidget(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetId: Int
) {
    val widgetData = HomeWidgetPlugin.getData(context)
    val intakeDate = widgetData.getString("intake_date", "")
    val targetValue = widgetData.getInt("target_value", 1) // Avoid division by zero

    // Get today's date in the same format (YYYY-MM-DD format)
    val today = java.text.SimpleDateFormat("yyyy-MM-dd", java.util.Locale.getDefault())
        .format(java.util.Date())

    // Reset intake_value to 0 if intake_date is missing or different from today
    val intakeValue = if (intakeDate.isNullOrEmpty() || intakeDate != today) {
        0
    } else {
        widgetData.getInt("intake_value", 0)
    }

    // Calculate percentage (0-100)
    val percentage = if (targetValue > 0) {
        ((intakeValue.toFloat() / targetValue.toFloat()) * 100).toInt().coerceIn(0, 100)
    } else {
        0
    }

    val views = RemoteViews(context.packageName, R.layout.status_widget).apply {
        // Set progress bar to fill water drop from bottom (using 10000 as max for smoother animation)
        setProgressBar(R.id.water_drop_progress, 10000, percentage * 100, false)

        // Set percentage text
        setTextViewText(R.id.percentage_text, "$percentage%")

        // Create intent to launch the app
        val intent = context.packageManager.getLaunchIntentForPackage(context.packageName)
        val pendingIntent = PendingIntent.getActivity(
            context,
            0,
            intent,
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            } else {
                PendingIntent.FLAG_UPDATE_CURRENT
            }
        )

        // Set click listener on the entire widget
        setOnClickPendingIntent(R.id.widget_root, pendingIntent)
    }
    appWidgetManager.updateAppWidget(appWidgetId, views)
}