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
	useracc.put("message", userid);
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
		System.out.println("goblog : " + HttpResult);
	}
	conn.disconnect();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
	<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.6.4/angular.min.js"></script>
	<script src="https://www.gstatic.com/firebasejs/4.6.2/firebase-app.js"></script>
	<script src="https://www.gstatic.com/firebasejs/4.6.2/firebase-messaging.js"></script>
	<script src="https://www.gstatic.com/firebasejs/4.6.2/firebase.js"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>Insert title here</title>
	</head>
	<body>
		<div ng-app="OrderChat">
		    <div ng-controller="chat">
		        <div ng-repeat="message in messages">
		            <span>{{message}}</span>
		        </div>
		        <form ng-submit="send()">
		            <input ng-model="textbox">
		        </form>
		    </div>
		</div>
	</body>

	<script>
		var id_sender = "<%= userid %>"
		var id_receiver = "<%= driverid %>"
		
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
		      //scope: '/toto/'
		    }).then(function(registration){
		      console.log('Service worker registered : ', registration.scope);
		    })
		    .catch(function(err){
		      console.log("Service worker registration failed : ", err);
		    });
		
		}
		
		var chat = angular.module('OrderChat', []);
		chat.controller( 'chat', ['$scope', function($scope) {
		    // Message Inbox
		    $scope.messages = [];
		    // Receive Messages
			const messaging = firebase.messaging();
			messaging.onMessage(function(payload) {
				  console.log("Message received. ", payload);
				  console.log(payload.notification.body);
				  $scope.messages.push(payload.notification.body);
				  $scope.$apply();
			});
		    // Send Messages
		    $scope.send = function() {
		    	var text = $scope.textbox;
		    	sendMessage(text);
		    	$scope.messages.push(text);
		    	$scope.textbox = '';
		    };
		}]);
		
		function sendMessage(text) {
			var notification = {
				id_sender: id_sender,
				id_receiver: id_receiver,
				message : text
			}
			console.log(notification);
			var http = new XMLHttpRequest();
			var url = "http://localhost:3000/sendchat";
			http.open("POST", url, true);
			http.setRequestHeader("Content-type", "application/json");
			http.send(JSON.stringify(notification));
		}
	</script>

</html>