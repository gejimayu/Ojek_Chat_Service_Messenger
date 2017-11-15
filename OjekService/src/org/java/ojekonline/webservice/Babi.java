package org.java.ojekonline.webservice;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlElementWrapper;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;
import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;

//import org.apache.http.entity.StringEntity;

import java.io.BufferedInputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.Map;

@XmlRootElement( name = "Babi" )
public class Babi {  
	private ArrayList<Map<String, String>> results;
	
	public Babi() {
		results = new ArrayList<Map<String, String>>();
	}
	 
	public Babi(ArrayList<Map<String, String>> results) {
		this.results = results;
	}
	
	public void setResults(ArrayList<Map<String, String>> results) {
		this.results = results;
	}
	
	@XmlJavaTypeAdapter(MapAdapter.class)    
	public ArrayList<Map<String, String>> getResults() {
		return this.results;
	}
}