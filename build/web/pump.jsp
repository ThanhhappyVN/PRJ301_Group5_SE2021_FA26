<%-- 
    Document   : pump
    Created on : Oct 13, 2026, 2:56:52 PM
    Author     : DatNuoc
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Pumps</title>
        <style>body {
                font-family:Arial;
                background:#f3f5f8;
                margin:28px;
                color:#182230
            }
            h1 {
                margin-bottom:8px
            }
            a,button {
                background:#2864ee;
                color:white;
                padding:9px 14px;
                border:0;
                border-radius:5px;
                text-decoration:none;
                cursor:pointer
            }
            input,select,textarea {
                padding:8px;
                border:1px solid #ccd3dd;
                border-radius:4px;
                margin:4px
            }
            table {
                width:100%;
                border-collapse:collapse;
                background:white;
                margin-top:20px
            }
            th,td {
                padding:10px;
                border-bottom:1px solid #e4e8ee;
                text-align:left;
                vertical-align:top
            }
            th {
                background:#e9eef6
            }
            .form {
                background:white;
                padding:16px;
                border-radius:8px;
                margin:16px 0
            }
            .back {
                background:#596579
            }
        </style>
    </head>
    <body>
        <h1>Pumps</h1>
        <p>Manage pump information and operating status.</p>
        <a class="back" href="dashboard.jsp">Dashboard</a>
        <div class="form">
            <h3>Add pump</h3>
            <% if (request.getAttribute("error") != null) {%>
            <div style="color: #b91c1c;
                 background: #fee2e2;
                 padding: 12px;
                 border-radius: 5px;
                 margin-bottom: 12px;">
                <%= request.getAttribute("error")%>
            </div>
            <% } %>
            <form method="post" action="PumpController">
                <input name="pumpCode" placeholder="Pump code" required>
                <input name="pumpName" placeholder="Pump name" required>
                <input name="model" placeholder="Model">
                <select name="systemId" required>
                    <option value="">Choose pump system</option>
                    <% java.util.List<String[]> systems = (java.util.List<String[]>) request.getAttribute("systems");
                        for (String[] s : systems) {%>
                    <option value="<%=s[0]%>">
                        <%=s[1]%>
                    </option>
                    <% } %>
                </select>
                <select name="status">
                    <option>ACTIVE</option>
                    <option>INACTIVE</option>
                    <option>MAINTENANCE</option>
                </select>
                <button type="submit">Save pump</button>
            </form>
        </div>
        <table>
            <tr>
                <th>ID</th>
                <th>Code</th>
                <th>Name</th>
                <th>Model</th>
                <th>System ID</th>
                <th>Status</th>
                <th>Actions</th>
            </tr>
            <% java.util.List<dto.Pump> pumps = (java.util.List<dto.Pump>) request.getAttribute("pumps");
                for (dto.Pump x : pumps) {%>
            <tr>
            <form method="post" action="PumpController">
                <td>
                    <%=x.getPumpId()%>
                    <input type="hidden" name="pumpId" value="<%=x.getPumpId()%>">
                </td>
                <td>
                    <input name="pumpCode" value="<%=x.getPumpCode()%>" required>
                </td>
                <td>
                    <input name="pumpName" value="<%=x.getPumpName()%>" required>
                </td>
                <td>
                    <input name="model" value="<%=x.getModel() == null ? "" : x.getModel()%>">
                </td>
                <td>
                    <select name="systemId">
                        <% for (String[] z : systems) {%>
                        <option value="<%=z[0]%>" <%=Integer.parseInt(z[0]) == x.getSystemId() ? "selected" : ""%>>
                            <%=z[1]%>
                        </option>
                        <% }%>
                    </select>
                </td>
                <td>
                    <select name="status">
                        <option <%= "ACTIVE".equals(x.getStatus()) ? "selected" : ""%>>ACTIVE</option>
                        <option <%= "INACTIVE".equals(x.getStatus()) ? "selected" : ""%>>INACTIVE</option>
                        <option <%= "MAINTENANCE".equals(x.getStatus()) ? "selected" : ""%>>MAINTENANCE</option>
                    </select>
                </td>
                <td>
                    <button>Update</button> <a href="PumpController?action=delete&id=<%=x.getPumpId()%>" onclick="return confirm('Delete this pump?')">Delete</a>
                </td>
            </form>
        </tr>
        <% }%>
    </table>
</body>
</html>
