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
<%@ page import = "java.util.ArrayList"%>
<%@ page import = "java.net.*, java.io.*, org.json.JSONObject, org.json.JSONArray" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="text/css" href="style/kepala.css">
<link rel="stylesheet" type="text/css" href="style/selectdriver.css">
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Select Driver</title>
</head>
<body>
	<%  
		int userid = -1;
	
		String pick = request.getParameter("picking_point"), 
				dest = request.getParameter("destination"), 
				prefdriver = request.getParameter("preferred_driver"),
				token = (String) session.getAttribute("token"),
				expiry_time = (String) session.getAttribute("expiry_time");	
		
		//create service object
		OjekDataImplService service = new OjekDataImplService();
		OjekData ps = service.getOjekDataImplPort();
		
		//validating token
		int result = ps.validateToken(token, expiry_time);
		if ((result == -2) || (result == -1)) {//token invalid
			response.setStatus(response.SC_MOVED_TEMPORARILY);
		    response.setHeader("Location", "http://localhost:8080/login.jsp");
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
		<tr id="current_order">
			<td><div class="circle">2</div></td>
			<td class="titleorder">Select a<br>Driver</td>
		</tr>
	</table>

	<table class="tableorder">
		<tr>
			<td><div class="circle">3</div></td>
			<td class="titleorder">Complete<br>your Order</td>
		</tr>
	</table>

	<div class="driverblock">
		<h2 class="title_driver">PREFERRED DRIVERS:</h2>
		<div class="chosen_driver">
		
		<%
			//make json object
			JSONObject useracc = new JSONObject();
			useracc.put("destination", dest);
			useracc.put("name", prefdriver);
			String sendme = useracc.toString();
			System.out.println("kirimgan " + sendme);
			//send post request
			String query = "http://localhost:3000/selectprefdriver"; URL url = new URL(query);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
			conn.setDoOutput(true); conn.setDoInput(true); conn.setRequestMethod("POST");
			OutputStream os = conn.getOutputStream();
			os.write(sendme.getBytes("UTF-8"));
			os.close();
			// read the response
			StringBuilder sb = new StringBuilder();  
			int HttpResult = conn.getResponseCode();
			if (HttpResult == HttpURLConnection.HTTP_OK) {
			    BufferedReader br = new BufferedReader(
			            new InputStreamReader(conn.getInputStream(), "utf-8"));
			    String line = null;  
			    while ((line = br.readLine()) != null) {  
			        sb.append(line + "\n");  
			    }
			    br.close();
			    System.out.println("hasilgan : " + sb.toString());  
				
			    if (sb.length() > 0) { // no result
			    	//extract JSON to get driver id
				    JSONObject kehabisannama = new JSONObject(sb.toString());
				    int driverid = kehabisannama.getInt("id_driver");
				    
				    //find profile of driver from ojek service
					Babi res = new Babi();
					res = ps.findDriver(driverid);
				
					Map<String, String> hasil = new HashMap<String, String>();
					
					ArrayList<MapElements> temp = new ArrayList<MapElements>();
					for (MapElementsArray isi : res.getResults()) {
						temp = (ArrayList<MapElements>) isi.getItem();
						for (MapElements konten : temp) { 
							hasil.put(konten.getKey(), konten.getValue());
						}
						%>
						<table>
							<tr>
								<td><img src='<%= hasil.get("prof_pic")  %>'></td>
								<td id='driver_identification'>
									<span id='driver_name'><%= hasil.get("name")  %></span><br>
									<span id='driver_rating'>☆ <%= Float.parseFloat(hasil.get("avgrating"))  %></span> 
									(<%= hasil.get("num_votes") %> votes) <br>
									<form action='http://localhost:8080/userchat.jsp' method='POST'>
										<input type="hidden" name="pick" value="<%=pick%>">
										<input type="hidden" name="dest" value="<%=dest%>">
										<button name='driverid' value='<%=hasil.get("id_driver")%>'>I CHOOSE YOU!</button>
									</form>
								</td>
							</tr>
						</table>	
			    <%  }
	
				} 
			}
		%>
		</div>
	</div>
	
	<div class="driverblock">
		<h2 class="title_driver">OTHER DRIVERS:</h2>
		<div class="chosen_driver">
		
		<%
			//make json object
			useracc = new JSONObject();
			useracc.put("destination", dest);
			sendme = useracc.toString();
			
			//send post request
			query = "http://localhost:3000/selectdriver"; url = new URL(query);
			conn = (HttpURLConnection) url.openConnection();
			conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
			conn.setDoOutput(true); conn.setDoInput(true); conn.setRequestMethod("POST");
			os = conn.getOutputStream();
			os.write(sendme.getBytes("UTF-8"));
			os.close();
			
			//array for results
			ArrayList<Integer> listdriver = new ArrayList<Integer>();
			// read the response
			sb = new StringBuilder();  
			HttpResult = conn.getResponseCode();
			if (HttpResult == HttpURLConnection.HTTP_OK) {
				BufferedReader br = new BufferedReader(
			            new InputStreamReader(conn.getInputStream(), "utf-8"));
			    String line = null;  
			    while ((line = br.readLine()) != null) {  
			        sb.append(line + "\n");  
			    }
			    br.close();
			    System.out.println("hasilgan : " + sb.toString());  
			    
			    if (sb.length() > 0) {
			    	JSONArray jsonArr = new JSONArray(sb.toString());
				    
				    //get element array of driver
				    for (int i = 0; i < jsonArr.length(); i++) {
				    	JSONObject jsonObject = jsonArr.getJSONObject(i);
				    	listdriver.add(jsonObject.getInt("id_driver"));
				    }
				    
				    //iterate through list of driver
				    for(Integer id : listdriver) {
					    Babi res = new Babi();
						System.out.println(prefdriver);
						res = ps.findDriver(id);
					
						//extract the results
						Map<String, String> hasil = new HashMap<String, String>();
						
						ArrayList<MapElements> temp = new ArrayList<MapElements>();
						for (MapElementsArray isi : res.getResults()) {
							temp = (ArrayList<MapElements>) isi.getItem();
							for (MapElements konten : temp) { 
								hasil.put(konten.getKey(), konten.getValue());
							}
							%>
							<table>
								<tr>
									<td><img src='<%= hasil.get("prof_pic") %>'></td>
									<td id='driver_identification'>
										<span id='driver_name'><%= hasil.get("name") %></span><br>
										<span id='driver_rating'>☆ <%= Float.parseFloat(hasil.get("avgrating"))  %></span> 
										(<%= hasil.get("num_votes") %> votes) <br>
										<form action='http://localhost:8080/userchat.jsp' method='POST'>
											<input type="hidden" name="userid" value="<%= userid %>"/>
											<button name='driverid' value='<%=hasil.get("id_driver")%>'>I CHOOSE YOU!</button>
										</form>
									</td>
								</tr>
							</table>
					<% }
				    }
			    }
			}
			conn.disconnect();
		%>
		
		</div>
	</div>	
</body>
</html>