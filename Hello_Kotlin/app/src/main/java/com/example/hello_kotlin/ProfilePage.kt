package com.example.hello_kotlin

import androidx.compose.foundation.Image
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Color.Companion.Blue
import androidx.compose.ui.graphics.Color.Companion.Cyan
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.constraintlayout.compose.ConstraintLayout
import com.example.hello_kotlin.ui.theme.Purple40

val gradientColors = listOf(Cyan, Blue, Purple40)

@Composable
fun ProfilePage(){
    Card(elevation = CardDefaults.cardElevation(6.dp), modifier = Modifier
        .padding(16.dp, 65.dp, 16.dp, 80.dp)) {
        ConstraintLayout {
            val (column)=createRefs()
            Column (horizontalAlignment= Alignment.CenterHorizontally , modifier = Modifier
                .verticalScroll(
                    rememberScrollState()
                )
                .constrainAs(column) {
                    top.linkTo(parent.top, margin = 30.dp)
                    bottom.linkTo(parent.bottom, margin = 40.dp)
                }){
                Image(painter = painterResource(id = R.drawable.me), contentDescription = "Erik",
                    modifier = Modifier
                        .size(200.dp)
                        .clip(CircleShape)
                        .border(width = 2.dp, color = Color.Green, shape = CircleShape),contentScale= ContentScale.Crop)
                Box(modifier = Modifier.height(15.dp))
                Text(text = "Erik Psw", fontSize = 50.sp, fontStyle = FontStyle.Italic, fontFamily = FontFamily.Cursive, style = TextStyle(
                    brush = Brush.linearGradient(
                        colors = gradientColors
                    )))
                Text(text = "潘世维", fontSize = 40.sp, fontFamily = FontFamily(Font(R.font.stzhongs)))
                Spacer(modifier = Modifier.height(10.dp))
                Text(text = "TONGJI UNIVERSITY", fontSize = 20.sp, fontFamily = FontFamily(Font(R.font.times)), fontWeight = FontWeight.Bold, color = Color(0,96,151))
                Row(horizontalArrangement = Arrangement.SpaceEvenly, modifier = Modifier.fillMaxSize()) {}

            }

    }
    }
}