<%@page import="mesfichiers.Employe"%>
<%@page import="mesfichiers.Entreprise"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="mesfichiers.DatabaseConnection"%>

<%
    // Vérification de la connexion
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Récupération de l'ID de l'employé depuis l'URL
    int employeId = 0;
    try {
        // Si pas de paramètre, on utilise l'ID de l'utilisateur connecté
        if (request.getParameter("id") != null) {
            employeId = Integer.parseInt(request.getParameter("id"));
        } else {
            employeId = (Integer) session.getAttribute("userId");
        }
    } catch (NumberFormatException e) {
        response.sendRedirect("liste_employes.jsp");
        return;
    }
    
    String userName = (String) session.getAttribute("userName");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Détails Employé</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        /* Style similaire au code précédent */
    </style>
</head>
<body>

    <div class="details-container">
        <%
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            boolean employeFound = false;
            
            try {
                conn = DatabaseConnection.getConnection();
                String sql = "SELECT e.*, ent.* FROM employe e INNER JOIN entreprise ent ON e.entreprise_id = ent.id WHERE e.matricule = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, employeId);
                rs = pstmt.executeQuery();
                
                if (rs.next()) {
                    employeFound = true;
        %>
                <div class="details-header">
                    <h1>Détails de l'Employé</h1>
                </div>
                
                <div class="details-content">
                    <div class="detail-item">
                        <label><i class="fas fa-user"></i> Nom Complet</label>
                        <p><%=rs.getString("nomEmp") + " " + rs.getString("prenomEmp") %></p>
                    </div>
                    
                    <div class="detail-item">
                        <label><i class="fas fa-building"></i> Fonction</label>
                        <p><%=rs.getString("fonctionEmp") %></p>
                    </div>
                    
                    <div class="detail-item">
                        <label><i class="fas fa-briefcase"></i> Service</label>
                        <p><%=rs.getString("serviceEmp") %></p>
                    </div>
                    
                    <div class="detail-item">
                        <label><i class="fas fa-calendar-alt"></i> Date d'Embauche</label>
                        <p><%= rs.getDate("dateEmbauche") != null ? rs.getDate("dateEmbauche").toLocalDate().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy")) : "Non renseignée" %></p>
                    </div>
                    
                    <div class="detail-item">
                        <label><i class="fas fa-venus-mars"></i> Sexe</label>
                        <p><%= rs.getString("sexeEmp") != null ? rs.getString("sexeEmp") : "Non renseigné" %></p>
                    </div>
                    
                    <div class="detail-item">
                        <label><i class="fas fa-dollar-sign"></i> Salaire</label>
                        <p><%= rs.getDouble("salaireBase") != 0 ? rs.getDouble("salaireBase") : "Non renseigné" %> €</p>
                    </div>
                    
                    <div class="detail-item">
                        <label><i class="fas fa-building"></i> Entreprise</label>
                        <p><%= rs.getString("nomEntrep") %></p>
                    </div>
                    
                    <div class="detail-item">
                        <label><i class="fas fa-map-marker-alt"></i> Adresse de l'Entreprise</label>
                        <p><%= rs.getString("adresseEntrep") %></p>
                    </div>
                    
                    <div class="detail-item">
                        <label><i class="fas fa-chart-line"></i> Chiffre d'Affaires</label>
                        <p><%= rs.getDouble("chiffreAffaire") != 0 ? rs.getDouble("chiffreAffaire") : "Non renseigné" %> €</p>
                    </div>
                    
                    <div class="detail-item">
                        <label><i class="fas fa-calendar"></i> Date de Création</label>
                        <p><%= rs.getDate("dateCreation") != null ? rs.getDate("dateCreation").toLocalDate().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy")) : "Non renseignée" %></p>
                    </div>
                </div>
        <% 
                } else { 
        %>
                <div class="error-message">
                    <h2>Employé non trouvé</h2>
                    <p>Les détails de l'employé avec le matricule <%= employeId %> n'ont pas pu être trouvés.</p>
                </div>
        <%
                }
            } catch (Exception e) {
        %>
                <div class="error-message">
                    <h2>Erreur</h2>
                    <p>Une erreur s'est produite lors de la récupération des détails de l'employé: <%= e.getMessage() %></p>
                </div>
        <%
                e.printStackTrace();
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException e) { }
                if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { }
                if (conn != null) try { conn.close(); } catch (SQLException e) { }
            }
        %>
        
        <div class="actions">
            <button class="btn btn-outline" onclick="history.back()">
                <i class="fas fa-arrow-left"></i> Retour
            </button>
        </div>
    </div>
</body>
</html>
