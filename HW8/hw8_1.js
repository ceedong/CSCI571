'use strict';
    var storage=window.localStorage;
    console.log(storage);
    var facebookGobal="";
    var symbolGlobal="";
    var stockPriceGlobal="";
    var changeGlobal="";
    var volumeGlobal="";
    var changePercentGlobal ="";
    var mylists = [];
    var frelists = [];
    var viewThePrice;
    var viewTheSMA;
    var viewTheEMA;
    var viewTheSTOCH;
    var viewTheRSI;
    var viewTheADX;
    var viewTheCCI;
    var viewTheBBANDS;
    var viewTheMACD;
   // mylists[0] = [];
    console.log(mylists.length);
   // mylists[0] = new array[];
    
    console.log(mylists);
          var mainApp = angular .module('firstApplication', ['ngMaterial','ngAnimate','ngSanitize','ui.bootstrap','ngMessages']);
                    mainApp.controller('autoCompleteController', autoCompleteController);
                 function autoCompleteController ($timeout, $q, $log, $http, $scope, $sce) {
                    
                     console.log(mylists.length);
                    var self = this;
                     console.log(this);
                    // list of states to be displayed
                    //self.states        = loadStates();
                    self.querySearch   = querySearch;
                    self.searchTextChange   = searchTextChange;
                    self.newState = newState;
                    function newState(state) {
                       alert("This functionality is yet to be implemented!");
                    }

                    function querySearch (query) {
                      //  console.log(query);
                       // console.log(self.States);
                        if(query !="" && query!=null){
                     //alert(text);
                      // self.states   = loadStates(); 
                 var results =  $http.get('http://default-environment.btnk2kbng4.us-east-2.elasticbeanstalk.com/'+query).then(function (response){
                     
                    
                     
                     console.log(mylists);
                        $scope.txtHint = response.data;
                        var autodata = response.data;
                        //alert(response.data);
                        console.log(response.data);
                        var allStates1="";
                        for (var i = 0; i < response.data.length -1; i++) {
                             allStates1 += autodata[i]['Symbol']+" - "+ autodata[i]['Name'] +" (" +autodata[i]['Exchange']+"), ";
                            }
                         allStates1 += autodata[i]['Symbol']+" - "+ autodata[i]['Name'] +" (" +autodata[i]['Exchange']+")";  
                        console.log(typeof allStates1);
                        self.States = loadStates(allStates1);
                       if(self.States !==undefined){
                       var results = query ? self.States.filter( createFilterFor(query) ) :
                          self.States, deferred;
                            console.log(results);
                          return results;}
                        console.log(self.States);
                    });
                         return results;
                        }   
                    }

                    function searchTextChange(text) {
                        // $log.info('Text changed to ' + text);
                    } 

                    //build list of states as map of key-value pairs
                    function loadStates(allStates) {
                        return allStates.split(/, +/g).map( function (state) {
                            var arr = state.split(" -");
                           // console.log(arr[0]);
                          return {
                             value: state.toLowerCase(),
                             display: state,
                             displayCap: arr[0]
                          };
                       });
                    }

                    //filter function for search query
                    function createFilterFor(query) {
                       var lowercaseQuery = angular.lowercase(query);
                       // alert(lowercaseQuery);
                       return function filterFn(state) {
                          return (state.value.indexOf(lowercaseQuery) === 0);
                       };
                    }

              $scope.getQuote = function(text){
                        $scope.slide=true;
                        $scope.hides = true;
                        $scope.hides2 = true;
                        $scope.hides3 = true;
                        $scope.hides4 = true;
                        $scope.hides5 = true;
                        $scope.hides6 = true;
                        $scope.hides7 = true;
                        $scope.hides8 = true;
                        $scope.hides9 = true;
                        $scope.hides10 = true;
                        $scope.hides11 = true;
                        $scope.hides12 = true;
                        console.log("The search function has been loaded.");
                        console.log("The progression bar is onloading.");
                        $http.get('http://default-environment.btnk2kbng4.us-east-2.elasticbeanstalk.com/stockinfo/'+text).then(function (response){
                        // var anyError = JSON.parse(response.data);
                        //    console.log(typeof anyError);
                        //    if(response.data.search("Error") != -1){
                        //        console.log("error happened!");
                        //    }
                        console.log(response.data);
                            
                        $scope.hides = false;
                        $scope.hides2 = false;
                        $scope.hides11 = false;
                        var autodata = response.data;
                        console.log(typeof autodata);
                        if(autodata["Time Series (Daily)"]==undefined || autodata["Time Series (Daily)"]== null){
                            $scope.tableContent ="<br><br><br><br><br><div class='alert alert-danger'>Error! Failed to get current stock data.</div>";
                            document.getElementById("1st").innerHTML = "<br><div class='alert alert-danger'>Error! Failed to get Price data.</div>";
                            document.getElementById("historicalChart").innerHTML = "<div class='alert alert-danger'>Error! Failed to get historical charts data.</div>"
                            return;
                        }
                        var lists = Object.keys(autodata["Time Series (Daily)"]);
                        //alert(response.data);
                        //$scope.tableContent = response.data;
                        //from this line is the table implementation.
                        $scope.tableContent = "<br><br>";
                        symbolGlobal = autodata["Meta Data"]["2. Symbol"].toUpperCase();
                        var priceSymbol = autodata["Meta Data"]["2. Symbol"];
                        $scope.tableContent += "<table class='table table-striped'><tr><th>Stock Ticker Symbol</th><td>"+autodata["Meta Data"]["2. Symbol"].toUpperCase();
                        $scope.tableContent += "</td></tr>";
                        $scope.tableContent += "<tr><th>Last Price</th><td>"+Number(autodata["Time Series (Daily)"][lists[0]]["4. close"]).toFixed(2)+"</td></tr>";
                        stockPriceGlobal = Number(autodata["Time Series (Daily)"][lists[0]]["4. close"]);
                        changeGlobal = Number(autodata["Time Series (Daily)"][lists[0]]["4. close"] - autodata["Time Series (Daily)"][lists[1]]["4. close"]);
                        changePercentGlobal=Number((autodata["Time Series (Daily)"][lists[0]]["4. close"] - autodata["Time Series (Daily)"][lists[1]]["4. close"])/autodata["Time Series (Daily)"][lists[1]]["4. close"]*100);
                         var upDown = autodata["Time Series (Daily)"][lists[0]]["4. close"] - autodata["Time Series (Daily)"][lists[1]]["4. close"];
                         if(upDown>0){
                        $scope.tableContent +="<tr><th>Change(Change Percent)</th><td class='text-success'>"+Number((autodata["Time Series (Daily)"][lists[0]]["4. close"] - autodata["Time Series (Daily)"][lists[1]]["4. close"])/autodata["Time Series (Daily)"][lists[1]]["4. close"]*100).toFixed(2)+"%";  $scope.tableContent +="<img  src='http://cs-server.usc.edu:45678/hw/hw8/images/Up.png' width='15px' height='15px'>";
                         }
                        else{
                             $scope.tableContent +="<tr><th>Change(Change Percent)</th><td class='text-danger'>"+Number((autodata["Time Series (Daily)"][lists[0]]["4. close"] - autodata["Time Series (Daily)"][lists[1]]["4. close"])/autodata["Time Series (Daily)"][lists[1]]["4. close"]*100).toFixed(2)+"%"; 
                            $scope.tableContent +="<img  src='http://cs-server.usc.edu:45678/hw/hw8/images/Down.png' width='15px' height='15px'>";}
                         if(autodata["Meta Data"]["3. Last Refreshed"].length == 19){
                         $scope.tableContent += "</td></tr><tr><th>Timestamp</th><td>"+autodata["Meta Data"]["3. Last Refreshed"]+" EST</td></tr>";
                         } else{
                           $scope.tableContent += "</td></tr><tr><th>Timestamp</th><td>"+autodata["Meta Data"]["3. Last Refreshed"]+" 16:00:00 EST</td></tr>";  
                         }
                         $scope.tableContent += "<tr><th>Open</th><td>"+Number(autodata["Time Series (Daily)"][lists[0]]["1. open"]).toFixed(2)+"</td></tr>";   
                         $scope.tableContent += "<tr><th>Previous Close</th><td>"+Number(autodata["Time Series (Daily)"][lists[1]]["4. close"]).toFixed(2)+"</td></tr>";
                         $scope.tableContent += "<tr><th>Day's Range</th><td>"+Number(autodata["Time Series (Daily)"][lists[0]]["3. low"]).toFixed(2)+'-'+Number(autodata["Time Series (Daily)"][lists[0]]["2. high"]).toFixed(2)+"</td></tr>";
                         volumeGlobal = Number(autodata["Time Series (Daily)"][lists[0]]["5. volume"]);
                         $scope.tableContent += "<tr><th>Volume</th><td>"+Number(autodata["Time Series (Daily)"][lists[0]]["5. volume"]).toLocaleString()+"</td></tr></table>";
                            
                            $scope.collapsed = false;
                                    for(var i=0; i<mylists.length; i++){      
                    if (mylists[i]["symbol"] == symbolGlobal){
                         $scope.collapsed = true;
                                                }
                    console.log($scope.collapsed);
                                        }   
                            
                         //above is to get all the table details in it.
                        //console.log(lists);
                            var priceDate=[];
                            var priceVolume=[];
                            var pricePrice=[];
                            for(var i=0; i <140; i++){
                                priceDate[139-i] = lists[i].slice(5,10);
                                priceVolume[139-i] = Number(autodata["Time Series (Daily)"][lists[i]]["5. volume"]); 
                                pricePrice[139-i] = Number(autodata["Time Series (Daily)"][lists[i]]["4. close"]); 
                                
                            }
                            var priceDatas = [];
                            if(lists.length >=1000){
                            for(var j=0; j<1000; j++){
                                var element1 = Date.parse(lists[j]);
                                var element2 = Number(autodata["Time Series (Daily)"][lists[j]]["4. close"]);
                               // priceDatas[999-j] = [Date.parse(lists[j]),Number(autodata["Time Series (Daily)"][lists[j]]["4. close"])];
                                priceDatas[999-j] = [element1, element2];
                            }} else{
                                var num = lists.length;
                              for(var j=0; j<num; j++){
                                var element1 = Date.parse(lists[j]);
                                var element2 = Number(autodata["Time Series (Daily)"][lists[j]]["4. close"]);
                               // priceDatas[999-j] = [Date.parse(lists[j]),Number(autodata["Time Series (Daily)"][lists[j]]["4. close"])];
                                priceDatas[num-j] = [element1, element2];
                            }  
                                
                                
                            }
                            //console.log(priceDatas);
                            var maxVolume=Math.max.apply(null, priceVolume);
                            var maxPrice=Math.max.apply(null, pricePrice);
                            console.log(maxPrice);
                            console.log(maxVolume);
                            //console.log(priceDates);
                            //console.log(pricePrices);
                            //console.log(priceDate);
                            //console.log(priceVolume);
                           //console.log(pricePrice);
                            viewPrice(priceDate, priceVolume, pricePrice, priceSymbol,maxPrice,maxVolume);
                            viewHistoricalCharts(priceDatas,priceSymbol);
                        }                                                                                                     
                        )
                           $http.get('http://default-environment.btnk2kbng4.us-east-2.elasticbeanstalk.com/SMA/'+text).then(function (response){
                             $scope.hides3 = false;
                             var autodata = response.data;
                             if(autodata["Technical Analysis: SMA"]== undefined || autodata["Technical Analysis: SMA"] == null){
                                 document.getElementById('2nd').innerHTML ="<br><div class='alert alert-danger'>Error! Failed to get SMA data.</div>";
                                 return;
                             }
                             var lists = Object.keys(autodata["Technical Analysis: SMA"]);
                             console.log(lists);
                             var SMASymbol = autodata["Meta Data"]["1: Symbol"];
                             var SMADate=[];
                             var SMAData=[];
                             for(var i=0; i<140; i++){
                                 SMADate[139-i] = lists[i].slice(5,10);
                                 SMAData[139-i] = Number(autodata["Technical Analysis: SMA"][lists[i]]["SMA"])
                             }
                             //console.log(SMAData);
                             //console.log(SMADate);
                             viewSMA(SMADate,SMAData,SMASymbol);
                         })
                   
                         
                        $http.get('http://default-environment.btnk2kbng4.us-east-2.elasticbeanstalk.com/EMA/'+text).then(function (response){
                             $scope.hides4 = false;
                             var autodata = response.data;
                            if(autodata["Technical Analysis: EMA"]== undefined || autodata["Technical Analysis: EMA"] == null){
                                 document.getElementById('3rd').innerHTML ="<br><div class='alert alert-danger'>Error! Failed to get EMA data.</div>";
                                 return;
                             }
                             var lists = Object.keys(autodata["Technical Analysis: EMA"]);
                             console.log(lists);
                             var EMASymbol = autodata["Meta Data"]["1: Symbol"];
                             var EMADate=[];
                             var EMAData=[];
                             for(var i=0; i<140; i++){
                                 EMADate[139-i] = lists[i].slice(5,10);
                                 EMAData[139-i] = Number(autodata["Technical Analysis: EMA"][lists[i]]["EMA"])
                             }
                             //console.log(SMAData);
                             //console.log(SMADate);
                             viewEMA(EMADate,EMAData,EMASymbol);
                         })
                  
                        $http.get('http://default-environment.btnk2kbng4.us-east-2.elasticbeanstalk.com/STOCH/'+text).then(function (response){
                             $scope.hides5 = false;
                             var autodata = response.data;
                            if(autodata["Technical Analysis: STOCH"]== undefined || autodata["Technical Analysis: STOCH"] == null){
                                 document.getElementById('4th').innerHTML ="<br><div class='alert alert-danger'>Error! Failed to get STOCH data.</div>";
                                 return;
                             }
                             var lists = Object.keys(autodata["Technical Analysis: STOCH"]);
                             console.log(lists);
                             var STOCHSymbol = autodata["Meta Data"]["1: Symbol"];
                             var STOCHDate=[];
                             var STOCHDataSlowD=[];
                             var STOCHDataSlowK=[];
                             for(var i=0; i<140; i++){
                                 STOCHDate[139-i] = lists[i].slice(5,10);
                                 STOCHDataSlowD[139-i] = Number(autodata["Technical Analysis: STOCH"][lists[i]]["SlowD"]);
                                 STOCHDataSlowK[139-i] = Number(autodata["Technical Analysis: STOCH"][lists[i]]["SlowK"])
                             }
                             //console.log(SMAData);
                             //console.log(SMADate);
                             viewSTOCH(STOCHDate,STOCHDataSlowD,STOCHDataSlowK,STOCHSymbol);
                         })
                  
                  
                        $http.get('http://default-environment.btnk2kbng4.us-east-2.elasticbeanstalk.com/RSI/'+text).then(function (response){
                             $scope.hides6 = false;
                             var autodata = response.data;
                            if(autodata["Technical Analysis: RSI"]== undefined || autodata["Technical Analysis: RSI"] == null){
                                 document.getElementById('5th').innerHTML ="<br><div class='alert alert-danger'>Error! Failed to get RSI data.</div>";
                                 return;
                             }
                             var lists = Object.keys(autodata["Technical Analysis: RSI"]);
                             console.log(lists);
                             var RSISymbol = autodata["Meta Data"]["1: Symbol"];
                             var RSIDate=[];
                             var RSIData=[];
                             for(var i=0; i<140; i++){
                                 RSIDate[139-i] = lists[i].slice(5,10);
                                 RSIData[139-i] = Number(autodata["Technical Analysis: RSI"][lists[i]]["RSI"])
                             }
                             //console.log(SMAData);
                             //console.log(SMADate);
                             viewRSI(RSIDate,RSIData,RSISymbol);
                         })

                         $http.get('http://default-environment.btnk2kbng4.us-east-2.elasticbeanstalk.com/ADX/'+text).then(function (response){
                             $scope.hides7 = false;
                             var autodata = response.data;
                             if(autodata["Technical Analysis: ADX"]== undefined || autodata["Technical Analysis: ADX"] == null){
                                 document.getElementById('6th').innerHTML ="<br><div class='alert alert-danger'>Error! Failed to get ADX data.</div>";
                                 return;
                             }
                             var lists = Object.keys(autodata["Technical Analysis: ADX"]);
                             console.log(lists);
                             var ADXSymbol = autodata["Meta Data"]["1: Symbol"];
                             var ADXDate=[];
                             var ADXData=[];
                             for(var i=0; i<140; i++){
                                 ADXDate[139-i] = lists[i].slice(5,10);
                                 ADXData[139-i] = Number(autodata["Technical Analysis: ADX"][lists[i]]["ADX"])
                             }
                             //console.log(SMAData);
                             //console.log(SMADate);
                             viewADX(ADXDate,ADXData,ADXSymbol);
                         })
                  
                        $http.get('http://default-environment.btnk2kbng4.us-east-2.elasticbeanstalk.com/CCI/'+text).then(function (response){
                             $scope.hides8 = false;
                             var autodata = response.data;
                            if(autodata["Technical Analysis: CCI"]== undefined || autodata["Technical Analysis: CCI"] == null){
                                 document.getElementById('7th').innerHTML ="<br><div class='alert alert-danger'>Error! Failed to get CCI data.</div>";
                                 return;
                             }
                             var lists = Object.keys(autodata["Technical Analysis: CCI"]);
                             console.log(lists);
                             var CCISymbol = autodata["Meta Data"]["1: Symbol"];
                             var CCIDate=[];
                             var CCIData=[];
                             for(var i=0; i<140; i++){
                                 CCIDate[139-i] = lists[i].slice(5,10);
                                 CCIData[139-i] = Number(autodata["Technical Analysis: CCI"][lists[i]]["CCI"])
                             }
                             //console.log(SMAData);
                             //console.log(SMADate);
                             viewCCI(CCIDate,CCIData,CCISymbol);
                         })
                        
                        $http.get('http://default-environment.btnk2kbng4.us-east-2.elasticbeanstalk.com/BBANDS/'+text).then(function (response){
                             $scope.hides9 = false;
                             var autodata = response.data;
                            if(autodata["Technical Analysis: BBANDS"]== undefined || autodata["Technical Analysis: BBANDS"] == null){
                                 document.getElementById('8th').innerHTML ="<br><div class='alert alert-danger'>Error! Failed to get BBANDS data.</div>";
                                 return;
                             }
                             var lists = Object.keys(autodata["Technical Analysis: BBANDS"]);
                             console.log(lists);
                             var BBANDSSymbol = autodata["Meta Data"]["1: Symbol"];
                             var BBANDSDate=[];
                             var BBANDSDataLower=[];
                             var BBANDSDataMiddle=[];
                             var BBANDSDataUpper=[];
                             for(var i=0; i<140; i++){
                                 BBANDSDate[139-i] = lists[i].slice(5,10);
                                 BBANDSDataLower[139-i] = Number(autodata["Technical Analysis: BBANDS"][lists[i]]["Real Lower Band"]);
                                 BBANDSDataMiddle[139-i] = Number(autodata["Technical Analysis: BBANDS"][lists[i]]["Real Middle Band"]);
                                 BBANDSDataUpper[139-i] = Number(autodata["Technical Analysis: BBANDS"][lists[i]]["Real Upper Band"]);
                             }
                             //console.log(SMAData);
                             //console.log(SMADate);
                             viewBBANDS(BBANDSDate,BBANDSDataLower,BBANDSDataMiddle,BBANDSDataUpper,BBANDSSymbol);
                         })
                  
                  
                      $http.get('http://default-environment.btnk2kbng4.us-east-2.elasticbeanstalk.com/MACD/'+text).then(function (response){
                           
                             $scope.hides10 = false;
                             var autodata = response.data;
                             if(autodata["Technical Analysis: MACD"]== undefined || autodata["Technical Analysis: MACD"] == null){
                                 document.getElementById('9th').innerHTML ="<br><div class='alert alert-danger'>Error! Failed to get MACD data.</div>";
                                 return;
                             }
                             var lists = Object.keys(autodata["Technical Analysis: MACD"]);
                             console.log(lists);
                             var MACDSymbol = autodata["Meta Data"]["1: Symbol"];
                             var MACDDate=[];
                             var MACDData=[];
                             var MACDDataSignal=[];
                             var MACDDataHist=[];
                             for(var i=0; i<140; i++){
                                 MACDDate[139-i] = lists[i].slice(5,10);
                                 MACDData[139-i] = Number(autodata["Technical Analysis: MACD"][lists[i]]["MACD"]);
                                 MACDDataSignal[139-i] = Number(autodata["Technical Analysis: MACD"][lists[i]]["MACD_Signal"]);
                                 MACDDataHist[139-i] = Number(autodata["Technical Analysis: MACD"][lists[i]]["MACD_Hist"]);
                             }
                             //console.log(SMAData);
                             //console.log(SMADate);
                             viewMACD(MACDDate,MACDData,MACDDataSignal,MACDDataHist,MACDSymbol);
                        
                         })
                  
                      $http.get('http://default-environment.btnk2kbng4.us-east-2.elasticbeanstalk.com/news/'+text).then(function (response){
                             console.log(response.data);
                            $scope.hides12 = false;
                             var autodata = response.data;
                            if(response.data == "NOTFOUND" ){
                                $scope.newsContent = "<div class='alert alert-danger'>Error! Failed to get news feed data.</div>";
                                return;
                            }
                             var count = 0;
                             var number = 0;
                             var target = "";
                             var x;
                             var title = "";
                             var link = "";
                             var pubDate = "";
                             var author = "";
                             var ESTorEDT = "";
                             var titleFormat = "";
                             var authorFormat = "";
                             var linkFormat = "";
                            $scope.newsContent = "";
                                while(count !=5){
                            target = JSON.stringify(autodata.rss.channel["0"].item[number].link);
                              if (target.search("article") != -1){
                                   linkFormat = target.slice(2, target.length -2);
                                    //console.log(target);
                                   title = JSON.stringify(autodata.rss.channel["0"].item[number].title);
                                   titleFormat = title.slice(2,title.length-2);
                                   // console.log(titleFormat);
                                   author = JSON.stringify(autodata.rss.channel["0"].item[number]["sa:author_name"]);
                                   authorFormat = author.slice(2, author.length-2);
                                    //console.log(author);
                                   pubDate = JSON.stringify(autodata.rss.channel["0"].item[number].pubDate);
                                   if (pubDate.search("-0400") == -1){
                                       ESTorEDT = "EST";
                                   } else {
                                       ESTorEDT = "EDT";
                                   }
                                   pubDate = pubDate.slice(2,28);
                                    //console.log(pubDate + ESTorEDT);
                                    $scope.newsContent += "<div class='well'><a href='"+linkFormat+"' target='_blank'>"+titleFormat+"</a><br><br><b>Author: "+authorFormat+"</b><br><br><b>Date: "+pubDate+ESTorEDT+"</b><br>"+"</div>";
                                  count++;  
                              }
                             
                             
                             
                             number++;
                            
                         }})
                  
                            
                    
                  
                    }
            
          
        $scope.Clear = function(){
            console.log("succ");
            $scope.ctrl.searchText="";
            $scope.products = "";
            document.getElementById("1st").innerHTML ="";
            document.getElementById("2nd").innerHTML ="";
            document.getElementById("3rd").innerHTML ="";
            document.getElementById("4th").innerHTML ="";
            document.getElementById("5th").innerHTML ="";
            document.getElementById("6th").innerHTML ="";
            document.getElementById("7th").innerHTML ="";
            document.getElementById("8th").innerHTML ="";
            document.getElementById("9th").innerHTML ="";
            document.getElementById("historicalChart").innerHTML = "";
            $scope.tableContent = "";
            $scope.newsContent = "";
             $scope.collapsed = false;
        }
              
              
              
          $scope.myfunc = function(){
             console.log($scope.selectedName);
              var temp ="";
              if($scope.selectedName == "Change Percent"){
                  temp = "percent";
              } else{
                  
                 
                  
             temp = $scope.selectedName.toLowerCase();}
              
              console.log($scope.myOrderBy);
              console.log($scope.selectedOrder);
              if($scope.selectedOrder == "Descending"){
                   $scope.myOrderBy = "-"+temp;    
                  } else{
                    $scope.myOrderBy = temp;
                  } 
              
        }    
              //initialization 
    $scope.addorremoveItem = function(x){
       if ($scope.collapsed == true){
                 var added = false;
        for(var i=0; i<mylists.length; i++){
            if (mylists[i]["symbol"] == symbolGlobal){
                 added = true;
                 $scope.collapsed = true;
            }
            console.log(added);
        }
          
           if (added == false){
              mylists[mylists.length] = [];
              mylists[mylists.length-1]["symbol"] = symbolGlobal;
              mylists[mylists.length-1]["price"] = Math.round(stockPriceGlobal *100)/100;
              mylists[mylists.length-1]["percent"] = Math.round(changePercentGlobal *100)/100;       
              mylists[mylists.length-1]["volume"] = Math.round(volumeGlobal *100)/100;
              mylists[mylists.length-1]["change"] = Math.round(changeGlobal*100)/100;
              console.log(mylists);}
              //experiment area
              $scope.products = mylists;
            console.log(mylists);
          
        //console.log(symbolGlobal,stockPriceGlobal, volumeGlobal, changeGlobal);
        console.log(mylists);
        //var text = "<table class='table table-striped'><thead><tr><th>Symbol</th><th>Stock Price</th><th>Change(Change Percent)</th><th>Volume</th><th>     </th></tr></thead><tbody><tr><td>" + symbolGlobal +"</td><td>" + stockPriceGlobal + "</td><td>" +  volumeGlobal + "</td><td>" + changeGlobal+"</td><td><button type='button' class=' btn btn-default'><span class='glyphicon glyphicon-trash'></span></button></td></tr> </tbody></table>";
        //text = $sce.trustAsHtml(text);
        //$scope.favouriteContent = text;
       
        $scope.errortext = "";
        if (!$scope.addMe) {return;}        
        if ($scope.products.indexOf($scope.addMe) == -1) {
            $scope.products.push($scope.addMe);
        } else {
            $scope.errortext = "The item is already in your falist.";
        }
          // localItems();
           
       } else{
           $scope.errortext = "";
           
        $scope.products.splice(x, 1);
           
          // localItems();
           
       }
        
        
    }          
              
             
    $scope.addItem = function () {
       // localItems();
        var added = false;
        for(var i=0; i<mylists.length; i++){
            if (mylists[i]["symbol"] == symbolGlobal){
                 added = true;
            }
            console.log(added);
        }
              if (added == false){
              mylists[mylists.length] = [];
              mylists[mylists.length-1]["symbol"] = symbolGlobal;
              mylists[mylists.length-1]["price"] = stockPriceGlobal;
              mylists[mylists.length-1]["percent"] = changePercentGlobal;       
              mylists[mylists.length-1]["volume"] = volumeGlobal;
              mylists[mylists.length-1]["change"] = changeGlobal;
              console.log(mylists);}
              //experiment area
              $scope.products = mylists;
            console.log(mylists);
        
        //console.log(symbolGlobal,stockPriceGlobal, volumeGlobal, changeGlobal);
        console.log(mylists);
        //var text = "<table class='table table-striped'><thead><tr><th>Symbol</th><th>Stock Price</th><th>Change(Change Percent)</th><th>Volume</th><th>     </th></tr></thead><tbody><tr><td>" + symbolGlobal +"</td><td>" + stockPriceGlobal + "</td><td>" +  volumeGlobal + "</td><td>" + changeGlobal+"</td><td><button type='button' class=' btn btn-default'><span class='glyphicon glyphicon-trash'></span></button></td></tr> </tbody></table>";
        //text = $sce.trustAsHtml(text);
        //$scope.favouriteContent = text;
       $scope.collapsed = true;
        $scope.errortext = "";
        if (!$scope.addMe) {return;}        
        if ($scope.products.indexOf($scope.addMe) == -1) {
            $scope.products.push($scope.addMe);
        } else {
            $scope.errortext = "The item is already in your falist.";
        }
        
        
        
    }
    $scope.removeItem = function (x) {
        var num = -1;
        console.log(x);
        for(var k=0; k<mylists.length; k++){
            if (mylists[k]["symbol"] == x){
                console.log(mylists[k]["symbol"]);
                num = k;
            }
        }
        console.log(num);
        $scope.errortext = "";    
        $scope.products.splice(num, 1);
        $scope.collapsed = false;
        
       // localItems();
    }
              
     $scope.sortBy=["Default","Symbol","Price","Change","Change Percent", "Volume"];
     $scope.order=["Ascending","Descending"];//experiment area
                     var whichImage = 'Price';
                     
                       $scope.imageproducer = function(x){
        
            whichImage = x;
            console.log(x);
                            
        } 
                       
         $scope.refresh = function(){
             
            
             for(var i=0; i< mylists.length; i++){
             console.log(mylists[i]);
             var angs = Object.keys(mylists[i]);
             console.log(angs[0]);
             
      console.log( mylists[i][angs[0]]);
             $http.get('http://default-environment.btnk2kbng4.us-east-2.elasticbeanstalk.com/stockinfo/'+mylists[i][angs[0]]).then(function (response){
                 var autodata = response.data;
                 var lists = Object.keys(autodata["Time Series (Daily)"]);
                 symbolGlobal = autodata["Meta Data"]["2. Symbol"].toUpperCase();
                 stockPriceGlobal = Number(autodata["Time Series (Daily)"][lists[0]]["4. close"]);
                 changeGlobal = Number(autodata["Time Series (Daily)"][lists[0]]["4. close"] - autodata["Time Series (Daily)"][lists[1]]["4. close"]);
                        changePercentGlobal=Number((autodata["Time Series (Daily)"][lists[0]]["4. close"] - autodata["Time Series (Daily)"][lists[1]]["4. close"])/autodata["Time Series (Daily)"][lists[1]]["4. close"]*100);
                 volumeGlobal = Number(autodata["Time Series (Daily)"][lists[0]]["5. volume"]);
                
                 
                 
                 
                 frelists[i] = [];
              frelists[i]["symbol"] = symbolGlobal;
              frelists[i]["price"] = Math.round(stockPriceGlobal *100)/100;
              frelists[i]["percent"] =Math.round(changePercentGlobal *100)/100;    
              frelists[i]["volume"] = Math.round(volumeGlobal *100)/100;
              frelists[i]["change"] = Math.round(changeGlobal*100)/100;
                 
             })
             
             $scope.products = frelists;
             
             
             }
    }               
                       
        $scope.facebook = function(){
                     
                     
                      
          var toBeLoad;
            if(whichImage =="Price") {toBeLoad = viewThePrice;}
            else if (whichImage == "SMA") {toBeLoad = viewTheSMA;}
            else if (whichImage == "ADX"){toBeLoad = viewTheADX;}
            else if (whichImage == "BBANDS") {toBeLoad = viewTheBBANDS;}
            else if (whichImage == "MACD") {toBeLoad = viewTheMACD;}
            else if (whichImage == "CCI"){ toBeLoad = viewTheCCI;}
            else if (whichImage == "EMA") {toBeLoad = viewTheEMA;}
            else if (whichImage == "STOCH"){toBeLoad = viewTheSTOCH;}
            else  {toBeLoad = viewTheRSI;}
            console.log(toBeLoad);
            testPOST(toBeLoad);
        }
    //the part is for facebook and export the image file
                     
      var exportUrl = "http://export.highcharts.com/";             
        
                     function testPOST(toBeLoad){
                         var optionStr = JSON.stringify(toBeLoad);
                         var dataString = encodeURI('async=true&type=jpeg&width=400&options=' + optionStr);
                         console.log(dataString);
                         $http({
                             method:'POST',
                             url:exportUrl,
                             headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                             data:dataString
                         }).then(function(response){
                             console.log('get the file from the website');
                             console.log(response.data);
                             facebookGobal = exportUrl + response.data;
                             //facebook api
                              FB.init({
      appId            : '163355540921852',
      autoLogAppEvents : true,
      xfbml            : true,
      version          : 'v2.11'
    });
                             
                             
                             FB.ui({
                                 method:'feed',
                                 link:facebookGobal,
                                
                                 caption:'video tutorials',
                                 description:'the best tutorial ever'
                             }, function(response){
                                 if(response && !response.error_message){
                                     alert("Posted Successfully");
                                 } else {
                                     alert("Not Posted");
                                 }
                             })
                             
                             
                         })
                     }
                     
                     
     //                
                     
                 }
     
   


//The follwing is for the Price-and-Volume chart-----------------------------
    function viewPrice(x,y,z,w,u,v){
         viewThePrice ={  
                                lang: {
            numericSymbols: ['k', ' M']
        },
        chart: {
            zoomType: 'x'

        },
        title: {
            text: w.toUpperCase()+' Stock Price and Volume'
        },
         subtitle: {
            text: '<a href="https://www.alphavantage.co/" target="_blank" style="color:rgb(57,122,175)" >Source: Alpha Vantage</a>'
        },
        xAxis: {
            categories:x,
            crosshair: true,
            tickInterval:5
        },
           yAxis: [{ // Primary yAxis
              
             max:u,
           

           title: {
               text: 'Stock Price',
          }
       },
        { // Secondary yAxis
           title: {
               text: 'Volume',   
            },
            
              max:v,
          
              opposite: true
       }],

        series: [{
         yAxis:0,
             name: 'Price',
              type: 'area',
              lineColor: 'rgb(11,36,251)',
              color: 'rgb(230,230,254)',
              data:z},
            { yAxis:1,
             name: ' Volume',
              type: 'column',
              color: 'rgb(252,13,27)',
             data:y
        }]
           }
        
        
                 new Highcharts.Chart('1st',viewThePrice);

    }
//The follwing is for the SMA chart-----------------------------
    function viewSMA(x,y,z){
         viewTheSMA = {
          chart: {
            zoomType: 'x'

        },
    title: {
        text: 'Simple Moving Average (SMA)'
    },
    subtitle: {
        text:  '<a href="https://www.alphavantage.co/" target="_blank" style="color:rgb(57,122,175)" >Source: Alpha Vantage</a>'
    },
    xAxis: {
        categories:x,
        crosshair: true,
        tickInterval:5
    },
    yAxis: {
            title: {
           text: 'SMA'  
        }   
    },
    series: [{
        name: z.toUpperCase(),
        data: y,
        color: '#ef9291'
                    }],
                 }
        
       Highcharts.chart('2nd',viewTheSMA);  
            }

//The follwing is for the EMA chart-----------------------------
            function viewEMA(x,y,z){
         viewTheEMA= {
          chart: {
            zoomType: 'x'

        },
    title: {
        text: 'Exponential Moving Average (EMA)'
    },
    subtitle: {
        text:  '<a href="https://www.alphavantage.co/" target="_blank" style="color:rgb(57,122,175)" >Source: Alpha Vantage</a>'
    },
    xAxis: {
        categories:x,
        crosshair: true,
        tickInterval:5
    },
    yAxis: {
            title: {
           text: 'EMA'  
        }   
    },
    series: [{
        name: z.toUpperCase(),
        data: y,
        color: '#ef9291'
                    }],
                 }        
                
       Highcharts.chart('3rd',viewTheEMA);  
            }
//The follwing is for the STOCH chart-----------------------------
 function viewSTOCH(x,y,z,w){
      viewTheSTOCH ={
         chart: {
            zoomType: 'x'

        },
    title: {
        text: 'Stochastic Oscillator (STOCH)'
    },
    subtitle: {
        text:  '<a href="https://www.alphavantage.co/" target="_blank" style="color:rgb(57,122,175)" >Source: Alpha Vantage</a>'
    },
    xAxis: {
        categories:x,
        crosshair: true,
        tickInterval:5
    },
    yAxis: {
            title: {
           text: 'STOCH'  
        }   
    },
    series: [{
        name: w.toUpperCase()+ " SlowD",
        data: y,
        color: '#ef9291'
                    },{
        name: w.toUpperCase() + " SlowK",
        data: z,
        color: '#7EB6EA'                
                    }],
                 }
     Highcharts.chart('4th', viewTheSTOCH);
     
     
 }

//The follwing is for the  part-----------------------------
            function viewRSI(x,y,z){
             viewTheRSI = {
          chart: {
            zoomType: 'x'

        },
    title: {
        text: 'Relative Strength Index (RSI)'
    },
    subtitle: {
        text:  '<a href="https://www.alphavantage.co/" target="_blank" style="color:rgb(57,122,175)" >Source: Alpha Vantage</a>'
    },
    xAxis: {
        categories:x,
        crosshair: true,
        tickInterval:5
    },
    yAxis: {
            title: {
           text: 'RSI'  
        }   
    },
    series: [{
        name: z.toUpperCase(),
        data: y,
        color: '#ef9291'
                    }],
                 }
       Highcharts.chart('5th', viewTheRSI);  
            }
//The follwing is for the  part-----------------------------
            function viewADX(x,y,z){
             viewTheADX = {
          chart: {
            zoomType: 'x'

        },
    title: {
        text: 'Average Directional Movement Index (ADX)'
    },
    subtitle: {
        text:  '<a href="https://www.alphavantage.co/" target="_blank" style="color:rgb(57,122,175)" >Source: Alpha Vantage</a>'
    },
    xAxis: {
        categories:x,
        crosshair: true,
        tickInterval:5
    },
    yAxis: {
            title: {
           text: 'ADX'  
        }   
    },
    series: [{
        name: z.toUpperCase(),
        data: y,
        color: '#ef9291'
                    }],
                 }    
       Highcharts.chart('6th', viewTheADX);  
            }

//The follwing is for the  part-----------------------------
            function viewCCI(x,y,z){
            viewTheCCI ={
          chart: {
            zoomType: 'x'

        },
    title: {
        text: 'Commodity Channel Index (CCI)'
    },
    subtitle: {
        text:  '<a target="_blank" href="https://www.alphavantage.co/" style="color:rgb(57,122,175)">Source: Alpha Vantage</a>'
    },
    xAxis: {
        categories:x,
        crosshair: true,
        tickInterval:5
    },
    yAxis: {
          //  min: 137.5,
          //  max: 165,
         //   tickInterval:2.5,
            title: {
           text: 'CCI'  
        }   
    },
    series: [{
        name: z.toUpperCase(),
        data: y,
        color: '#ef9291'
                    }],
                 }    
       Highcharts.chart('7th', viewTheCCI);  
            }
    

    function viewBBANDS(x,y,z,w,v){
                viewTheBBANDS = {
                        chart: {
            zoomType: 'x'

        },
    title: {
        text: 'Bollinger Bands (BBANDS)'
    },
    subtitle: {
        text:  '<a href="https://www.alphavantage.co/" target="_blank" style="color:rgb(57,122,175)" >Source: Alpha Vantage</a>'
    },
    xAxis: {
        categories:x,
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
    series: [{
        name: v.toUpperCase() + " Real Middle Band",
        data: z,
        color: '#ef9291'
                    },{
        name: v.toUpperCase() + " Real Lower Band",
        data: y,
        color: '#000000'               
                    },{
        name: v.toUpperCase() + " Real Upper Band",
        data: w,
        color: '#C3E4C6'                
                    }],
                 }
                    Highcharts.chart('8th', viewTheBBANDS)
    }


    function viewMACD(x,y,z,w,v){
         viewTheMACD = {
                     chart: {
            zoomType: 'x'

        },
    title: {
        text: 'Moving Average Convergence/Divergence (MACD)'
    },
    subtitle: {
        text:  '<a href="https://www.alphavantage.co/" target="_blank" style="color:rgb(57,122,175)" >Source: Alpha Vantage</a>'
    },
    xAxis: {
        categories:x,
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
    series: [{
        name: v.toUpperCase() + " MACD_Hist",
        data: w,
        color: '#ef9291'
                    },{
        name: v.toUpperCase() + " MACD",
        data: y,
        color: '#000000'               
                    },{
        name: v.toUpperCase() + " MACD_Signal",
        data: z,
        color: '#C3E4C6'                
                    }]
                     
                      
                 }
                 Highcharts.chart('9th', viewTheMACD)
        
    }



 function localItems(){
    if(toJSON == "{}"){
        toJSON = "";
    }
           var toJSONlength = 0;
           var toJSON="{";
             for(var a=0; a<mylists.length; a++){
                 toJSONlength++;
                 toJSON += '"' + mylists[a]["symbol"] + '"';
                 
               if(a != mylists.length -1) { toJSON +=",";}
             }
           toJSON += "}";
           storage.clear();
           storage.setItem("data",toJSON);
           console.log(storage);
           console.log(toJSONlength);
           console.log(toJSON);}


//The follwing is for the HistoricalCharts part-----------------------------
    function viewHistoricalCharts(x,y){
        var viewTheHistory = {
          chart: {
            
            zoomType: 'x'

        },
                
           rangeSelector: {

            buttons: [ {
                type: 'week',
                count: 1,
                text: '1w'
            }, {
                type: 'month',
                count: 1,
                text: '1m'
            },{
                type: 'month',
                count: 3,
                text: '3m'
            }, {
                type: 'month',
                count: 6,
                text: '6m'
            }, {                                                 
                type: 'ytd',
                count: 1,
                text: 'YTD'
            }, {
                type: 'year',
                count: 1,
                text: '1y'
            }, {
                type: 'all',
                text: 'All'
            }],
            selected: 0
        },
        
                
    title: {
        text: y.toUpperCase()+' Stock Value'
    },
    subtitle: {
        text:  '<a href="https://www.alphavantage.co/" target="_blank" style="color:rgb(57,122,175)" >Source: Alpha Vantage</a>'
    },
      yAxis: {
            title: {
           text: 'Stock Value'  
        }   
    },
         
    series: [{
        name: y.toUpperCase(),
        data: x,
        type: 'area',
        color: 'rgb(159,201,239)'
                    }],
       navigation: {
        buttonOptions: {
          align: 'right' 
        }
    }
        
      
                 }
  Highcharts.stockChart('historicalChart', viewTheHistory ); 
     
    }
