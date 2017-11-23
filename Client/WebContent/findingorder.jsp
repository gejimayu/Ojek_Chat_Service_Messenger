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
<%@ page import = "java.net.*, java.io.*, org.json.JSONObject" %>

<script src="https://www.gstatic.com/firebasejs/4.6.2/firebase-app.js"></script>
<script src="https://www.gstatic.com/firebasejs/4.6.2/firebase-messaging.js"></script>
<script src="https://www.gstatic.com/firebasejs/4.6.2/firebase.js"></script>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="manifest" href="manifest.json">
<link rel="stylesheet" type="text/css" href="style/pickdestination.css">
<link rel="stylesheet" type="text/css" href="style/kepala.css">
<title>Order</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Pick Destination</title>

<script src="js/validateform.js"></script>

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
		//System.out.println(token);
		//System.out.println(expiry_time);
		
		//validating token
		int result = ps.validateToken(token, expiry_time);
		//System.out.println(result);
		if ((result == -2) || (result == -1)) {//token invalid
			//System.out.println("hello " + result);
			response.setStatus(response.SC_MOVED_TEMPORARILY);
		    response.setHeader("Location", "http://localhost:8080/login.jsp");
		    return;
		}
		else { //token valid, get user id
			userid = result;
		}
		//System.out.println(userid);
		String nameuser = ps.getNameUser(userid);
		
		//  RETRIEVE PREFERRED LOCATIONS OF DRIVER
		ArrayList<String> locations = new ArrayList<String>();
		
		//retrieve from service
		Babi res = new Babi();
		res = ps.listLocation(userid);
	
		Map<String, String> hasil = new HashMap<String, String>();
		ArrayList<MapElements> temp = new ArrayList<MapElements>();
		
		for (MapElementsArray isi : res.getResults()) {
			temp = (ArrayList<MapElements>) isi.getItem();
			for (MapElements konten : temp) { 
				hasil.put(konten.getKey(), konten.getValue());
			}
			locations.add(hasil.get("location"));
		}
		
		String[] locationsend = locations.toArray(new String[locations.size()]);
		
		//create JSON object
		JSONObject driver = new JSONObject();
		driver.put("id_driver", userid);
		driver.put("locations", locationsend);
		driver.put("name", nameuser);
		String sendme = driver.toString();
		
		//send post request to store driver in a pool of online driver
		String query = "http://localhost:3000/storedriver";
		try {
			System.out.println(sendme);
			URL url = new URL(query);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
			conn.setDoOutput(true);
			conn.setRequestMethod("POST");
			OutputStream os = conn.getOutputStream();
			os.write(sendme.getBytes("UTF-8"));
			os.close();
			
			int HttpResult = conn.getResponseCode(); 
			if (HttpResult == HttpURLConnection.HTTP_OK) {
			    System.out.println("result ok");
			} else {
			    System.out.println(HttpResult);
			}  
			conn.disconnect();
		}
		catch (Exception e) {
            System.out.println("error : " + e);
		}
			
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
		    }).catch(function(err){
		      console.log("Service worker registration failed : ", err);
		    });
	
		}
	
		const messaging = firebase.messaging();
		
		messaging.onMessage(function(payload) {
			  console.log("Message received. ", payload);
			  post("/driverchat.jsp", {"custid": payload.notification.body});
		});
		
		function post(path, params, method) {
		    method = method || "post"; // Set method to post by default if not specified.

		    // The rest of this code assumes you are not using a library.
		    // It can be made less wordy if you use one.
		    var form = document.createElement("form");
		    form.setAttribute("method", method);
		    form.setAttribute("action", path);

		    for(var key in params) {
		        if(params.hasOwnProperty(key)) {
		            var hiddenField = document.createElement("input");
		            hiddenField.setAttribute("type", "hidden");
		            hiddenField.setAttribute("name", key);
		            hiddenField.setAttribute("value", params[key]);

		            form.appendChild(hiddenField);
		        }
		    }

		    document.body.appendChild(form);
		    form.submit();
		}
	</script>
	
	<div>
		<p id="hi_username">Hi, <b> <%= nameuser %></b> !</p>
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

	<div class="content">
		<div id="findingorder">
			<h2>Finding Order...</h2>
			<form action="findorder.jsp" method="GET">
				<button id="cancelorder">CANCEL</button>
			</form>
		</div>
	</div>
	
</body>
</html>
