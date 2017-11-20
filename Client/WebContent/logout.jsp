<%@ page import = "java.net.*, java.io.*, org.json.JSONObject" %>
<%
		String token = (String) session.getAttribute("token");
		int userid = (Integer) session.getAttribute("userid");
		
		//make json object
		JSONObject account = new JSONObject();
		account.put("token", token);
		String sendme = account.toString();
		
		//send post request
		String query = "http://localhost:8081/IdentityService/logout";
		URL url = new URL(query);
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
		conn.setDoOutput(true);
		conn.setRequestMethod("POST");
		OutputStream os = conn.getOutputStream();
		os.write(sendme.getBytes("UTF-8"));
		os.close();
		
		//make json object
		JSONObject useracc = new JSONObject();
		useracc.put("id_user", userid);
		sendme = useracc.toString();
		
		//send 2nd post request
		query = "http://localhost:3000/deletetoken";
		url = new URL(query);
		conn = (HttpURLConnection) url.openConnection();
		conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
		conn.setDoOutput(true);
		conn.setDoInput(true);
		conn.setRequestMethod("POST");
		os = conn.getOutputStream();
		os.write(sendme.getBytes("UTF-8"));
		os.close();
		
		int HttpResult = conn.getResponseCode(); 
		if (HttpResult == HttpURLConnection.HTTP_OK) {
			//redirect
	        response.setStatus(response.SC_MOVED_TEMPORARILY);
	        response.setHeader("Location", "http://localhost:8080/login.jsp");
		} else {
		    %> <script> alert("Logout failed, try again") </script> <%
		}  
		conn.disconnect();

%>