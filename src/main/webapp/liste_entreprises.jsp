<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="mesfichiers.EntrepriseDAO" %>
<%@ page import="mesfichiers.Entreprise" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.sql.*" %>
<%@ page import="mesfichiers.DatabaseConnection" %>

<%
    List<Entreprise> entreprises = new ArrayList<>();
    try {
        EntrepriseDAO entrepriseDAO = new EntrepriseDAO();
        entreprises = entrepriseDAO.getAllEntreprises();
        request.setAttribute("entreprises", entreprises);
    } catch(Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Entreprises</title>
    <style>
        :root {
            --darkblue: #1a237e;
            --lightblue: #534bae;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f0f2f5;
            padding: 20px;
        }

        .container {
            max-width: 90%;
            margin: 0 auto;
            background: white;
            padding: 2rem;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }

        h1 {
            color: var(--darkblue);
            text-align: center;
            margin-bottom: 2rem;
        }

        .table-container {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 2rem;
        }

        th, td {
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        th {
            background-color: var(--darkblue);
            color: white;
            font-weight: 600;
        }

        tr:hover {
            background-color: #f5f5f5;
        }

        .btn {
            display: inline-block;
            padding: 0.5rem 1rem;
            border-radius: 5px;
            text-decoration: none;
            margin-right: 0.5rem;
            cursor: pointer;
            font-size: 0.9rem;
            border: none;
        }

        .btn-primary {
            background-color: var(--darkblue);
            color: white;
        }

        .btn-primary:hover {
            background-color: var(--lightblue);
        }

        .btn-warning {
            background-color: #ff9800;
            color: white;
        }

        .btn-warning:hover {
            background-color: #e68a00;
        }

        .btn-danger {
            background-color: #f44336;
            color: white;
        }

        .btn-danger:hover {
            background-color: #d32f2f;
        }

        .actions {
            margin-top: 2rem;
            text-align: center;
        }

        .btn-outline {
            background-color: transparent;
            color: var(--darkblue);
            border: 1px solid var(--darkblue);
        }

        .btn-outline:hover {
            background-color: var(--darkblue);
            color: white;
        }

        .search-container {
            margin-bottom: 2rem;
        }

        .search-input {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 1rem;
            margin-bottom: 1rem;
        }

        .search-input:focus {
            outline: none;
            border-color: var(--lightblue);
            box-shadow: 0 0 0 2px rgba(83, 75, 174, 0.2);
        }

        .empty-message {
            text-align: center;
            padding: 2rem;
            color: #757575;
            font-style: italic;
        }

        @media (max-width: 768px) {
            .container {
                max-width: 100%;
                padding: 1rem;
            }
            
            th, td {
                padding: 0.5rem;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Liste des Entreprises</h1>

        <div class="search-container">
            <input type="text" id="searchInput" class="search-input" placeholder="Rechercher une entreprise...">
        </div>

        <div class="table-container">
            <table id="entreprisesTable">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Nom</th>
                        <th>Adresse</th>
                        <th>Chiffre d'Affaire</th>
                        <th>Date de Création</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% if(entreprises != null && !entreprises.isEmpty()) { 
                        for(Entreprise entreprise : entreprises) { %>
                    <tr>
                        <td><%= entreprise.getId() %></td>
                        <td><%= entreprise.getNomEntrep() %></td>
                        <td><%= entreprise.getAdresseEntrep() %></td>
                        <td><%= entreprise.getChiffreAffaire() %></td>
                        <td><%= entreprise.getDateCreation() %></td>
                        <td>
                           
                            <a href="deleteEntreprise.jsp?id=<%= entreprise.getId() %>" class="btn btn-danger" onclick="return confirm('Êtes-vous sûr de vouloir supprimer cette entreprise?')">Supprimer</a>
                        </td>
                    </tr>
                    <% } 
                    } else { %>
                    <tr>
                        <td colspan="6" class="empty-message">Aucune entreprise trouvée</td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>

        <div class="actions">
            <a href="creerEntreprise.jsp" class="btn btn-primary">Ajouter une entreprise</a>
            <button class="btn btn-outline" onclick="window.location.href='adminProfile.jsp'">
                Retour à l'accueil
            </button>
        </div>
    </div>

    <script>
        // Script pour la recherche dans le tableau
        document.getElementById('searchInput').addEventListener('keyup', function() {
            const searchValue = this.value.toLowerCase();
            const table = document.getElementById('entreprisesTable');
            const rows = table.getElementsByTagName('tr');

            for (let i = 1; i < rows.length; i++) {
                let found = false;
                const cells = rows[i].getElementsByTagName('td');
                
                // Si c'est un message "aucune entreprise", on le saute
                if (cells.length === 1 && cells[0].className === 'empty-message') {
                    continue;
                }

                for (let j = 0; j < cells.length - 1; j++) { // On exclut la colonne des actions
                    const cellValue = cells[j].textContent || cells[j].innerText;
                    if (cellValue.toLowerCase().indexOf(searchValue) > -1) {
                        found = true;
                        break;
                    }
                }

                if (found) {
                    rows[i].style.display = '';
                } else {
                    rows[i].style.display = 'none';
                }
            }
        });
    </script>
</body>
</html>