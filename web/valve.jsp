<%-- 
    Document   : valve
    Created on : Sep 25, 2026, 10:22:08 PM
    Author     : DatNuoc
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="dto.Valve"%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Valve Management</title>
    </head>

    <body>

        <h2>Valve Management</h2>
        <a href="dashboard.jsp">Dashboard</a>
        <!-- Error -->
        <% if (request.getAttribute("ERROR") != null) { %>
            <p style="color:red;">
                <%= request.getAttribute("ERROR") %>
            </p>
        <% } %>

        <!-- Search -->
        <form action="ValveController" method="get">

            <input type="hidden"
                   name="action"
                   value="list">

            <input type="text"
                   name="keyword"
                   placeholder="Search valve..."
                   value="<%= request.getAttribute("KEYWORD") != null
                           ? request.getAttribute("KEYWORD") : "" %>">

            <input type="submit"
                   value="Search">

        </form>

        <br>

        <!-- Add Valve -->
        <h3>Add Valve</h3>

        <form action="ValveController" method="post">

            <input type="hidden"
                   name="action"
                   value="add">

            <p>
                Valve Code:
                <input type="text"
                       name="valveCode"
                       required>
            </p>

            <p>
                Pump ID:
                <input type="number"
                       name="pumpId"
                       required>
            </p>

            <p>
                Position:
                <input type="text"
                       name="position"
                       required>
            </p>

            <p>
                Status:
                <input type="text"
                       name="status"
                       required>
            </p>

            <input type="submit"
                   value="Add Valve">

        </form>

        <br>
        <!-- Edit -->
        <%
            Valve editValve =
                    (Valve) request.getAttribute("VALVE");

            if (editValve != null) {
        %>

        <h3>Edit Valve</h3>

        <form action="ValveController" method="post">

            <input type="hidden"
                   name="action"
                   value="update">

            <input type="hidden"
                   name="id"
                   value="<%= editValve.getId() %>">

            <p>
                ID:
                <input type="text"
                       value="<%= editValve.getId() %>"
                       readonly>
            </p>

            <p>
                Valve Code:
                <input type="text"
                       name="valveCode"
                       value="<%= editValve.getValveCode() %>"
                       required>
            </p>

            <p>
                Pump ID:
                <input type="number"
                       name="pumpId"
                       value="<%= editValve.getPumpId() %>"
                       required>
            </p>

            <p>
                Position:
                <input type="text"
                       name="position"
                       value="<%= editValve.getPosition() %>"
                       required>
            </p>

            <p>
                Status:
                <input type="text"
                       name="status"
                       value="<%= editValve.getStatus() %>"
                       required>
            </p>

            <input type="submit"
                   value="Update">

            <a href="ValveController?action=list">
                Cancel
            </a>

        </form>

        <br>

        <%
            }
        %>
        <!-- Valve List -->
        <h3>Valve List</h3>

        <table border="1"
               cellpadding="8"
               cellspacing="0">

            <tr>
                <th>ID</th>
                <th>Valve Code</th>
                <th>Pump ID</th>
                <th>Position</th>
                <th>Status</th>
                <th>Action</th>
            </tr>

            <%
                List<Valve> list =
                        (List<Valve>) request.getAttribute("LIST_VALVE");

                if (list != null && !list.isEmpty()) {

                    for (Valve valve : list) {
            %>

            <tr>

                <td>
                    <%= valve.getId() %>
                </td>

                <td>
                    <%= valve.getValveCode() %>
                </td>

                <td>
                    <%= valve.getPumpId() %>
                </td>

                <td>
                    <%= valve.getPosition() %>
                </td>

                <td>
                    <%= valve.getStatus() %>
                </td>

                <td>

                    <a href="ValveController?action=edit&id=<%= valve.getId() %>">
                        Edit
                    </a>

                    |

                    <a href="ValveController?action=delete&id=<%= valve.getId() %>"
                       onclick="return confirm('Are you sure you want to delete this valve?');">
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
                    No valve found.
                </td>
            </tr>

            <%
                }
            %>

        </table>

        <br>

        <!-- Pagination -->
        <%
            Integer currentPage =
                    (Integer) request.getAttribute("CURRENT_PAGE");

            Integer totalPages =
                    (Integer) request.getAttribute("TOTAL_PAGES");

            String keyword =
                    (String) request.getAttribute("KEYWORD");

            if (currentPage == null) {
                currentPage = 1;
            }

            if (totalPages == null) {
                totalPages = 0;
            }

            if (keyword == null) {
                keyword = "";
            }

            if (totalPages > 1) {
        %>

        <div>

            <% if (currentPage > 1) { %>

                <a href="ValveController?action=list&page=<%= currentPage - 1 %>&keyword=<%= keyword %>">
                    Previous
                </a>

            <% } %>


            <% for (int i = 1; i <= totalPages; i++) { %>

                <% if (i == currentPage) { %>

                    <strong>
                        [<%= i %>]
                    </strong>

                <% } else { %>

                    <a href="ValveController?action=list&page=<%= i %>&keyword=<%= keyword %>">
                        <%= i %>
                    </a>

                <% } %>

            <% } %>


            <% if (currentPage < totalPages) { %>

                <a href="ValveController?action=list&page=<%= currentPage + 1 %>&keyword=<%= keyword %>">
                    Next
                </a>

            <% } %>

        </div>

        <% } %>

    </body>
</html>