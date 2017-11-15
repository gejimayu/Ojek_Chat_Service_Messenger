<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import = "java.net.*, java.io.*, org.json.JSONObject" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="Ngo-Jek - Ojek Online Clone Website">
    <meta name="author" content="Taufan Mahaputra, Erfandi Suryo Putra, Gianfranco F.H">
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	
	 <!-- Properties Title -->
    <link rel="shortcut icon" href="" />
    <title>Ngo-Jek</title>
    
    <!-- Custom CSS -->
    <link href="style/main.css" rel="stylesheet" type='text/css'/>
    <!-- Custom Fonts -->
    <link href="assets/fonts/font-awesome.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Oswald:400,500,600" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Roboto:400,500" rel="stylesheet">
    <!-- Script -->
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
    <script src="assets/javascript/login.js"></script>
</head>
<body>
	<%
	if (request.getParameter("username") != null) {
		//retrieve data
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		
		//make json object
		JSONObject account = new JSONObject();
		account.put("username", username);
		account.put("password", password);
		String sendme = account.toString();
		
		//send post request
		String query = "http://localhost:8081/IdentityService/login";
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
		    System.out.println("" + sb.toString());  
		    JSONObject jsonObject = new JSONObject(sb.toString());
		    
		    //extract token
			String token = jsonObject.getString("token");
			String expiry_time = jsonObject.getString("expiry_time");
			session.setAttribute("token", token);
			session.setAttribute("expiry_time", expiry_time);
			//redirect
	        response.setStatus(response.SC_MOVED_TEMPORARILY);
	        response.setHeader("Location", "http://localhost:8080/Client/selectdestination.jsp");
		} else {
		    %> <script> alert("Wrong password / username") </script> <%
		}  
		conn.disconnect();
	}
	%>

 	<div class="login" id="form-login">
 		<h2 class="title">---LOGIN---</h2>
    <form method="POST" action="login.jsp" name="form-login" enctype='application/json'>
   		<div class="input-form">
   			<div class="label">
   				<p style="width: 120px;">Username</p>
  	 			<input id="username-field" type="text" name="username" placeholder="   your username">
  	 		</div>
  	 		<div class="label">
  	 			<p style="width: 120px;">Password</p>
  	 			<input id="password-field" type="password" name="password" placeholder="   password">
  	 		</div>
  	 	</div>
   		<div class="submit-form"> 
   			<p class="no-acc"><a href="register.jsp"> Don't have an account?</a></p>
   			<input type="submit" value="GO!" onclick=" return submitForm(this,event)">
   		</div>
    </form>
 	</div>
</body>
</html>