<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="ISO-8859-1"%>
<%@ page import="javax.xml.namespace.QName" %>
<%@ page import="javax.xml.ws.Service" %>
<%@ page import="java.net.URL" %>
<%@ page import = "java.io.*,java.util.*,java.sql.*"%>
<%@ page import="org.java.ojekonline.webservice.OjekData" %>
<%@ page import="org.java.ojekonline.webservice.OjekDataImplService" %>
<%@ page import="org.java.ojekonline.webservice.Profile" %>
<%@ page import="org.java.ojekonline.webservice.Babi" %>
<%@ page import="org.java.ojekonline.webservice.MapElementsArray" %>
<%@ page import="org.java.ojekonline.webservice.MapElements" %>
<%@ page import = "java.util.ArrayList"%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="Ngo-Jek - Ojek Online Clone Website">
    <meta name="author" content="Taufan Mahaputra, Erfandi Suryo Putro, Gianfranco F.H">

    <!-- Properties Title -->
    <link rel="shortcut icon" href="" />
    <title>Ngo-Jek</title>

   
    <!-- Custom CSS -->
    <link href="style/main.css" rel="stylesheet" type='text/css'/>
    <link href="style/profile.css" rel="stylesheet" type='text/css'/>
    <!-- Custom Fonts -->
    <link href="style/font-awesome.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Patua+One" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Oswald:400,500,600" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Roboto:400,500" rel="stylesheet">
    <!-- Script -->
    <script src=""></script>
</head>
<body>
	<%
		int id_user = 1;
		String token = (String) session.getAttribute("token"),
				expiry_time = (String) session.getAttribute("expiry_time");
	
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
			id_user = result;
		}
		Profile profile = new Profile();
		profile = ps.getProfileInfo(id_user);
		
	%>


 	<div class="container">
    <!-- navbar -->
    <div class="navbar">
      <img src="img/yesbos.png" class="logo">
      <div class="logout">
        <p style="margin-bottom: 2px;">Hi, <strong><%= profile.getUsername() %></strong> !</p>
        <a href="logout.jsp">Logout</a>
      </div>
    </div>

    <!-- navigation -->
    <div class="header" id="header">
          <nav>
            <ul>
              <li><a href="selectdestination.jsp">ORDER</a></li>
              <li><a href="history-penumpang.jsp">HISTORY</a></li>
              <li><a href="profile.jsp" class="option-active" >MY PROFILE</a></li>
            </ul>
          </nav>
    </div>

    <!-- profile -->
    <div class="profile">
        <div class="profile-header">
          <h2 class="profile-title">MY PROFILE</h2>
            <a href="edit-profile.jsp"  class="fa fa-pencil fa-2x edit-profile-icon tooltip"><span class="tooltiptext">Edit Profile</span></a>
        </div>
        <div class="img-profile">
          <img src="<%= profile.getPicture() %>">
          <h3 style="margin-bottom: 5px;"> @<%= profile.getUsername() %> </h3>
          <%= profile.getFullName() %><br>
          <% String driver_status = profile.getDriver();
     	  		if(driver_status.equals("true")) {
     	  			Babi rating = new Babi();
     	  			rating = ps.getRatingDetail(id_user);
     	  			Map<String, String> rating_ = new HashMap<String, String>();
     	  			
     	  			ArrayList<MapElements> temp_ = new ArrayList<MapElements>();
     	  			if(rating.getResults().size() != 0) {
     	  				for (MapElementsArray isi : rating.getResults()) {
     	  					temp_ = (ArrayList<MapElements>) isi.getItem();
     	  					for (MapElements konten : temp_) { 
     	  						rating_.put(konten.getKey(), konten.getValue());
     	  					}
     	  					out.println("Driver | <i class=\"fa fa-star\" aria-hidden=\"true\" style=\"color: #ffa500;\"><strong>&nbsp;" + rating_.get("rating") + "</strong></i> &nbsp;(" + rating_.get("votes") + " votes)");
     	  	    		}
     	  			}
     	  			else {
     	  				out.println("Driver | <i class=\"fa fa-star\" aria-hidden=\"true\" style=\"color: #ffa500;\"><strong>&nbsp;0</strong></i> &nbsp;(0 votes)");
     	  			}
     	  		}
     	  		else {
     	  			out.println("Non-Driver");
     	  		}
     	  %>
          <br>
          <i class="fa fa-envelope-o" aria-hidden="true">&nbsp; <%= profile.getUsername() %></i><br>
          <i class="fa fa-phone" aria-hidden="true">&nbsp; <%= profile.getPhoneNumber() %></i>
        </div>
    </div>

    <!-- preferred-location -->
	<% if(driver_status.equals("true")) { %>
    <div class="preferred-location">
    			 	<div class="location-header">
				          <h4 class="profile-title">PREFERRED LOCATIONS:</h4>
				          <a href="edit-location.jsp" class="fa fa-pencil fa-2x edit-location-icon tooltip"><span class="tooltiptext">Edit Location</span></a>
				    </div>
				    <div class="list-location">
				        <ul>
    	<%
		    Babi res = new Babi();
			res = ps.listLocation(id_user);
			Map<String, String> hasil = new HashMap<String, String>();
			
			int i;
			int counter = 0;
			ArrayList<MapElements> temp = new ArrayList<MapElements>();
			if(res.getResults().size() != 0) {
				for (MapElementsArray isi : res.getResults()) {
					temp = (ArrayList<MapElements>) isi.getItem();
					for (MapElements konten : temp) { 
						hasil.put(konten.getKey(), konten.getValue());
					}
					
					i = 0;
					out.print("<li>");
					while(i < counter) {
			           	i++;
			           	out.print("&emsp;");
			        }
					out.println("<i class=\"fa fa-angle-right\" aria-hidden=\"true\"><span>&nbsp;" + hasil.get("location") + "</span></i></li>");
					counter++;
	    		}
			}
			else {
				out.println("No location was inserted");
			}
		%>
						</ul>
				    </div>
				 </div>
		<%
			}
		%>
  </div>

	


</body>
</html>