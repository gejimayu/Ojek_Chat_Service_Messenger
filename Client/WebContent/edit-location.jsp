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
    <meta name="author" content="Taufan Mahaputra, Robby Syaifullah, M Rafli">
    <!-- Properties Title -->
    <link rel="shortcut icon" href="editlocation.css" />
    <title>Ngo-Jek</title>

    <!-- Custom CSS -->
    <link href="style/main.css" rel="stylesheet" type='text/css' />
    <link href="style/editlocation.css" rel="stylesheet" type='text/css' />
    <!-- Custom Fonts -->
    <link href="style/font-awesome.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Patua+One" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Oswald:400,500,600" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Roboto:400,500" rel="stylesheet">
    <link href="style/editlocation.css" rel="stylesheet">
    <!-- Script -->
    <script src="javascript/edit-location.js"></script>
</head>
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
<body>
	<div class="container">
        <br>
        <!-- Header Section -->
        <div class="profile-header">
            <h2 class="profile-title">EDIT PREFERRED LOCATION</h2>
        </div>
        
        <!-- Table Section-->
        <table>
            <tr>
                <th class="kolom-1">No</th>
                <th class="kolom-2">Location</th>
                <th class="kolom-3">Actions</th>
            </tr>
           <%
           
           Babi res = new Babi();
			res = ps.listLocation(id_user);
			Map<String, String> hasil = new HashMap<String, String>();
			
			int counter = 1;
			ArrayList<MapElements> temp = new ArrayList<MapElements>();
			if(res.getResults().size() != 0) {
				for (MapElementsArray isi : res.getResults()) {
					temp = (ArrayList<MapElements>) isi.getItem();
					for (MapElements konten : temp) { 
						hasil.put(konten.getKey(), konten.getValue());
					}
					out.println("<tr>");
		           		out.println("<td class=\"kolom-1\">" + counter + "</td>");
		           		out.println("<td class=\"kolom-2\">");
		      	   			out.println("<form action=\"save-location.jsp\" method=\"POST\" class=\"form-save\">");
		          				out.println("<input type=\"hidden\" name=\"id_user\" value=\"" + id_user +  "\">");
		    					out.println("<input type=\"hidden\" name=\"old-location\" value=\"" + hasil.get("location") + "\">");
		     					out.println("<input id=\"" + hasil.get("location") + "\" type=\"hidden\" name=\"new-location\" value=\"" + hasil.get("location") + "\">");
		        				out.println("<span id=\"" + hasil.get("location") + "s\">" + hasil.get("location") + "</span>");
		        		out.println("</td>");
		        		out.println("<td class=\"kolom-3\">");
		        			out.println("<i id=\"" + hasil.get("location") + "pencil\"style=\"margin-left:8px;cursor:pointer;\" class=\"fa fa-pencil\" aria-hidden=\"true\" onclick=\"editLocation('" + hasil.get("location") + "')\" ></i>");
		        			out.println("<button id=\"" + hasil.get("location") + "save\" type=\"submit\" class=\"save-button\"> ");
		        			out.println("<i  class=\"fa fa-floppy-o\" aria-hidden=\"true\"></i> ");
		        			out.println("</button> </form>");
		        			out.println("<i style=\"margin-left:15px;cursor:pointer;\" class=\"fa fa-times\" aria-hidden=\"true\" onclick=\"deleteLocation('" + hasil.get("location") + "')\" ></i>");
		        		out.println("</td>");
	        		out.println("</tr>");
					counter++;
	    		}
			}
           	
        	%>
        </table>

        <!--Field Form-->
        <form class="form-field" action="add-location.jsp" method="POST">
            <h3> ADD NEW LOCATION: </h3>
            <input type="hidden" name="id_user" value="<%= id_user %>">
            <input class="form-textbox" type="text" name="location" required>&emsp;
            <button class="btn-add">ADD</button>
        </form>
         <button class="form-field btn-back"><a href="profile.jsp"> BACK </a> </button>

        <div id="modalMessage" class="modal">
          <!-- Modal content -->
          <div class="modal-content">
            <span class="close" onclick="closeModal()">&times;</span>
            <p>Are you sure want to delete this location?</p><span id="nameLocation"></span>

            <form action="delete-location.jsp" method="POST">
                <input type="hidden" name="id_user" value="<%= id_user %>">
                <input type="hidden" name="location" value="" id="location">
                <input type="submit" name="delete" value="YES">
            </form>
          </div>
        </div>
    </div>
</body>
</html>