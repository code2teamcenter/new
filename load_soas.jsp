<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
   pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page import="java.util.TreeSet"%>
<%@page import="com.siemns.xmlsearch.beans.FeatureObj"%>
<%@page import="com.siemns.xmlsearch.beans.RequestObj"%>
<%@page import="com.siemens.xmlsearch.util.PropertiesUtil"%>
<%@page import="com.siemns.xmlsearch.beans.StepObj"%>
<%@page import="java.io.File"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.siemens.xmlsearch.util.CoreUtil"%>
<%@page import="com.siemens.xmlsearch.stax.StaxParser"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Set"%>
<html>
   <head>
      <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
      <title>SOA List</title>
   </head>
   <body>
      <%
         String testDirName = request.getParameter("soaStringList");
                  
                  String configFilePath = "/WEB-INF/properties/config.properties";
                  String baselineArrayString = testDirName;
                  
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
                  	//stepList = CoreUtil.getAllStepsFromFeatureList(featureList);
                  	stepList = CoreUtil.getUniqueStepFromFeature(featureList);
                  	List<RequestObj> soaListForReport = CoreUtil
                  			.getAllSOARequestWithinSingleFeatureList(featureList);
                  	List<RequestObj> soaList = CoreUtil
                  			.getUniqueSOAsFromList(soaListForReport);
                  	List<RequestObj> configuredSoaList = new ArrayList<RequestObj>();
                  
                  	for (RequestObj requestObj : soaList) {
                  		soaStringList.add(requestObj.getRequestURL());
                  	}
                  }
                  
                  if(null!=stepList & stepList.size()>0)
                  {
         %>
      <div>
         <div>
            <b>Select Step(s)</b>
         </div>
         <%
            int count = 0;
            %>
         <input onclick="selectAllStepsAjax()" type="checkbox"
            name='selectallsteps' id='selectallsteps' value='selectallsteps'>
         All<br />
         <%
            for (StepObj stepObj : stepList) {
            	            	count++;
            	            	String stepName = stepObj.getStepName();
            %>
         <input onclick="loadStepAjax()" type="checkbox"
            name='check_step_<%=stepName%>' id='check_step_<%=stepName%>'
            value='<%=stepObj.getScenarioName()%>##<%=stepName%>##<%=stepObj.getSummaryObj().getTotalNetworkTime()%>##<%=stepObj.getStepId()%>'><%=stepName%>
         <br>
         <%
            }
            %>
      </div>
      <%}else {
         %>
      <div>
         <b>No Steps to display</b>
      </div>
      <%
         }
                  
                  %>
      <div id="soas_list"></div>
   </body>
</html>