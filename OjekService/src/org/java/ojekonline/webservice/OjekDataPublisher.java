package org.java.ojekonline.webservice;
import javax.xml.ws.Endpoint;

public class OjekDataPublisher {
	public static void main(String[] args) {
		  Endpoint.publish("http://localhost:8082/WS/OjekData",new OjekDataImpl());
	}
}