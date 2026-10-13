/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import util.DbContext;

/**
 *
 * @author DatNuoc
 */
public class AlertController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AlertController</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AlertController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try ( Connection c = DbContext.getConnection();  PreparedStatement s = c.prepareStatement("SELECT a.alert_id,a.device_id,a.session_id,a.source,a.label,a.risk_score,a.status,a.created_at FROM Alert a ORDER BY a.created_at DESC")) {
            try ( ResultSet r = s.executeQuery()) {
                java.util.List<Object[]> rows = new java.util.ArrayList<Object[]>();
                while (r.next()) {
                    rows.add(new Object[]{r.getInt(1), r.getObject(2), r.getObject(3), r.getString(4), r.getString(5), r.getObject(6), r.getString(7), r.getTimestamp(8)});
                }
                request.setAttribute("rows", rows);
            }
            request.getRequestDispatcher("alerts.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try ( Connection c = DbContext.getConnection();  PreparedStatement s = c.prepareStatement("UPDATE Alert SET status=? WHERE alert_id=?")) {
            s.setString(1, request.getParameter("status"));
            s.setInt(2, Integer.parseInt(request.getParameter("id")));
            s.executeUpdate();
            response.sendRedirect("AlertController");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
