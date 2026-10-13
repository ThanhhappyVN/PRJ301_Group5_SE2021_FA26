<%-- 
    Document   : dashboard
    Created on : Sep 25, 2026, 10:55:00 PM
    Author     : DatNuoc
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dto.User"%>

<%
    User loginUser = (User) session.getAttribute("LOGIN_USER");

    if (loginUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Pump and Valve Monitoring - Dashboard</title>

    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f4f6f9;
        }

        .header {
            background: #1f2937;
            color: white;
            padding: 18px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header h2 {
            margin: 0;
        }

        .user-info {
            text-align: right;
        }

        .container {
            padding: 30px;
        }

        .welcome {
            margin-bottom: 25px;
        }

        .welcome h1 {
            margin-bottom: 8px;
        }

        .menu {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
        }

        .card {
            background: white;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .card h3 {
            margin-top: 0;
        }

        .card p {
            color: #666;
            min-height: 40px;
        }

        .button {
            display: inline-block;
            padding: 10px 16px;
            background: #2563eb;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }

        .button:hover {
            background: #1d4ed8;
        }

        .logout {
            background: #dc2626;
        }

        .logout:hover {
            background: #b91c1c;
        }
    </style>
</head>

<body>

<div class="header">

    <h2>Pump and Valve Monitoring</h2>

    <div class="user-info">
        <div>
            <strong><%= loginUser.getFullName() %></strong>
        </div>

        <div>
            Role: <%= loginUser.getRoleName() %>
        </div>

        <div style="margin-top: 8px;">
            <a class="button logout"
               href="<%= request.getContextPath() %>/LogoutController">
                Logout
            </a>
        </div>
    </div>

</div>

<div class="container">

    <div class="welcome">
        <h1>Dashboard</h1>
        <p>
            Monitor pump systems, pumps, valves, alerts and maintenance activities.
        </p>
    </div>

    <div class="menu">

        <div class="card">
            <h3>Pump Systems</h3>
            <p>Manage pump system information.</p>
            <a class="button" href="<%= request.getContextPath() %>/PumpSystemController">
                Manage
            </a>
        </div>

        <div class="card">
            <h3>Pumps</h3>
            <p>Manage pump information and operating status.</p>
            <a class="button" href="<%= request.getContextPath() %>/PumpController">
                Manage
            </a>
        </div>

        <div class="card">
            <h3>Valves</h3>
            <p>Manage valves and valve operating information.</p>
            <a class="button"
               href="<%= request.getContextPath() %>/ValveController?action=list">
                Manage
            </a>
        </div>

        <div class="card">
            <h3>Pump Runs</h3>
            <p>View pump running data and sensor readings.</p>
            <a class="button" href="<%= request.getContextPath() %>/PumpRunController">
                View
            </a>
        </div>

        <div class="card">
            <h3>Alerts</h3>
            <p>View abnormal conditions and alert evidence.</p>
            <a class="button" href="<%= request.getContextPath() %>/AlertController">
                View
            </a>
        </div>

        <div class="card">
            <h3>Maintenance Tickets</h3>
            <p>Create and manage maintenance tickets.</p>
            <a class="button" href="<%= request.getContextPath() %>/MaintenanceTicketController">
                Manage
            </a>
        </div>

        <div class="card">
            <h3>Fault Scenarios</h3>
            <p>Manage fault scenarios and anomaly labels.</p>
            <a class="button" href="<%= request.getContextPath() %>/FaultScenarioController">
                Manage
            </a>
        </div>
<% if ("ADMIN".equalsIgnoreCase(loginUser.getRoleName())) { %>
        <div class="card">
            <h3>Users</h3>
            <p>Manage system users and roles.</p>
            <a class="button" href="<%= request.getContextPath() %>/UserController">
                Manage
            </a>
        </div>
<% } %>
        <div class="card">
            <h3>Audit Logs</h3>
            <p>Review system activities and audit records.</p>
            <a class="button" href="<%= request.getContextPath() %>/AuditController">
                View
            </a>
        </div>

    </div>

</div>

</body>
</html>