<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dto.User"%>
<%@page import="java.util.List"%>

<%
    User loginUser = (User) session.getAttribute("LOGIN_USER");
    if (loginUser == null || !"ADMIN".equalsIgnoreCase(loginUser.getRoleName())) {
        response.sendError(403, "Only ADMIN can access User Management");
        return;
    }

    List<User> users = (List<User>) request.getAttribute("USERS");
    List<String> roles = (List<String>) request.getAttribute("ROLES");
    User editUser = (User) request.getAttribute("EDIT_USER");
    String error = (String) request.getAttribute("ERROR");
    String message = (String) request.getAttribute("MESSAGE");

    if (users == null) {
        users = new java.util.ArrayList<User>();
    }
    if (roles == null) {
        roles = new java.util.ArrayList<String>();
    }

    String oldUsername = request.getAttribute("OLD_USERNAME") == null
            ? "" : String.valueOf(request.getAttribute("OLD_USERNAME"));
    String oldFullName = request.getAttribute("OLD_FULL_NAME") == null
            ? "" : String.valueOf(request.getAttribute("OLD_FULL_NAME"));
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Management</title>
    <style>
        body { margin: 0; font-family: Arial, sans-serif; background: #f4f6f9; }
        .header { background: #1f2937; color: white; padding: 18px 30px;
                  display: flex; justify-content: space-between; align-items: center; }
        .header h2 { margin: 0; }
        .container { padding: 30px; }
        .panel { background: white; padding: 22px; border-radius: 8px;
                 box-shadow: 0 2px 8px rgba(0,0,0,0.08); margin-bottom: 22px; }
        table { width: 100%; border-collapse: collapse; background: white; }
        th, td { padding: 10px; border: 1px solid #ddd; text-align: left; }
        th { background: #e5e7eb; }
        input, select { padding: 8px; width: 100%; box-sizing: border-box; margin-top: 5px; }
        .row { display: grid; grid-template-columns: repeat(2, 1fr); gap: 15px; }
        .button { display: inline-block; padding: 9px 14px; background: #2563eb;
                  color: white; text-decoration: none; border: 0; border-radius: 5px; cursor: pointer; }
        .button.gray { background: #6b7280; }
        .button.red { background: #dc2626; }
        .message { padding: 10px; margin-bottom: 15px; border-radius: 5px; }
        .error { background: #fee2e2; color: #991b1b; }
        .success { background: #dcfce7; color: #166534; }
        .actions form { display: inline; }
        .small { color: #666; font-size: 13px; }
    </style>
</head>
<body>

<div class="header">
    <h2>Pump and Valve Monitoring - User Management</h2>
    <div>
        <strong><%= loginUser.getFullName() %></strong>
        &nbsp; | &nbsp; ADMIN
        &nbsp; | &nbsp;
        <a class="button gray" href="<%= request.getContextPath() %>/DashboardController">Dashboard</a>
        <a class="button red" href="<%= request.getContextPath() %>/LogoutController">Logout</a>
    </div>
</div>

<div class="container">

    <% if (error != null) { %>
        <div class="message error"><%= error %></div>
    <% } %>

    <% if (message != null) { %>
        <div class="message success"><%= message %></div>
    <% } %>

    <div class="panel">
        <h2>Add New User</h2>
        <p class="small">New users are ACTIVE immediately. Role must be one of the five roles defined in the database.</p>

        <form action="<%= request.getContextPath() %>/UserController" method="post">
            <input type="hidden" name="action" value="create">

            <div class="row">
                <div>
                    <label>Username</label>
                    <input type="text" name="username" maxlength="50" required value="<%= oldUsername %>">
                </div>
                <div>
                    <label>Full Name</label>
                    <input type="text" name="fullName" maxlength="80" required value="<%= oldFullName %>">
                </div>
            </div>

            <br>
            <div class="row">
                <div>
                    <label>Password</label>
                    <input type="password" name="password" minlength="6" maxlength="60" required>
                </div>
                <div>
                    <label>Confirm Password</label>
                    <input type="password" name="confirm" minlength="6" maxlength="60" required>
                </div>
            </div>

            <br>
            <div class="row">
                <div>
                    <label>Role</label>
                    <select name="roleName" required>
                        <option value="">-- Select role --</option>
                        <% for (String role : roles) { %>
                            <option value="<%= role %>"><%= role %></option>
                        <% } %>
                    </select>
                </div>
                <div>
                    <label>&nbsp;</label>
                    <button class="button" type="submit">Create User</button>
                </div>
            </div>
        </form>
    </div>

    <% if (editUser != null) { %>
    <div class="panel">
        <h2>Edit User #<%= editUser.getUserId() %></h2>
        <form action="<%= request.getContextPath() %>/UserController" method="post">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="userId" value="<%= editUser.getUserId() %>">

            <div class="row">
                <div>
                    <label>Username</label>
                    <input type="text" value="<%= editUser.getUsername() %>" readonly>
                </div>
                <div>
                    <label>Full Name</label>
                    <input type="text" name="fullName" maxlength="80" required value="<%= editUser.getFullName() == null ? "" : editUser.getFullName() %>">
                </div>
            </div>

            <br>
            <div class="row">
                <div>
                    <label>Role</label>
                    <select name="roleName" required>
                        <% for (String role : roles) { %>
                            <option value="<%= role %>" <%= role.equals(editUser.getRoleName()) ? "selected" : "" %>><%= role %></option>
                        <% } %>
                    </select>
                </div>
                <div>
                    <label>Status</label>
                    <select name="status" required>
                        <option value="ACTIVE" <%= "ACTIVE".equals(editUser.getStatus()) ? "selected" : "" %>>ACTIVE</option>
                        <option value="INACTIVE" <%= "INACTIVE".equals(editUser.getStatus()) ? "selected" : "" %>>INACTIVE</option>
                    </select>
                </div>
            </div>

            <br>
            <button class="button" type="submit">Save Changes</button>
            <a class="button gray" href="<%= request.getContextPath() %>/UserController">Cancel</a>
        </form>
    </div>
    <% } %>

    <div class="panel">
        <h2>All Users</h2>
        <table>
            <tr>
                <th>ID</th>
                <th>Username</th>
                <th>Full Name</th>
                <th>Role</th>
                <th>Status</th>
                <th>Action</th>
            </tr>

            <% for (User user : users) { %>
            <tr>
                <td><%= user.getUserId() %></td>
                <td><%= user.getUsername() %></td>
                <td><%= user.getFullName() == null ? "" : user.getFullName() %></td>
                <td><%= user.getRoleName() == null ? "-" : user.getRoleName() %></td>
                <td><%= user.getStatus() %></td>
                <td class="actions">
                    <a class="button" href="<%= request.getContextPath() %>/UserController?action=edit&id=<%= user.getUserId() %>">Edit</a>
                </td>
            </tr>
            <% } %>
        </table>
    </div>

</div>
</body>
</html>
