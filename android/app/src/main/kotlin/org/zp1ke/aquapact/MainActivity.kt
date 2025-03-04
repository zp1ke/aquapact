package org.zp1ke.aquapact

import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val healthChannel = "org.zp1ke.aquapact/health"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            healthChannel
        ).setMethodCallHandler { call, result ->
            if (call.method == "addIntake") {
                val value = call.argument<Double>("value")
                val dateTimeMillis = call.argument<Long>("dateTimeMillis")
                Log.d("MainActivity", "addIntake: $value, $dateTimeMillis")
                // TODO
                result.success(true)
            } else {
                result.notImplemented()
            }
        }
    }
}
