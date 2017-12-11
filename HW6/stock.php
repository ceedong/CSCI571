
<!DOCTYPE html>
    <html>
        <head>
            <style>
                .leftarea{
                    background-color:rgb(245,245,245);
                }
                .errors{
                    position:relative;
                    top:20px;
                    width:60%;
                    margin:auto;
                }
                a{
                    text-decoration: none;
                }
                #info{
                    bottom:10px;
                } 
                .newStyle{
                    text-align: center;
                    font-size:80%;
                    font-family:sans-serif;
                    color:rgb(191,191,191);
                }
                .screen{
                    background-color:rgb(245,245,245);
                    width:300px;
                    height:150px;
                    margin:0 auto;
                    text-align: center;
                    font-family:CG Times;
                    font-size:150%;
                    border:1px solid grey;
                }
                .ticker{
                    font-size:50%;
                }
                .buttons{
                    position: relative;
                    bottom:30px;
                    left:60px;
                }
                .ticker1{
                    position: relative;
                    bottom:60px;
                    right:90px;
                    font-size:50%;
                }
                table {
                border-collapse: collapse;
                width: 100%;
                }

                table, tr, th {
                border: 1px solid black;
                font-family:CG Times;
                        }
                th{
                    text-align: left;
                    background-color:rgb(245,245,245);
                        }
                .thisleft tr{
                    text-align: center;
                    background-color:rgb(251,251,251);
                        }
                img{
                    width:15px;
                    height:15px;
                        }
                table{
                    position:relative;
                    top:-140px;
                }
            </style>
          
            <script>
            function clearStuff(ele){
               ele.value = "";
            } 
    

                
            function check(){
                var output = true;
                if(document.getElementById('Ticker').value == "")
                {output = false;
                alert("Please enter a value!");
                return output;}
            }
            
            function viewPrice(x, y, z, w, v, t, l){             
             new Highcharts.Chart('container',{  
                            lang: {
        numericSymbols: ['k', ' M']
    },
    chart: {
      
        
    },
    title: {
        text: 'Stock Price ('+ w +')'
    },
     subtitle: {
        text: '<a href="https://www.alphavantage.co/" style>Source: Alpha Vantage</a>'
    },
    xAxis: {
        categories:x,
        crosshair: true,
        tickInterval:5
    },
       yAxis: [{ // Primary yAxis
          min:135,
         max:170,
       tickInterval:5,
          
       title: {
           text: 'Stock Price',
      }
   },
    { // Secondary yAxis
       title: {
           text: 'Volume',   
        },
         // min:0,
          max:l*4,
        // tickInterval:50000000,
          opposite: true
   }],
    legend: {
        align: 'right',
        verticalAlign: 'middle',
        layout: 'vertical'
    },
    series: [{
     yAxis:0,
         name: v,
          type: 'area',
          color: '#ef9291',
          data:z},
        { yAxis:1,
         name: v + ' Volume',
          type: 'column',
          color: 'white',
         data:y
    }]
       });                                 
           document.getElementById("news").innerHTML="<div class='newStyle' onclick='anotherButton()'>click to show stock news<br><img src='http://cs-server.usc.edu:45678/hw/hw6/images/Gray_Arrow_Down.png'></div>";                    
           //document.getElementById("news").innerHTML+=e.length;
           
            }
                
            function anotherButton(){
                   document.getElementById("news").innerHTML="<div class='newStyle' onclick='anotherButton1()'>click to hide stock news<br><img src='http://cs-server.usc.edu:45678/hw/hw6/images/Gray_Arrow_Up.png'></div>"; 
                   
                }
           function anotherButton1(){
                   document.getElementById("news").innerHTML="<div class='newStyle' onclick='anotherButton()'>click to show stock news<br><img src='http://cs-server.usc.edu:45678/hw/hw6/images/Gray_Arrow_Down.png'></div>"; 
               
                }     
                
                
                function viewSMA(x1,y){  
                            url = "https://www.alphavantage.co/query?function=SMA&symbol=" +y +"&interval=daily&time_period=10&series_type=close&apikey=8DIPSKNL7WX7C3IG";
                var xmlhttp = new XMLHttpRequest();
                xmlhttp.onreadystatechange = function(){
                    if (this.readyState == 4 && this.status == 200){
                     jsonObj = JSON.parse(xmlhttp.responseText);
                        jsonObj2 = jsonObj["Technical Analysis: SMA"];
                        var num =[];
                        for(key in jsonObj2){
                            nums = parseFloat(jsonObj2[key]["SMA"]);
                            num.push(nums);
                            if(key == "2017-04-10"){
                                break;
                            }
                            var numNew =[];
                         for (var i = num.length-1; i>=0; i--){
                             numNew.push(num[i]);
                         }
                         
                        }
                       
                    
                        //for the SMA chart 
                        Highcharts.chart('container', {
    title: {
        text: 'Simple Moving Average (SMA)'
    },
    subtitle: {
        text:  '<a href="https://www.alphavantage.co/" style>Source: Alpha Vantage</a>'
    },
    xAxis: {
        categories:x1,
        crosshair: true,
        tickInterval:5
    },
    yAxis: {
          //  min: 137.5,
          //  max: 165,
         //   tickInterval:2.5,
            title: {
           text: 'SMA'  
        }   
    },
     legend: {
        align: 'right',
        verticalAlign: 'middle',
        layout: 'vertical'
    },
    series: [{
        name: jsonObj["Meta Data"]["1: Symbol"],
        data: numNew,
        color: '#ef9291'
                    }],
                 });
               }
            }
                xmlhttp.open("GET",url,true);
                xmlhttp.send();        
                }
             
                function viewEMA(x1,y){
                                  url = "https://www.alphavantage.co/query?function=EMA&symbol="+y+"&interval=daily&time_period=10&series_type=close&apikey=8DIPSKNL7WX7C3IG";
                var xmlhttp = new XMLHttpRequest();
                xmlhttp.onreadystatechange = function(){
                    if (this.readyState == 4 && this.status == 200){
                     jsonObj = JSON.parse(xmlhttp.responseText);
                        jsonObj2 = jsonObj["Technical Analysis: EMA"];
                        var num =[];
                        for(key in jsonObj2){
                            nums = parseFloat(jsonObj2[key]["EMA"]);
                            num.push(nums);
                            if(key == "2017-04-10"){
                                break;
                            }
                            var numNew =[];
                         for (var i = num.length-1; i>=0; i--){
                             numNew.push(num[i]);
                         }
                       
                        }
                        
                    
                        //for the SMA chart 
                        Highcharts.chart('container', {
    title: {
        text: 'Simple Moving Average (EMA)'
    },
    subtitle: {
        text:  '<a href="https://www.alphavantage.co/" style>Source: Alpha Vantage</a>'
    },
    xAxis: {
        categories:x1,
        crosshair: true,
        tickInterval:5
    },
    yAxis: {
          //  min: 137.5,
         //   max: 165,
         //   tickInterval:2.5,
            title: {
           text: 'EMA'  
        }   
    },
     legend: {
        align: 'right',
        verticalAlign: 'middle',
        layout: 'vertical'
    },
    series: [{
        name: jsonObj["Meta Data"]["1: Symbol"],
        data: numNew,
        color: '#ef9291'
                    }],
                 });
               }
            }
                xmlhttp.open("GET",url,true);
                xmlhttp.send();    
                }
                function viewSTOCH(x1,y){
                                      url = "https://www.alphavantage.co/query?function=STOCH&symbol="+y+"&interval=daily&time_period=10&series_type=close&apikey=8DIPSKNL7WX7C3IG";
                var xmlhttp = new XMLHttpRequest();
                xmlhttp.onreadystatechange = function(){
                    if (this.readyState == 4 && this.status == 200){
                     jsonObj = JSON.parse(xmlhttp.responseText);
                        jsonObj2 = jsonObj["Technical Analysis: STOCH"];
                        var num =[];
                        var num2 =[];
                        for(key in jsonObj2){
                            nums = parseFloat(jsonObj2[key]["SlowD"]);
                            num.push(nums);
                            nums2 = parseFloat(jsonObj2[key]["SlowK"]);
                            num2.push(nums2);
                            if(key == "2017-04-10"){
                                break;
                            }
                            var numNew =[];
                            var numNew2 =[];
                         for (var i = num.length-1; i>=0; i--){
                             numNew.push(num[i]);
                             numNew2.push(num2[i]);
                         }  
                        }
                       
                    
                        //for the SMA chart 
                        Highcharts.chart('container', {
    title: {
        text: 'Stochastic Oscillator (STOCH)'
    },
    subtitle: {
        text:  '<a href="https://www.alphavantage.co/" style>Source: Alpha Vantage</a>'
    },
    xAxis: {
        categories:x1,
        crosshair: true,
        tickInterval:5
    },
    yAxis: {
       //     min: 0,
       //     max: 100,
        //    tickInterval:10,
            title: {
           text: 'STOCH'  
        }   
    },
     legend: {
        align: 'right',
        verticalAlign: 'middle',
        layout: 'vertical'
    },
    series: [{
        name: jsonObj["Meta Data"]["1: Symbol"] + " SlowD",
        data: numNew,
        color: '#ef9291'
                    },{
        name: jsonObj["Meta Data"]["1: Symbol"] + " SlowK",
        data: numNew2,
        color: '#7EB6EA'                
                    }],
                 });
               }
            }
                xmlhttp.open("GET",url,true);
                xmlhttp.send();        
                }
                
                function viewRSI(x1,y){
                  url = "https://www.alphavantage.co/query?function=RSI&symbol="+y+"&interval=daily&time_period=10&series_type=close&apikey=8DIPSKNL7WX7C3IG";
                var xmlhttp = new XMLHttpRequest();
                xmlhttp.onreadystatechange = function(){
                    if (this.readyState == 4 && this.status == 200){
                     jsonObj = JSON.parse(xmlhttp.responseText);
                        jsonObj2 = jsonObj["Technical Analysis: RSI"];
                        var num =[];
                        for(key in jsonObj2){
                            nums = parseFloat(jsonObj2[key]["RSI"]);
                            num.push(nums);
                            if(key == "2017-04-10"){
                                break;
                            }
                            var numNew =[];
                         for (var i = num.length-1; i>=0; i--){
                             numNew.push(num[i]);
                         }
                       
                        }
                        
                    
                        //for the SMA chart 
                        Highcharts.chart('container', {
    title: {
        text: 'Relative Strength Index (RSI)'
    },
    subtitle: {
        text:  '<a href="https://www.alphavantage.co/" style>Source: Alpha Vantage</a>'
    },
    xAxis: {
        categories:x1,
        crosshair: true,
        tickInterval:5
    },
    yAxis: {
      //      min: 0,
      //      max: 100,
       //     tickInterval:10,
            title: {
           text: 'RSI'  
        }   
    },
     legend: {
        align: 'right',
        verticalAlign: 'middle',
        layout: 'vertical'
    },
    series: [{
        name: jsonObj["Meta Data"]["1: Symbol"],
        data: numNew,
        color: '#ef9291'
                    }],
                 });
               }
            }
                xmlhttp.open("GET",url,true);
                xmlhttp.send();        
                }
                function viewADX(x1,y){
                                  url = "https://www.alphavantage.co/query?function=ADX&symbol="+y+"&interval=daily&time_period=10&series_type=close&apikey=8DIPSKNL7WX7C3IG";
                var xmlhttp = new XMLHttpRequest();
                xmlhttp.onreadystatechange = function(){
                    if (this.readyState == 4 && this.status == 200){
                     jsonObj = JSON.parse(xmlhttp.responseText);
                        jsonObj2 = jsonObj["Technical Analysis: ADX"];
                        var num =[];
                        for(key in jsonObj2){
                            nums = parseFloat(jsonObj2[key]["ADX"]);
                            num.push(nums);
                            if(key == "2017-04-10"){
                                break;
                            }
                            var numNew =[];
                         for (var i = num.length-1; i>=0; i--){
                             numNew.push(num[i]);
                         }
                       
                        }
                        
                    
                        //for the SMA chart 
                        Highcharts.chart('container', {
    title: {
        text: 'Average Directional Movement Index (ADX)'
    },
    subtitle: {
        text:  '<a href="https://www.alphavantage.co/" style>Source: Alpha Vantage</a>'
    },
    xAxis: {
        categories:x1,
        crosshair: true,
        tickInterval:5
    },
    yAxis: {
         //   min: 10,
         //   max: 45,
         //   tickInterval:5,
            title: {
           text: 'ADX'  
        }   
    },
     legend: {
        align: 'right',
        verticalAlign: 'middle',
        layout: 'vertical'
    },
    series: [{
        name: jsonObj["Meta Data"]["1: Symbol"],
        data: numNew,
        color: '#ef9291'
                    }],
                 });
               }
            }
                xmlhttp.open("GET",url,true);
                xmlhttp.send();        
                }
                function viewCCI(x1,y){
                                                url = "https://www.alphavantage.co/query?function=CCI&symbol="+y+"&interval=daily&time_period=10&series_type=close&apikey=8DIPSKNL7WX7C3IG";
                var xmlhttp = new XMLHttpRequest();
                xmlhttp.onreadystatechange = function(){
                    if (this.readyState == 4 && this.status == 200){
                     jsonObj = JSON.parse(xmlhttp.responseText);
                        jsonObj2 = jsonObj["Technical Analysis: CCI"];
                        var num =[];
                        for(key in jsonObj2){
                            nums = parseFloat(jsonObj2[key]["CCI"]);
                            num.push(nums);
                            if(key == "2017-04-10"){
                                break;
                            }
                            var numNew =[];
                         for (var i = num.length-1; i>=0; i--){
                             numNew.push(num[i]);
                         }
                       
                        }
                        
                    
                        //for the SMA chart 
                        Highcharts.chart('container', {
    title: {
        text: 'Commodity Channel Index (CCI)'
    },
    subtitle: {
        text:  '<a href="https://www.alphavantage.co/" style>Source: Alpha Vantage</a>'
    },
    xAxis: {
        categories:x1,
        crosshair: true,
        tickInterval:5
    },
    yAxis: {
     //       min: -300,
     //       max: 300,
     //       tickInterval:100,
            title: {
           text: 'CCI'  
        }   
    },
     legend: {
        align: 'right',
        verticalAlign: 'middle',
        layout: 'vertical'
    },
    series: [{
        name: jsonObj["Meta Data"]["1: Symbol"],
        data: numNew,
        color: '#ef9291'
                    }],
                 });
               }
            }
                xmlhttp.open("GET",url,true);
                xmlhttp.send();      
                    
                    
                }
                function viewMACD(x1,y){
                     url = "https://www.alphavantage.co/query?function=MACD&symbol="+y+"&interval=daily&time_period=10&series_type=close&apikey=8DIPSKNL7WX7C3IG";
                var xmlhttp = new XMLHttpRequest();
                xmlhttp.onreadystatechange = function(){
                    if (this.readyState == 4 && this.status == 200){
                     jsonObj = JSON.parse(xmlhttp.responseText);
                        jsonObj2 = jsonObj["Technical Analysis: MACD"];
                        var num =[];
                        var num2 =[];
                        var num3 =[];
                        for(key in jsonObj2){
                            nums = parseFloat(jsonObj2[key]["MACD_Hist"]);
                            num.push(nums);
                            nums2 = parseFloat(jsonObj2[key]["MACD"]);
                            num2.push(nums2);
                            nums3 = parseFloat(jsonObj2[key]["MACD_Signal"]);
                            num3.push(nums3);
                            if(key == "2017-04-10"){
                                break;
                            }
                            var numNew =[];
                            var numNew2 =[];
                            var numNew3 =[];
                         for (var i = num.length-1; i>=0; i--){
                             numNew.push(num[i]);
                             numNew2.push(num2[i]);
                             numNew3.push(num3[i]);
                         }  
                        }
                       
                    
                        //for the SMA chart 
                        Highcharts.chart('container', {
    title: {
        text: 'Moving Average Convergence/Divergence (MACD)'
    },
    subtitle: {
        text:  '<a href="https://www.alphavantage.co/" style>Source: Alpha Vantage</a>'
    },
    xAxis: {
        categories:x1,
        crosshair: true,
        tickInterval:5
    },
    yAxis: {
      //      min: -2,
      //      max: 4,
       //     tickInterval:1,
            title: {
           text: 'MACD'  
        }   
    },
     legend: {
        align: 'right',
        verticalAlign: 'middle',
        layout: 'vertical'
    },
    series: [{
        name: jsonObj["Meta Data"]["1: Symbol"] + " MACD_Hist",
        data: numNew,
        color: '#ef9291'
                    },{
        name: jsonObj["Meta Data"]["1: Symbol"] + " MACD",
        data: numNew2,
        color: '#000000'               
                    },{
        name: jsonObj["Meta Data"]["1: Symbol"] + " MACD_Signal",
        data: numNew3,
        color: '#C3E4C6'                
                    }],
                 });
               }
            }
                xmlhttp.open("GET",url,true);
                xmlhttp.send();       
                }
                function viewBBANDS(x1,y){
                           url = "https://www.alphavantage.co/query?function=BBANDS&symbol="+y+"&interval=daily&time_period=10&series_type=close&apikey=8DIPSKNL7WX7C3IG";
                var xmlhttp = new XMLHttpRequest();
                xmlhttp.onreadystatechange = function(){
                    if (this.readyState == 4 && this.status == 200){
                     jsonObj = JSON.parse(xmlhttp.responseText);
                        jsonObj2 = jsonObj["Technical Analysis: BBANDS"];
                        var num =[];
                        var num2 =[];
                        var num3 =[];
                        for(key in jsonObj2){
                            nums = parseFloat(jsonObj2[key]["Real Middle Band"]);
                            num.push(nums);
                            nums2 = parseFloat(jsonObj2[key]["Real Lower Band"]);
                            num2.push(nums2);
                            nums3 = parseFloat(jsonObj2[key]["Real Upper Band"]);
                            num3.push(nums3);
                            if(key == "2017-04-10"){
                                break;
                            }
                            var numNew =[];
                            var numNew2 =[];
                            var numNew3 =[];
                         for (var i = num.length-1; i>=0; i--){
                             numNew.push(num[i]);
                             numNew2.push(num2[i]);
                             numNew3.push(num3[i]);
                         }  
                        }
                       
                    
                        //for the SMA chart 
                        Highcharts.chart('container', {
    title: {
        text: 'Bollinger Bands (BBANDS)'
    },
    subtitle: {
        text:  '<a href="https://www.alphavantage.co/" style>Source: Alpha Vantage</a>'
    },
    xAxis: {
        categories:x1,
        crosshair: true,
        tickInterval:5
    },
    yAxis: {
      //      min: 135,
      //      max: 170,
       //     tickInterval:5,
            title: {
           text: 'BBANDS'  
        }   
    },
     legend: {
        align: 'right',
        verticalAlign: 'middle',
        layout: 'vertical'
    },
    series: [{
        name: jsonObj["Meta Data"]["1: Symbol"] + " Real Middle Band",
        data: numNew,
        color: '#ef9291'
                    },{
        name: jsonObj["Meta Data"]["1: Symbol"] + " Real Lower Band",
        data: numNew2,
        color: '#000000'               
                    },{
        name: jsonObj["Meta Data"]["1: Symbol"] + " Real Upper Band",
        data: numNew3,
        color: '#C3E4C6'                
                    }],
                 });
               }
            }
                xmlhttp.open("GET",url,true);
                xmlhttp.send();                 
                }
            </script> 
        </head>
        <body>
            <div class="screen"><i>Stock Search</i><hr>
                <form action="stock.php" name="myname" id="myform" method="POST" onsubmit ="return check();">
                    <p class="ticker">Enter Stock Ticker Symbol:*
                        <input type="text" id="Ticker" name="Enter" value=""></p>
                    <p class="buttons"><input type="submit" value="Search" name="submit" />
                    <input type="button" value="Clear" name="clear" onclick="clearStuff(document.getElementById('Ticker'))"/></p>
                    <p class="ticker1"><i>*-Mandatory fields.</i></p>
                </form>
            </div>
                         
      
          
            
                        <div id="container" style="min-width: 310px; height: 400px; margin: 0 auto"></div>
                        <script src="https://code.highcharts.com/highcharts.src.js"></script>          
                        
            
                        <div id="news"></div>
      
            <NOSCRIPT>
        </body>
    </html>
