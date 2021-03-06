
package org2.java.identity.webservice;

import java.net.MalformedURLException;
import java.net.URL;
import javax.xml.namespace.QName;
import javax.xml.ws.Service;
import javax.xml.ws.WebEndpoint;
import javax.xml.ws.WebServiceClient;
import javax.xml.ws.WebServiceException;
import javax.xml.ws.WebServiceFeature;


/**
 * This class was generated by the JAX-WS RI.
 * JAX-WS RI 2.2.9-b130926.1035
 * Generated source version: 2.2
 * 
 */
@WebServiceClient(name = "TokenControllerImplService", targetNamespace = "http://webservice.identity.java.org2/", wsdlLocation = "http://localhost:8083/WS/TokenController?wsdl")
public class TokenControllerImplService
    extends Service
{

    private final static URL TOKENCONTROLLERIMPLSERVICE_WSDL_LOCATION;
    private final static WebServiceException TOKENCONTROLLERIMPLSERVICE_EXCEPTION;
    private final static QName TOKENCONTROLLERIMPLSERVICE_QNAME = new QName("http://webservice.identity.java.org2/", "TokenControllerImplService");

    static {
        URL url = null;
        WebServiceException e = null;
        try {
            url = new URL("http://localhost:8083/WS/TokenController?wsdl");
        } catch (MalformedURLException ex) {
            e = new WebServiceException(ex);
        }
        TOKENCONTROLLERIMPLSERVICE_WSDL_LOCATION = url;
        TOKENCONTROLLERIMPLSERVICE_EXCEPTION = e;
    }

    public TokenControllerImplService() {
        super(__getWsdlLocation(), TOKENCONTROLLERIMPLSERVICE_QNAME);
    }

    public TokenControllerImplService(WebServiceFeature... features) {
        super(__getWsdlLocation(), TOKENCONTROLLERIMPLSERVICE_QNAME, features);
    }

    public TokenControllerImplService(URL wsdlLocation) {
        super(wsdlLocation, TOKENCONTROLLERIMPLSERVICE_QNAME);
    }

    public TokenControllerImplService(URL wsdlLocation, WebServiceFeature... features) {
        super(wsdlLocation, TOKENCONTROLLERIMPLSERVICE_QNAME, features);
    }

    public TokenControllerImplService(URL wsdlLocation, QName serviceName) {
        super(wsdlLocation, serviceName);
    }

    public TokenControllerImplService(URL wsdlLocation, QName serviceName, WebServiceFeature... features) {
        super(wsdlLocation, serviceName, features);
    }

    /**
     * 
     * @return
     *     returns TokenController
     */
    @WebEndpoint(name = "TokenControllerImplPort")
    public TokenController getTokenControllerImplPort() {
        return super.getPort(new QName("http://webservice.identity.java.org2/", "TokenControllerImplPort"), TokenController.class);
    }

    /**
     * 
     * @param features
     *     A list of {@link javax.xml.ws.WebServiceFeature} to configure on the proxy.  Supported features not in the <code>features</code> parameter will have their default values.
     * @return
     *     returns TokenController
     */
    @WebEndpoint(name = "TokenControllerImplPort")
    public TokenController getTokenControllerImplPort(WebServiceFeature... features) {
        return super.getPort(new QName("http://webservice.identity.java.org2/", "TokenControllerImplPort"), TokenController.class, features);
    }

    private static URL __getWsdlLocation() {
        if (TOKENCONTROLLERIMPLSERVICE_EXCEPTION!= null) {
            throw TOKENCONTROLLERIMPLSERVICE_EXCEPTION;
        }
        return TOKENCONTROLLERIMPLSERVICE_WSDL_LOCATION;
    }

}
