<%@ page import="mesfichiers.Employe"%>
<%@ page import="mesfichiers.EmployeDAO" %>


<%
    // Vérification de la session
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    int userId = (Integer) session.getAttribute("userId");
    String userName = (String) session.getAttribute("userName");
    
    // Récupération de la liste de employes depuis la session ou la base de données
    java.util.List<Employe> employes = (java.util.List<Employe>) session.getAttribute("employes");
    if (employes == null) {
        try {
            EmployeDAO employeDAO = new EmployeDAO();
            employes = employeDAO.getAllEmployes();
            session.setAttribute("employes", employes);
        } catch (Exception e) {
            out.println("<!-- Erreur: " + e.getMessage() + " -->");
            employes = new java.util.ArrayList<>();
        }
    }
    
    // Comptage des employes selon leur statut
    int totalemployes = employes.size();
   
  
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Administration - Gestion des employés</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.7.0/chart.min.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --bg-primary: #121212;
            --bg-secondary: #1e1e1e;
            --bg-tertiary: #2d2d2d;
            --text-primary: #ffffff;
            --text-secondary: #b3b3b3;
            --accent: #8A2BE2;
            --accent-dark: #6a1cb7;
            --danger: #e53935;
            --danger-dark: #c62828;
            --success: #43a047;
            --warning: #ffb300;
            --border: #3d3d3d;
            --card-shadow: 0 4px 8px rgba(0, 0, 0, 0.5);
        }
        
        a {
            text-decoration: none;
            color: var(--accent);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            transition: all 0.3s ease;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--bg-primary);
            color: var(--text-primary);
            line-height: 1.6;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 20px;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding: 20px;
            background: linear-gradient(135deg, var(--bg-tertiary), var(--bg-secondary));
            border-radius: 15px;
            box-shadow: var(--card-shadow);
            border: 1px solid var(--border);
        }

        .search-wrapper {
            position: relative;
            width: 300px;
        }

        .search-bar {
            width: 100%;
            padding: 12px 40px 12px 15px;
            border-radius: 25px;
            border: 2px solid var(--border);
            background-color: var(--bg-primary);
            color: var(--text-primary);
            font-size: 16px;
        }

        .search-bar::placeholder {
            color: var(--text-secondary);
        }

        .search-icon {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-secondary);
        }

        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(12, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }

        .stats {
            grid-column: span 12;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }

        .stat-card {
            background-color: var(--bg-secondary);
            padding: 25px;
            border-radius: 15px;
            text-align: center;
            box-shadow: var(--card-shadow);
            border: 1px solid var(--border);
            display: flex;
            flex-direction: column;
            align-items: center;
            cursor: pointer;
            transform: translateY(0);
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.7);
            background-color: var(--bg-tertiary);
        }

        .stat-icon {
            font-size: 2.5em;
            margin-bottom: 15px;
            color: var(--accent);
        }

        .stat-number {
            font-size: 2.5em;
            font-weight: bold;
            color: var(--accent);
            margin: 10px 0;
        }

        .stat-change {
            color: var(--text-secondary);
        }

        .chart-container {
            grid-column: span 8;
            background: var(--bg-secondary);
            padding: 20px;
            border-radius: 15px;
            box-shadow: var(--card-shadow);
            border: 1px solid var(--border);
        }

        .chart-container h2 {
            color: var(--text-primary);
            margin-bottom: 15px;
        }

        .recent-activity {
            grid-column: span 4;
            background: var(--bg-secondary);
            padding: 20px;
            border-radius: 15px;
            box-shadow: var(--card-shadow);
            border: 1px solid var(--border);
        }

        .recent-activity h2 {
            color: var(--text-primary);
            margin-bottom: 15px;
        }

        .activity-item {
            padding: 15px 0;
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
        }

        .activity-item:last-child {
            border-bottom: none;
        }

        .activity-icon {
            margin-right: 15px;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
        }

        .activity-item div:last-child {
            color: var(--text-primary);
        }

        .activity-item small {
            color: var(--text-secondary);
        }

        .employees-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            background-color: var(--bg-secondary);
            border-radius: 15px;
            overflow: hidden;
            box-shadow: var(--card-shadow);
            margin-top: 20px;
            border: 1px solid var(--border);
        }

        .employees-table th,
        .employees-table td {
            padding: 20px;
            text-align: left;
            border-bottom: 1px solid var(--border);
        }

        .employees-table th {
            background-color: var(--bg-tertiary);
            color: var(--text-primary);
            font-weight: 500;
            text-transform: uppercase;
            font-size: 0.9em;
            letter-spacing: 1px;
        }

        .employees-table tr:hover {
            background-color: var(--bg-tertiary);
        }

        .employees-table tbody tr:last-child td {
            border-bottom: none;
        }

        .btn {
            padding: 10px 20px;
            border-radius: 25px;
            border: none;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s ease;
            font-size: 14px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn i {
            font-size: 16px;
        }

        .btn-primary {
            background-color: var(--accent);
            color: var(--text-primary);
        }

        .btn-primary:hover {
            background-color: var(--accent-dark);
            transform: translateY(-2px);
        }

        .btn-danger {
            background-color: var(--danger);
            color: white;
        }

        .btn-danger:hover {
            background-color: var(--danger-dark);
            transform: translateY(-2px);
        }

        .status-badge {
            padding: 6px 12px;
            border-radius: 15px;
            font-size: 0.85em;
            font-weight: 500;
        }

        .status-pending {
            background-color: var(--warning);
            color: var(--bg-primary);
        }

        .status-approved {
            background-color: var(--success);
            color: white;
        }

        /* Nouveaux styles pour les notifications et l'animation de mise à jour */
        .highlight-updated {
            background-color: rgba(67, 160, 71, 0.2) !important;
            transition: background-color 2s;
        }

        .notification {
            position: fixed;
            top: 20px;
            right: -300px;
            padding: 15px 25px;
            border-radius: 5px;
            z-index: 1000;
            opacity: 0;
            box-shadow: 0 4px 8px rgba(0,0,0,0.3);
        }

        .success-notification {
            background-color: var(--success);
            color: white;
        }

        .error-notification {
            background-color: var(--danger);
            color: white;
        }

        .alert {
            margin: 20px 0;
            padding: 15px;
            border-radius: 5px;
        }

        .alert-info {
            background-color: rgba(67, 160, 71, 0.2);
            color: var(--success);
            border: 1px solid var(--success);
        }

        .alert-danger {
            background-color: rgba(229, 57, 53, 0.2);
            color: var(--danger);
            border: 1px solid var(--danger);
        }

        @media (max-width: 1200px) {
            .chart-container {
                grid-column: span 12;
            }
            .recent-activity {
                grid-column: span 12;
            }
        }

        @media (max-width: 768px) {
            .header {
                flex-direction: column;
                gap: 20px;
            }

            .search-wrapper {
                width: 100%;
            }

            .employees-table {
                display: block;
                overflow-x: auto;
            }

            .btn {
                padding: 8px 16px;
                font-size: 12px;
            }

            .stat-card {
                padding: 15px;
            }

            .stat-number {
                font-size: 2em;
            }
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .animate-in {
            animation: fadeIn 0.5s ease-out forwards;
        }
    </style>
</head>
<body>
    <div class="container">
      
        <!-- Display message if available -->
        <% 
            String statusMessage = (String) session.getAttribute("statusMessage");
            if (statusMessage != null) {
                String alertClass = statusMessage.contains("Erreur") ? "alert-danger" : "alert-info";
        %>
        <div class="alert <%= alertClass %> animate-in">
            <%= statusMessage %>
        </div>
        <%
                session.removeAttribute("statusMessage"); // Clear the message
            }
        %>

        <div class="header animate-in">
            <h1><i class="fas fa-user-shield"></i> Tableau de bord administrateur</h1>
            <div class="search-wrapper">
                <input type="text" class="search-bar" placeholder="Rechercher un employé...">
                <i class="fas fa-search search-icon"></i>
            </div>
            
            <div class="actions">
                <a href="logout.jsp" class="btn btn-primary">
                    <i class="fas fa-sign-out-alt"></i>
                    Déconnexion
                </a>
            </div>
        </div>

        <div class="dashboard-grid">
            <div class="stats">
                <div class="stat-card animate-in">
                    <i class="fas fa-users stat-icon"></i>
                    <h3>Total employés</h3>
                    <div class="stat-number"><%= totalemployes %></div>
                    <div class="stat-change">+12% ce mois</div>
                </div>
                
            </div>

            <div class="chart-container animate-in">
                <h2>Création des employés et des entreprises</h2>
               <div>
                <td>
                            <a href="creerEmp.jsp" class="btn btn-primary">
                                <i class="fas fa-user"></i> Ajouter un employé
                            </a>
                            <a href="creerEntreprise.jsp" class="btn btn-danger delete-btn"">
                                <i class="fas fa-building"></i> Ajouter une entreprise
                            </a>
                            <a href="liste_entreprises.jsp" class="btn btn-danger delete-btn"">
                                <i ></i> Voir liste des entreprises
                            </a>
                        </td>
               
               </div>
            </div>

            <div class="recent-activity animate-in">
                <h2>Activité récente</h2>
                <div class="activity-item">
                    <div class="activity-icon" style="background-color: var(--success)">
                        <i class="fas fa-check"></i>
                    </div>
                    <div>
                        <div>Nouveau employé validé</div>
                        <small>Il y a 5 minutes</small>
                    </div>
                </div>
                <div class="activity-item">
                    <div class="activity-icon" style="background-color: var(--warning)">
                        <i class="fas fa-user-plus"></i>
                    </div>
                    <div>
                        <div>Nouvelle inscription</div>
                        <small>Il y a 15 minutes</small>
                    </div>
                </div>
                <div class="activity-item">
                    <div class="activity-icon" style="background-color: var(--danger)">
                        <i class="fas fa-trash"></i>
                    </div>
                    <div>
                        <div>Employé supprimé</div>
                        <small>Il y a 1 heure</small>
                    </div>
                </div>
            </div>
        </div>

        <table class="employees-table animate-in">
            <thead>
                <tr>
                    <th>Matricule</th>
                    <th>Nom</th>
                    <th>Prénom</th>
                    <th>Fonction</th>
                    <th>Salaire Base</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% 
                // Récupération des employes depuis la session
                
                // Affichage des employes
                if (employes != null && !employes.isEmpty()) {
                    for (Employe employe : employes) {
                %>
                    <tr id="employe-row-<%= employe.getMatricule() %>">
                        <td><%= employe.getMatricule() %></td>
                        <td><%= employe.getNomEmp() %></td>
                        <td><%= employe.getPrenomEmp() %></td>
                        <td><%= employe.getFonctionEmp() %></td>
                        <td><%= employe.getSalaireBase() %></td>
                       
                        <td>
                            <a href="details.jsp?id=<%= employe.getMatricule() %>" class="btn btn-primary">
                                <i class="fas fa-eye"></i> Détails
                            </a>
                            <button type="button" class="btn btn-danger delete-btn" data-id="<%= employe.getMatricule() %>">
                                <i class="fas fa-trash"></i> Supprimer
                            </button>
                        </td>
                    </tr>
                <% 
                    }
                } else {
                %>
                    <tr>
                        <td colspan="7" style="text-align: center;">
                            Aucun employé trouvé dans la base de données.
                        </td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <script>
       
            // Recherche dynamique améliorée
            $('.search-bar').on('keyup', function() {
                var value = $(this).val().toLowerCase();
                $('.employees-table tbody tr').filter(function() {
                    $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1);
                });
            });

            // Fonction pour la suppression
            $('.delete-btn').on('click', function() {
                var employeId = $(this).data('id');
                if (confirm('Êtes-vous sûr de vouloir supprimer cet employé ? Cette action est irréversible.')) {
                    $.ajax({
                        type: "POST",
                        url: "delete.jsp",
                        data: { id: employeId, entityType: "employe" },
                        success: function(response) {
                            // Supprimer la ligne du tableau
                            $('#employe-row-' + employeId).fadeOut(500, function() {
                                $(this).remove();
                            });
                            
                            // Afficher une notification de succès
                            showNotification("Employé supprimé avec succès", "success");
                            
                            // Mettre à jour les statistiques
                            var currentTotal = parseInt($('.stat-number').text());
                            $('.stat-number').text(currentTotal - 1);
                        },
                        error: function(xhr, status, error) {
                            // Afficher une notification d'erreur
                            showNotification("Erreur lors de la suppression: " + error, "error");
                            console.error("Erreur AJAX:", xhr.responseText);
                        }
                    });
                }
            });
            
            // Fonction pour afficher une notification
            function showNotification(message, type) {
                var notificationClass = "success-notification";
                if (type === "error") {
                    notificationClass = "error-notification";
                } else if (type === "warning") {
                    notificationClass = "warning-notification";
                }
                
                var notification = $('<div class="notification ' + notificationClass + '">' + message + '</div>');
                
                $('body').append(notification);
                
                // Animer l'apparition et la disparition
                notification.animate({
                    opacity: 1,
                    right: '20px'
                }, 500).delay(3000).animate({
                    opacity: 0,
                    right: '-300px'
                }, 500, function() {
                    $(this).remove();
                });
            }
            
            // Faire disparaître les alertes après quelques secondes
            setTimeout(function() {
                $('.alert').fadeOut('slow');
            }, 5000);
        });
    </script>
</body>
</html>