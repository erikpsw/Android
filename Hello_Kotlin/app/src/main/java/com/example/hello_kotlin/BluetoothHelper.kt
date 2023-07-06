package com.example.hello_kotlin

import android.bluetooth.BluetoothGattCharacteristic
import android.content.Context
import android.os.Handler
import android.os.Looper
import android.widget.Toast
import com.welie.blessed.*

class BluetoothHelper(private val appContext: Context) {


    private val bluetoothCentralManagerCallback: BluetoothCentralManagerCallback =
        object : BluetoothCentralManagerCallback() {
        }
    private val peripheralCallback: BluetoothPeripheralCallback =
        object : BluetoothPeripheralCallback() {
        }
    val central = BluetoothCentralManager(appContext, bluetoothCentralManagerCallback, Handler(
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
        peripheral.writeCharacteristic( characteristic, str.toByteArray(), WriteType.WITH_RESPONSE)
    }
}