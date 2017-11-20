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
<%@ page import = "java.util.Date"%>
<%@ page import = "java.text.SimpleDateFormat"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="manifest" href="manifest.json">
<link rel="stylesheet" type="text/css" href="style/pickdestination.css">
<link rel="stylesheet" type="text/css" href="style/kepala.css">
<title>Order</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Pick Destination</title>

<script src="https://www.gstatic.com/firebasejs/4.6.2/firebase-app.js"></script>
<script src="https://www.gstatic.com/firebasejs/4.6.2/firebase-messaging.js"></script>

<script>
  // Initialize Firebase
  var config = {
    apiKey: "AIzaSyAITe42GKTLwVBNZd3LUAwF5kDR-C1LBqc",
    authDomain: "wbdojek.firebaseapp.com",
    databaseURL: "https://wbdojek.firebaseio.com",
    projectId: "wbdojek",
    storageBucket: "wbdojek.appspot.com",
    messagingSenderId: "1084102565082"
  };
  firebase.initializeApp(config);
</script>

<script src="js/validateform.js"></script>


</head>
<body>
	<script>
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
