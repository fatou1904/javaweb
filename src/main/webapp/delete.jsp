<%@ page import="mesfichiers.EmployeDAO" %>
<%@ page import="mesfichiers.EntrepriseDAO" %>
<%@ page import="mesfichiers.Employe" %>
<%@ page import="mesfichiers.Entreprise" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Vérification de la session
    if (session.getAttribute("userId") == null) {
        response.setStatus(401); // Unauthorized
        response.setContentType("application/json");
        out.print("{\"success\":false,\"message\":\"Non autorisé\"}");
        return;
    }

    String idParam = request.getParameter("id");
    String entityType = request.getParameter("entityType"); // 'employe' ou 'entreprise'

    if (idParam == null || idParam.trim().isEmpty() || entityType == null || entityType.trim().isEmpty()) {
        response.setStatus(400); // Bad Request
        response.setContentType("application/json");
        out.print("{\"success\":false,\"message\":\"ID manquant ou type d'entité invalide\"}");
        return;
    }

    int id;
    try {
        id = Integer.parseInt(idParam);
    } catch (NumberFormatException e) {
        response.setStatus(400); // Bad Request
        response.setContentType("application/json");
        out.print("{\"success\":false,\"message\":\"ID invalide\"}");
        return;
    }

    try {
        boolean success = false;
        
        if ("employe".equalsIgnoreCase(entityType)) {
            EmployeDAO employeDAO = new EmployeDAO();
            success = employeDAO.delete(id); // Suppression de l'employé
            
            // Log pour le débogage
            System.out.println("Tentative de suppression de l'employé avec ID=" + id + ", résultat: " + success);
            
            // Logique pour supprimer l'entité de la session (si applicable)
            if (success) {
                java.util.List<Employe> employes = (java.util.List<Employe>) session.getAttribute("employes");
                if (employes != null) {
                    employes.removeIf(e -> e.getMatricule() == id);
                    session.setAttribute("employes", employes);
                }
            }
        } else if ("entreprise".equalsIgnoreCase(entityType)) {
            EntrepriseDAO entrepriseDAO = new EntrepriseDAO();
            success = entrepriseDAO.delete(id); // Suppression de l'entreprise
            
            // Log pour le débogage
            System.out.println("Tentative de suppression de l'entreprise avec ID=" + id + ", résultat: " + success);
            
            // Suppression de l'entreprise de la liste dans la session si présente
            if (success) {
                java.util.List<Entreprise> entreprises = (java.util.List<Entreprise>) session.getAttribute("entreprises");
                if (entreprises != null) {
                    entreprises.removeIf(e -> e.getId() == id);
                    session.setAttribute("entreprises", entreprises);
                }
            }
        } else {
            response.setStatus(400); // Bad Request
            response.setContentType("application/json");
            out.print("{\"success\":false,\"message\":\"Type d'entité inconnu\"}");
            return;
        }

        if (success) {
            session.setAttribute("statusMessage", "L'entité a été supprimée avec succès.");

            // Vérification si c'est une requête AJAX
            boolean isAjax = request.getHeader("X-Requested-With") != null || 
                             (request.getHeader("Accept") != null && 
                              request.getHeader("Accept").contains("application/json"));

            if (isAjax) {
                response.setContentType("application/json");
                out.print("{\"success\":true,\"message\":\"Entité supprimée avec succès\"}");
            } else {
                // Pour les requêtes normales, rediriger
                response.sendRedirect("adminprofile.jsp");
            }
        } else {
            // Log pour le débogage
            System.out.println("Échec de la suppression de l'entité avec ID=" + id);

            session.setAttribute("statusMessage", "Erreur: Impossible de supprimer l'entité.");

            // Vérification si c'est une requête AJAX
            boolean isAjax = request.getHeader("X-Requested-With") != null || 
                             (request.getHeader("Accept") != null && 
                              request.getHeader("Accept").contains("application/json"));

            if (isAjax) {
                response.setStatus(500); // Internal Server Error
                response.setContentType("application/json");
                out.print("{\"success\":false,\"message\":\"Impossible de supprimer l'entité\"}");
            } else {
                // Pour les requêtes normales, rediriger
                response.sendRedirect("adminprofile.jsp");
            }
        }
    } catch (Exception e) {
        // Log pour le débogage
        System.out.println("Exception lors de la suppression de l'entité ID=" + id + ": " + e.getMessage());
        e.printStackTrace();

        session.setAttribute("statusMessage", "Erreur: " + e.getMessage());

        // Vérification si c'est une requête AJAX
        boolean isAjax = request.getHeader("X-Requested-With") != null || 
                         (request.getHeader("Accept") != null && 
                          request.getHeader("Accept").contains("application/json"));

        if (isAjax) {
            response.setStatus(500); // Internal Server Error
            response.setContentType("application/json");
            out.print("{\"success\":false,\"message\":\"Erreur: " + e.getMessage().replaceAll("\"", "\\\\\"") + "\"}");
        } else {
            // Pour les requêtes normales, rediriger
            response.sendRedirect("adminprofile.jsp");
        }
    }
%>