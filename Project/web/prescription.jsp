<%-- 
    Document   : success
    Created on : Mar 23, 2014, 12:25:37 AM
    Author     : slouli
--%>

<%@page import="servlets.QueryServlet"%>
<%@page import="java.util.ArrayList"%>
<%@page import="models.Prescription"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<jsp:useBean id="user" class="models.User" scope="session"/>
<% if (user == null || user.getType() == null || !user.getType().equals("doctor")) {
    response.sendRedirect("home.jsp");
} else { %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="bootstrap-3.1.1-dist/css/bootstrap.min.css" rel="stylesheet" media="screen">
        <link rel="icon" href="resources/favicon.ico"/>
        <title>Prescription List</title>
    </head>
    
    
    <%! ArrayList<Prescription> prescriptionList;%>
    <% prescriptionList = (ArrayList<Prescription>) request.getAttribute("prescriptionList");%>
    
    <body>
        <nav class="navbar navbar-default" role="navigation">
            <div class="container">
                <ul class="nav navbar-nav">
                    <li>
                        <a href="home.jsp">Home</a>
                    </li>
                    <% if (user.getType().equals("financial officer")) { %>
                        <li>
                            <a href="QueryServlet?query=<%= QueryServlet.DOCTORS_BY_FO %>">Doctors</a>
                        </li>
                        <li>
                            <a href="QueryServlet?query=<%= QueryServlet.PATIENTS_BY_FO %>">Patients</a>
                        </li>
                        <li>
                            <a href="QueryServlet?query=<%= QueryServlet.RECORDS_ALL %>">Visitation Records</a>
                        </li>
                    <% } else if (user.getType().equals("doctor")) { %>
                        <li>
                            <a href="QueryServlet?query=<%= QueryServlet.APPOINTMENTS_FOR_DOCTOR %>&doctor_id=<%= user.getId()%>">Schedule</a>
                        </li>
                        <li>
                            <a href="QueryServlet?query=<%= QueryServlet.PATIENTS_BY_DOCTOR %>&doctor_id=<%= user.getId()%>">Patients</a>
                        </li>
                        <li>
                            <a href="QueryServlet?query=<%= QueryServlet.STAFF_QUERY %>&doctor_id=<%= user.getId()%>">Staff Members</a>
                        </li>
                        <li class="active">
                            <a href="QueryServlet?query=<%= QueryServlet.PRESCRIPTIONS_ALL %>">Prescription List</a>
                        </li>
                    <% } else if (user.getType().equals("staff")) { %>
                        <li>
                            <a href="QueryServlet?query=<%= QueryServlet.DOCTORS_QUERY_BY_STAFF %>&staff_id=<%= user.getId()%>">Associated Doctors</a>
                        </li>
                        <li>
                            <a href="QueryServlet?query=<%= QueryServlet.PATIENTS_BY_STAFF %>&staff_id=<%= user.getId()%>">Patients</a>
                        </li>
                    <% } %>
                </ul>
                <ul class="nav navbar-nav navbar-right">
                    <li>
                        <a href="LogoutServlet">Logout</a>
                    </li>
                </ul>
            </div>
        </nav>
        <div class="container">
            <%
                if (prescriptionList != null) {
            %>
            <h2>Prescriptions</h2>
            <form class="form-inline" style="padding-bottom:15px;" role="form" method="post" action="QueryServlet?query=<%= QueryServlet.PRESCRIPTIONS_QUERY %>">
                <div class="form-group">
                    <input class="form-control" placeholder="Prescription Search" type='text' name='prescription_query'/></br>
                </div>
                <div class="form-group">
                    <input class="form-control btn btn-default" type='submit' value='Submit Query'/>
                </div>
            </form>
            
            <table class="table table-striped">
                <tr><th>Name</th><th>Alias</th><th>Descriptions</th></tr>
                <%
                    for (Prescription p : prescriptionList) {
                %>
                <tr>
                    <td><%= p.getName()%></td>
                    <td><%= p.getAlias()%></td>
                    <td><%= p.getDescription()%></td>
                </tr>
                <%
                    }
                %>
            </table>
            <%
                } else {
            %>
            <p>Empty List</p>
            <%
                }
            %>
        </div>
        
    </body>
</html>
<% } %>
