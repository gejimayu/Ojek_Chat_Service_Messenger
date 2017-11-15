package org2.java.identity.webservice;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.jws.WebService;

import java.util.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;

import com.mysql.jdbc.Statement;

@WebService(endpointInterface="org2.java.identity.webservice.TokenController")
public class TokenControllerImpl implements TokenController{
	// JDBC driver name and database URL
	static final String JDBC_DRIVER = "com.mysql.jdbc.Driver";  
	static final String DB_URL = "jdbc:mysql://localhost:3306/ojekaccount";
	//  Database credentials
	static final String USER = "root";
	static final String PASS = "";
	Statement stmt = null;
    Connection conn = null;
    ResultSet rs = null;
	
    void execute(String query) {
		//Connect to database
	    try {
	    	// Register JDBC driver
	        Class.forName("com.mysql.jdbc.Driver");
	          
	        conn = DriverManager.getConnection(DB_URL, USER, PASS);
	          
	        stmt = (Statement) conn.createStatement();
	        
	        //Validate token
	        rs =stmt.executeQuery(query);
	    } 
	    catch(SQLException se) {
	    	//Handle errors for JDBC
	    	se.printStackTrace();
	    } 
	    catch(Exception e) {
	      	//Handle errors for Class.forName
	      	e.printStackTrace();
	    } 
	}
    
	@Override
	public int validateToken(String token, String expirytime) {
		//return -2 : token invalid, -1 : token expired, else : token valid = user_id
		int result = 0;
		
		//get current date
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date dateNow = new Date();
		Date expirydate = new Date();;
		//convert expiry time
		try {
			expirydate = dateFormat.parse(expirytime);
		} catch (ParseException e1) {
			e1.printStackTrace();
		}
		
		String query = "SELECT * FROM accesstoken WHERE token = '"+ token +"' AND expiretime = '"+ expirytime +"'";
		execute(query);
		try {
			if (rs.next()) { //token validated
				System.out.println("Compared datenow : " + dateFormat.format(dateNow));
				System.out.println("Compared expirydate : " + dateFormat.format(expirydate));
				if (dateNow.after(expirydate)) { //token expired
					result = -1;
				}
				else {
					result = rs.getInt("id_user");
				}
			}
			else { //token invalid
				result = -2; 
			}
			stmt.close();
	        conn.close();
		} catch (SQLException e) {
		} 
		System.out.println("Comparison result : " + result);
		return result;
	}

}

