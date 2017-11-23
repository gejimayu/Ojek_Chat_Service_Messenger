<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
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
    <meta name="author" content="Taufan Mahaputra, Robby Syaifullah, M Rafli">
    <!-- Properties Title -->
    <link rel="shortcut icon" href="" />
    <title>Ngo-Jek</title>

    <!-- Custom CSS -->
    <link href="style/main.css" rel="stylesheet" type='text/css' />
    <link href="style/editprofile.css" rel="stylesheet" type='text/css' />

    <!-- Custom Fonts -->
    <link href="style/font-awesome.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Patua+One" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Oswald:400,500,600" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Roboto:400,500" rel="stylesheet">
    <!-- Script -->
    <script src="javascript/edit-profile.js"></script>
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
	    response.setHeader("Location", "http://localhost:8080/login.jsp");
	    return;
	}
	else { //token valid, get user id
		id_user = result;
	}
	Profile profile = new Profile();
	profile = ps.getProfileInfo(id_user);

	%>
    <div class="container">
        <!-- Header Section -->
        <div class="profile-header">
            <h2 class="profile-title">EDIT PROFILE INFORMATION</h2>
        </div>
            
        <!-- Content Field-->
        <div class="content">
            <form name="form-edit-profile" action="upload" method="POST" enctype="multipart/form-data" onsubmit="return validateForm()">
            <input type="hidden" name="id_user" value="<%= id_user %>">
            <table>
                <tr>
                    <td>
                        <div class="img-profile">
                            <img src="<%= profile.getPicture() %>" alt="User Picture" width="200" height="200">
                        </div>
                    </td>
                    <td>
                        <div class="right-side">
                            <h5> Update profile picture </h5>    
                           	<input type="file" name="fileToUpload" id="fileToUpload" hidden></input>
                           	<input type="text" name="description" onClick="fileToUpload.click()"></input>
						    <input type="button" id="clickme" value="Browse.." onClick="fileToUpload.click()"/>
                      </div>
                    </td>
                </tr>
                <input name="filePath" type="text" value="<%=profile.getPicture()%>" hidden/>
                <tr>
                    <td>Your Name</td>
                    <td><input id="name" type="text" class="right-side-box" name="name" value="<%= profile.getFullName() %>"></td>
                </tr>
                
                <tr>
                    <td>Phone</td>
                    <td>
                        <input id="phone" type="text" class="right-side-box" name="phone" value="<%= profile.getPhoneNumber() %>" onkeypress='return onlyNumber(event)'>
                    </td>
                </tr>
                
                <tr>
                    <td>Status Driver</td>
                    <td>
                        <label class="switch">
                            <input id="isDriver" type="checkbox" name="driver" value="YES">
                            <span class="slider round"></span>
                        </label>
                    </td>
                </tr>

                </table>
        </div>
        <br><br>
        <button class="btn-back"><a href="profile.jsp"> BACK </a></button>
        <button class="btn-save" type="submit" name="submit">SAVE</button>
        </form>
        <%
        String driver_status = profile.getDriver();
  		if(driver_status.equals("true")) {
  			out.println("<script>" 
  						+ "document.getElementById('isDriver').checked = true; "
  						+ "</script>");
  		}
  		else {
  			out.println("<script>" 
						+ "document.getElementById('isDriver').checked = false; "
						+ "</script>");
  		}
	  	%>
    </div>
</body>
</html>