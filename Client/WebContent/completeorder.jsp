<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.io.*,java.util.*,java.sql.*"%>
<%@ page import = "javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="org.java.ojekonline.webservice.OjekData" %>
<%@ page import="org.java.ojekonline.webservice.OjekDataImplService" %>
<%@ page import="org.java.ojekonline.webservice.Babi" %>
<%@ page import="org.java.ojekonline.webservice.MapElementsArray" %>
<%@ page import="org.java.ojekonline.webservice.MapElements" %>
<%@ page import = "java.util.ArrayList"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="text/css" href="style/kepala.css">
<link rel="stylesheet" type="text/css" href="style/completeorder.css">
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Order</title>
<script src="js/validateform.js"></script>
</head>
<body>
	<%  
		int userid = 1;
		String pick = request.getParameter("pick"), 
				dest = request.getParameter("dest"),
				token = (String) session.getAttribute("token"),
				expiry_time = (String) session.getAttribute("expiry_time");
		
		int driverid =  Integer.parseInt(request.getParameter("driverid"));
		
		//create service object
		OjekDataImplService service = new OjekDataImplService();
		OjekData ps = service.getOjekDataImplPort();
		
		//validating token
		int result = ps.validateToken(token, expiry_time);
		if ((result == -2) || (result == -1)) {//token invalid
			response.setStatus(response.SC_MOVED_TEMPORARILY);
		    response.setHeader("Location", "http://localhost:8080/Client/login.jsp");
		    return;
		}
		else { //token valid, get user id
			userid = result;
		}
		
		String nameuser = ps.getNameUser(userid);
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
			<td class="titleorder">Complete<br>your Order</td>
		</tr>
	</table>

	<h2 id="howwasit">HOW WAS IT?</h2>

	<div id="ordercontent">
	
		<%
			Babi res = new Babi();
			System.out.println("driverid: " + driverid);
			res = ps.getProfile(driverid, 0);
		
			Map<String, String> hasil = new HashMap<String, String>();
			
			ArrayList<MapElements> temp = new ArrayList<MapElements>();
			for (MapElementsArray isi : res.getResults()) {
				temp = (ArrayList<MapElements>) isi.getItem();
				for (MapElements konten : temp) { 
					hasil.put(konten.getKey(), konten.getValue());
				} %>
			
				<img src='<%= hasil.get("prof_pic") %>'>
				<p id='username'>@<%= hasil.get("username") %></p>
				<p id='name'><%= hasil.get("name") %></p>
	
		<%	} %>
	
		<form action="selectdestination.jsp" method="POST" onsubmit="return validateForm2()">
		    <div class="rate">
		        <input type="radio" id="star5" name="rate" value="5" /><label for="star5" title="text">5 stars</label>
		        <input type="radio" id="star4" name="rate" value="4" /><label for="star4" title="text">4 stars</label>
		        <input type="radio" id="star3" name="rate" value="3" /><label for="star3" title="text">3 stars</label>
		        <input type="radio" id="star2" name="rate" value="2" /><label for="star2" title="text">2 stars</label>
		        <input type="radio" id="star1" name="rate" value="1" /><label for="star1" title="text">1 star</label>
		    </div>
			<textarea id="comment" name="comment" placeholder="Your comment..."></textarea>
			<button>Complete<br>Order</button>
			<input type="hidden" name="pick" value="<%=pick%>">
			<input type="hidden" name="dest" value="<%=dest%>">
			<input type="hidden" name="driverid" value="<%=driverid%>">
		</form>
	</div>
</body>
</html>