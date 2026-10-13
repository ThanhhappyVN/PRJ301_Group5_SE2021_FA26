<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Maintenance Tickets</title>
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
<h1>Maintenance Tickets</h1>
<p>Create tickets and update maintenance status.</p>
<a class="back" href="dashboard.jsp">Dashboard</a>
<div class="form">
<h3>Create ticket</h3>
<form method="post" action="MaintenanceTicketController">
<input type="hidden" name="action" value="create">
<input type="number" name="deviceId" placeholder="Existing device ID" required min="1">
<input name="note" placeholder="Maintenance note" required maxlength="400" style="width:40%">
<button>Create ticket</button>
</form>
</div>
<table>
<tr>
<th>ID</th>
<th>Alert</th>
<th>Device</th>
<th>Assigned user</th>
<th>Note</th>
<th>Status</th>
<th>Opened</th>
<th>Closed</th>
<th>Update</th>
</tr>
<% java.util.List<Object[]> rows=(java.util.List<Object[]>)request.getAttribute("rows"); for(Object[] r:rows){ %>
<tr>
<td>
<%=r[0]%>
</td>
<td>
<%=r[1]%>
</td>
<td>
<%=r[2]%>
</td>
<td>
<%=r[3]%>
</td>
<td>
<%=r[4]%>
</td>
<td>
<%=r[5]%>
</td>
<td>
<%=r[6]%>
</td>
<td>
<%=r[7]%>
</td>
<td>
<form method="post" action="MaintenanceTicketController">
<input type="hidden" name="id" value="<%=r[0]%>">
<select name="status">
<option <%= "OPEN".equals(r[5])?"selected":"" %>>OPEN</option>
<option <%= "IN_PROGRESS".equals(r[5])?"selected":"" %>>IN_PROGRESS</option>
<option <%= "CLOSED".equals(r[5])?"selected":"" %>>CLOSED</option>
</select>
<button>Save</button>
</form>
</td>
</tr>
<% } %>
</table>
</body>
</html>