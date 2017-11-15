package org2.java.identity.webservice;
import javax.xml.ws.Endpoint;

public class TokenControllerPublisher {
	public static void main(String[] args) {
		  Endpoint.publish("http://localhost:8083/WS/TokenController",new TokenControllerImpl());
	}
}
