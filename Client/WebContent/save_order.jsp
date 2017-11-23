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
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
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
		
			String nameuser = ps.getNameUser(userid);
		
			//retrieve needed data order
			int driverid = Integer.parseInt(request.getParameter("driverid"));
			String pick = (String) request.getParameter("pick");
			String dest = (String) request.getParameter("dest");
			int rate = Integer.parseInt(request.getParameter("rate"));
			String comment = request.getParameter("comment");
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date date = new Date();	
			String dateNow = dateFormat.format(date);
			String drivername = ps.getNameUser(driverid);
			
			//add order data to db
			ps.insertOrder(driverid, userid, dateNow, pick, dest, rate, comment);
			
			//retrieve numvotes and avgrating driver
			int num_votes = 0;
			float avgrating = 0;
			
			Babi res = new Babi();
			res = ps.getProfile(driverid, 1);
			Map<String, String> hasil = new HashMap<String, String>();
			ArrayList<MapElements> temp = new ArrayList<MapElements>();
			for (MapElementsArray isi : res.getResults()) {
				temp = (ArrayList<MapElements>) isi.getItem();
				for (MapElements konten : temp) { 
					hasil.put(konten.getKey(), konten.getValue());
				}
				num_votes = Integer.parseInt(hasil.get("num_votes"));
				avgrating = Float.parseFloat(hasil.get("avgrating"));
			}
			
			//update numvotes and avgrating
			num_votes += 1;
			avgrating = ((avgrating * (num_votes - 1)) + rate) / num_votes;
			ps.updateDriver(driverid, num_votes, avgrating);
			
			//insert user history
			ps.insertHistory(userid, driverid, dateNow, nameuser, drivername, 
					pick, dest, rate, comment, 0, 0);
			//insert driver history
			ps.insertHistory(userid, driverid, dateNow, nameuser, drivername, 
					pick, dest, rate, comment, 0, 1);
			
			response.setStatus(response.SC_MOVED_TEMPORARILY);
			response.setHeader("Location", "http://localhost:8080/selectdestination.jsp");
		%>

</body>
</html>