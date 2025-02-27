<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="mesfichiers.EntrepriseDAO" %>
<%@ page import="mesfichiers.Entreprise" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="mesfichiers.DatabaseConnection" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%



// Récupération des données du formulaire
String nomEntrep = request.getParameter("nomEntrep");
String adresseEntrep = request.getParameter("adresseEntrep");
String chiffreAffaireStr = request.getParameter("chiffreAffaire");
String dateCreationStr = request.getParameter("dateCreation");

// Variables pour stocker les erreurs
List<String> errors = new ArrayList<>();
boolean hasError = false;

// Validation des données
// 1. Vérifier si les champs obligatoires sont remplis
if (nomEntrep == null || nomEntrep.trim().isEmpty()) {
    errors.add("Le nom de l'entreprise est obligatoire");
    hasError = true;
}

if (adresseEntrep == null || adresseEntrep.trim().isEmpty()) {
    errors.add("L'adresse de l'entreprise est obligatoire");
    hasError = true;
}

// 2. Vérifier et convertir le chiffre d'affaires
double chiffreAffaire = 0;
if (chiffreAffaireStr == null || chiffreAffaireStr.trim().isEmpty()) {
    errors.add("Le chiffre d'affaires est obligatoire");
    hasError = true;
} else {
    try {
        chiffreAffaire = Double.parseDouble(chiffreAffaireStr.replace(",", "."));
        if (chiffreAffaire < 0) {
            errors.add("Le chiffre d'affaires ne peut pas être négatif");
            hasError = true;
        }
    } catch (NumberFormatException e) {
        errors.add("Format du chiffre d'affaires invalide. Veuillez entrer un nombre valide");
        hasError = true;
    }
}

// 3. Vérifier la date de création
LocalDate dateCreation = null;
if (dateCreationStr == null || dateCreationStr.trim().isEmpty()) {
    errors.add("La date de création est obligatoire");
    hasError = true;
} else {
    try {
        dateCreation = LocalDate.parse(dateCreationStr);
        // Vérifier si la date est dans le futur
        if (dateCreation.isAfter(LocalDate.now())) {
            errors.add("La date de création ne peut pas être dans le futur");
            hasError = true;
        }
    } catch (Exception e) {
        errors.add("Format de date invalide");
        hasError = true;
    }
}

// 4. Vérifier si le nom de l'entreprise existe déjà
if (!hasError) {
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
        conn = DatabaseConnection.getConnection();
        String sql = "SELECT COUNT(*) FROM entreprise WHERE nomEntrep = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, nomEntrep);
        rs = pstmt.executeQuery();
        
        if (rs.next() && rs.getInt(1) > 0) {
            errors.add("Une entreprise avec ce nom existe déjà dans la base de données");
            hasError = true;
        }
    } catch (SQLException e) {
        errors.add("Erreur lors de la vérification du nom d'entreprise: " + e.getMessage());
        hasError = true;
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { }
        if (conn != null) try { conn.close(); } catch (SQLException e) { }
    }
}

// Si pas d'erreur, enregistrer l'entreprise
if (!hasError) {
    Connection conn = null;
    PreparedStatement pstmt = null;
    
    try {
        conn = DatabaseConnection.getConnection();
        String sql = "INSERT INTO entreprise (nomEntrep, adresseEntrep, chiffreAffaire, dateCreation) VALUES (?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, nomEntrep);
        pstmt.setString(2, adresseEntrep);
        pstmt.setDouble(3, chiffreAffaire);
        pstmt.setDate(4, java.sql.Date.valueOf(dateCreation));
        
        int result = pstmt.executeUpdate();
        
        if (result > 0) {
            // Succès - rediriger vers la liste des entreprises
            session.setAttribute("successMessage", "L'entreprise " + nomEntrep + " a été ajoutée avec succès");
            response.sendRedirect("liste_entreprises.jsp");
            return;
        } else {
            errors.add("Erreur lors de l'enregistrement de l'entreprise");
            hasError = true;
        }
    } catch (SQLException e) {
        errors.add("Erreur lors de l'enregistrement de l'entreprise: " + e.getMessage());
        hasError = true;
        e.printStackTrace();
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { }
        if (conn != null) try { conn.close(); } catch (SQLException e) { }
    }
}

// Si des erreurs, les afficher
if (hasError) {
    request.setAttribute("errors", errors);
    request.setAttribute("nomEntrep", nomEntrep);
    request.setAttribute("adresseEntrep", adresseEntrep);
    request.setAttribute("chiffreAffaire", chiffreAffaireStr);
    request.setAttribute("dateCreation", dateCreationStr);
    
    // Transférer à la page d'inscription avec les erreurs
    request.getRequestDispatcher("creerEntreprise.jsp").forward(request, response);
    return;
}%>
</body>
</html>