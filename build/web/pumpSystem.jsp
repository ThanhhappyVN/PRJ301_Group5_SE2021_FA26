<%-- 
    Document   : pumpSystem
    Created on : Oct 7, 2026, 10:31:50 AM
    Author     : DatNuoc
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="dto.PumpSystem"%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Pump System Management</title>

        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 30px;
            }

            h1 {
                margin-bottom: 20px;
            }

            table {
                border-collapse: collapse;
                width: 100%;
                margin-top: 20px;
            }

            th, td {
                border: 1px solid #ccc;
                padding: 10px;
                text-align: center;
            }

            th {
                background-color: #f2f2f2;
            }

            input, select {
                padding: 7px;
                margin: 5px;
            }

            button {
                padding: 7px 12px;
                cursor: pointer;
            }

            a {
                text-decoration: none;
                margin: 0 5px;
            }

            .error {
                color: red;
                margin: 10px 0;
            }

            .pagination {
                margin-top: 20px;
                text-align: center;
            }

            .pagination a {
                border: 1px solid #ccc;
                padding: 6px 10px;
            }

            .pagination a.active {
                background-color: #ddd;
                font-weight: bold;
            }
        </style>
    </head>

    <body>
        <h1>Pump System Management</h1>
        <a href="dashboard.jsp">Dashboard</a>
        <%
            String error = (String) request.getAttribute("ERROR");
            if (error != null) {
        %>
        <div class="error"><%= error%></div>
        <%
            }

            String keyword = (String) request.getAttribute("KEYWORD");

            if (keyword == null) {
                keyword = "";
            }

            List<PumpSystem> list
                    = (List<PumpSystem>) request.getAttribute("LIST_PUMP_SYSTEM");
            PumpSystem editSystem
                    = (PumpSystem) request.getAttribute("PUMP_SYSTEM");
        %>


        <!-- SEARCH -->
        <form action="PumpSystemController" method="get">

            <input type="hidden" name="action" value="list">

            <input type="text"
                   name="keyword"
                   value="<%= keyword%>"
                   placeholder="Search system...">

            <button type="submit">Search</button>

            <a href="PumpSystemController?action=list">
                Show All
            </a>

        </form>


        <!-- ADD / EDIT FORM -->

        <%
            if (editSystem == null) {
        %>

        <h2>Add Pump System</h2>

        <form action="PumpSystemController" method="post">

            <input type="hidden"
                   name="action"
                   value="add">

            <input type="text"
                   name="systemCode"
                   placeholder="System Code"
                   required>

            <input type="text"
                   name="systemName"
                   placeholder="System Name"
                   required>

            <input type="text"
                   name="location"
                   placeholder="Location">

            <select name="status">
                <option value="ACTIVE">ACTIVE</option>
                <option value="INACTIVE">INACTIVE</option>
                <option value="MAINTENANCE">MAINTENANCE</option>
            </select>

            <button type="submit">
                Add
            </button>

        </form>

        <%
        } else {
        %>

        <h2>Edit Pump System</h2>

        <form action="PumpSystemController" method="post">

            <input type="hidden"
                   name="action"
                   value="update">

            <input type="hidden"
                   name="id"
                   value="<%= editSystem.getSystemId()%>">

            <input type="text"
                   name="systemCode"
                   value="<%= editSystem.getSystemCode()%>"
                   placeholder="System Code"
                   required>

            <input type="text"
                   name="systemName"
                   value="<%= editSystem.getSystemName()%>"
                   placeholder="System Name"
                   required>

            <input type="text"
                   name="location"
                   value="<%= editSystem.getLocation()%>"
                   placeholder="Location">

            <select name="status">

                <option value="ACTIVE"
                        <%= "ACTIVE".equals(editSystem.getStatus())
                    ? "selected" : ""%>>
                    ACTIVE
                </option>

                <option value="INACTIVE"
                        <%= "INACTIVE".equals(editSystem.getStatus())
                    ? "selected" : ""%>>
                    INACTIVE
                </option>

                <option value="MAINTENANCE"
                        <%= "MAINTENANCE".equals(editSystem.getStatus())
                    ? "selected" : ""%>>
                    MAINTENANCE
                </option>

            </select>

            <button type="submit">
                Update
            </button>

            <a href="PumpSystemController?action=list">
                Cancel
            </a>

        </form>

        <%
            }
        %>


        <!-- LIST -->

        <h2>Pump System List</h2>

        <table>

            <tr>
                <th>ID</th>
                <th>System Code</th>
                <th>System Name</th>
                <th>Location</th>
                <th>Status</th>
                <th>Action</th>
            </tr>

            <%
                if (list != null && !list.isEmpty()) {

                    for (PumpSystem system : list) {
            %>

            <tr>

                <td>
                    <%= system.getSystemId()%>
                </td>

                <td>
                    <%= system.getSystemCode()%>
                </td>

                <td>
                    <%= system.getSystemName()%>
                </td>

                <td>
                    <%= system.getLocation()%>
                </td>

                <td>
                    <%= system.getStatus()%>
                </td>

                <td>

                    <a href="PumpSystemController?action=edit&id=<%= system.getSystemId()%>">
                        Edit
                    </a>

                    |

                    <a href="PumpSystemController?action=delete&id=<%= system.getSystemId()%>"
                       onclick="return confirm('Are you sure you want to delete this system?');">
                        Delete
                    </a>

                </td>

            </tr>

            <%
                }

            } else {
            %>

            <tr>
                <td colspan="6">
                    No pump system found.
                </td>
            </tr>

            <%
                }
            %>

        </table>


        <!-- PAGINATION -->

        <%
            Integer currentPageObj
                    = (Integer) request.getAttribute("CURRENT_PAGE");
            Integer totalPagesObj
                    = (Integer) request.getAttribute("TOTAL_PAGES");
            int currentPage
                    = currentPageObj != null ? currentPageObj : 1;
            int totalPages
                    = totalPagesObj != null ? totalPagesObj : 1;
        %>

        <div class="pagination">
            <% if (currentPage > 1) { %>
            <a href="PumpSystemController?action=list&keyword=<%= keyword%>&page=<%= currentPage - 1%>">
                Previous
            </a>

            <%
                }
                for (int i = 1; i <= totalPages; i++) {
            %>
            <a class="<%= i == currentPage ? "active" : ""%>"
               href="PumpSystemController?action=list&keyword=<%= keyword%>&page=<%= i%>">
                <%= i%>
            </a>
            <%
                }

                if (currentPage < totalPages) {
            %>
            <a href="PumpSystemController?action=list&keyword=<%= keyword%>&page=<%= currentPage + 1%>">
                Next
            </a>
            <%
                }
            %>
        </div>
    </body>
</html>
