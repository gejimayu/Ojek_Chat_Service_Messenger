
package org2.java.identity.webservice;

import javax.xml.bind.JAXBElement;
import javax.xml.bind.annotation.XmlElementDecl;
import javax.xml.bind.annotation.XmlRegistry;
import javax.xml.namespace.QName;


/**
 * This object contains factory methods for each 
 * Java content interface and Java element interface 
 * generated in the org2.java.identity.webservice package. 
 * <p>An ObjectFactory allows you to programatically 
 * construct new instances of the Java representation 
 * for XML content. The Java representation of XML 
 * content can consist of schema derived interfaces 
 * and classes representing the binding of schema 
 * type definitions, element declarations and model 
 * groups.  Factory methods for each of these are 
 * provided in this class.
 * 
 */
@XmlRegistry
public class ObjectFactory {

    private final static QName _ValidateToken_QNAME = new QName("http://webservice.identity.java.org2/", "validateToken");
    private final static QName _ValidateTokenResponse_QNAME = new QName("http://webservice.identity.java.org2/", "validateTokenResponse");

    /**
     * Create a new ObjectFactory that can be used to create new instances of schema derived classes for package: org2.java.identity.webservice
     * 
     */
    public ObjectFactory() {
    }

    /**
     * Create an instance of {@link ValidateTokenResponse }
     * 
     */
    public ValidateTokenResponse createValidateTokenResponse() {
        return new ValidateTokenResponse();
    }

    /**
     * Create an instance of {@link ValidateToken }
     * 
     */
    public ValidateToken createValidateToken() {
        return new ValidateToken();
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link ValidateToken }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://webservice.identity.java.org2/", name = "validateToken")
    public JAXBElement<ValidateToken> createValidateToken(ValidateToken value) {
        return new JAXBElement<ValidateToken>(_ValidateToken_QNAME, ValidateToken.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link ValidateTokenResponse }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://webservice.identity.java.org2/", name = "validateTokenResponse")
    public JAXBElement<ValidateTokenResponse> createValidateTokenResponse(ValidateTokenResponse value) {
        return new JAXBElement<ValidateTokenResponse>(_ValidateTokenResponse_QNAME, ValidateTokenResponse.class, null, value);
    }

}
