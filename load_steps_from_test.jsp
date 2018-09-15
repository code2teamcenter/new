<%@page import="com.siemens.xmlsearch.util.CoreUtil"%>
<%@page import="com.siemns.xmlsearch.beans.FeatureObj"%>
<%@page import="com.siemens.xmlsearch.stax.StaxParser"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.siemns.xmlsearch.beans.RequestObj"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.List"%>
<%@page import="com.siemns.xmlsearch.beans.StepObj"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.TreeSet"%>
<%@page import="com.siemens.xmlsearch.util.PropertiesUtil"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
   pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
   <head>
      <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
      <title>Step List</title>
   </head>
   <body>
      <%
         String testDirName = request.getParameter("soaStringList");
         
         String configFilePath = "/WEB-INF/properties/config.properties";
         String baselineArrayString = testDirName;
         
         /* String baselineArrayStringFromProp = PropertiesUtil.readProperty(
         getServletContext().getResourceAsStream(configFilePath),
         "result.path");
         baselineArrayStringFromProp = baselineArrayStringFromProp + ","
         + baselineArrayString; */
         //String[] baselineResults = baselineArrayStringFromProp.split(",");
         String[] baselineResults = testDirName.split(",");
         
         String soaJsonString = PropertiesUtil.readProperty(
         		getServletContext().getResourceAsStream(configFilePath),
         		"soas.json");
         
         Set<String> soaStringList = new TreeSet<String>();
         List<StepObj> stepList = new ArrayList<StepObj>();
         
         List<String> baselineResultList = new ArrayList<String>();
         for (int index = 0; index < baselineResults.length; index++) {
         	String soaNameObj = baselineResults[index];
         	baselineResultList.add(soaNameObj);
         }
         
         Map<String, List<RequestObj>> soaMap = new HashMap<String, List<RequestObj>>();
         
         for (String baselineResultBasePath : baselineResultList) {
         
         	List<FeatureObj> featureList = StaxParser
         			.getAllAvailableFeatures(baselineResultBasePath);
         	stepList = CoreUtil.getAllStepsFromFeatureList(featureList);
         	//stepList = CoreUtil.getUniqueStepFromFeature(featureList);
         	List<RequestObj> soaListForReport = CoreUtil
         			.getAllSOARequestWithinSingleFeatureList(featureList);
         	List<RequestObj> soaList = CoreUtil
         			.getUniqueSOAsFromList(soaListForReport);
         	List<RequestObj> configuredSoaList = new ArrayList<RequestObj>();
         
         	for (RequestObj requestObj : soaList) {
         		soaStringList.add(requestObj.getRequestURL());
         	}
         }
         %>
      <div>
         <div>
            <b>Select Step from List</b>
         </div>
         <select name="stepDropDownList" id="stepDropDownList"
            class="w3-select w3-border-black w3-padding"
            onchange="loadSOAsFromTestAndStepAjax()">
            <%
               for (StepObj stepObj : stepList) {
               
               	String stepName = stepObj.getStepName();
               %>
            <option id='<%=stepName%>_<%=stepObj.getStepId()%>'
               value='<%=stepObj.getScenarioName()%>##<%=stepName%>##<%=stepObj.getSummaryObj().getTotalNetworkTime()%>##<%=stepObj.getStepId()%>'><%=stepName%>
            </option>
            <%
               }
               %>
         </select>
      </div>
   </body>
</html>