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
        /* Thème sombre noir et violet */
:root {
  --bg-primary: #121212;
  --bg-secondary: #1e1e1e;
  --accent-primary: #8b5cf6; /* Violet principal */
  --accent-secondary: #6d28d9; /* Violet plus foncé */
  --accent-hover: #a78bfa; /* Violet plus clair */
  --text-primary: #f3f4f6;
  --text-secondary: #d1d5db;
  --text-muted: #9ca3af;
  --border-color: #2d2d2d;
  --shadow-color: rgba(0, 0, 0, 0.5);
}

body {
  background-color: var(--bg-primary);
  color: var(--text-primary);
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  margin: 0;
  padding: 0;
  min-height: 100vh;
}

.details-container {
  max-width: 900px;
  margin: 2rem auto;
  background-color: var(--bg-secondary);
  border-radius: 12px;
  box-shadow: 0 8px 30px var(--shadow-color);
  overflow: hidden;
}

.details-header {
  background: linear-gradient(135deg, var(--accent-primary), var(--accent-secondary));
  color: white;
  padding: 1.5rem 2rem;
  border-top-left-radius: 12px;
  border-top-right-radius: 12px;
  position: relative;
  overflow: hidden;
}

.details-header::after {
  content: "";
  position: absolute;
  bottom: -10px;
  left: 0;
  right: 0;
  height: 10px;
  background: linear-gradient(to bottom, rgba(0,0,0,0.1), transparent);
}

.details-header h1 {
  margin: 0;
  font-weight: 600;
  font-size: 1.8rem;
  letter-spacing: 0.5px;
}

.details-content {
  padding: 2rem;
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
  gap: 1.5rem;
}

.detail-item {
  position: relative;
  padding: 1.25rem;
  border-radius: 8px;
  background-color: rgba(255, 255, 255, 0.05);
  border: 1px solid var(--border-color);
  transition: all 0.3s ease;
}

.detail-item:hover {
  transform: translateY(-3px);
  box-shadow: 0 10px 25px -10px rgba(139, 92, 246, 0.3);
  border-color: var(--accent-primary);
}

.detail-item label {
  display: block;
  font-size: 0.875rem;
  font-weight: 500;
  color: var(--accent-primary);
  margin-bottom: 0.5rem;
  display: flex;
  align-items: center;
}

.detail-item label i {
  margin-right: 0.5rem;
  color: var(--accent-primary);
}

.detail-item p {
  font-size: 1.1rem;
  margin: 0;
  color: var(--text-primary);
  font-weight: 400;
  word-break: break-word;
}

.actions {
  display: flex;
  justify-content: flex-end;
  padding: 1.5rem 2rem;
  border-top: 1px solid var(--border-color);
}

.btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 0.75rem 1.5rem;
  border-radius: 8px;
  font-weight: 500;
  font-size: 0.9rem;
  transition: all 0.2s ease;
  cursor: pointer;
  gap: 0.5rem;
}

.btn i {
  font-size: 1rem;
}

.btn-outline {
  background: transparent;
  color: var(--accent-primary);
  border: 1px solid var(--accent-primary);
}

.btn-outline:hover {
  background-color: var(--accent-primary);
  color: white;
  box-shadow: 0 5px 15px rgba(139, 92, 246, 0.4);
}

.error-message {
  text-align: center;
  padding: 3rem 2rem;
}

.error-message h2 {
  color: #ef4444;
  margin-bottom: 1rem;
}

.error-message p {
  color: var(--text-secondary);
}

/* Responsive Design */
@media (max-width: 768px) {
  .details-container {
    margin: 1rem;
    border-radius: 8px;
  }
  
  .details-content {
    grid-template-columns: 1fr;
    padding: 1.5rem;
  }
  
  .detail-item {
    padding: 1rem;
  }
}

/* Animation de chargement */
@keyframes pulse {
  0% { opacity: 0.6; }
  50% { opacity: 1; }
  100% { opacity: 0.6; }
}

/* Animation d'entrée pour les éléments */
@keyframes fadeIn {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}

.detail-item {
  animation: fadeIn 0.3s ease forwards;
  animation-delay: calc(var(--i, 0) * 0.1s);
}

/* Personnalisation de la barre de défilement */
::-webkit-scrollbar {
  width: 8px;
  height: 8px;
}

::-webkit-scrollbar-track {
  background: var(--bg-secondary);
}

::-webkit-scrollbar-thumb {
  background: var(--accent-secondary);
  border-radius: 4px;
}

::-webkit-scrollbar-thumb:hover {
  background: var(--accent-primary);
}
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
                        <p><%= rs.getDouble("salaireBase") != 0 ? rs.getDouble("salaireBase") : "Non renseigné" %> fcfa</p>
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
                        <p><%= rs.getDouble("chiffreAffaire") != 0 ? rs.getDouble("chiffreAffaire") : "Non renseigné" %> fcfa</p>
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
