package org.java.ojekonline.webservice;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet("/upload")
@MultipartConfig
public class UploadImage extends HttpServlet {
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		OjekDataImplService service = new OjekDataImplService();
		OjekData ps = service.getOjekDataImplPort();

		String user = request.getParameter("id_user");
		int id_user = Integer.parseInt(user);
		String full_name = request.getParameter("name");
		String phone_number = request.getParameter("phone");
		String driver = request.getParameter("driver");
		String imagePath = request.getParameter("filePath");
		System.out.println("image path : " + imagePath);
		if (driver != null) {
			driver = "true";
		}
		else {
			driver = "false";
		}
		
		String pathSave = "";
		
		// Create path components to save the file
	    final String path = "D:\\EclipseApps\\Client\\WebContent\\img";
	    
	    final Part filePart = request.getPart("fileToUpload");
	    
	    final String fileName = getFileName(filePart);
	    
	    if (fileName.length() == 0) {
	    	pathSave = imagePath;
	    }
	    else {
	    	pathSave = "img/" +fileName;
		    
		    OutputStream out = null;
		    InputStream filecontent = null;
		    try {
		        out = new FileOutputStream(new File(path + File.separator
		                + fileName));
		        filecontent = filePart.getInputStream();

		        int read = 0;
		        final byte[] bytes = new byte[1024];

		        while ((read = filecontent.read(bytes)) != -1) {
		            out.write(bytes, 0, read);
		        }
		    } catch (FileNotFoundException fne) {
		    } finally {
		        if (out != null) {
		            out.close();
		        }
		        if (filecontent != null) {
		            filecontent.close();
		        }
		    }
	    }
		
		ps.saveProfile(id_user, pathSave, full_name, phone_number, driver);
	    response.sendRedirect("profile.jsp");
	}
	
	private String getFileName(final Part part) {
	    final String partHeader = part.getHeader("content-disposition");
	    for (String content : part.getHeader("content-disposition").split(";")) {
	        if (content.trim().startsWith("filename")) {
	            return content.substring(
	                    content.indexOf('=') + 1).trim().replace("\"", "");
	        }
	    }
	    return null;
	}
}
