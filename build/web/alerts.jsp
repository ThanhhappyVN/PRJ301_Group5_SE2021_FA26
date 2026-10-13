<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Alerts</title>
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
        <h1>Alerts</h1>
        <p>Review abnormal conditions and update alert status.</p>
        <a class="back" href="dashboard.jsp">Dashboard</a>
        <table>
            <tr>
                <th>ID</th>
                <th>Device</th>
                <th>Session</th>
                <th>Source</th>
                <th>Label</th>
                <th>Risk</th>
                <th>Status</th>
                <th>Created</th>
                <th>Update</th>
            </tr>
            <% java.util.List<Object[]> rows = (java.util.List<Object[]>) request.getAttribute("rows");
    for (Object[] r : rows) {%>
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
                    <form method="post" action="AlertController">
                        <input type="hidden" name="id" value="<%=r[0]%>">
                        <select name="status">
                            <option <%= "OPEN".equals(r[6]) ? "selected" : ""%>>OPEN</option>
                            <option <%= "ACKNOWLEDGED".equals(r[6]) ? "selected" : ""%>>ACKNOWLEDGED</option>
                            <option <%= "RESOLVED".equals(r[6]) ? "selected" : ""%>>RESOLVED</option>
                        </select>
                        <button>Save</button>
                    </form>
                </td>
            </tr>
            <% }%>
        </table>
    </body>
</html>