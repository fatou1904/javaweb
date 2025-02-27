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
    <title>Administration - Gestion des employes</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.7.0/chart.min.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --dark-blue: #00264d;
            --darker-blue: #001a33;
            --white: #ffffff;
            --light-gray: #f5f5f5;
            --text-dark: #333333;
            --success: #28a745;
            --warning: #ffc107;
            --danger: #dc3545;
        }
        
        a{
        text-decoration: none;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            transition: all 0.3s ease;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--white);
            color: var(--text-dark);
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
            background: linear-gradient(135deg, var(--dark-blue), var(--darker-blue));
            border-radius: 15px;
            color: var(--white);
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .search-wrapper {
            position: relative;
            width: 300px;
        }

        .search-bar {
            width: 100%;
            padding: 12px 40px 12px 15px;
            border-radius: 25px;
            border: 2px solid rgba(255, 255, 255, 0.2);
            background-color: rgba(255, 255, 255, 0.1);
            color: var(--white);
            font-size: 16px;
            backdrop-filter: blur(5px);
        }

        .search-bar::placeholder {
            color: rgba(255, 255, 255, 0.7);
        }

        .search-icon {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: rgba(255, 255, 255, 0.7);
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
            background-color: var(--white);
            padding: 25px;
            border-radius: 15px;
            text-align: center;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            border: 1px solid rgba(0, 0, 0, 0.05);
            display: flex;
            flex-direction: column;
            align-items: center;
            cursor: pointer;
            transform: translateY(0);
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.1);
        }

        .stat-icon {
            font-size: 2.5em;
            margin-bottom: 15px;
            color: var(--dark-blue);
        }

        .stat-number {
            font-size: 2.5em;
            font-weight: bold;
            color: var(--dark-blue);
            margin: 10px 0;
        }

        .chart-container {
            grid-column: span 8;
            background: white;
            padding: 20px;
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
        }

        .recent-activity {
            grid-column: span 4;
            background: white;
            padding: 20px;
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
        }

        .activity-item {
            padding: 15px 0;
            border-bottom: 1px solid #eee;
            display: flex;
            align-items: center;
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

        .employees-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            background-color: var(--white);
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            margin-top: 20px;
        }

        .employees-table th,
        .employees-table td {
            padding: 20px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        .employees-table th {
            background-color: var(--dark-blue);
            color: var(--white);
            font-weight: 500;
            text-transform: uppercase;
            font-size: 0.9em;
            letter-spacing: 1px;
        }

        .employees-table tr:hover {
            background-color: var(--light-gray);
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
            background-color: var(--dark-blue);
            color: var(--white);
        }

        .btn-primary:hover {
            background-color: var(--darker-blue);
            transform: translateY(-2px);
        }

        .btn-danger {
            background-color: var(--danger);
            color: white;
        }

        .btn-danger:hover {
            background-color: #bd2130;
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
            color: var(--text-dark);
        }

        .status-approved {
            background-color: var(--success);
            color: white;
        }

        /* Nouveaux styles pour les notifications et l'animation de mise à jour */
        .highlight-updated {
            background-color: rgba(40, 167, 69, 0.2) !important;
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
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
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
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
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
      

        <div class="header animate-in">
            <h1><i class="fas fa-user-shield"></i> Tableau de bord administrateur</h1>
            <div class="search-wrapper">
                <input type="text" class="search-bar" placeholder="Rechercher un employe...">
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
                    <h3>Total employes</h3>
                    <div class="stat-number"><%= totalemployes %></div>
                    <div class="stat-change">+12% ce mois</div>
                </div>
                
            </div>

            <div class="chart-container animate-in">
                <h2>Évolution des Employes inscrit</h2>
                <canvas id="registrationChart"></canvas>
            </div>

            <div class="recent-activity animate-in">
                <h2>Activité récente</h2>
                <div class="activity-item">
                    <div class="activity-icon" style="background-color: var(--success)">
                        <i class="fas fa-check"></i>
                    </div>
                    <div>
                        <div>Nouveau employe validé</div>
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
                        <div>employeure supprimée</div>
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
                    <tr matricule="employe-row-<%= employe.getMatricule() %>">
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
                            Aucun employe trouvé dans la base de données.
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
          // Fonction pour la suppression
$('.delete-btn').on('click', function() {
    var employeId = $(this).data('id');
    if (confirm('Êtes-vous sûr de vouloir supprimer ce employe ? Cette action est irréversible.')) {
        $.ajax({
            type: "POST",
            url: "delete.jsp",
            data: { idemploye: employeId },
            success: function(response) {
                // Supprimer la ligne du tableau
                $('#employe-row-' + employeId).fadeOut(500, function() {
                    $(this).remove();
                });
                
                // Afficher une notification de succès
                showNotification("employe supprimé avec succès", "success");
                
                // Mettre à jour les statistiques (vous devrez rafraîchir la page ou mettre à jour via JS)
            },
            error: function() {
                // Afficher une notification d'erreur
                showNotification("Erreur lors de la suppression du employe", "error");
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