package com.example.hello_kotlin

import android.bluetooth.BluetoothGattCharacteristic
import android.content.Context
import android.os.Handler
import android.os.Looper
import android.widget.Toast
import com.welie.blessed.*
import java.util.*


class BluetoothHelper(private val appContext: Context,mainViewModel: MainViewModel =  MainViewModel()
      ,  changeIsConnect:()->Unit
) {
    lateinit var characteristic:BluetoothGattCharacteristic

    private val bluetoothCentralManagerCallback: BluetoothCentralManagerCallback =
        object : BluetoothCentralManagerCallback() {
            override fun onDisconnectedPeripheral(
                peripheral: BluetoothPeripheral,
                status: HciStatus
            ) {
                super.onDisconnectedPeripheral(peripheral, status)
                mainViewModel.disconnected()
                changeIsConnect()
                mainViewModel.setLightValue("Not Connected")
                mainViewModel.setLightPercent(0.0f)
            }

            override fun onConnectedPeripheral(peripheral: BluetoothPeripheral) {//连接成功
                super.onConnectedPeripheral(peripheral)
                mainViewModel.connected()
                changeIsConnect()

                val writeC=peripheral.getCharacteristic(
                    UUID.fromString("0000ffe0-0000-1000-8000-00805f9b34fb"),
                    UUID.fromString("0000ffe1-0000-1000-8000-00805f9b34fb"))
                if (writeC!=null) characteristic=writeC

                peripheral.setNotify(characteristic,true)
            }


        }
    val peripheralCallback: BluetoothPeripheralCallback =
        object : BluetoothPeripheralCallback() {
            override fun onCharacteristicUpdate(
                peripheral: BluetoothPeripheral,
                value: ByteArray?,
                characteristic: BluetoothGattCharacteristic,
                status: GattStatus
            ) {
                super.onCharacteristicUpdate(peripheral, value, characteristic, status)
                if (value!=null)  {

//                    Toast.makeText(appContext,String(value), Toast.LENGTH_SHORT).show()
                    mainViewModel.setLightValue((4095-String(value).toInt()).toString())

                    mainViewModel.setLightPercent(1-(String(value).toFloat()/4096))
                }
            }
            }



    private val central = BluetoothCentralManager(appContext, bluetoothCentralManagerCallback, Handler(
        Looper.getMainLooper()));

    fun connectPeripheral(MAC_address:String): BluetoothPeripheral {
        val peripheral = central.getPeripheral(MAC_address)
        try {
            central.connectPeripheral(peripheral,peripheralCallback)
        } catch (e: java.lang.Exception){
            Toast.makeText(appContext, "Error", Toast.LENGTH_SHORT).show()
        }
        return peripheral
    }

    fun disconnectPeripheral( BLE_device: BluetoothPeripheral){
        central.cancelConnection(BLE_device)
    }

    fun sendMessage(peripheral:BluetoothPeripheral, characteristic: BluetoothGattCharacteristic, message:String){
        val str="@${message}.@${message}."
        peripheral.writeCharacteristic( characteristic, str.toByteArray(), WriteType.WITHOUT_RESPONSE)
    }

}