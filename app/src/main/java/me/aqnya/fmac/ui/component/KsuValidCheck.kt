package me.aqnya.fmac.ui.component
 
import androidx.compose.runtime.Composable
import me.aqnya.fmac.Natives
import me.aqnya.fmac.ksuApp
 
@Composable
fun KsuIsValid(
    content: @Composable () -> Unit
) {
    val isManager = Natives.becomeManager(ksuApp.packageName)
    val ksuVersion = if (isManager) Natives.version else null
     
    if (ksuVersion != null) {
        content()
    }
}