<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Vérification formulaire</title>
</head>
<body>
<%@ page import="java.sql.*" %>
<%@ page import="mesfichiers.Employe"%>
<%@ page import="mesfichiers.Entreprise"%>
<%@ page import="mesfichiers.DatabaseConnection"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.List"%>
<%@ page import="java.time.LocalDate"%>
<%@ page import="java.time.format.DateTimeParseException"%>

<%
System.out.println("Début du traitement du formulaire...");

try {
    // Récupération des données du formulaire
    String nomEmp = request.getParameter("nomEmp");
    String prenomEmp = request.getParameter("prenomEmp");
    String fonctionEmp = request.getParameter("fonctionEmp");
    String sexeEmp = request.getParameter("sexeEmp");
    String serviceEmp = request.getParameter("serviceEmp");
    String dateStr = request.getParameter("dateEmbauche");
    String salaireBase = request.getParameter("salaireBase");
    String entrepriseIdStr = request.getParameter("entrepriseId");

    System.out.println("Données reçues: " + nomEmp + ", " + prenomEmp + ", " + fonctionEmp);

    // Validation des champs obligatoires
    if (nomEmp == null || prenomEmp == null || fonctionEmp == null || sexeEmp == null ||
        serviceEmp == null || dateStr == null || salaireBase == null || entrepriseIdStr == null ||
        nomEmp.trim().isEmpty() || prenomEmp.trim().isEmpty() || fonctionEmp.trim().isEmpty() ||
        serviceEmp.trim().isEmpty() || entrepriseIdStr.trim().isEmpty()) {

        request.setAttribute("errorMessage", "Tous les champs obligatoires doivent être remplis.");
        request.getRequestDispatcher("adminProfile.jsp").forward(request, response);
        return;
    }

    // Validation de la date
    LocalDate dateEmbauche;
    try {
        dateEmbauche = LocalDate.parse(dateStr);
    } catch (DateTimeParseException e) {
        request.setAttribute("errorMessage", "Format de date invalide. Utilisez le format YYYY-MM-DD.");
        request.getRequestDispatcher("adminProfile.jsp").forward(request, response);
        return;
    }

    // Validation du salaire
    double salaire;
    try {
        salaire = Double.parseDouble(salaireBase);
        if (salaire <= 0) {
            throw new NumberFormatException("Le salaire doit être positif.");
        }
    } catch (NumberFormatException e) {
        request.setAttribute("errorMessage", "Le salaire doit être un nombre positif.");
        request.getRequestDispatcher("adminProfile.jsp").forward(request, response);
        return;
    }

    // Validation de l'ID de l'entreprise
    int entrepriseId;
    try {
        entrepriseId = Integer.parseInt(entrepriseIdStr);
    } catch (NumberFormatException e) {
        request.setAttribute("errorMessage", "Identifiant de l'entreprise invalide.");
        request.getRequestDispatcher("adminProfile.jsp").forward(request, response);
        return;
    }

    // Génération du matricule
    int matricule = (int) (System.currentTimeMillis() / 1000);

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        conn = DatabaseConnection.getConnection();

        // Vérification de l'existence de l'entreprise
        String checkEntreprise = "SELECT id FROM entreprise WHERE id = ?";
        pstmt = conn.prepareStatement(checkEntreprise);
        pstmt.setInt(1, entrepriseId);
        ResultSet rs = pstmt.executeQuery();
        if (!rs.next()) {
            request.setAttribute("errorMessage", "L'entreprise spécifiée n'existe pas.");
            request.getRequestDispatcher("adminProfile.jsp").forward(request, response);
            return;
        }
        pstmt.close();

        // Insertion de l'employé
        String sql = "INSERT INTO employe (matricule, nomEmp, prenomEmp, fonctionEmp, serviceEmp, dateEmbauche, sexeEmp, salaireBase, entreprise_id) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sql);

        pstmt.setInt(1, matricule);
        pstmt.setString(2, nomEmp);
        pstmt.setString(3, prenomEmp);
        pstmt.setString(4, fonctionEmp);
        pstmt.setString(5, serviceEmp);
        pstmt.setDate(6, java.sql.Date.valueOf(dateEmbauche));
        pstmt.setString(7, sexeEmp);
        pstmt.setDouble(8, salaire);
        pstmt.setInt(9, entrepriseId);

        int result = pstmt.executeUpdate();

        if (result > 0) {
            System.out.println("Inscription réussie !");
            session.setAttribute("successMessage", "Inscription réussie ! L'employé a été ajouté.");
            response.sendRedirect("adminProfile.jsp");
        } else {
            throw new SQLException("L'insertion a échoué.");
        }

    } catch (SQLException e) {
        e.printStackTrace();
        request.setAttribute("errorMessage", "Erreur lors de l'inscription: " + e.getMessage());
        request.getRequestDispatcher("adminProfile.jsp").forward(request, response);
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }

} catch (Exception e) {
    e.printStackTrace();
    request.setAttribute("errorMessage", "Une erreur est survenue lors de l'inscription.");
    request.getRequestDispatcher("adminProfile.jsp").forward(request, response);
}
%>

</body>
</html>