/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package api;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import dao.DeviceDao;
import dao.PumpRunDao;
import dto.PumpRun;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import service.AlertService;

/**
 *
 * @author DELL
 */
@WebServlet("/api/pump/batch")
public class PumpRunApi extends HttpServlet {

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
            out.println("<title>Servlet PumpRunApi</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet PumpRunApi at " + request.getContextPath() + "</h1>");
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
        processRequest(request, response);
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
        JsonObject body = JsonParser.parseReader(request.getReader()).getAsJsonObject();
        int deviceId = body.get("device_id").getAsInt();
        int savedCount = 0;
        for (JsonElement element : body.getAsJsonArray("sessions")) {
            JsonObject json = element.getAsJsonObject();
            PumpRun session = new PumpRun();
            session.setDeviceId(deviceId);
            session.setDeviceSeq(json.get("seq").getAsInt());
            session.setMeasuredAt(java.sql.Timestamp.valueOf(json.get("measured_at").getAsString()));
            session.setVib1Rms(json.get("vib1_rms").getAsDouble());
            session.setCurrentA(json.get("current_a").getAsDouble());
            session.setPressureBar(json.get("pressure_bar").getAsDouble());
            session.setFluidTempC(json.get("fluid_temp_c").getAsDouble());
            session.setFlowLpm(json.get("flow_lpm").getAsDouble());
            try {
                long newId = new PumpRunDao().insert(session);
                if (newId > 0) {
                    savedCount++;
                    session.setSessionId(newId);
                    new AlertService().evaluate(session);
                }
            } catch (SQLException duplicate) {
                log("Failed to save device_seq="
                        + session.getDeviceSeq()
                        + ", device_id="
                        + deviceId, duplicate);
            } catch (Exception e) {
                log("Alert evaluation failed", e);
            }
        }
        try {
            new DeviceDao().touch(deviceId);
        } catch (SQLException e) {
            log("Cannot update device last_seen", e);
        }
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write("{\"saved\":" + savedCount + "}");
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
