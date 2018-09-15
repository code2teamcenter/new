<%@page import="com.siemens.xmlsearch.util.CoreUtil"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.io.File"%>
<%@page import="com.siemens.xmlsearch.util.PropertiesUtil"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
   pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
   <head></head>
   <body>
      <%
         String currBaseline = request.getParameter("currBaseline");
         String release_type = request.getParameter("release_type");
                  final Logger LOGGER = Logger.getLogger(this.getClass());
                  String configFilePath = "/WEB-INF/properties/config.properties";
                  String resultLoc = PropertiesUtil.readProperty(
                  	     		getServletContext().getResourceAsStream(configFilePath),
                  	     		"resultLoc");
                  File resFile = new File(resultLoc);
                  String[] list = resFile.list();
                  List<String> allBaselinesAndBackup = Arrays.asList(list);
                  List<String> baselineList = new ArrayList<String>();
                  List<String> baselineListWithPath = new ArrayList<String>();
                  
                  // remove backup baselines form list
                  //filter baseliens results from other that selected baselines
                  for (int i = allBaselinesAndBackup.size() - 1; i >= 0; i--) {
                  	if (!allBaselinesAndBackup.get(i).contains("backup") && allBaselinesAndBackup.get(i).contains(release_type)) {
                  baselineList.add(allBaselinesAndBackup.get(i));
                  	}
                  }
                  // sort the list by name
                  Collections.sort(baselineList);
                  // reverse order so that latest appears first
                  Collections.reverse(baselineList);
                  
                  LOGGER.info("Configured Baseline list: ");
                  // sorted list by name
                  for (String baseline : baselineList) {
                  	String path = resultLoc + File.separator + baseline;
                  	baselineListWithPath.add(path);
                  	LOGGER.info(path);
                  }
                  if(baselineList.size()>0)
                  {
         %>
      <b>Baseline Results: </b>
      <br>
      <%
         }
                  int index=0;
                  ArrayList<File> files = new ArrayList<File>();
                  for (String baseline : baselineList) { 
                 	 
                  	String path = resultLoc + File.separator + baseline;
                  	if(baseline.equalsIgnoreCase(currBaseline))
                  	{
                  		CoreUtil.listTests(path, files);
         %>
      <input type="checkbox" checked disabled id="baseline_res_<%=index%>"
         name="baseline_res_<%=index%>" value="<%=path%>"><%=baseline%>
      <%
         }
                  	else
                  	{
         %>
      <input type="checkbox" id="baseline_res_<%=index%>"
         name="baseline_res_<%=index%>" value="<%=path%>"><%=baseline%>
      <%
         }
                  index++;
                  //only latest 5 baselines to be sown for comparison
                  if(index==5)
                  	break;
                  }
         %>
      <select name="testResultLocs" id="testResultLocs"
         class="select-style wide-test"
         onchange="loadSOAAjax();validateReportForm();" style="display: block;">
         <option value="Select">Select Test</option>
         <%
            for(File testFile : files)
            	         {
            	String name = testFile.getName();
            %>
         <option value="<%=testFile%>"><%=name%></option>
         <%
            }
            %>
      </select>
   </body>
</html>