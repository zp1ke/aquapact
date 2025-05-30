Diagram illustrating the high-level architecture of how the `aquapact` application synchronizes water intake records with the Android Health Connect platform, which can then be accessed by apps like Health Connect (currently implemented) and Samsung Health.

The home.dart file you're viewing is part of the "Flutter Frontend" container.

```mermaid
C4Context
  title AquaPact: Water Intake Sync with Health Connect

  Person(user, "User", "Interacts with the AquaPact app to log water intake and views health data on their device.")

  System_Boundary(aquapact_system, "AquaPact Application") {
    Container(flutter_frontend, "Flutter Frontend", "Dart/Flutter", "Provides the user interface (e.g., home.dart for intake logging), manages app state, and initiates data sync operations via MethodChannel. Resides in 'lib/'.")
    Container(native_android_layer, "Native Android Layer", "Kotlin", "Hosts MethodChannel handlers (MainActivity.kt) and the Health Connect Service (HealthConnect.kt) that wraps the Health Connect SDK. Resides in 'android/app/src/main/kotlin/'.")
  }

  System_Ext(health_connect_sdk, "Android Health Connect SDK/Platform", "Java/Kotlin APIs provided by Android", "Manages permissions and provides APIs to read/write health data (e.g., HydrationRecord) to a centralized store on the device.")
  System_Ext(samsung_health_app, "Samsung Health (or other Health App)", "Third-party Android Application", "Reads data from and potentially writes data to the Health Connect platform. Displays aggregated health information to the user.")

  Rel(user, flutter_frontend, "Logs Water Intake In / Views Status On")
  Rel(flutter_frontend, native_android_layer, "Sends Intake Data / Sync Commands", "Flutter MethodChannel (org.zp1ke.aquapact/health)")
  Rel(native_android_layer, health_connect_sdk, "Writes/Reads Hydration Data Using", "Health Connect SDK API Calls")
  Rel(health_connect_sdk, samsung_health_app, "Provides Hydration Data To / Receives From")
  Rel(user, samsung_health_app, "Views Water Intake Data In")

  UpdateRelStyle(user, flutter_frontend, $offsetY="-30")
  UpdateRelStyle(flutter_frontend, native_android_layer, $offsetY="0")
  UpdateRelStyle(native_android_layer, health_connect_sdk, $offsetY="0")
  UpdateRelStyle(health_connect_sdk, samsung_health_app, $offsetY="0")
  UpdateRelStyle(user, samsung_health_app, $offsetY="30", $offsetX="50")
```

**Explanation of Components and Flow:**

1.  **User:** Interacts with the **Flutter Frontend** of the AquaPact app (e.g., using UI elements defined in home.dart) to log their water intake.
2.  **Flutter Frontend (lib):**
    *   Captures the intake data.
    *   Uses services like `IntakesHandler` (intakes.dart) and `HealthChannelService` (health.dart).
    *   Communicates with the **Native Android Layer** via a Flutter `MethodChannel`.
3.  **Native Android Layer (aquapact):**
    *   `MainActivity.kt`: Receives calls from the Flutter Frontend via the MethodChannel.
    *   `HealthConnect.kt`: Contains the logic to interact with the **Android Health Connect SDK**. It translates the app's intake data into `HydrationRecord` objects (or other relevant Health Connect data types) and uses the SDK to write them.
4.  **Android Health Connect SDK/Platform:**
    *   This is an on-device data store and API layer provided by Android.
    *   The AquaPact **Native Android Layer** uses this SDK to request permissions and then to insert, update, or delete water intake records.
5.  **Samsung Health (or other Health App):**
    *   Acts as a client to the **Android Health Connect Platform**.
    *   If the user has granted permissions, Samsung Health can read the hydration data written by AquaPact (and other apps) from Health Connect and display it within its own interface.
    *   The interaction between AquaPact and Samsung Health is indirect, mediated by the Health Connect platform.

This architecture allows AquaPact to contribute water intake data to a centralized health data store on the user's device, making it accessible to the user through various health and fitness applications they might use, like Health Connect and Samsung Health.
