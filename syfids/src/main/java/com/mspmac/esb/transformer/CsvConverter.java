package com.mspmac.esb.transformer;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import javax.xml.datatype.DatatypeConfigurationException;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.DOMException;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.mule.api.MuleEventContext;
import org.mule.api.MuleMessage;

public class CsvConverter implements org.mule.api.lifecycle.Callable {
	
	public CsvConverter() {
		
	}
	
	public Document convert(MuleMessage message) throws DOMException, ParseException, DatatypeConfigurationException {
		
		String[] csv = (String[]) message.getPayload();
		String[] strHeaders = message.getInvocationProperty("dataHeaders");
		String[] headers = strHeaders[0].split(",");
		//System.out.println(headers[0]);
		
		DocumentBuilderFactory dFact = DocumentBuilderFactory.newInstance();
		DocumentBuilder build;
		Document doc = null;
		
		SimpleDateFormat sdfParse = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS", Locale.ENGLISH);
		//SimpleDateFormat sdfFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'-05:00'");
		
		try {
			build = dFact.newDocumentBuilder();
	        doc = build.newDocument();
		  } catch (ParserConfigurationException e) {
			  e.printStackTrace();
		  }		
				
		// FlightInfo
		Element flight = doc.createElement("Flight");
		flight.setAttribute("CorrelationID", message.getUniqueId());
		doc.appendChild(flight);
		
		for(int i = 0; i < csv.length; i++ ) {			
			Element el = doc.createElement(headers[i]);
			String oVal = csv[i].trim();
			if(oVal.indexOf("NULL")>=0) {
				oVal = "";
			}
			//System.out.println(oVal);
			if(headers[i].indexOf("Date") > 0) {			    			
				if(oVal.length() > 0){					
					el.appendChild(doc.createTextNode(formatXMLDate(sdfParse.parse(oVal))));
					//System.out.println(sdfFormat.format(sdfParse.parse(oVal)));
				} 				
			} else {
				el.appendChild(doc.createTextNode(oVal));
			}			
			flight.appendChild(el);			
		}	
		
		return doc;
		
	}	

	@Override
	public Object onCall(MuleEventContext eventContext) throws Exception {
	  MuleMessage message = eventContext.getMessage();
	  Document newPayload = this.convert(message);//(message.getPayloadAsString());
	  message.setPayload(newPayload);
	  return message;
	}
	
	private String formatXMLDate(Date varDate) throws DatatypeConfigurationException {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ssZ");
		String val = formatter.format(varDate);
		val = val.substring(0, val.length()-2) + ":" + val.substring(val.length()-2, val.length());
		return val;
	}
}