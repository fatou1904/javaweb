<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="mesfichiers.DatabaseConnection"%>
<%@ page import="org.mindrot.jbcrypt.BCrypt"%>

<%
    // Configuration initiale
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // Logs pour le débogage
    System.out.println("=== Début du traitement de connexion ===");
    System.out.println("Session ID: " + session.getId());

    // Récupération des données du formulaire
    String login = request.getParameter("login");
    String password = request.getParameter("password");

    System.out.println("login reçu: " + login);
    // Ne pas logger le mot de passe pour des raisons de sécurité

    // Validation des entrées
    if (login == null || login.trim().isEmpty() || password == null || password.trim().isEmpty()) {
        System.out.println("Erreur: login ou mot de passe vide");
        request.setAttribute("errorMessage", "Veuillez remplir tous les champs");
        request.getRequestDispatcher("login.jsp").forward(request, response);
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    // Variables pour déterminer le statut de l'authentification
    boolean userAuthenticated = false;
    boolean isAdmin = false;
    int userId = -1;
    String userName = "";

    try {
        // Établissement de la connexion
        conn = DatabaseConnection.getConnection();
        if (conn == null) {
            throw new SQLException("La connexion à la base de données a échoué");
        }
        System.out.println("Connexion à la base de données établie");

        // Normalisation de l'login
        String normalizedlogin = login.trim().toLowerCase();

        // Vérification admin
        String sqlAdmin = "SELECT * FROM admin WHERE login = ?";
        pstmt = conn.prepareStatement(sqlAdmin);
        pstmt.setString(1, normalizedlogin);
        rs = pstmt.executeQuery();
        System.out.println("Requête de recherche admin exécutée");

        if (rs.next()) {
            String hashedPassword = rs.getString("password");
            if (hashedPassword == null) {
                System.out.println("Erreur: Mot de passe hashé non trouvé pour l'admin");
                throw new SQLException("Mot de passe hashé non trouvé dans la base de données pour l'admin");
            }

            // Vérification du mot de passe pour l'admin
            if (BCrypt.checkpw(password, hashedPassword)) {
                System.out.println("Authentification réussie pour l'admin: " + login);
                userAuthenticated = true;
                isAdmin = true;
                userId = rs.getInt("id");
                userName = login; // Ou un autre champ si disponible comme rs.getString("nom")
            } else {
                System.out.println("Mot de passe incorrect pour l'admin: " + login);
            }
        } else {
            System.out.println("Aucun admin trouvé avec l'login: " + login);
        }

        // Traitement du résultat de l'authentification
        if (userAuthenticated) {
            // Nettoyage de la session existante
            session.invalidate();
            session = request.getSession(true);

            // Création de la nouvelle session
            session.setAttribute("userId", userId);
            session.setAttribute("userlogin", login);
            session.setAttribute("userName", userName);
            session.setMaxInactiveInterval(3600); // 1 heure

            System.out.println("Session créée avec succès");
            
            // Redirection vers la page admin
            System.out.println("Redirection vers adminprofile.jsp");
            response.sendRedirect("adminProfile.jsp");
            return;
        } else {
            System.out.println("Authentification échouée pour: " + login);
            request.setAttribute("errorMessage", "Login ou mot de passe incorrect");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }

    } catch (SQLException e) {
        System.out.println("Erreur SQL : " + e.getMessage());
        e.printStackTrace();
        request.setAttribute("errorMessage", "Une erreur technique est survenue. Veuillez réessayer plus tard.");
        request.getRequestDispatcher("login.jsp").forward(request, response);
    } catch (Exception e) {
        System.out.println("Erreur inattendue : " + e.getMessage());
        e.printStackTrace();
        request.setAttribute("errorMessage", "Une erreur inattendue est survenue. Veuillez réessayer plus tard.");
        request.getRequestDispatcher("login.jsp").forward(request, response);
    } finally {
        // Fermeture des ressources
        System.out.println("Fermeture des ressources");
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>