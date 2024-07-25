package com.example.hello_kotlin

import androidx.compose.runtime.Composable
import androidx.lifecycle.ViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow

data class ConnectState(
    val state:Int =0,
    val connect_str: String = "connect",
    val indicator_size:Int=0
)

class MainViewModel:ViewModel() {

    fun loading() {
        _connectState.value = ConnectState(1,"",30)
    }

    fun connected() {
        _connectState.value = ConnectState(2,"connected",0)
    }

    fun disconnected() {
        _connectState.value = ConnectState(0,"connect",0)
    }

    fun setLightValue(str:String) {
        _lightValue.value = str
    }

    fun setLightPercent(percent:Float) {

        _lightPercent.value = percent

    }

    //只可在此文件中更改
    private val _connectState = MutableStateFlow(ConnectState())
    val connectState: StateFlow<ConnectState> = _connectState.asStateFlow()
    //对外只读状态流

    private val _lightValue = MutableStateFlow("Not Connected")
    val lightValue: StateFlow<String> = _lightValue.asStateFlow()

    private val _lightPercent = MutableStateFlow(0.0f)
    val lightPercent: StateFlow<Float> = _lightPercent.asStateFlow()

}

