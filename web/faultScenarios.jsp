<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Fault Scenarios</title>
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
<h1>Fault Scenarios</h1>
<p>Manage test scenarios and expected anomaly labels.</p>
<a class="back" href="dashboard.jsp">Dashboard</a>
<div class="form">
<h3>Add scenario</h3>
<form method="post" action="FaultScenarioController">
<input name="code" placeholder="Scenario code" required>
<input name="name" placeholder="Scenario name" required>
<input name="description" placeholder="Description" style="width:25%">
<select name="label">
<option>NORMAL</option>
<option>PARTIAL_VALVE_CLOSURE</option>
<option>IMBALANCE</option>
<option>LEAK</option>
<option>CAVITATION</option>
<option>SENSOR_FAULT</option>
</select>
<select name="status">
<option>ACTIVE</option>
<option>INACTIVE</option>
</select>
<button>Save scenario</button>
</form>
</div>
<table>
<tr>
<th>ID</th>
<th>Code</th>
<th>Name</th>
<th>Description</th>
<th>Expected label</th>
<th>Status</th>
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
</tr>
<% } %>
</table>
</body>
</html>