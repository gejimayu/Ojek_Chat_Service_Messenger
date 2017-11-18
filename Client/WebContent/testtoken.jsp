<%@ page import="org.java.ojekonline.webservice.OjekData" %>
<%@ page import="org.java.ojekonline.webservice.OjekDataImplService" %>
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
	out.print("UserID: " + userid + "<br>" + "FCMToken: " + fcmToken + "<br>");
%>