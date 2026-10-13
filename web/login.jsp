<%-- 
    Document   : login
    Created on : Sep 25, 2026, 8:51:39 PM
    Author     : DatNuoc
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login</title>
    </head>
    <body>
        <h2>Login</h2>

        <%
            String error = (String) request.getAttribute("ERROR");

            if (error != null) {
        %>
        <p style="color:red;"><%= error%></p>
        <%
            }
        %>

        <form action="<%= request.getContextPath() %>/LoginController" method="post">

            <label>Username:</label>
            <input type="text" name="username" required>
            <br><br>

            <label>Password:</label>
            <input type="password" name="password" required>
            <br><br>

            <button type="submit">Login</button>

        </form>
        <p>
            Don't have an account?
            <a href="register.jsp">Register</a>
        </p>
    </body>
</html>
