<%@page import="java.util.List"%>
<%@page import="java.util.Arrays"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="com.siemens.xmlsearch.util.PropertiesUtil"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
   pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
   <body>
      <%
         //logger
         final Logger LOGGER = Logger.getLogger(this.getClass());
         String configFilePath = "/conf/serverconstants.properties";
         
         //read aw release info from config file
         String awPrefixList = PropertiesUtil.readProperty(
         getServletContext().getResourceAsStream(configFilePath),
         "aw.prefix.list");
         
         LOGGER.info("aw prefix list: " + awPrefixList);
         
         //get all the release prefix in list
         String[] awList = awPrefixList.split(",");
         List<String> awPrefList =  Arrays.asList(awList);
         %>
      <select id="release_type" name="release_type" class="select-style wide"
         onchange="populateModuleList();checkform();">
         <option value="Select">Select</option>
         <%
            for(String awPrefix : awPrefList)
            {
            %>
         <option value="<%=awPrefix%>"><%=awPrefix%></option>
         <%
            }
            %>
      </select>
   </body>
</html>