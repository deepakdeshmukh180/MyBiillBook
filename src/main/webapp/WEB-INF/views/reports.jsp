<!DOCTYPE html>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
   <head>
      <title>AdminLTE | Dashboard</title>
      <!-- bootstrap 3.0.2 -->
      <link
         href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css"
         rel="stylesheet" type="text/css" />
      <!-- font Awesome -->
      <link
         href="${pageContext.request.contextPath}/resources/css/font-awesome.min.css"
         rel="stylesheet" type="text/css" />
      <!-- Ionicons -->
      <link
         href="${pageContext.request.contextPath}/resources/css/ionicons.min.css"
         rel="stylesheet" type="text/css" />
      <!-- Morris chart -->
      <link
         href="${pageContext.request.contextPath}/resources/css/morris/morris.css"
         rel="stylesheet" type="text/css" />
      <!-- jvectormap -->
      <link
         href="${pageContext.request.contextPath}/resources/css/jvectormap/jquery-jvectormap-1.2.2.css"
         rel="stylesheet" type="text/css" />
      <!-- fullCalendar -->
      <link
         href="${pageContext.request.contextPath}/resources/css/fullcalendar/fullcalendar.css"
         rel="stylesheet" type="text/css" />
      <!-- Daterange picker -->
      <link
         href="${pageContext.request.contextPath}/resources/css/daterangepicker/daterangepicker-bs3.css"
         rel="stylesheet" type="text/css" />
      <!-- bootstrap wysihtml5 - text editor -->
      <link
         href="${pageContext.request.contextPath}/resources/css/bootstrap-wysihtml5/bootstrap3-wysihtml5.min.css"
         rel="stylesheet" type="text/css" />
      <!-- Theme style -->
      <link
         href="${pageContext.request.contextPath}/resources/css/AdminLTE.css"
         rel="stylesheet" type="text/css" />
      <link
         href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css"
         rel="stylesheet" type="text/css" />
      <!-- font Awesome -->
      <link
         href="${pageContext.request.contextPath}/resources/css/font-awesome.min.css"
         rel="stylesheet" type="text/css" />
      <!-- Ionicons -->
      <link
         href="${pageContext.request.contextPath}/resources/css/ionicons.min.css"
         rel="stylesheet" type="text/css" />
      <!-- DATA TABLES -->
      <link
         href="${pageContext.request.contextPath}/resources/css/datatables/dataTables.bootstrap.css"
         rel="stylesheet" type="text/css" />
      <!-- Theme style -->
      <link
         href="${pageContext.request.contextPath}/resources/css/AdminLTE.css"
         rel="stylesheet" type="text/css" />
      <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
      <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
      <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
      <script src="https://oss.maxcdn.com/libs/respond.${pageContext.request.contextPath}/resources/js/1.3.0/respond.min.js"></script>
      <![endif]-->

         <script src=
      "https://cdn.jsdelivr.net/npm/html2canvas@1.0.0-rc.5/dist/html2canvas.min.js">
          </script>

          <!-- Include locally otherwise -->
          <!-- <script src='html2canvas.js'></script> -->

          <style>
              #photo {
                  border: 4px solid green;
                  padding: 4px;
              }
          </style>
      <style type="text/css">
               // solution 1:
               .datepicker {
               font-size: 0.875em;
               }
               /* solution 2: the original datepicker use 20px so replace with the following:*/
               .datepicker td, .datepicker th {
               width: 1.5em;
               height: 1.5em;
               }

                thead {
                                  background-color: lightsteelblue;
                                 }


                        h1,
                        h3 {
                            text-align: center;
                            color: green;
                        }

                        table {
                            width: 100%;
                            border-collapse: collapse;
                        }

                        th,
                        td {
                            padding: 1px;
                            text-align: center;
                            border-bottom: 1px solid black;
                        }

                        tr:hover {
                            background-color: rgb(205, 243, 187);
                        }



               * {box-sizing: border-box}
               body {font-family: "Lato", sans-serif;}

               /* Style the tab */
               .tab {
                 float: left;
                 border: 1px solid #ccc;
                 background-color: #f1f1f1;
                 width: 17%;
                 height: 740px;
               }



               /* Style the buttons inside the tab */
               .tab button {
                 display: block;
                 background-color: aliceblue;
                 color: black;
                 padding: 22px 16px;
                 width: 100%;
                 border: none;
                 outline: none;
                 text-align: left;
                 cursor: pointer;
                 transition: 0.3s;
                 font-size: 17px;
               }
      table {
        font-family: sans-serif;
        border-collapse: collapse;
        max-height: 420px;
        overflow: auto;
      }

.btn {
  border: 2px solid black;
  background-color: white;
  color: black;

  cursor: pointer;
}

/* Green */
.success {
  border-color: #04AA6D;
  color: green;
}

.success:hover {
  background-color: #04AA6D;
  color: white;
}

/* Blue */
.info {
  border-color: #2196F3;
  color: dodgerblue;
}

.info:hover {
  background: #2196F3;
  color: white;
}

/* Orange */
.warning {
  border-color: #ff9800;
  color: orange;
}

.warning:hover {
  background: #ff9800;
  color: white;
}

/* Red */
.danger {
  border-color: #f44336;
  color: red;
}

.danger:hover {
  background: #f44336;
  color: white;
}

/* Gray */
.default {
  border-color: #e7e7e7;
  color: black;
}

.default:hover {
  background: #e7e7e7;
}







.amountfield{
    text-align: right;
    font-weight: bold;
}



               /* Change background color of buttons on hover */
               .tab button:hover {
                 background-color: #ddd;
               }

               /* Create an active/current "tab button" class */
               .tab button.active {
                 background-color: lightsteelblue;
               }

               /* Style the tab content */
               .tabcontent {
                 float: left;
                 padding: 0px 12px;
                 border: 1px solid #ccc;
                 width: 79%;
                 border-left: none;
                 height: 740px;
               }

            </style>
      <script type="text/javascript">
         $('.datepicker').datepicker({
             weekStart: 1,
             daysOfWeekHighlighted: "6,0",
             autoclose: true,
             todayHighlight: true,
         });
         $('.datepicker').datepicker("setDate", new Date());
      </script>
   </head>
   <body style="font-size:small">
      <c:if test="${pageContext.request.userPrincipal.name != null}">
         <!-- Content Header (Page header) -->
         <section class="content-header">
            <h1>
               Reports <small>View/Download Reports</small>
            </h1>
            <form id="logoutForm" method="POST" action="${pageContext.request.contextPath}/logout">
               <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            </form>
            <h4 style="
               margin-left: 76%;
               margin-top: -2%;
               ">Welcome ${pageContext.request.userPrincipal.name} | <a onclick="document.forms['logoutForm'].submit()">Logout</a></h4>
            <ol class="breadcrumb">
               <li><a href="${pageContext.request.contextPath}/login/home"><i
                  class="fa fa-dashboard"></i> Home</a></li>
               <li class="active">Invoices</li>
            </ol>
<div class="row myform" style=" margin-top: -1%; margin-bottom: 1%; ">
                  <form action="${pageContext.request.contextPath}/company/reportbydate"
                     method="post" modelAttribute="DATERANGE" role="form" novalidate>
                     <div class="row justify-content-center">
                        <div class="col-lg-2"></div>
                        <div class="col-lg-3">
                           <label for="startDate">Start</label>
                           <input id="startDate" name="startDate" value="${startDate}" class="form-control" type="date" />
                        </div>
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <div class="col-lg-3">
                           <label for="endDate">End</label>
                           <input id="startDate" name="endDate" value="${endDate}" class="form-control" type="date" />
                        </div>
                        <div class="col-lg-1">
                           <label for="startDate">Search</label>
                           <button class="btn btn-success form-control" type="submit">Search</button>
                        </div>
                        <div class="col-lg-1">
                           <label for="startDate">Download PDF</label>
                           <button class="btn btn-warning form-control" type="button">Download</button>
                        </div>
                     </div>
                  </form>
               </div>
            <div class="tab">
              <button class="tablinks" onclick="openCity(event, 'London')" id="defaultOpen">Invoices History</button>
              <button class="tablinks" onclick="openCity(event, 'Paris')">Transactions History</button>

            </div>

            <div id="London" class="tabcontent">


              <table id="example" class="table table-bordered table-striped ">
                                         <thead>
                                            <tr>
                                               <th >Invoice No</th>
                                               <th >Customer Name</th>
                                               <th>Products</th>

                                               <th>Invoice Amt</th>
                                               <th >Paid Amt</th>
                                               <th >Closing Amt</th>
                                               <th >Date</th>
                                            </tr>
                                         </thead>
                                         <tbody class="ScrollStyle">
                                            <c:forEach items="${Invoices}" var="custmer">
                                               <tr>
                                                  <td>${custmer.invoiceId}</td>
                                                  <td style="text-align: left;">${custmer.custName}</td>
                                                  <td style="text-align: left;">${custmer.itemDetails}</td>

                                                  <td class="amountfield">${custmer.totInvoiceAmt}</td>
                                                  <td class="amountfield">${custmer.advanAmt}</td>
                                                  <td class="amountfield">${custmer.balanceAmt}</td>
                                                  <td>${custmer.date}</td>
                                               </tr>
                                            </c:forEach>
                                            </tfoot>
                                      </table>

                                      <div class="row myform" style="overflow-x:auto;margin-left:3%">

                                                     <form>

                                                      <div class="col-md-3 form-group">
                                                                                                                <label class="control-label" for="fullName">Date between </label>
                                                                                                                <input required type="text" readonly="true" class="form-control" value="${invoicetotal.date}"/>
                                                                                                             </div>
                                                        <div class="col-md-3 form-group">
                                                           <label class="control-label" for="fullName">Total Invoice Amount</label>
                                                           <input required type="text" readonly="true" class="form-control" value="${invoicetotal.totInvoiceAmt}"/>
                                                        </div>


                                                           <div class=" col-md-3 form-group">
                                                              <label>Total Paid Amount</label>
                                                              <input  type="text"  readonly="true" value="${invoicetotal.advanAmt}" class="form-control" />
                                                           </div>

                                                        <div class="col-md-3  form-group">
                                                           <label class="control-label" for="phoneNo">Total Closing Amount</label>
                                                           <input required type="text" readonly="true" class="form-control" value="${invoicetotal.balanceAmt}"/>
                                                        </div>



                                                     </form>

                                               </div>


            </div>

            <div id="Paris" class="tabcontent">



                                   <table id="example1" class="table table-bordered table-striped">
                                      <thead>
                                         <th style="
                                                 width: 0%;
                                             " >Transaction Id</th>
                                         <th>Customer Name</th>
                                         <th>Description</th>
                                         <th >Closing Amt</th>
                                         <th >Payment Mode</th>
                                         <th >Deposited Amt</th>
                                          <th>Created By </th>
                                         <th >Date </th>
                                      </thead>
                                      <tbody>
                                         <c:forEach items="${transactions}" var="balanceDeposit">
                                            <tr>
                                               <td style="
                                                       width: 0%;
                                                   ">${balanceDeposit.id}</td>
                                               <td>${balanceDeposit.custName}</td>
                                               <td>${balanceDeposit.description}</td>
                                               <td class="amountfield">${balanceDeposit.currentOusting}</td>
                                               <td>${balanceDeposit.modeOfPayment}</td>
                                               <td class="amountfield">${balanceDeposit.advAmt}</td>
                                               <td>${balanceDeposit.createdBy}</td>
                                               <td>${balanceDeposit.createdAt}</td>
                                               </td>
                                            </tr>
                                         </c:forEach>
                                         </tfoot>
                                   </table>
            </div>

            <div id="Tokyo" class="tabcontent">
              <h3>Tokyo</h3>
            <label>Choose a browser from this list:
            <input list="browsers" name="myBrowser" /></label>
            <datalist id="browsers">
              <option value="Chrome">
              <option value="Firefox">
              <option value="Internet Explorer">
              <option value="Opera">
              <option value="Safari">
              <option value="Microsoft Edge">
            </datalist>

            <body>
                <div id="photo">
                    <h1>GeeksforGeeks</h1>
                    Hello everyone! This is a
                    trial page for taking a
                    screenshot.
                    <br><br>
                    This is a dummy button!
                    <button> Dummy</button>
                    <br><br>
                    Click the button below to
                    take a screenshot of the div.
                    <br><br>

                    <!-- Define the button
                    that will be used to
                    take the screenshot -->

                </div>
                <h1>Screenshot:</h1>
                <div id="output"></div>

                <script type="text/javascript">

                    // Define the function
                    // to screenshot the div
                    function takeshot() {
                        let div =
                            document.getElementById('London');

                        // Use the html2canvas
                        // function to take a screenshot
                        // and append it
                        // to the output div
                        html2canvas(div).then(

                            function (canvas) {
                                document
                                .getElementById('output')
                                .appendChild(canvas);
                                console.log(canvas.toDataURL());

                            })
                    }
                </script>
            </body>
            </div>

            <script>
            function openCity(evt, cityName) {
              var i, tabcontent, tablinks;
              tabcontent = document.getElementsByClassName("tabcontent");
              for (i = 0; i < tabcontent.length; i++) {
                tabcontent[i].style.display = "none";
              }
              tablinks = document.getElementsByClassName("tablinks");
              for (i = 0; i < tablinks.length; i++) {
                tablinks[i].className = tablinks[i].className.replace(" active", "");
              }
              document.getElementById(cityName).style.display = "block";
              evt.currentTarget.className += " active";
            }

            // Get the element with id="defaultOpen" and click on it
            document.getElementById("defaultOpen").click();
            </script>

         </section>
         <!-- jQuery 2.0.2 -->
         <script
            src="http://ajax.googleapis.com/ajax/libs/jquery/2.0.2/jquery.min.js"></script>
         <!-- jQuery UI 1.10.3 -->
         <script
            src="${pageContext.request.contextPath}/resources/js/jquery-ui-1.10.3.min.js"
            type="text/javascript"></script>
         <!-- Bootstrap -->
         <script
            src="${pageContext.request.contextPath}/resources/js/bootstrap.min.js"
            type="text/javascript"></script>
         <!-- Morris.js charts -->
         <script
            src="//cdnjs.cloudflare.com/ajax/libs/raphael/2.1.0/raphael-min.js"></script>
         <script
            src="${pageContext.request.contextPath}/resources/js/plugins/morris/morris.min.js"
            type="text/javascript"></script>
         <!-- Sparkline -->
         <script
            src="${pageContext.request.contextPath}/resources/js/plugins/sparkline/jquery.sparkline.min.js"
            type="text/javascript"></script>
         <!-- jvectormap -->
         <script
            src="${pageContext.request.contextPath}/resources/js/plugins/jvectormap/jquery-jvectormap-1.2.2.min.js"
            type="text/javascript"></script>
         <script
            src="${pageContext.request.contextPath}/resources/js/plugins/jvectormap/jquery-jvectormap-world-mill-en.js"
            type="text/javascript"></script>
         <!-- fullCalendar -->
         <script
            src="${pageContext.request.contextPath}/resources/js/plugins/fullcalendar/fullcalendar.min.js"
            type="text/javascript"></script>
         <!-- jQuery Knob Chart -->
         <script
            src="${pageContext.request.contextPath}/resources/js/plugins/jqueryKnob/jquery.knob.js"
            type="text/javascript"></script>
         <!-- daterangepicker -->
         <script
            src="${pageContext.request.contextPath}/resources/js/plugins/daterangepicker/daterangepicker.js"
            type="text/javascript"></script>
         <!-- Bootstrap WYSIHTML5 -->
         <script
            src="${pageContext.request.contextPath}/resources/js/plugins/bootstrap-wysihtml5/bootstrap3-wysihtml5.all.min.js"
            type="text/javascript"></script>
         <!-- iCheck -->
         <script
            src="${pageContext.request.contextPath}/resources/js/plugins/iCheck/icheck.min.js"
            type="text/javascript"></script>
         <!-- AdminLTE App -->
         <script
            src="${pageContext.request.contextPath}/resources/js/AdminLTE/app.js"
            type="text/javascript"></script>
         <!-- AdminLTE dashboard demo (This is only for demo purposes) -->
         <!-- AdminLTE for demo purposes -->
         <script
            src="${pageContext.request.contextPath}/resources/js/AdminLTE/demo.js"
            type="text/javascript"></script>
         <!-- jQuery 2.0.2 -->
         <script
            src="http://ajax.googleapis.com/ajax/libs/jquery/2.0.2/jquery.min.js"></script>
         <!-- Bootstrap -->
         <script
            src="${pageContext.request.contextPath}/resources/js/bootstrap.min.js"
            type="text/javascript"></script>
         <!-- DATA TABES SCRIPT -->
         <script
            src="${pageContext.request.contextPath}/resources/js/plugins/datatables/jquery.dataTables.js"
            type="text/javascript"></script>
         <script
            src="${pageContext.request.contextPath}/resources/js/plugins/datatables/dataTables.bootstrap.js"
            type="text/javascript"></script>
         <!-- AdminLTE App -->
         <script
            src="${pageContext.request.contextPath}/resources/js/AdminLTE/app.js"
            type="text/javascript"></script>
         <!-- AdminLTE for demo purposes -->
         <script
            src="${pageContext.request.contextPath}/resources/js/AdminLTE/demo.js"
            type="text/javascript"></script>
         <!-- page script -->
         <script type="text/javascript">
            $(function() {
            	$("#example1").dataTable({


            	});
            });

            $(function() {
                  			$("#example").dataTable({

                  				 lengthMenu: [ [4, 10, 25, 50, -1], [4, 10, 25, 50, "All"] ],
                                      pageLength: 4
                  			});
                  		});


            $('document').ready(function(){

            var now = new Date();

              var day = ("0" + now.getDate()).slice(-2);
              var month = ("0" + (now.getMonth() + 1)).slice(-2);

              var today = now.getFullYear()+"-"+(month)+"-"+(day) ;


             $('.datePicker').val(today);

            });
         </script>
      </c:if>
   </body>
</html>