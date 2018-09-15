<%@page import="java.io.File"%>
<%@page import="java.io.InputStream"%>
<%@page import="com.siemens.plm.commonutil.CommonUtils"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
   pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
   <head>
      <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
      <title>available baselines</title>
   </head>
   <body>
      <%
         String releaseType = null;
         String configFilePath = "conf/serverconstants.properties";
         InputStream fileInputStream = getServletContext()
         		.getResourceAsStream(configFilePath);
         
         releaseType = request.getParameter("release_type");
         String baselineName = null;
         
         if (null != releaseType && !releaseType.equalsIgnoreCase("Select")) {
         
         	String refUnit = CommonUtils.getRefUnitForReleseType(
         			releaseType, fileInputStream);
         	baselineName = refUnit.substring(refUnit
         			.lastIndexOf(File.separator) + 1);
         
         }
         %>
      <%-- <div align="right" id="baseline_id" value="<%=baselineName%>"><%=baselineName%></div> --%>
      <form action="">
         <input id="baseline_id" disabled="disabled" value="<%=baselineName%>" style="background-color: white; border: none; text-align: right;">
      </form>
   </body>
</html>