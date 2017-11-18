<%@ page import="org.java.ojekonline.webservice.OjekData" %>
<%@ page import="org.java.ojekonline.webservice.OjekDataImplService" %>
<%@ page import = "java.net.*, java.io.*, org.json.JSONObject" %>
<%@ page import="org.java.ojekonline.webservice.Profile" %>

<%
	int userid = -1;
	String token = (String) session.getAttribute("token"),
	       expiry_time = (String) session.getAttribute("expiry_time");
	String fcmToken = request.getParameter("token");
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
	
	//make json object
	JSONObject usertoken = new JSONObject();
	usertoken.put("id_user", userid);
	usertoken.put("token", fcmToken);
	String sendme = usertoken.toString();
	System.out.println("hello " + sendme);
	
	//send post request
	URL url = new URL("http://localhost:3000/storetoken");
	try {
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
		conn.setDoOutput(true);
		conn.setDoInput(true);
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
	catch(Exception e) {
		System.out.println("error : " + e);
	}
	
	//redirecting
	response.setStatus(response.SC_MOVED_TEMPORARILY);
	Profile profil = ps.getProfileInfo(userid);
	if (profil.getDriver().equals("true")) {
		response.setHeader("Location", "http://localhost:8080/Client/profile.jsp");
	}
	else {
		response.setHeader("Location", "http://localhost:8080/Client/selectdestination.jsp");
	}
	
%>