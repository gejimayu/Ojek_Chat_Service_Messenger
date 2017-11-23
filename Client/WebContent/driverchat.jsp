<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="org.java.ojekonline.webservice.OjekData" %>
<%@ page import="org.java.ojekonline.webservice.OjekDataImplService" %>

<%
		int userid = -1;
		
		//create service object
		OjekDataImplService service = new OjekDataImplService();
		OjekData ps = service.getOjekDataImplPort();
		session.setAttribute("visit", "not first");
		//get token from session
		String token = (String) session.getAttribute("token");
		String expiry_time = (String) session.getAttribute("expiry_time");
		System.out.println(token);
		System.out.println(expiry_time);
		//validating token
		int result = ps.validateToken(token, expiry_time);
		System.out.println(result);
		if ((result == -2) || (result == -1)) {//token invalid
			System.out.println("hello " + result);
			response.setStatus(response.SC_MOVED_TEMPORARILY);
		    response.setHeader("Location", "http://localhost:8080/login.jsp");
		    return;
		}
		else { //token valid, get user id
			userid = result;
		}
		System.out.println(userid);
		String nameuser = ps.getNameUser(userid);
		String custid = request.getParameter("custid");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Chat</title>
		<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.6.4/angular.min.js"></script>
		<script src="https://www.gstatic.com/firebasejs/4.6.2/firebase-app.js"></script>
		<script src="https://www.gstatic.com/firebasejs/4.6.2/firebase-messaging.js"></script>
		<script src="https://www.gstatic.com/firebasejs/4.6.2/firebase.js"></script>
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
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
		var id_receiver = "<%= custid %>"
		
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