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
    suspend fun saveIntake(
        activity: ComponentActivity,
        recordId: String?,
        intakeId: String,
        valueInLiters: Double,
        dateTimeMillis: Long,
        callback: (String?) -> Unit
    ) {
        val healthConnectClient = getHealthConnectClient(activity)
        var resultId: String? = null
        if (healthConnectClient != null) {
            resultId =
                saveIntake(healthConnectClient, recordId, intakeId, valueInLiters, dateTimeMillis)
        }
        callback(resultId)
    }

    private suspend fun saveIntake(
        healthConnectClient: HealthConnectClient,
        recordId: String?,
        intakeId: String,
        valueInLiters: Double,
        dateTimeMillis: Long
    ): String? {
        val instant = Instant.ofEpochMilli(dateTimeMillis)
        val record = HydrationRecord(
            volume = Volume.liters(valueInLiters),
            startTime = instant,
            endTime = instant.plusMillis(1),
            startZoneOffset = ZoneOffset.UTC,
            endZoneOffset = ZoneOffset.UTC,
            metadata = Metadata.manualEntry(clientRecordId = intakeId),
        )
        try {
            if (recordId != null) {
                // Update an existing HydrationRecord
                healthConnectClient.updateRecords(listOf(record))
                Log.d("HealthConnect", "Record updated: $recordId")
                return recordId
            }
            // Create a new HydrationRecord
            val response = healthConnectClient.insertRecords(listOf(record))
            Log.d("HealthConnect", "Record added: ${response.recordIdsList}")
            return response.recordIdsList.first()
        } catch (e: Exception) {
            Log.e("HealthConnect", e.message, e)
            return null
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