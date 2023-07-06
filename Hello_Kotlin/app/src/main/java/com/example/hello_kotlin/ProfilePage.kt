package com.example.hello_kotlin

import android.content.Context

import androidx.compose.foundation.Image
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.*
import androidx.compose.material3.CardDefaults.cardElevation
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.RectangleShape
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontStyle
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.constraintlayout.compose.ConstraintLayout
import com.welie.blessed.BluetoothPeripheral
import java.util.*




@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ProfilePage(appContent:Context){
    lateinit var BLE_Device:BluetoothPeripheral
    val bluetoothHelper=BluetoothHelper(appContent)

    Card(elevation = cardElevation(6.dp), modifier = Modifier
        .padding(16.dp, 70.dp, 16.dp, 100.dp)) {
ConstraintLayout {
    val (column)=createRefs()

    Column (horizontalAlignment=Alignment.CenterHorizontally , modifier = Modifier
        .verticalScroll(
            rememberScrollState()
        )
        .constrainAs(column) {
            top.linkTo(parent.top, margin = 65.dp)
            end.linkTo(parent.end)
        } ){
//            Box(modifier = Modifier.height(30.dp))
        Image(painter = painterResource(id = R.drawable.me), contentDescription = "Erik",
            modifier = Modifier
                .size(200.dp)
                .clip(CircleShape)
                .border(width = 2.dp, color = Color.Green, shape = CircleShape),contentScale=ContentScale.Crop)
        Box(modifier = Modifier.height(15.dp))
        Text(text = "Erik Psw", fontSize = 30.sp, fontStyle = FontStyle.Italic, fontFamily = FontFamily.Cursive)
        Text(text = "潘世维", fontSize = 30.sp, fontFamily = FontFamily.Serif)
        Spacer(modifier = Modifier.height(10.dp))
        Row(horizontalArrangement = Arrangement.SpaceEvenly, modifier = Modifier.fillMaxSize()) {
            Button(onClick = {
                BLE_Device=bluetoothHelper.connectPeripheral("C8:47:80:03:24:BF")

                             }, shape = RectangleShape) {
                Text(text = "Connect", fontSize = 20.sp, fontStyle = FontStyle.Normal, fontFamily = FontFamily(
                    Font(R.font.tinos)))
            }
            Button(onClick = { bluetoothHelper.disconnectPeripheral(BLE_Device) }, shape = RectangleShape) {
                Text(text = "Disconnect", fontSize = 20.sp, fontStyle = FontStyle.Normal, fontFamily = FontFamily(
                    Font(R.font.tinos)))
            }

        }
        Spacer(modifier = Modifier.height(20.dp))
        Row(horizontalArrangement = Arrangement.SpaceEvenly, modifier = Modifier.fillMaxSize()) {
            Button(onClick = { val characteristic=BLE_Device.getCharacteristic(UUID.fromString("0000ffe0-0000-1000-8000-00805f9b34fb"),UUID.fromString("0000ffe1-0000-1000-8000-00805f9b34fb"))
                if (characteristic != null) {
                    bluetoothHelper.sendMessage(BLE_Device,characteristic,"A")
                }

            }, shape = RectangleShape) {
                Text(text = "Light", fontSize = 20.sp, fontStyle = FontStyle.Normal, fontFamily = FontFamily(
                    Font(R.font.tinos)))
            }
            Button(onClick = {
                val characteristic=BLE_Device.getCharacteristic(UUID.fromString("0000ffe0-0000-1000-8000-00805f9b34fb"),UUID.fromString("0000ffe1-0000-1000-8000-00805f9b34fb"))
                if (characteristic != null) {
                    bluetoothHelper.sendMessage(BLE_Device,characteristic,"B")
                             }}, shape = RectangleShape) {
                Text(text = "Disconnect", fontSize = 20.sp, fontStyle = FontStyle.Normal, fontFamily = FontFamily(
                    Font(R.font.tinos)))
                }
            }
        }
    }
}

}
