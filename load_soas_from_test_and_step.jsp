<%@page import="java.util.Iterator"%>
<%@page import="com.siemens.xmlsearch.util.CoreUtil"%>
<%@page import="com.siemns.xmlsearch.beans.FeatureObj"%>
<%@page import="com.siemens.xmlsearch.stax.StaxParser"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.siemns.xmlsearch.beans.RequestObj"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
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
      <title>SOA List</title>
   </head>
   <body>
      <%
         String testDirName = request.getParameter("soaStringList");
         String stepDropDownList = request.getParameter("stepDropDownList");
         
         String scenarioName = "";
         String stepName = "";
         String totalNetTime = "";
         String stepId = "";
         String[] splitArr = stepDropDownList.split("##");
         if (null != splitArr && splitArr.length >= 4) {
         	scenarioName = splitArr[0];
         	stepName = splitArr[1];
         	totalNetTime = splitArr[2];
         	stepId = splitArr[3];
         }
         
         String[] baselineResults = testDirName.split(",");
         
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
         	List<StepObj> newStep = new ArrayList<StepObj>();
         	//stepList = CoreUtil.getUniqueStepFromFeature(featureList);
         	newStep = CoreUtil.getStepsByStepNameAndStepId(stepList,
         			stepName, stepId, scenarioName);
         	List<RequestObj> soaListForReport = CoreUtil
         			.getAllSOARequestFromStepList(newStep);
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
            <b>Select SOA(s)</b>
         </div>
         <%
            for (Iterator<String> iterator = soaStringList.iterator(); iterator
            		.hasNext();) {
            	String soaString = (String) iterator.next();
            	String soaTruncString = soaString.substring(soaString
            			.lastIndexOf("/") + 1);
            %>
         <input type="checkbox" name="check_soas_<%=soaString%>"
            id="check_soas_<%=soaString%>" value="<%=soaString%>"><%=soaTruncString%>
         <br>
      </div>
      <%
         }
         %>
   </body>
</html>