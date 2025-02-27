package messervlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import mesfichiers.Employe;
import mesfichiers.EmployeDAO;

/**
 * Servlet implementation class AdminServlet
 */
@WebServlet("/admin")
public class AdminServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("Servlet AdminServlet appelé");

        // Check if user is authenticated
        if (request.getSession().getAttribute("userId") == null) {
            System.out.println("Utilisateur non connecté, redirection vers login.jsp");
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            // Fetch employees from the database
            EmployeDAO employeDAO = new EmployeDAO();
            List<Employe> employes = employeDAO.getAllEmployes();
            System.out.println("Employés récupérés: " + employes.size());

            // Store employees in the request scope (not session)
            request.setAttribute("employes", employes);

        } catch (SQLException e) {
            System.err.println("Erreur lors de la récupération des employés: " + e.getMessage());
            request.setAttribute("error", "Erreur lors du chargement des employés.");
            e.printStackTrace();
        }

        // Forward to admin.jsp
        System.out.println("Redirection vers adminProfile.jsp");
        request.getRequestDispatcher("adminProfile.jsp").forward(request, response);
    }
}
