package org.zp1ke.aquapact

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.util.Log
import androidx.activity.ComponentActivity
import androidx.health.connect.client.HealthConnectClient
import androidx.health.connect.client.records.HydrationRecord
import androidx.health.connect.client.records.metadata.Metadata
import androidx.health.connect.client.units.Volume
import java.time.Instant
import java.time.ZoneOffset

object HealthConnect {
    suspend fun addIntake(
        activity: ComponentActivity,
        intakeId: String,
        valueInLiters: Double,
        dateTimeMillis: Long,
        callback: (Boolean) -> Unit
    ) {
        val healthConnectClient = getHealthConnectClient(activity)
        var added = false
        if (healthConnectClient != null) {
            added = addIntake(healthConnectClient, intakeId, valueInLiters, dateTimeMillis)
        }
        callback(added)
    }

    private suspend fun addIntake(
        healthConnectClient: HealthConnectClient,
        intakeId: String,
        valueInLiters: Double,
        dateTimeMillis: Long
    ): Boolean {
        val instant = Instant.ofEpochMilli(dateTimeMillis)
        try {
            val record = HydrationRecord(
                volume = Volume.liters(valueInLiters),
                startTime = instant,
                endTime = instant,
                startZoneOffset = ZoneOffset.UTC,
                endZoneOffset = ZoneOffset.UTC,
                metadata = Metadata.manualEntryWithId(intakeId),
            )
            healthConnectClient.insertRecords(listOf(record))
            return true
        } catch (e: Exception) {
            Log.e("HealthConnect", e.message, e)
            return false
        }
    }

    fun getHealthConnectClient(activity: Activity): HealthConnectClient? {
        if (healthIsAvailable(activity)) {
            return HealthConnectClient.getOrCreate(activity)
        }
        return null
    }

    private fun healthIsAvailable(context: Context): Boolean {
        val availabilityStatus = HealthConnectClient.getSdkStatus(context)
        if (availabilityStatus == HealthConnectClient.SDK_UNAVAILABLE_PROVIDER_UPDATE_REQUIRED) {
            val uri =
                "market://details?id=com.google.android.apps.healthdata&url=healthconnect%3A%2F%2Fonboarding"
            context.startActivity(
                Intent(Intent.ACTION_VIEW).apply {
                    setPackage("com.android.vending")
                    data = Uri.parse(uri)
                    putExtra("overlay", true)
                    putExtra("callerId", context.packageName)
                }
            )
            return false
        }
        return availabilityStatus == HealthConnectClient.SDK_AVAILABLE
    }
}