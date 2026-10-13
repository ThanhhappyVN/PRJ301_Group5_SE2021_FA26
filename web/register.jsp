<%-- 
    Document   : register
    Created on : Sep 25, 2026, 10:09:26 PM
    Author     : DatNuoc
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Register</title>
    </head>
    <body>

        <h2>Register</h2>

        <% if (request.getAttribute("ERROR") != null) { %>
            <p style="color:red;">
                <%= request.getAttribute("ERROR") %>
            </p>
        <% } %>

        <% if (request.getAttribute("MESSAGE") != null) { %>
            <p style="color:green;">
                <%= request.getAttribute("MESSAGE") %>
            </p>
        <% } %>

        <form action="<%= request.getContextPath() %>/RegisterController" method="post">

            <p>
                Username:
                <input type="text"
                       name="username"
                       value="<%= request.getAttribute("OLD_USERNAME") != null
                               ? request.getAttribute("OLD_USERNAME") : "" %>">
            </p>

            <p>
                Full Name:
                <input type="text"
                       name="fullName"
                       value="<%= request.getAttribute("OLD_FULL_NAME") != null
                               ? request.getAttribute("OLD_FULL_NAME") : "" %>">
            </p>

            <p>
                Password:
                <input type="password"
                       name="password">
            </p>

            <p>
                Confirm Password:
                <input type="password"
                       name="confirm">
            </p>

            <p>
                <input type="submit" value="Register">
            </p>

        </form>

        <p>
            Already have an account?
            <a href="<%= request.getContextPath() %>/login.jsp">Login</a>
        </p>

    </body>
</html>
