<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="org.java.ojekonline.webservice.OjekData" %>
<%@ page import="org.java.ojekonline.webservice.OjekDataImplService" %>
<%@ page import = "java.net.*, java.io.*, org.json.JSONObject" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>Chat</title>
	<link rel="stylesheet" type="text/css" href="style/kepala.css">
	<link rel="stylesheet" type="text/css" href="style/chatbox.css">
	<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.6.4/angular.min.js"></script>
	<script src="https://www.gstatic.com/firebasejs/4.6.2/firebase-app.js"></script>
	<script src="https://www.gstatic.com/firebasejs/4.6.2/firebase-messaging.js"></script>
	<script src="https://www.gstatic.com/firebasejs/4.6.2/firebase.js"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
	<script src = "javascript/scrollglue.js"></script>
</head>
<body>
	
	<%
		int userid = -1;
		
		//create service object
		OjekDataImplService service = new OjekDataImplService();
		OjekData ps = service.getOjekDataImplPort();
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
		String namecust = ps.getNameUser(Integer.valueOf(custid));
		
		//send 2nd post request to delete the driver's status of finding order
		String query = "http://localhost:3000/drivers/" + userid;
		URL url = new URL(query);
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
		conn.setDoOutput(true); conn.setDoInput(true);
		conn.setRequestMethod("DELETE");
		
		int HttpResult = conn.getResponseCode(); 
		if (HttpResult == HttpURLConnection.HTTP_OK) {
			//redirect
			System.out.println("oke boss");
		} else {
			System.out.println("jancuk");
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
	
	<p id="makeanorder">LOOKING FOR AN ORDER</p>
	
	<div class="dchatheader">
		<p id="gotorder">Got an Order!</p>
		<p id="namecust"><%= namecust %></p>
	</div>
	
	<script>
		var id_sender = "<%= userid %>"
		var id_receiver = "<%= custid %>"
		console.log(id_receiver);
		
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
		    }).catch(function(err){
		    	console.log("Service worker registration failed : ", err);
		    });
	
		}
	
		var chatApp = angular.module("chatApp", ['luegg.directives']);
		chatApp.controller('chatController', function($scope, $http) {
			$scope.userid =  "<%= userid %>";
			$scope.driverid = "<%= custid %>";
			$scope.message = [];
			
			$http.get("http://localhost:3000/chats?id_sender="+$scope.userid+"&id_receiver="+$scope.driverid)
		    .then(function(response) {
		    	console.log(response.data);
		        $scope.message = response.data;
		    });
			
			const messaging = firebase.messaging();
			messaging.onMessage(function(payload) {
			    console.log("Message received. ", payload);
			    console.log(payload.notification.body);
			    var notification = {
					id_sender: $scope.driverid,
					id_receiver: $scope.userid,
					message: payload.notification.body
				}
			    if (notification.message === 'goaway') {
			    	window.location = "http://localhost:8080/findorder.jsp";
			    } 
			    else {
			    	$scope.message.push(notification);
			    	$scope.$apply();
			    }
			});
			
			$scope.send = function(id, rid, msg) {
				var notification = {
					id_sender: id,
					id_receiver: rid,
					message: msg,
					issave: 1
				}
				$scope.message.push(notification);
		    	sendMessage(notification);
		    	$scope.chatcontent = '';
			};
		});
		
		function sendMessage(notification) {
			console.log(notification);
			var http = new XMLHttpRequest();
			var url = "http://localhost:3000/chats";
			http.open("POST", url, true);
			http.setRequestHeader("Content-type", "application/json");
			http.send(JSON.stringify(notification));
		}
	</script>
	
	<table id="outerchatbox" ng-app = "chatApp" ng-controller = "chatController">
		<tr id="chat">
			<td class="chatborder">
				<div id="chatholder" scroll-glue>
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
	
</body>

</html>