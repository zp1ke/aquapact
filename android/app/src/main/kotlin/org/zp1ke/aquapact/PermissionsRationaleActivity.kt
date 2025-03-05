package org.zp1ke.aquapact

import android.app.Activity
import android.os.Bundle
import android.widget.TextView

class PermissionsRationaleActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_permissions_rationale)

        val rationaleTextView: TextView = findViewById(R.id.rationaleTextView)
        rationaleTextView.text = getString(R.string.permissions_rationale)
    }
}