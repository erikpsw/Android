package com.example.hello_kotlin

import androidx.compose.foundation.layout.height
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.Build
import androidx.compose.material.icons.outlined.Create
import androidx.compose.material.icons.outlined.Face
import androidx.compose.material.icons.outlined.Person
import androidx.compose.runtime.Composable
import androidx.compose.material3.Icon
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.NavigationBarItem
import androidx.compose.material3.Text
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.unit.dp
import androidx.navigation.NavHostController

//seal 密封结构体枚举
sealed class ButtomData(val icon: ImageVector ,val title:String,val nav:String) {
    object Main:ButtomData(icon= Icons.Outlined.Build, title = "Main","IotPage")
    object Profile:ButtomData(icon= Icons.Outlined.Person, title = "Profile","ProfilePage")
}

@Composable
fun ButtonMenu(navigation:NavHostController){

    val items= listOf(ButtomData.Main,ButtomData.Profile)
    NavigationBar(containerColor = Color.White, contentColor = Color.Black, modifier = Modifier.height(70.dp)) {
        for (it in items) {
            NavigationBarItem(
                label = {Text(it.title)},
                alwaysShowLabel = true,
                selected = false,
                onClick = { navigation.navigate(it.nav) },
                icon = { Icon(imageVector = it.icon, contentDescription = it.title) })

        } }

}

