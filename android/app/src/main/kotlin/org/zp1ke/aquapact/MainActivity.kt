package org.zp1ke.aquapact

import android.util.Log
import androidx.activity.ComponentActivity
import androidx.annotation.NonNull
import androidx.health.connect.client.HealthConnectClient
import androidx.health.connect.client.PermissionController
import androidx.health.connect.client.permission.HealthPermission
import androidx.health.connect.client.records.HydrationRecord
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.DelicateCoroutinesApi
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import org.zp1ke.aquapact.HealthConnect.getHealthConnectClient

@OptIn(DelicateCoroutinesApi::class)
class MainActivity : FlutterFragmentActivity() {
    private val healthChannel = "org.zp1ke.aquapact/health"

    private val permissions =
        setOf(
            HealthPermission.getReadPermission(HydrationRecord::class),
            HealthPermission.getWritePermission(HydrationRecord::class),
        )

    private val requestPermissions =
        registerForActivityResult(PermissionController.createRequestPermissionResultContract()) { granted ->
            hasPermissions = granted.containsAll(permissions)
        }

    private var hasPermissions = false

    override fun configureFlutterEngine(@NonNull engine: FlutterEngine) {
        super.configureFlutterEngine(engine)
        MethodChannel(
            engine.dartExecutor.binaryMessenger,
            healthChannel
        ).setMethodCallHandler { call, result ->
            val activity = this as ComponentActivity
            if (call.method == "addIntake") {
                val intakeId = call.argument<String>("intakeId")
                val valueInLiters = call.argument<Double>("valueInLiters")
                val dateTimeMillis = call.argument<Long>("dateTimeMillis")
                Log.d("MainActivity", "addIntake: $valueInLiters, $dateTimeMillis")

                if (intakeId != null && valueInLiters != null && valueInLiters > 0 && dateTimeMillis != null) {
                    GlobalScope.launch {
                        HealthConnect.addIntake(
                            activity,
                            intakeId,
                            valueInLiters,
                            dateTimeMillis
                        ) { added ->
                            Log.d("MainActivity", "addIntake: $intakeId = $added")
                            result.success(added)
                        }
                    }
                } else {
                    result.success(false)
                }
            } else if (call.method == "checkPermissions") {
                val healthConnectClient = getHealthConnectClient(activity)
                if (healthConnectClient != null) {
                    GlobalScope.launch {
                        checkPermissionsAndRun(healthConnectClient)
                        result.success(hasPermissions)
                    }
                } else {
                    result.success(false)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private suspend fun checkPermissionsAndRun(healthConnectClient: HealthConnectClient) {
        val granted = healthConnectClient.permissionController.getGrantedPermissions()
        if (granted.containsAll(permissions)) {
            hasPermissions = true
        } else {
            requestPermissions.launch(permissions)
        }
    }
}
