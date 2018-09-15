<%@page import="java.io.InputStream"%>
<%@page import="com.siemens.plm.commonutil.CommonUtils"%>
<%@ page
   import="java.io.FileInputStream, java.io.File, java.io.FileFilter"%>
<html>
   <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
      <title>Module List</title>
   </head>
   <body>
      <%
         String releaseType = null;
         File[] files = null;
         %>
      <div id="folder_selection_for_feature_run">
         <div>
            <select id="module_name" name="module_name" class="select-style wide"
               onchange="getFeatureListAjax()">
               <option value="Select">Select</option>
               <%
                  String configFilePath = "conf/serverconstants.properties";
                  InputStream fileInputStream = getServletContext()
                  		.getResourceAsStream(configFilePath);
                  String conf = "/WEB-INF/properties/config.properties";
                  InputStream fis = getServletContext().getResourceAsStream(conf);
                  
                  releaseType = request.getParameter("release_type");
                  if (null != releaseType && !releaseType.equalsIgnoreCase("Select")) {
                  	files = CommonUtils.getModuleforPerformance(releaseType,
                  			fileInputStream, fis);
                  	for (int i = 0; i < files.length; i++) {
                  		String fileNm = files[i].getName();
                  		String absPath = files[i].getAbsolutePath();
                  %>
               <option value="featureCheck_<%=absPath%>"
                  id="featureCheck_<%=absPath%>">
                  <%=fileNm%>
               </option>
               <%
                  }
                  }
                  %>
            </select>
         </div>
      </div>
   </body>
</html>