import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;


import javax.servlet.RequestDispatcher;
import java.sql.*;
import com.mysql.jdbc.Statement;
import java.util.UUID; //for generating token
import java.util.Date;
import java.text.SimpleDateFormat;
/**
 * Servlet implementation class logout
 */
@WebServlet("/login")
public class login extends HttpServlet {
	private static final long serialVersionUID = 1L;
	// JDBC driver name and database URL
	static final String JDBC_DRIVER = "com.mysql.jdbc.Driver";  
	static final String DB_URL = "jdbc:mysql://localhost:3306/ojekaccount";

	//  Database credentials
	static final String USER = "root";
	static final String PASS = "";
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		StringBuffer jb = new StringBuffer();
		String line = null;
		String username = null;
		String password = null;
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		//get current time
		Date date = new Date();
		//add an hour
		Date newDate = new Date(date.getTime() + 1 * 3600 * 1000);
		String dateNow = dateFormat.format(newDate);
		
		//Read body
		try {
		  BufferedReader reader = request.getReader();
		  while ((line = reader.readLine()) != null)
		    jb.append(line);
		} catch (Exception e) { /*report an error*/ }
		
		//Parse string JSON
		String jsonData = jb.toString();
		try {
			JSONObject jsonObject = new JSONObject(jsonData); // put "String"
			username = jsonObject.getString("username");
			password = jsonObject.getString("password");
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		
		//Connect to database
	    Statement stmt = null;
	    Connection conn = null;
	     request.setAttribute("message", "sukses");
	    try {
	    	// Register JDBC driver
	        Class.forName("com.mysql.jdbc.Driver");
	          
	      	// Open a connection
	        System.out.println("trying to connect");
	        conn = DriverManager.getConnection(DB_URL, USER, PASS);
	        System.out.println("successul connected to database");
	          
	        stmt = (Statement) conn.createStatement();
	        String sql;
	        
	        //GET ID User
	        sql = "SELECT id_user FROM userdata WHERE username = '" + username + "' and password = '" + password + "'";
	        ResultSet rs =stmt.executeQuery(sql);
	        if (!rs.next()) { //No 
	        	response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
	        	response.addHeader("message", "not found");
	        	return;
	        }
	        
	        String id = rs.getString("id_user");
	        
	        // Generating token
	        UUID uuid = UUID.randomUUID();
	        String usertoken = uuid.toString().replace("-", "");
	        
	        // Execute Insert Query
	        sql = "INSERT INTO accesstoken VALUES (" + id + ",'" + usertoken + "', '"+ dateNow +"')";
	        stmt.executeUpdate(sql);
	        
	        //send token and expiry time
	        PrintWriter out = response.getWriter();
	        response.setContentType("application/json");
	        response.setCharacterEncoding("utf-8");
	        response.setStatus(HttpServletResponse.SC_OK );
	        JSONObject json = new JSONObject();
	        json.put("token", usertoken);
	        json.put("expiry_time", dateNow);
	        out.print(json.toString());
	        stmt.close();
	        conn.close();
	    } 
	    catch(SQLException se) {
	    	//Handle errors for JDBC
	    	response.setStatus(HttpServletResponse.SC_BAD_REQUEST );
	    	se.printStackTrace();
	    } 
	    catch(Exception e) {
	      	//Handle errors for Class.forName
	      	e.printStackTrace();
	    } 
	    finally {
	    	//finally block used to close resources
	        try {
	           if(stmt!=null)
	              stmt.close();
	        } catch(SQLException se2) {
	        } // nothing we can do
	        try {
	           if(conn!=null)
	        	   conn.close();
	        } catch(SQLException se) {
	             se.printStackTrace();
	        } //end finally try
	    }
	}

}