<%-- 
    Document   : pumpRun
    Created on : Oct 8, 2026, 7:04:23 PM
    Author     : DatNuoc
--%>
<%@page import="dto.PumpRun"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    List<PumpRun> list = (List<PumpRun>) request.getAttribute("LIST_PUMP_RUN");

    String keyword = (String) request.getAttribute("KEYWORD");
    Integer currentPage = (Integer) request.getAttribute("CURRENT_PAGE");
    Integer totalPages = (Integer) request.getAttribute("TOTAL_PAGES");

    if (keyword == null) {
        keyword = "";
    }

    if (currentPage == null) {
        currentPage = 1;
    }

    if (totalPages == null) {
        totalPages = 1;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Pump Run Monitoring</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 30px;
            }

            h2 {
                margin-bottom: 20px;
            }

            .search-box {
                margin-bottom: 20px;
            }

            .search-box input {
                padding: 8px;
                width: 250px;
            }

            .search-box button {
                padding: 8px 15px;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 15px;
            }

            th, td {
                border: 1px solid #ccc;
                padding: 10px;
                text-align: center;
            }

            th {
                background-color: #f2f2f2;
            }

            .pagination {
                margin-top: 20px;
                text-align: center;
            }

            .pagination a {
                display: inline-block;
                padding: 7px 12px;
                margin: 2px;
                border: 1px solid #ccc;
                text-decoration: none;
            }

            .pagination a.active {
                background-color: #ddd;
                font-weight: bold;
            }
        </style>
    </head>

    <body>

        <h2>Pump Run Monitoring</h2>
        <a href="dashboard.jsp">Dashboard</a>
        <!-- Search -->
        <div class="search-box">
            <form action="PumpRunController" method="get">

                <input type="hidden" name="action" value="search">

                <input type="text"
                       name="keyword"
                       value="<%= keyword%>"
                       placeholder="Search session, device...">

                <button type="submit">Search</button>

            </form>
        </div>

        <!-- Pump Run Table -->
        <table>

            <tr>
                <th>Session ID</th>
                <th>Device ID</th>
                <th>Device Seq</th>
                <th>Measured At</th>
                <th>Vibration RMS</th>
                <th>Current (A)</th>
                <th>Pressure (bar)</th>
                <th>Fluid Temp (°C)</th>
                <th>Flow (L/min)</th>
                <th>Action</th>
            </tr>

            <%
                if (list != null && !list.isEmpty()) {
                    for (PumpRun pumpRun : list) {
            %>

            <tr>
                <td><%= pumpRun.getSessionId()%></td>

                <td><%= pumpRun.getDeviceId()%></td>

                <td><%= pumpRun.getDeviceSeq()%></td>

                <td><%= pumpRun.getMeasuredAt()%></td>

                <td><%= pumpRun.getVib1Rms()%></td>

                <td><%= pumpRun.getCurrentA()%></td>

                <td><%= pumpRun.getPressureBar()%></td>

                <td><%= pumpRun.getFluidTempC()%></td>

                <td><%= pumpRun.getFlowLpm()%></td>

                <td>
                    <a href="PumpRunController?action=detail&sessionId=<%= pumpRun.getSessionId()%>">
                        View
                    </a>
                </td>
            </tr>

            <%
                }
            } else {
            %>

            <tr>
                <td colspan="10">
                    No pump run data found.
                </td>
            </tr>

            <%
                }
            %>

        </table>

        <!-- Pagination -->
        <div class="pagination">

            <%
                if (currentPage > 1) {
            %>

            <a href="PumpRunController?action=search&keyword=<%= keyword%>&page=<%= currentPage - 1%>">
                Previous
            </a>

            <%
                }

                for (int i = 1; i <= totalPages; i++) {
            %>

            <a class="<%= (i == currentPage) ? "active" : ""%>"
               href="PumpRunController?action=search&keyword=<%= keyword%>&page=<%= i%>">
                <%= i%>
            </a>

            <%
                }

                if (currentPage < totalPages) {
            %>

            <a href="PumpRunController?action=search&keyword=<%= keyword%>&page=<%= currentPage + 1%>">
                Next
            </a>

            <%
                }
            %>

        </div>

    </body>
</html>
