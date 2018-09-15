<%@page import="com.siemns.xmlsearch.beans.SummaryObj"%>
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
      <title>Step List</title>
   </head>
   <body>
      <%
         String testDirName = request.getParameter("soaStringList");
                  String stepStringList = request.getParameter("stepStringList");
                  
                  String[] confSteps = null;
                  confSteps = ((String) stepStringList).split(",");
                  
                  List<StepObj> stepListFromUI = new ArrayList<StepObj>();
                  for (int index = 0; index < confSteps.length; index++) {
                  	String[] arr = confSteps[index].split("##");
                  	if (arr.length >= 4) {
                  		StepObj stepObj = new StepObj();
                  		SummaryObj summaryObj = new SummaryObj();
                  		stepObj.setScenarioName(arr[0]);
                  		stepObj.setStepName(arr[1]);
                  		summaryObj.setTotalNetworkTime(arr[2]);
                  		stepObj.setSummaryObj(summaryObj);
                  		stepObj.setStepId(Integer.valueOf(arr[3]));
                  		stepListFromUI.add(stepObj);
                  	}
                  }
                  
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
                  List<RequestObj> soaListWithAverageRequestTime = new ArrayList<RequestObj>();
                  List<RequestObj> configuredSoaList = new ArrayList<RequestObj>();
                  List<RequestObj> configUnique = new ArrayList<RequestObj>();
                  
                  for (String baselineResultBasePath : baselineResultList) {
                  
                  	List<StepObj> configSteps = new ArrayList<StepObj>();
                  
                  	List<FeatureObj> featureList = StaxParser
                  			.getAllAvailableFeatures(baselineResultBasePath);
                  	//stepList = CoreUtil.getAllStepsFromFeatureList(featureList);
                  	stepList = CoreUtil.getUniqueStepFromFeature(featureList);
                  
                  	for (StepObj stepObj : stepListFromUI) {
                  		String scenarioName = stepObj.getScenarioName();
                  		String stepName = stepObj.getStepName();
                  		String stepId = String.valueOf(stepObj.getStepId());
                  		configSteps.add(CoreUtil.calculateAvgStep(scenarioName,
                  				stepName, stepList));
                  	}
                  	stepList = configSteps;
                  
                  	if (stepList.size() != 0) {
                  		List<RequestObj> soaList = CoreUtil
                  				.getAllSOARequestFromStepList(stepList);
                  
                  
                  		for (RequestObj requestObj : soaList) {
                  			configuredSoaList.add(requestObj);
                  		}
                  
                  		//CoreUtil.calculateAverageRequestTIme(requestURL, requestList)
                  		configUnique = CoreUtil
                  				.getUniqueSOAsFromList(configuredSoaList);
                  
                  		for (String soaNameString : soaStringList) {
                  			soaListWithAverageRequestTime.add(CoreUtil
                  					.calculateAverageRequestTIme(soaNameString,
                  							configuredSoaList));
                  		}
                  
                  		soaMap.put(baselineResultBasePath,
                  				soaListWithAverageRequestTime);
                  	}
                  
                  }
         %>
      <div>
         <div>
            <b>Select SOA(s)</b>
         </div>
         <%
            if(configUnique.size()!=0)
            {
            %>
         <input onclick="selectAllSOAsAjax(true)" type="checkbox"
            name='selectallsoas' id='selectallsoas' value='selectallsoas'>
         All<br />
         <%
            }
            %>
         <%
            for (Iterator<RequestObj> iterator = configUnique.iterator(); iterator
            	            		.hasNext();) {
            	            	RequestObj req = iterator.next();
            	            	String soaString = req.getRequestURL();
            	            	String soaTruncString = soaString.substring(soaString
            	            			.lastIndexOf("/") + 1);
            %>
         <input onclick="selectAllSOAsAjax(false)" type="checkbox"
            name="check_soas_<%=soaString%>" id="check_soas_<%=soaString%>"
            value="<%=soaString%>"><%=soaTruncString%>
         <br>
         <%
            }
            %>
      </div>
   </body>
</html>