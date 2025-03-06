package org.zp1ke.aquapact

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalUriHandler
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import org.zp1ke.aquapact.theme.AppTheme

class PermissionsRationaleActivity : ComponentActivity() {
    @OptIn(ExperimentalMaterial3Api::class)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        enableEdgeToEdge()

        setContent {
            AppTheme {
                Scaffold(
                    modifier = Modifier.fillMaxSize(),
                    containerColor = MaterialTheme.colorScheme.background,
                    topBar = {
                        TopAppBar(
                            title = {
                                Text(stringResource(R.string.app_name))
                            })
                    },
                ) { innerPadding ->
                    Surface(
                        modifier = Modifier
                            .fillMaxSize()
                            .padding(innerPadding),
                    ) {
                        PrivacyPolicyScreen()
                    }
                }
            }
        }
    }
}

@Composable
fun PrivacyPolicyScreen() {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(32.dp),
        verticalArrangement = Arrangement.Top,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Row(
            horizontalArrangement = Arrangement.SpaceAround,
            verticalAlignment = Alignment.CenterVertically,
        ) {
            Image(
                modifier = Modifier.fillMaxWidth(0.5f),
                painter = painterResource(id = R.drawable.ic_aquapact_logo),
                contentDescription = stringResource(id = R.string.app_name)
            )
            Image(
                modifier = Modifier.fillMaxWidth(0.5f),
                painter = painterResource(id = R.drawable.ic_health_connect_logo),
                contentDescription = stringResource(id = R.string.health_connect_logo)
            )
        }
        Spacer(modifier = Modifier.height(32.dp))
        Text(
            text = stringResource(id = R.string.privacy_policy),
            color = MaterialTheme.colorScheme.onBackground,
            style = MaterialTheme.typography.bodyLarge,
        )
        Spacer(modifier = Modifier.height(32.dp))
        Text(
            text = stringResource(R.string.privacy_policy_description),
            style = MaterialTheme.typography.bodyMedium,
            textAlign = TextAlign.Justify,
        )
        Spacer(modifier = Modifier.height(32.dp))
        WebButton()
    }
}

@Preview
@Composable
fun PrivacyPolicyScreenPreview() {
    AppTheme {
        PrivacyPolicyScreen()
    }
}

@Composable
fun WebButton() {
    val uriHandler = LocalUriHandler.current
    val url = "https://sp1ke.dev/aquapact"

    OutlinedButton(
        onClick = { uriHandler.openUri(url) }, modifier = Modifier.padding(8.dp)
    ) {
        Text(stringResource(R.string.full_privacy_policy))
    }
}