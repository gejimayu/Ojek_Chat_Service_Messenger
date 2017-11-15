package org.java.ojekonline.webservice;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

class MapElements
{
  @XmlElement public String  key;
  @XmlElement public String value;

  private MapElements() {} //Required by JAXB

  public MapElements(String key, String value)
  {
    this.key   = key;
    this.value = value;
  }
}
