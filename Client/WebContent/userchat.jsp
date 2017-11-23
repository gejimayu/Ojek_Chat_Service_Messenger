<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.io.*,java.util.*,java.sql.*"%>
<%@ page import = "javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="org.java.ojekonline.webservice.OjekData" %>
<%@ page import="org.java.ojekonline.webservice.OjekDataImplService" %>
<%@ page import="org.java.ojekonline.webservice.Babi" %>
<%@ page import="org.java.ojekonline.webservice.Profile" %>
<%@ page import="org.java.ojekonline.webservice.MapElementsArray" %>
<%@ page import="org.java.ojekonline.webservice.MapElements" %>
<%@ page import = "java.util.ArrayList"%>
<%@ page import = "java.net.*, java.io.*, org.json.JSONObject, org.json.JSONArray" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="text/css" href="style/kepala.css">
<link rel="stylesheet" type="text/css" href="style/chatbox.css">
<script src="https://www.gstatic.com/firebasejs/4.6.2/firebase-app.js"></script>
<script src="https://www.gstatic.com/firebasejs/4.6.2/firebase-messaging.js"></script>
<script src="https://www.gstatic.com/firebasejs/4.6.2/firebase.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script src = "https://ajax.googleapis.com/ajax/libs/angularjs/1.3.14/angular.min.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<%
		int userid = -1;
		
		String pick = request.getParameter("pick"), 
				dest = request.getParameter("dest"),
				driverid = request.getParameter("driverid"),
				token = (String) session.getAttribute("token"),
				expiry_time = (String) session.getAttribute("expiry_time");	
		
		//create service object
		OjekDataImplService service = new OjekDataImplService();
		OjekData ps = service.getOjekDataImplPort();
		
		//validating token
		int result = ps.validateToken(token, expiry_time);
		if ((result == -2) || (result == -1)) {//token invalid
			response.setStatus(response.SC_MOVED_TEMPORARILY);
		    response.setHeader("Location", "http://localhost:8080/login.jsp");
		    return;
		}
		else { //token valid, get user id
			userid = result;
		}
		
		String nameuser = ps.getNameUser(userid);
	
		//make json object
		JSONObject useracc = new JSONObject();
		useracc.put("id_sender", userid);
		useracc.put("id_receiver", driverid);
		useracc.put("message", "yoman");
		String sendme = useracc.toString();
		
		//send post request
		String query = "http://localhost:3000/sendchat"; 
		URL url = new URL(query);
		String key = "AAAA_GmMXNo:APA91bHPCn5TqamLyqh8Fpw0mjP78qrDQpOw1HE0jNCLP8SV7PXHzJYb_0cX4xRWAF8jHQsoF0rNMQS0LHK-De1kkx9YsC_ifYj62iVQ9tcew9S9In3jXSHI118sifj1uJAHJVHQjHvb";
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setRequestProperty("Content-Type", "application/json");
		conn.setRequestProperty("Authorization", "key="+key);
		conn.setDoOutput(true); conn.setDoInput(true); conn.setRequestMethod("POST");
		OutputStream os = conn.getOutputStream();
		os.write(sendme.getBytes("UTF-8"));
		os.close();
		int HttpResult = conn.getResponseCode();
		if (HttpResult == HttpURLConnection.HTTP_OK) {
			System.out.println("berhasil");
		}
		else {
			System.out.println("gagal : " + HttpResult);
		}
		conn.disconnect();
	%>

	<div>
		<p id="hi_username">Hi, <b><%= nameuser %></b> !</p>
		<h1 id="logo">
			<span id="labelgreen">PR</span>-<span id="labelred">OJEK</span>
		</h1>
		<a id="logout" href="logout.jsp">Logout</a>
		<p id="extralogo">wush... wush... ngeeeeenggg...</p>
	</div>

	<table id="tableactivity">
		<tr>
			<td id="current_activity"><a href="selectdestination.jsp">ORDER</a></td>
			<td class="rest_activity"><a href="history-penumpang.jsp">HISTORY</a></td>
			<td class="rest_activity"><a href="profile.jsp">MY PROFILE</a></td>
		</tr>
	</table>

	<p id="makeanorder">MAKE AN ORDER</p>
		
	<table class="tableorder">
		<tr>
			<td><div class="circle">1</div></td>
			<td class="titleorder">Select<br>Destination</td>
		</tr>
	</table>

	<table class="tableorder">
		<tr>
			<td><div class="circle">2</div></td>
			<td class="titleorder">Select a<br>Driver</td>
		</tr>
	</table>
	
	<table class="tableorder">
		<tr id="current_order">
			<td><div class="circle">3</div></td>
			<td class="titleorder">Chat<br>Driver</td>
		</tr>
	</table>

	<table class="tableorder">
		<tr>
			<td><div class="circle">4</div></td>
			<td class="titleorder">Complete<br>your Order</td>
		</tr>
	</table>
	
	<script>
		var config = {
			    apiKey: "AIzaSyAITe42GKTLwVBNZd3LUAwF5kDR-C1LBqc",
			    authDomain: "wbdojek.firebaseapp.com",
			    databaseURL: "https://wbdojek.firebaseio.com",
			    projectId: "wbdojek",
			    storageBucket: "wbdojek.appspot.com",
			    messagingSenderId: "1084102565082"
			  };
		
		firebase.initializeApp(config);
		
		if ('serviceWorker' in navigator){
		    console.log("SW present !!! ");
		    navigator.serviceWorker.register('firebase-messaging-sw.js', {
		    }).then(function(registration){
		      console.log('Service worker registered : ', registration.scope);
		    })
		    .catch(function(err){
		      console.log("Service worker registration failed : ", err);
		    });
		}
		
		var chatApp = angular.module("chatApp", []);
		chatApp.controller('chatController', function($scope) {
			$scope.userid =  "<%= userid %>";
			$scope.driverid = "<%= driverid %>";
			$scope.message = [];
			const messaging = firebase.messaging();
			messaging.onMessage(function(payload) {
			    console.log("Message received. ", payload);
			    console.log(payload.notification.body);
			    var notification = {
					id_sender: $scope.driverid,
					id_receiver: $scope.userid,
					message: payload.notification.body
				}
				$scope.message.push(notification);
	  			$scope.$apply();
			});
			$scope.send = function(id, rid, msg) {
				var notification = {
					id_sender: id,
					id_receiver: rid,
					message: msg
				}
				$scope.message.push(notification);
		    	sendMessage(notification);
		    	$scope.chatcontent = '';
			};
			//default post header
			$http.defaults.headers.post['Content-Type'] = 'application-json/x-www-form-urlencoded;charset=utf-8';
			//send login data
			$http({
		        method: 'POST',
		        url: 'http://localhost:3000-/loadhistory',
		        data: $.param({
		            id_sender: req.body.id_sender,
		            id_receiver: req.body.id_receiver
		        }),
		        headers: {'Content-Type': 'application-json/x-www-form-urlencoded'}
		    	}).success(function (data, status, headers, config) {
		        	// handle success things
		    	}).error(function (data, status, headers, config) {
		        	// handle error things
		    	});
			});
		}
		function sendMessage(notification) {
			console.log(notification);
			var http = new XMLHttpRequest();
			var url = "http://localhost:3000/sendchat";
			http.open("POST", url, true);
			http.setRequestHeader("Content-type", "application/json");
			http.send(JSON.stringify(notification));
		}
	</script>
	
	<table id="outerchatbox" ng-app = "chatApp" ng-controller = "chatController">
		<tr id="chat">
			<td class="chatborder">
				<div id="chatholder">
					<div ng-repeat = "msg in message track by $index">
						<table ng-if="msg.id_sender == userid" class="ourbox">
							<tr>
								<td>
									{{ msg.message }}
								</td>
							</tr>
						</table>
						<table ng-if="msg.id_sender == driverid" class="opponentbox">
							<tr>
								<td>
									{{ msg.message }}
								</td>
							</tr>
						</table>
					</div>
				</div>
			</td>
		</tr>
		<tr id="typesection">
			<td class="chatborder">
				<textarea ng-model = "chatcontent"></textarea>
				<button ng-click = "send(userid, driverid, chatcontent)">Kirim</button>
			</td>
		</tr>
	</table>

	<form action="completeorder.jsp" method="POST">
		<input type="hidden" name="pick" value="<%= pick %>"/>
		<input type="hidden" name="dest" value="<%= dest %>"/>
		<input type="hidden" name="driverid" value="<%= driverid %>"/>
		<button type="submit" id="closechat">CLOSE</button>
	</form>

</body>
</html>