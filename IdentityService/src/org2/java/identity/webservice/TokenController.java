package org2.java.identity.webservice;

import javax.jws.WebMethod;
import javax.jws.WebService;

@WebService
public interface TokenController {
	
	@WebMethod
	public int validateToken(String token, String expirytime);
	
}

