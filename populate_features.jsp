<%@page import="java.io.InputStream"%>
<%@page import="java.util.Properties"%>
<%@page import="com.siemens.plm.commonutil.CommonUtils"%>
<%@page import="java.io.File"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
   pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
   <head>
      <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
      <title>Feature List - multiuser</title>
   </head>
   <body>
      <%
         Properties p = new Properties();
         InputStream in = getClass().getClassLoader().getResourceAsStream(
         		"conf\\userconfig.properties");
         p.load(in);
         		
         %>
      <%
         String testDirName;
         testDirName = request.getParameter("module_name");
         if (testDirName == null) {
         	testDirName = "4GBOM AW";
         }
         File[] featureFiles = CommonUtils.getTestFiles(testDirName);
         String basePath = "abc";
         %>
      <input type="text" hidden="true" id="base_dir" name="base_dir"
         value="<%=testDirName%>" />
      <div style="overflow-y: scroll; height: 350px; ">
         <table class="table-config">
            <tr>
               <th>&nbsp;</th>
               <th>Tests</th>
               <th>Number of Users</th>
               <th>Test Type</th>
               <th>Status</th>
            </tr>
            <%
               for (int i = 0; i < featureFiles.length; i++) {
               	if (featureFiles[i].getAbsolutePath().contains("performance")) {
               		String test_info = featureFiles[i].getName();
               		String test_abs_path = featureFiles[i].getAbsolutePath();
               
               		//display the test type
               		String testTypeToBeDisplayed = "Performance_tests";
               %>
            <tr>
               <td><input type="checkbox"
                  name="singleUserCheckBox_<%=test_abs_path%>" id="<%=test_info%>" /></td>
               <td><%=test_info%></td>
               <td>
                  <select name="userCount_<%=test_abs_path%>"
                     id="<%=featureFiles[i].getName()%>" class="select-style" onchange="checkform()">
                     <%
                        for (int j = 0; j <= p.stringPropertyNames().size(); j++) {
                        %>
                     <option value=<%=j%>>
                        &nbsp;<%=j%>&nbsp;
                     </option>
                     <%
                        }
                        %>
                  </select>
               </td>
               <td><%=testTypeToBeDisplayed%></td>
               <td id=<%="status_" + test_abs_path%> name="statusCell">&nbsp;</td>
            </tr>
            <%
               }
               }
               %>
         </table>
      </div>
   </body>
</html>