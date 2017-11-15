<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import = "java.net.*, java.io.*, org.json.JSONObject" %>
<%@ page import="org.java.ojekonline.webservice.OjekData" %>
<%@ page import="org.java.ojekonline.webservice.OjekDataImplService" %>
<%@ page import="org.java.ojekonline.webservice.Babi" %>
<%@ page import="org.java.ojekonline.webservice.MapElementsArray" %>
<%@ page import="org.java.ojekonline.webservice.MapElements" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="stylesheet" type="text/css" href="style/register.css">
<title>Register</title>
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
<script>
	function checkForm() {
		// Fetching values from all input fields and storing them in variables.
		var username = document.forms["myForm"]["username"].value;
	    var email = document.forms["myForm"]["email"].value;
	    var fullname = document.forms["myForm"]["fullname"].value;
	    var password = document.forms["myForm"]["password"].value;
	    var confirmpassword = document.forms["myForm"]["confirmpassword"].value;
	    var phonenumber = document.forms["myForm"]["phonenumber"].value;
	
		//Check All Values/Informations Filled by User are Valid Or Not.If All Fields Are invalid Then Generate alert.
		if ((password == '') || (fullname == '') || (username == '') || (email == '')){
			alert("Fill All Fields");
			return false;
		}
		else if (password != confirmpassword){
			alert("Password Doesn't Match");
			return false;
		}
		else if (!(/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(email))){
			alert("Email Is Not Valid");
			return false;
		}
		else if (!(/^[0-9]{9,}$/.test(phonenumber))){
			alert("Phone Number Is Not Valid");
			return false;
		}
		else{
			return true;
		}
	}
	
</script>

</head>
<body>
	<%
	if (request.getParameter("username") != null) {
		//retrieve data
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String email = request.getParameter("email");
		String fullname = request.getParameter("fullname");
		String phonenumber = request.getParameter("phonenumber");
		String driverstatus = request.getParameter("driverstatus");
		
		//create SOAP object
		OjekDataImplService service = new OjekDataImplService();
		OjekData ps = service.getOjekDataImplPort();
		
		//insert to SOAP DB
		if (driverstatus == null)
			driverstatus = "false";
		ps.insertUser(fullname, username, "img/blank_ava.png", email, phonenumber, driverstatus);
		
		//make json object
		JSONObject account = new JSONObject();
		account.put("username", username);
		account.put("password", password);
		account.put("email", email);
		String sendme = account.toString();
		
		//send post request
		String query = "http://localhost:8081/IdentityService/register";
		URL url = new URL(query);
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
		conn.setDoOutput(true);
		conn.setDoInput(true);
		conn.setRequestMethod("POST");
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
		    //System.out.println("" + sb.toString());  
		    JSONObject jsonObject = new JSONObject(sb.toString());
		    
		    //extract token
			String token = jsonObject.getString("token");
			String expiry_time = jsonObject.getString("expiry_time");
			session.setAttribute("token", token);
			session.setAttribute("expiry_time", expiry_time);
			//redirect
	        response.setStatus(response.SC_MOVED_TEMPORARILY);
	        if (driverstatus.equals("true")) {
	        	System.out.println("redirect profile");
				response.setHeader("Location", "http://localhost:8080/Client/profile.jsp");
	        }
	        else {
	        	System.out.println("redirect destination");
	        	response.setHeader("Location", "http://localhost:8080/Client/selectdestination.jsp");
	        }
		} else {
		    %> <script> alert("Username or email is already used") </script> <%
		}  
		conn.disconnect();
	}
	%>

	<center>
		<form method="POST" action="register.jsp" enctype='application/json' id="myForm" onsubmit="return checkForm()">
			<center style="font-size: 30px"><b>SIGNUP</b></center><br>
			<table>
				<tr><td>Your Name</td><td colspan="2"><input id="fullname" name="fullname" type="text" maxlength="20"/></td></tr>
				<tr><td>Username</td><td><input id="username" name="username" type="text" type="text" maxlength="20" /></td></tr>
				<tr><td>Email</td><td><input id="email" name="email" type="text" maxlength="20" /></td></tr>
				<tr><td>Password</td><td colspan="2"><input id="password" name="password" type="password" maxlength="20"/></td></tr>
				<tr><td>Confirm Password</td><td colspan="2"><input id="confirmpassword" name="confirmpassword" type="password" maxlength="20"/></td></tr>
				<tr><td>Phone Number</td><td colspan="2"><input id="phonenumber" name="phonenumber" type="text" maxlength="12"/></td></tr>
				<tr><td colspan="3"><input id="driverstatus" type="checkbox" name="driverstatus" value="true"/>Also sign me up as a driver!</td></tr>
				<tr><td colspan="3" height="10"></td></tr>			
				<tr><td><a href=login.jsp>Already have an account?</a></td>
				<td align="right" colspan="2"><input type='submit' value="REGISTER"></td></tr>
			</table>
		</form>
	</center>
</body>
</html>