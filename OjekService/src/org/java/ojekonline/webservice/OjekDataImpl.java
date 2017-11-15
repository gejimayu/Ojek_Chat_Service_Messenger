package org.java.ojekonline.webservice;
import javax.jws.WebMethod;
import javax.jws.WebService;
import org2.java.identity.webservice.*;


import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import com.mysql.jdbc.Statement;

@WebService(endpointInterface="org.java.ojekonline.webservice.OjekData")
public class OjekDataImpl implements OjekData {
	// JDBC driver name and database URL
	static final String JDBC_DRIVER = "com.mysql.jdbc.Driver";  
	static final String DB_URL = "jdbc:mysql://localhost:3306/ojekonline";
	//  Database credentials
	static final String USER = "root";
	static final String PASS = "";
	Statement stmt = null;
    Connection conn = null;
    ResultSet rs = null;
		
	@Override
	public int validateToken(String token, String expiry_time) {
		TokenControllerImplService service = new TokenControllerImplService();
		TokenController ps = service.getTokenControllerImplPort();
		return ps.validateToken(token, expiry_time);
	}
	
	void execute(String query, int code) {
		// code 1 : select
		// code 2 : insert
		// code 3 : update
		// code 4 : delete
		//Connect to database
	    try {
	    	// Register JDBC driver
	        Class.forName("com.mysql.jdbc.Driver");
	          
	        conn = DriverManager.getConnection(DB_URL, USER, PASS);
	          
	        stmt = (Statement) conn.createStatement();
	        
	        //Validate token
	        switch(code) {
	        	case 1: rs =stmt.executeQuery(query);
	        			break;
	        	default:stmt.executeUpdate(query);
	        			break;
	        }
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
	public Babi getRatingDetail(int id_user) {
		ArrayList<Map<String, String>> smth = new ArrayList<Map<String, String>>();
		try {
			String query = "SELECT * FROM driver WHERE id_driver = " + id_user + "";
			execute(query, 1);
			while(rs.next()) {
				Map<String, String> temp = new HashMap<String, String>();
				temp.put("rating", rs.getString("avgrating"));
				temp.put("votes", rs.getString("num_votes"));
				smth.add(temp);
			}
			stmt.close();
			conn.close();
		} catch (SQLException e) {
				e.printStackTrace();
		}
		
		Babi kampret = new Babi();
		kampret.setResults(smth);
		
		return kampret;
	}
	
	@Override
	public Babi findDriver(int id_user, String pick, String dest) {
	    ArrayList<Map<String, String>> smth = new ArrayList<Map<String, String>>();
		try {
			String query = 
					"SELECT DISTINCT name, prof_pic, avgrating, "
					+ "id_driver, num_votes FROM driver NATURAL JOIN pref_location "
					+ "join user WHERE id_user <> "+ Integer.toString(id_user) +" AND id_user = id_driver AND" + 
					"( '" + pick + "' = location OR '" +  dest + "' = location)";
			execute(query, 1);
			while (rs.next()) {
				System.out.println(rs.getString("name"));
				Map<String, String> temp = new HashMap<String, String>();
				temp.put("name", rs.getString("name"));
				temp.put("prof_pic", rs.getString("prof_pic"));
				temp.put("avgrating", Float.toString(rs.getFloat("avgrating")));
				temp.put("id_driver", Integer.toString(rs.getInt("id_driver")));
				temp.put("num_votes", Integer.toString(rs.getInt("num_votes")));
				smth.add(temp);
			}
			
			stmt.close();
			conn.close();
		} catch (SQLException e) {
				e.printStackTrace();
		}
	
		Babi kampret = new Babi();
		kampret.setResults(smth);
		
		return kampret;
	}

	@Override
	public String getNameUser(int id_user) {
		String query = "SELECT name FROM user WHERE id_user = " + Integer.toString(id_user);
		execute(query, 1);
		String result = null;

		try {
			if (rs.next())
				result = rs.getString("name");
		
			stmt.close();
	        conn.close();
		} catch (SQLException e) {
		} 
        
		return result;
	}

	@Override
	public Babi findPrefDriver(int id_user, String name) {
		ArrayList<Map<String, String>> smth = new ArrayList<Map<String, String>>();
		try {
			String query = 
					"SELECT DISTINCT name, prof_pic, avgrating, "
					+ "id_driver, num_votes FROM driver join "
					+ " user WHERE id_user <> "+ Integer.toString(id_user) +" AND name =  "
							+ "'"+ name + "' AND id_driver = id_user";
			execute(query, 1);
			if (rs.next()) {
				System.out.println(rs.getString("name"));
				Map<String, String> temp = new HashMap<String, String>();
				temp.put("name", rs.getString("name"));
				temp.put("prof_pic", rs.getString("prof_pic"));
				temp.put("avgrating", Float.toString(rs.getFloat("avgrating")));
				temp.put("id_driver", Integer.toString(rs.getInt("id_driver")));
				temp.put("num_votes", Integer.toString(rs.getInt("num_votes")));
				smth.add(temp);
			}
			
			 stmt.close();
		     conn.close();
		} catch (SQLException e) {
				// TODO Auto-generated catch block
				System.out.println("asem");
				e.printStackTrace();
		}
	
		Babi kampret = new Babi();
		kampret.setResults(smth);
		
		return kampret;
	}

	@Override
	public Babi getProfile(int id_user, int driverstatus) {
		ArrayList<Map<String, String>> smth = new ArrayList<Map<String, String>>();
		try {
			String query = null;
			if (driverstatus == 0) {
				query = "SELECT * FROM user WHERE id_user = " + Integer.toString(id_user);
			}
			else {
				query = "SELECT * FROM user join driver WHERE id_user = id_driver "
						+ "AND id_user = " + Integer.toString(id_user);
			}
			execute(query, 1);
			if (rs.next()) {
				System.out.println(rs.getString("name"));
				Map<String, String> temp = new HashMap<String, String>();
				temp.put("name", rs.getString("name"));
				temp.put("prof_pic", rs.getString("prof_pic"));
				temp.put("username", rs.getString("username"));
				if (driverstatus == 1) {
					temp.put("avgrating", Float.toString(rs.getFloat("avgrating")));
					temp.put("num_votes", Integer.toString(rs.getInt("num_votes")));
				}
				smth.add(temp);
			}
			
			 stmt.close();
		     conn.close();
		} catch (SQLException e) {
				e.printStackTrace();
		}
	
		Babi kampret = new Babi();
		kampret.setResults(smth);
		
		return kampret;
	}

	@Override
	public void insertOrder(int id_driver, int id_user, String tgl, String pick, String dest, int rate,
			String comment) {
		try {
			String query = 
					"INSERT INTO order_data(id_driver, id_user, date_order, origin, destination, rating, comment) " 
					+ "VALUES ("+ Integer.toString(id_driver) +", "+ Integer.toString(id_user) +", '"
					+ tgl +"', '"+ pick +"', '"+ dest +"', " 
					+ Integer.toString(rate) + ", '"+ comment +"')";
			execute(query, 2);
			
			 stmt.close();
		     conn.close();
		} catch (SQLException e) {
				e.printStackTrace();
		}
	}

	@Override
	public void updateDriver(int id_driver, int num_votes, float avgrating) {
		try {
			String query = 
					"UPDATE driver SET avgrating = "+ Float.toString(avgrating) +", "
							+ "num_votes = "+ Integer.toString(num_votes) +" "
							+ "WHERE id_driver = "+ Integer.toString(id_driver);
			execute(query, 3);
			
			 stmt.close();
		     conn.close();
		} catch (SQLException e) {
				e.printStackTrace();
		}
	}

	@Override
	public void insertHistory(int id_user, int id_driver, String tgl, String nameuser, String namedriver, String pick,
			String dest, int rate, String comment, int hide, int driverstatus) {
		try {
			String query = null;
			if (driverstatus == 0) { //userhistory
				query = 
						"INSERT INTO user_history(id_user, id_driver, date_order, customer_name, "
						+ "origin, destination, rating, comment, hide) " 
						+ "VALUES ("+ Integer.toString(id_user) +", "+ Integer.toString(id_driver) +", '"
						+ tgl + "', '"+ namedriver +"' , '"+ pick +"', '"+ dest +"', " 
						+ Integer.toString(rate) + ", '"+ comment +"' , 0)";
			}
			else { //driverhistory
				query = 
						"INSERT INTO driver_history(id_driver, id_user, date_order, customer_name, "
						+ "origin, destination, rating, comment, hide) " 
						+ "VALUES ("+ Integer.toString(id_driver) +", "+ Integer.toString(id_user) +", '"
						+ tgl + "', '"+ nameuser +"' , '"+ pick +"', '"+ dest +"', " 
						+ Integer.toString(rate) + ", '"+ comment +"' , 0)";
			}
			
			execute(query, 2);
			
			 stmt.close();
		     conn.close();
		} catch (SQLException e) {
				e.printStackTrace();
		}
		
	}
	
	@Override
	public Profile getProfileInfo(int id_user) {
		Profile profile = new Profile();
		
		try {
			String query = "SELECT * FROM user WHERE id_user = " + id_user;
			execute(query, 1);
			while(rs.next()) {
				profile.setFullName(rs.getString("name"));
				profile.setUsername(rs.getString("username"));
				profile.setEmail(rs.getString("email"));
				profile.setPhoneNumber(rs.getString("phone_number"));
				profile.setDriver(rs.getString("driver_status"));
				profile.setPicture(rs.getString("prof_pic"));
			}
			stmt.close();
	        conn.close();
		}
		catch (SQLException e) {
			//error
		}
		return profile;
	}
	
	@Override
	public Babi listLocation(int id_user) {
		 ArrayList<Map<String, String>> locations = new ArrayList<Map<String, String>>();
		
		try {
			String query = "SELECT * FROM pref_location WHERE id_driver = " + id_user;
			execute(query, 1);
			while(rs.next()) {
				Map<String, String> temp = new HashMap<String,String>();
				temp.put("location", rs.getString("location"));
				locations.add(temp);
			}
			stmt.close();
	        conn.close();
		}
		catch (SQLException e) {
			//error
		}
		
		Babi output = new Babi();
		output.setResults(locations);
		return output;
	}
	
	@Override
	public void addLocation(int id_driver, String location) {
		try {
			String query = 
					"INSERT INTO pref_location(id_driver, location) " 
					+ "VALUES ("+ id_driver + ", '"+ location +"')";
			execute(query, 2);
			
			stmt.close();
		    conn.close();
		} catch (SQLException e) {
				e.printStackTrace();
		}
	}
	
	@Override
	public void deleteLocation(int id_driver, String location) {
		try {
			String query = 
					"DELETE FROM pref_location WHERE id_driver = " + id_driver + " and location='" + location + "'";
			execute(query, 2);
			
			stmt.close();
		    conn.close();
		} catch (SQLException e) {
				e.printStackTrace();
		}
	}
	
	@Override
	public void saveLocation(int id_driver, String old_loc, String new_loc) {
		try {
			String query = 
					"UPDATE pref_location SET location='" + new_loc + "' WHERE  location='" + old_loc + "' AND id_driver = " + id_driver +"";
			execute(query, 2);
			
			stmt.close();
		    conn.close();
		} catch (SQLException e) {
				e.printStackTrace();
		}
	}

	@Override
	public Babi getUserHistory(int id_user) {
		ArrayList<Map<String, String>> smth = new ArrayList<Map<String, String>>();
		try {
			String query = null;
			query = "SELECT * FROM user_history WHERE id_user = " + Integer.toString(id_user) + " and hide = 0";
			System.out.println(query);
			execute(query, 1);
			while (rs.next()) {
				System.out.println(rs.getString("comment"));
				Map<String, String> temp = new HashMap<String, String>();
				temp.put("id_history", Integer.toString(rs.getInt("id_history")));
				temp.put("id_user", Integer.toString(rs.getInt("id_user")));
				temp.put("id_driver", Integer.toString(rs.getInt("id_driver")));
				temp.put("date_order", rs.getString("date_order"));
				temp.put("customer_name", rs.getString("customer_name"));
				temp.put("origin", rs.getString("origin"));
				temp.put("destination", rs.getString("destination"));
				temp.put("rating", Integer.toString(rs.getInt("rating")));
				temp.put("comment", rs.getString("comment"));
				temp.put("hide", Integer.toString(rs.getInt("hide")));
				smth.add(temp);
			}
			
			 stmt.close();
		     conn.close();
		} catch (SQLException e) {
				e.printStackTrace();
		}
	
		Babi kampret = new Babi();
		kampret.setResults(smth);
		
		return kampret;
	}
	
	@Override
	public Babi getDriverHistory(int id_driver) {
		ArrayList<Map<String, String>> smth = new ArrayList<Map<String, String>>();
		try {
			String query = null;
			query = "SELECT * FROM driver_history WHERE id_driver = " + Integer.toString(id_driver) + " and hide = 0";
			System.out.println(query);
			execute(query, 1);
			while (rs.next()) {
				System.out.println(rs.getString("comment"));
				Map<String, String> temp = new HashMap<String, String>();
				temp.put("id_history", Integer.toString(rs.getInt("id_history")));
				temp.put("id_user", Integer.toString(rs.getInt("id_user")));
				temp.put("id_driver", Integer.toString(rs.getInt("id_driver")));
				temp.put("date_order", rs.getString("date_order"));
				temp.put("customer_name", rs.getString("customer_name"));
				temp.put("origin", rs.getString("origin"));
				temp.put("destination", rs.getString("destination"));
				temp.put("rating", Integer.toString(rs.getInt("rating")));
				temp.put("comment", rs.getString("comment"));
				temp.put("hide", Integer.toString(rs.getInt("hide")));
				smth.add(temp);
			}
			
			 stmt.close();
		     conn.close();
		} catch (SQLException e) {
				e.printStackTrace();
		}
	
		Babi kampret = new Babi();
		kampret.setResults(smth);
		
		return kampret;
	}
	
	@Override
	public void hideUserHistory(int id_history) {
		try {
			String query = "UPDATE user_history SET hide=1 WHERE id_history =" + Integer.toString(id_history);
			execute(query, 3);
			 stmt.close();
		     conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	@Override
	public void hideDriverHistory(int id_history) {
		try {
			String query = "UPDATE driver_history SET hide=1 WHERE id_history =" + Integer.toString(id_history);
			execute(query, 3);
			 stmt.close();
		     conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	@Override
	public void saveProfile(int id_user, String filepath, String full_name, String phone_number, String driver) {
		try {
			String query = 
					" UPDATE user SET name = '" + full_name + "', "
					+ "phone_number = '" + phone_number + "', "
					+ "driver_status = '" + driver + "', "
					+ "prof_pic = '" + filepath +"' "
					+ "WHERE id_user =" + id_user + "";
			execute(query, 2);
			
			stmt.close();
		    conn.close();
		} catch (SQLException e) {
				e.printStackTrace();
		}	
	}


	@Override
	public void insertUser(String name, String username, String prof_pic, String email, String phone_number,
			String driver_status) {
		try {
			String query = null;
			query = "INSERT INTO user(name, username, prof_pic, email, "
					+ "phone_number, driver_status) " 
					+ "VALUES ('"+ name +"' , '"+ username +"', '"+ prof_pic +"', "
					+ "'" + email + "', '" + phone_number + "', '"+ driver_status +"')" ;
			
			execute(query, 2);
			
			query = "SELECT * from user WHERE username = '" + username + "'";
			
			execute(query, 1);
			
			if (rs.next()) {
				int id = rs.getInt("id_user");
				query = "INSERT INTO driver(id_driver, avgrating, num_votes) "
						+ "VALUES (" + Integer.toString(id) + ", 0, 0)";
				execute(query, 2);
			}
			
			 stmt.close();
		     conn.close();
		} catch (SQLException e) {
				e.printStackTrace();
		}
	}
	
	public void Register(String name, String email, String phone_number, String driver_status) {
		try {
			String query = ("INSERT INTO user (name, email, phone_number, driver_status) VALUES ('"+name+"','"+email+"','"+phone_number+"','"+driver_status+"')");
			execute(query, 2);
			 stmt.close();
		     conn.close();
		} catch (SQLException e) {
				e.printStackTrace();
		}
	}
	
	public String getPicture(int id_user) {
		String query = "SELECT prof_pic FROM user WHERE id_user = " + Integer.toString(id_user);
		execute(query, 1);
		String result = null;

		try {
			if (rs.next())
				result = rs.getString("prof_pic");
		
			stmt.close();
	        conn.close();
		} catch (SQLException e) {
		} 
        
		return result;
	}
}
