<%@page import="java.io.InputStream"%>
<%@page import="com.siemens.plm.daemon.TestJob"%>
<%@page import="java.util.List"%>
<html data-ng-app="app" data-ng-controller="myCtrl">
   <head>
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <link rel="stylesheet" href="css/bootstrap.min.css">
      <script src="js/jquery.min.js"></script>
      <script src="js/bootstrap.min.js"></script>
      <title>Performance Home Page</title>
      <link rel="stylesheet" type="text/css" href="css\tabstyle.css">
      <!-- <script type="text/javascript"
         src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script> -->
      <script src="js/tab.js"></script>
      <script src="js/angular.min.js"></script>
      <script src="js/angular-filter.min.js"></script>
      <!--Load the AJAX API-->
      <script src="js/loader.js"></script>
      <script src="js/main.js"></script>
      <script src="js/graph.js"></script>
      <link rel="stylesheet" href="css/w3.css">
   </head>
   <body onload="loadReleaseData()">
      <%@ page import="java.util.Properties, java.util.Iterator"%>
      <%@ page
         import="java.io.FileInputStream, java.io.File, java.io.FileFilter"%>
      <%@ page import="com.siemens.plm.commonutil.CommonUtils"%>
      <div class="tabs">
         <ul class="tab-links">
            <li class="active"><a href="#tab1">Run Selenium Tests</a></li>
         </ul>
         <div class="tab-content">
            <div id="tab1" class="tab active">
               <div class="container">
                  <div class="panel-group" id="accordion">
                     <div class="panel panel-default">
                        <div class="panel-heading">
                           <h4 class="panel-title">
                              <a data-toggle="collapse" data-parent="#accordion"
                                 href="#collapse1">Configure and Execute Tests</a>
                           </h4>
                        </div>
                        <div id="collapse1" class="panel-collapse collapse in">
                           <div class="panel-body">
                              <form action="/perf/scheduleTest" method="post"
                                 name="scheduleTestForm">
                                 <div class="testbox">
                                    <!-- <h1>Configuration Details</h1>
                                       <hr> -->
                                    <table class="table-config">
                                       <tr>
                                          <td>Pool Manager URL:</td>
                                          <td>
                                             <input type="text" name="server_url"
                                                id="server_url"
                                                placeholder="Enter Pool Manager URL here..."
                                                value="http://pnv6s1614:7001/awc/" required
                                                class="wide" onchange="checkform()" /> <!-- http://10.134.64.92:7001/awc/, http://10.134.64.60:7001/awc/, http://pnv6s830:7001/awc/ http://10.134.210.47:7001/awc/-->
                                          </td>
                                       </tr>
                                       <tr>
                                          <td>User Type</td>
                                          <td>
                                             <!-- <div class="accounttype"> --> <input type="radio"
                                                value="single" id="radioOne" name="scenario" checked
                                                onClick="disableUserCountDropDowns()" /> <label
                                                for="radioOne" onClick="disableUserCountDropDowns()"
                                                class="radio">Single User</label> <input type="radio"
                                                value="multiple" id="radioTwo" name="scenario"
                                                onClick="enableUserCountDropDowns()" /> <label
                                                for="radioTwo" onClick="enableUserCountDropDowns()"
                                                class="radio">Multi-User</label> <!-- </div> -->
                                          </td>
                                       </tr>
                                       <tr>
                                          <td>
                                             <div id="testTypeStr">Test Type:</div>
                                          </td>
                                          <td>
                                             <div id="testTypeInp">
                                                <select name="testType" id="testType"
                                                   class="select-style wide">
                                                   <option value="Threshold" selected>Benchmark
                                                      Test
                                                   </option>
                                                   <option value="Stress">Continuous Test</option>
                                                   <option value="Soak">Soak Test</option>
                                                </select>
                                             </div>
                                          </td>
                                       </tr>
                                       <tr>
                                          <td>Select Release:</td>
                                          <td>
                                             <div id="select_release_type">
                                                <select id="release_type" name="release_type"
                                                   class="select-style wide"
                                                   onchange="populateModuleList();checkform();">
                                                   <option value="Select">Select</option>
                                                   <!-- <option value="aw3.1">aw3.1</option> -->
                                                   <option value="aw3.2">aw3.2</option>
                                                   <!-- <option value="aw3.3">aw3.3</option> -->
                                                </select>
                                             </div>
                                             <div align="right" id="baseline_id_div"
                                                style="font-weight: bold"></div>
                                          </td>
                                       </tr>
                                       <tr>
                                          <td>Select Module:</td>
                                          <td>
                                             <select id="module_name" name="module_name"
                                                onchange="getFeatureListAjax();checkform()"
                                                class="select-style wide">
                                                <option value="Select">Select</option>
                                             </select>
                                          </td>
                                       </tr>
                                    </table>
                                 </div>
                                 <div id="featureFileList"></div>
                                 <button type="button" class="disabled-button"
                                    name="btn_execute_test" id="btn_execute_test" disabled
                                    data-ng-click="scheduleTests()">Execute Tests</button>
                              </form>
                           </div>
                        </div>
                     </div>
                     <div class="panel panel-default">
                        <div class="panel-heading">
                           <h4 class="panel-title">
                              <a data-toggle="collapse" data-parent="#accordion"
                                 href="#collapse2">View Graph and Export</a>
                           </h4>
                        </div>
                        <div id="collapse2" class="panel-collapse collapse">
                           <div class="panel-body">
                              <form name="reportForm" onload="validateReportForm();">
                                 <div id="baselines_checkbox">
                                    <select name="testResultLocs" id="testResultLocs"
                                       class="select-style wide-test"
                                       onchange="loadSOAAjax();validateReportForm();"
                                       style="display: block;">
                                       <option value="Select">Select Test</option>
                                    </select>
                                 </div>
                                 <div id="soaStrList"></div>
                                 <div id="soaList"></div>
                                 <button onclick="generateGraphServletAjax()"
                                    class="disabled-button" id="view_graph">View Graph</button>
                                 <button onclick="exportDataAjax()" class="disabled-button"
                                    id="export_data">Export All Results</button>
                                 <button onclick="exportDataForSingleTestAjax()" class="button"
                                    id="export_data_single">Export Test Result</button>
                              </form>
                              <div id="chart_div_step_chart"></div>
                              <div id="chart_div_column_chart"></div>
                           </div>
                        </div>
                     </div>
                  </div>
               </div>
            </div>
         </div>
      </div>
   </body>
</html>