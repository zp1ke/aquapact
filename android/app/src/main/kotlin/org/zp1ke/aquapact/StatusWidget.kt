package org.zp1ke.aquapact

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
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
        // Set progress bar (using 10000 as max for smoother animation, so multiply by 100)
        setProgressBar(R.id.intake_progress_bar, 10000, percentage * 100, false)

        // Set percentage text
        setTextViewText(R.id.percentage_text, "$percentage%")
    }
    appWidgetManager.updateAppWidget(appWidgetId, views)
}