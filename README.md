# CSCI571
My entire work for CSCI571 in USC during 2017 Fall semester.

## Description
The content covers many materials related to web techonologies, like HTML/CSS/JSON/XML/PHP/JavaScript/AWS/iOS Development etc.
Five hands-on homeworks are given for the latest web technologies.
Related technologies for every hw:<br>
HW3: HTML/CSS<br>
HW4: JSON<br>
HW6: PHP/JavaScript<br>
HW8: Ajax/JSON/Responsive Web Design/Node.js<br>
HW9: Mobile App Development(iOS)/Swift<br>
HW1/2/5/7 are related sowftware installations and configurations for Apache/PHP/Nginx/AWS.

## Homework-3
The assignment aims to imitate a web page as closely as possible, writing HTML and CSS directly.
The web page in Chrome browser:
![alt text](http://cs-server.usc.edu:45678/hw/hw3/ScreenShotChrome.png)

## Homework-4
The assignment aims to write a HTML/JavaScript program, which takes the URL of a JSON document containing US Airlines information, parses the JSON file, and extracts the list of airlines, displaying them in a table. The JavaScript program will be embedded in an HTML file so that it can be executed within a browser. 

![alt text](/hw4.png)

## Homework-6
The assignment aims to create a webpage that allows users to search for stock information using the Stock quote API, and the results will be displayed in both tabular format and charts format using HighCharts. The user will also be provided News clips for the selected stock. 

![alt text](/hw6.png)

## Homework-8
### High-level Description
Like HW#6, this assignment aims to create a webpage that allows users to search for stock information using Alpha Vantage API and display the results on the same page below the form. Also, the assignment requires to build a Node.js script to return JSON formatted data to the front-end. The client will parse the JSON data and render it in a nice-looking responsive UI, using the Bootstrap toolkit.<br>

A user will first open a page as shown below, where she/he can enter the stock ticker symbol, and select from a list of matching stock symbols using "autocomplete". Then after pressing the "quote" button, AJAX function will be executed to start an asynchronous transaction with Node.js script running on pre-configured AWS server. The server will fetch:<br>
1) corresponding stock's JSON file from the Alpha Vantage API<br>
2) corresponding stock's news XML file from the Seeking Alpha News RSS feed<br>
and then parse them to the client-side. <br>

The client-side will then process the JSON file and extract neccessary information in a tabular and Highchart diagram form, the XML file will also be processed for recent news display.<br>

Other features include:<br>
1) share Highchart on Facebook<br>
2) favourite list to improve user experience<br>
3) local storage feature<br>
4) responsive design<br>

### Pics for detail
#### Initial page

![alt text](/hw8_initial.png)
#### Auto-complete

![alt text](/hw8_autocomplete.png)
#### Current-stock details

![alt text](/hw8_stockinfo.png)
#### Historical chart details

![alt text](/hw8_historical.png)
#### News feed chart details

![alt text](/hw8_news.png)
#### Responsive design

![alt text](/hw8_responsive.png)


## Homework-9
