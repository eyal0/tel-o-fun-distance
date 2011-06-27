// ==UserScript==
// @name          Tel-O-Fun Distance
// @namespace     http://code.google.com/p/tel-o-fun-distance
// @description   Enhance Tel-O-Fun with distance information
// @include       https://www.tel-o-fun.co.il/%D7%94%D7%97%D7%A9%D7%91%D7%95%D7%9F%D7%A9%D7%9C%D7%99/tabid/63/TabSection/History/Default.aspx
// @version       1
// ==/UserScript==

/*
Copyright 2011 Eyal Soha

This file is part of Tel-O-Fun Distance.

Tel-O-Fun Distance is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Tel-O-Fun Distance is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Tel-O-Fun Distance. If not, see http://www.gnu.org/licenses/.
*/

//looks like this: 27/05/2011 14:49:55
function stringToDate(string) {
  var regexp = "([0-9]{2})\/([0-9]{2})\/([0-9]{4})\\s*([0-9]{2}):([0-9]{2}):([0-9]{2})";
  var d = string.match(new RegExp(regexp));
  if(d) {
    return(new Date(d[3], d[2], d[1], d[4], d[5], d[6]));
  } else {
    return(null);
  }
}

function addColumn(tbl) {
  var tblHeadObj = tbl.tHead;
  if(tblHeadObj) {
    for (var h=0; h<tblHeadObj.rows.length; h++) {
      var newTH = tblHeadObj.rows[h].children[0].cloneNode(true);
      newTH.innerText = "";
      tblHeadObj.rows[h].appendChild(newTH);
    }
  }

  for(var j=0; j < tbl.tBodies.length; j++) {
    var tblBodyObj = tbl.tBodies[j];
    for (var i=0; i<tblBodyObj.rows.length; i++) {
      var newCell = tblBodyObj.rows[i].children[0].cloneNode(true);
      newCell.innerText = "";
      tblBodyObj.rows[i].appendChild(newCell);
    }
  }
}

function telofun() {
  var table=document.evaluate("//table[2]", document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null);
  var tbl = table.snapshotItem(0);

  addColumn(tbl);  //column for distances
  tbl.tBodies[0].rows[0].children[5].innerText = "\u05de\u05e8\u05d7\u05e7 \u0028\u05de\u05f3\u0029"; //distance (m')
  addColumn(tbl);  //column for times
  tbl.tBodies[0].rows[0].children[6].innerText = "\u05d6\u05de\u05df"; //time

  var nodes=document.evaluate("//table[2]/tbody/tr", document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null);

  for(var i=0; i < nodes.snapshotLength; i++) {
    var startTime = stringToDate(nodes.snapshotItem(i).children[0].textContent);
    var endTime = stringToDate(nodes.snapshotItem(i).children[1].textContent);
    if(startTime && endTime) {
      var timeString = "";
      var timeDiff = Math.floor((endTime.getTime() - startTime.getTime())/1000);
      if(timeDiff >= 30*60) { //if more than 30 minutes, color node red
        nodes.snapshotItem(i).children[6].style.color = "red";
      }
      timeString = String(timeDiff % 60);
      while(timeString.length < 2)
        timeString = "0" + String(timeString);
      timeDiff = Math.floor(timeDiff/60);
      timeString = (timeDiff % 60) + ":" + timeString;
      while(timeString.length < 5)
        timeString = "0" + timeString;
      timeDiff = Math.floor(timeDiff/60);
      timeString = timeDiff + ":" + timeString;
      nodes.snapshotItem(i).children[6].innerHTML = timeString;
    }
  }
};

if(typeof(unsafeWindow)=='undefined') { unsafeWindow=window; }

function waitForReady(callback) {
  try { var docState=unsafeWindow.document.readyState; } catch(e) { docState=null; }
  if(docState) {
    if(docState!='complete') { window.setTimeout(waitForReady,150,callback); return; }
  }
  callback();
}

waitForReady(telofun);