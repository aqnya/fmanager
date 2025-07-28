package me.aqnya.fmanager

import android.graphics.Color
import android.os.Build
import android.os.Bundle
import androidx.core.graphics.ColorUtils
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "fmac/color"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            if (call.method == "getAccentColor") {
                val color = getSystemAccentColor()
                result.success(color)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getSystemAccentColor(): Int {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val accent = getColor(android.R.color.system_accent1_500)
            accent
        } else {
            // Android 11 及以下使用固定色
            Color.parseColor("#6200EE") // 紫色
        }
    }
}