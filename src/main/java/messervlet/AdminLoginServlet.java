package messervlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import mesfichiers.Authentification;

@WebServlet("/adminLogin")
public class AdminLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private Authentification authService = new Authentification();
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Récupération des paramètres du formulaire
        String login = request.getParameter("login");
        String password = request.getParameter("password");
        
        // Vérification des identifiants
        boolean isAuthenticated = authService.authenticateAdmin(login, password);
        
        if (isAuthenticated) {
            // Création d'une session pour l'admin
            HttpSession session = request.getSession();
            session.setAttribute("login", login);
            session.setAttribute("userType", "admin");
            
            // Log pour débogage
            System.out.println("Authentification réussie pour l'admin: " + login);
            System.out.println("Redirection vers le tableau de bord admin");
            
            // Redirection vers la page d'administration
            response.sendRedirect(request.getContextPath() + "/adminDashboard.jsp");
        } else {
            // Log pour débogage
            System.out.println("Authentification échouée pour: " + login);
            
            // Redirection vers la page de login avec message d'erreur
            response.sendRedirect("adminLogin.jsp?error=Identifiants%20invalides");
        }
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Redirection vers la page de login si on accède directement au servlet
        response.sendRedirect("adminLogin.jsp");
    }
}