
package org.java.ojekonline.webservice;

import javax.xml.bind.JAXBElement;
import javax.xml.bind.annotation.XmlElementDecl;
import javax.xml.bind.annotation.XmlRegistry;
import javax.xml.namespace.QName;


/**
 * This object contains factory methods for each 
 * Java content interface and Java element interface 
 * generated in the org.java.ojekonline.webservice package. 
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

    private final static QName _Profile_QNAME = new QName("http://webservice.ojekonline.java.org/", "Profile");
    private final static QName _Babi_QNAME = new QName("http://webservice.ojekonline.java.org/", "Babi");

    /**
     * Create a new ObjectFactory that can be used to create new instances of schema derived classes for package: org.java.ojekonline.webservice
     * 
     */
    public ObjectFactory() {
    }

    /**
     * Create an instance of {@link Babi }
     * 
     */
    public Babi createBabi() {
        return new Babi();
    }

    /**
     * Create an instance of {@link Profile }
     * 
     */
    public Profile createProfile() {
        return new Profile();
    }

    /**
     * Create an instance of {@link MapElementsArray }
     * 
     */
    public MapElementsArray createMapElementsArray() {
        return new MapElementsArray();
    }

    /**
     * Create an instance of {@link MapElements }
     * 
     */
    public MapElements createMapElements() {
        return new MapElements();
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link Profile }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://webservice.ojekonline.java.org/", name = "Profile")
    public JAXBElement<Profile> createProfile(Profile value) {
        return new JAXBElement<Profile>(_Profile_QNAME, Profile.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link Babi }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://webservice.ojekonline.java.org/", name = "Babi")
    public JAXBElement<Babi> createBabi(Babi value) {
        return new JAXBElement<Babi>(_Babi_QNAME, Babi.class, null, value);
    }

}
