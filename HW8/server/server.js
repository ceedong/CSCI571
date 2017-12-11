const express = require('express')
const cors = require('cors')
const app = express()
const request = require('request')
app.use(cors())



app.get('/:stock', function(req, res){
        var stock = req.params.stock.toLowerCase()
        request('http:/\/\dev.markitondemand.com/MODApis/Api/v2/Lookup/json?input=' + stock, function(error, response, body){
        if(!error && response.statusCode == 200){
        var result = JSON.parse(body)
        res.send(result)
        console.log("one request on stock" + stock)
}
})
})

app.get('/stockinfo/:stock', function(req, res){
        var stock = req.params.stock.toLowerCase()
        request('https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=aapl&outputsize=full&apikey=8DIPSKNL7WX7C3IG', function(error, response, body){
        if(!error && response.statusCode == 200){
        var result = JSON.parse(body)
        res.send(result)
        console.log("one request on stock this time is for the general info" + stock)
}
})
})


app.get('/',function(req,res) {
        
       	res.send('Welcome to Ce Dong AWSsss!')
})

app.listen(8081, () => console.log('Server running on port 8081'))

