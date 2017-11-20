<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.io.*,java.util.*,java.sql.*"%>
<%@ page import = "javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="org.java.ojekonline.webservice.OjekData" %>
<%@ page import="org.java.ojekonline.webservice.OjekDataImplService" %>
<%@ page import="org.java.ojekonline.webservice.Profile" %>
<%@ page import = "java.util.Date"%>
<%@ page import = "java.text.SimpleDateFormat"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>

<script src="https://www.gstatic.com/firebasejs/4.6.2/firebase-app.js"></script>
<script src="https://www.gstatic.com/firebasejs/4.6.2/firebase-messaging.js"></script>
<script src="https://www.gstatic.com/firebasejs/4.6.2/firebase.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>

</head>
<body>
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
		Profile profil = ps.getProfileInfo(userid);
%>

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
		      //scope: '/toto/'
		    }).then(function(registration){
		      console.log('Service worker registered : ', registration.scope);
		    })
		    .catch(function(err){
		      console.log("Service worker registration failed : ", err);
		    });
	
		}
	
		const messaging = firebase.messaging();
	
		messaging.requestPermission()
		.then(function() {
			console.log('Notification permission granted.');
			// TODO(developer): Retrieve an Instance ID token for use with FCM.
			// ...
		})
		.catch(function(err) {
			console.log('Unable to get permission to notify.', err);
		});
	
		messaging.getToken()
		.then(function(currentToken) {
			if (currentToken) {
				console.log(currentToken);
				console.log(<%= userid %>);
				var tobesent = {
					token: currentToken,
					id_user: <%= userid %>
				};
				$.ajax({
		            type: 'post',
		            url: 'http://localhost:3000/storetoken',
		            data: JSON.stringify(tobesent),
		            contentType: "application/json; charset=utf-8",
		            traditional: true,
		            success: function (data) {
		            	<%  
		            		if (profil.getDriver().equals("true"))
		            			%>window.location.replace("profile.jsp");<%
		            		else 
		            			%>window.location.replace("selectdestination.jsp");<%
		                %>
		            }
		        });
			} else {
			  // Show permission request.
			  console.log('No Instance ID token available. Request permission to generate one.');
			}
		})
		.catch(function(err) {
			console.log('An error occurred while retrieving token. ', err);
		});
	</script>
</body>
</html>