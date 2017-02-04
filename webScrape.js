var express = require("express");
var fs = require("fs");
var request = require('request');
var cheerio = require('cheerio');

var app = express();

app.get("/scrape", function(req, res) {
	var url = 'http://www.sportsmanager.us/PublicLinks/Teams.asp?Org=417&Link=6767';
	
	request(url, function(error, response, html) {
		if (!error) {
			var $ = cheerio.load(html);
			
			var email=[];
			var name=[]; 
			var title=[];
			var myjson=[];
			
			var form = $("form[name='frmTeams'] > table");
			var tr = form.children("tr");
			var td = tr.children("td");
			var button = td.children("input[name='btnmail']");
			var i=0;
			button.each(function() {
				
				var onclick = $(this).attr("onclick");
				var newString = onclick.substring(onclick.indexOf("(")+1, onclick.length-1).replace(/'/g, "");
				var contactArr = newString.split(",");
				email.push(contactArr[0]);
				name.push(contactArr[1].substring(9));
				title.push(contactArr[2].trim());
				
				myjson.push({"email":contactArr[0], "name":contactArr[1].substring(9), "title":contactArr[2].trim()});
				
			});
			console.log(JSON.stringify(myjson, null, 4));
			res.send("Check your console!");
		}
	});
});


/*var myfile="/Users/lizbastian/Desktop/sportsmanager.html";
$ = cheerio.load(fs.readFileSync("/Users/lizbastian/Desktop/sportsmanager.html"));

var form = $("form[name='frmTeams'] > table");
var tr = form.children("tr");
console.log(form.length);
var td = tr.children("td");
var labels = td.children("label");
labels.each(function() {
	console.log($(this).text());
});*/

app.listen('8081');
console.log('Magic happens on port 8081');
exports = module.exports = app;
