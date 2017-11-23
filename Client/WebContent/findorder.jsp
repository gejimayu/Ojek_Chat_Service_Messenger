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
			session.setAttribute("userid", userid);
		}
		System.out.println(userid);
		String nameuser = ps.getNameUser(userid);
		
		//make json object
		JSONObject useracc = new JSONObject();
		useracc.put("id_user", userid);
		String sendme = useracc.toString();
		
		//send 2nd post request
		String query = "http://localhost:3000/deletefindingdriver";
		URL url = new URL(query);
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
		conn.setDoOutput(true); conn.setDoInput(true);
		conn.setRequestMethod("POST");
		OutputStream os = conn.getOutputStream();
		os.write(sendme.getBytes("UTF-8"));
		os.close();
		
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
		
	<form action="findingorder.jsp" method="GET">
		<button>FIND ORDER</button>
	</form>	
	
</body>
</html>
