package com.example.hello_kotlin

import android.content.Context
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.interaction.collectIsPressedAsState
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.*
import androidx.compose.material3.CardDefaults.cardElevation
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.constraintlayout.compose.ConstraintLayout
import com.welie.blessed.BluetoothPeripheral

var times=0


@Composable
fun CircularProgressIndicatorSample(
    connect_Str:String,indicator_size:Int,state:Int,connect_fun:()->Unit,disconnect_fun:()->Unit
) {
    Column(horizontalAlignment = Alignment.CenterHorizontally) {
        Button(
            onClick = {
                if(state==0){
                    connect_fun()
                }
                if(state==2){
                    disconnect_fun()
                }
        } ){
            Text(connect_Str)
            CircularProgressIndicator(color = Color.White, modifier = Modifier.size(indicator_size.dp))
        }
        Spacer(Modifier.requiredHeight(10.dp))
    }
}


@Composable
fun MainPage(appContent:Context,mainViewModel: MainViewModel =  MainViewModel()) {
    val connectState by mainViewModel.connectState.collectAsState()
    lateinit var bleDevice:BluetoothPeripheral
    var isConnect=false
    val lightValue by mainViewModel.lightValue.collectAsState()
    val lightPercent by mainViewModel.lightPercent.collectAsState()
    fun changeIsConnect(){
        isConnect=!isConnect
    }
    val bluetoothHelper=BluetoothHelper(appContent,mainViewModel){changeIsConnect()}
    Text("Iot Devices Control",
        modifier = Modifier
            .padding(8.dp)
            , style = MaterialTheme.typography.titleLarge)

    Column() {
        Card(elevation = cardElevation(8.dp), modifier = Modifier
            .padding(16.dp, 70.dp, 16.dp, 20.dp)) {
            ConstraintLayout {
                val (column)=createRefs()


                Column (horizontalAlignment=Alignment.CenterHorizontally , modifier = Modifier
                    .verticalScroll(
                        rememberScrollState()
                    )
                    .constrainAs(column) {
                        top.linkTo(parent.top, margin = 20.dp)
                        bottom.linkTo(parent.bottom, margin = 40.dp)
                    } ){
//            Box(modifier = Modifier.height(30.dp))
                    Spacer(modifier = Modifier.height(10.dp))
                    Row(horizontalArrangement = Arrangement.SpaceEvenly, modifier = Modifier.fillMaxSize()) {
                    }
                    Text(text = "connect to Bluetooth", style= MaterialTheme.typography.titleLarge)
                    Spacer(modifier = Modifier.height(5.dp))
                    CircularProgressIndicatorSample(connectState.connect_str,connectState.indicator_size,connectState.state,
                        {
                            bleDevice=bluetoothHelper.connectPeripheral("C8:47:80:03:24:BF")
                            mainViewModel.loading()},
                        {
                            bluetoothHelper.disconnectPeripheral(bleDevice)
                            mainViewModel.loading()
                        }
                    )
                    Spacer(modifier = Modifier.height(5.dp))
                    Text(text = "Light Control", style= MaterialTheme.typography.titleMedium)
                    Spacer(modifier = Modifier.height(3.dp))
                    var checked by remember { mutableStateOf(false) }
                    Switch(checked = checked, onCheckedChange = { checked = it
                        if(isConnect){
                            if(checked){
                                bluetoothHelper.sendMessage(bleDevice,bluetoothHelper.characteristic,"A") }
                            else{

                                bluetoothHelper.sendMessage(bleDevice,bluetoothHelper.characteristic,"B")}}
                    })
                    val interactionSource = remember { MutableInteractionSource() }
                    val isPressed by interactionSource.collectIsPressedAsState()
                    LaunchedEffect(isPressed) {
                        // isPressed状态变化后执行的代码
                        if(isConnect){
                            if (isPressed) {
                                bluetoothHelper.sendMessage(bleDevice,bluetoothHelper.characteristic,"C")
                            } else {
                                bluetoothHelper.sendMessage(bleDevice,bluetoothHelper.characteristic,"D")
                            }
                        }
                    }
                    Spacer(modifier = Modifier.height(5.dp))
                    Text(text = "Buzzer Control", style= MaterialTheme.typography.titleMedium)
                    Spacer(modifier = Modifier.height(3.dp))
                    Button(
                        onClick = {
                        },
                        interactionSource = interactionSource, modifier = Modifier.width(100.dp)) {

                    }

                }

            }

        }
        Card(elevation = cardElevation(10.dp), modifier = Modifier
            .padding(16.dp, 0.dp, 16.dp, 80.dp)
            .width(200.dp).height(140.dp)) {
            Spacer(modifier = Modifier.height(20.dp))
                Text(text = "Light Value", style= MaterialTheme.typography.titleMedium,modifier = Modifier.align(alignment = Alignment.CenterHorizontally))
                    Spacer(modifier = Modifier.height(20.dp))
            LinearProgressIndicator(progress = lightPercent,modifier = Modifier.align(alignment = Alignment.CenterHorizontally))
            Spacer(modifier = Modifier.height(20.dp))
                    Text(text = lightValue,modifier = Modifier.align(alignment = Alignment.CenterHorizontally))
                }

        }
    }



