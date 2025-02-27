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
    <title>Formulaire d'Inscription</title>
    <style>
    
        /* Styles précédents conservés */
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
            max-width: 50%;
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

        .form-group {
            margin-bottom: 1.5rem;
        }

        label {
            display: block;
            margin-bottom: 0.5rem;
            color: var(--darkblue);
            font-weight: 600;
        }

        input, select {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 1rem;
            transition: border-color 0.3s ease;
        }

        input:focus, select:focus {
            outline: none;
            border-color: var(--lightblue);
            box-shadow: 0 0 0 2px rgba(83, 75, 174, 0.2);
        }

        .row {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
        }

        .col {
            flex: 1;
            min-width: 250px;
        }

        button {
            background-color: var(--darkblue);
            color: white;
            padding: 1rem 2rem;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 1rem;
            width: 100%;
            transition: background-color 0.3s ease;
        }

        button:hover {
            background-color: var(--lightblue);
        }

        .error {
            color: red;
            font-size: 0.875rem;
            margin-top: 0.25rem;
            display: none;
        }

        /* Nouveaux styles pour la photo */
        .photo-upload {
            text-align: center;
            margin-bottom: 2rem;
        }

        .photo-preview {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            margin: 1rem auto;
            border: 2px dashed var(--darkblue);
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            position: relative;
        }

        .photo-preview img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: none;
        }

        .photo-preview.has-image img {
            display: block;
        }

        .photo-icon {
            font-size: 3rem;
            color: var(--darkblue);
        }

        .photo-input {
            display: none;
        }

        .photo-label {
            background-color: var(--darkblue);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 5px;
            cursor: pointer;
            display: inline-block;
            margin-top: 1rem;
            transition: background-color 0.3s ease;
        }

        .photo-label:hover {
            background-color: var(--lightblue);
        }

        @media (max-width: 600px) {
            .container {
                padding: 1rem;
            }
            
            .row {
                flex-direction: column;
                gap: 10px;
            }
            
            .col {
                width: 100%;
            }
        }
    </style>
</head>
<body>

    <div class="container">
        <h1>Formulaire d'Inscription</h1>
        
        <!-- Affichage des messages d'erreur -->
        <% if(request.getAttribute("errorMessage") != null) { %>
            <div class="error-message" style="color: red; margin-bottom: 20px; text-align: center;">
                <%= request.getAttribute("errorMessage") %>
            </div>
        <% } %>

        <form id="inscriptionForm" method="post" action="verification.jsp" onsubmit="return valifonctionEmpForm()">
            <div class="row">
                <div class="col">
                    <div class="form-group">
                        <label for="nomEmp">Nom</label>
                        <input type="text" id="nomEmp" name="nomEmp" required>
                        <span class="error" id="nomError">Le nom est requis</span>
                    </div>
                </div>
                <div class="col">
                    <div class="form-group">
                        <label for="prenomEmp">Prénom</label>
                        <input type="text" id="prenomEmp" name="prenomEmp" required>
                        <span class="error" id="prenomError">Le prénom est requis</span>
                    </div>
                </div>
            </div>
            
            <div class="form-group">
                <label for="fonctionEmp">fonction</label>
                <input type="fonctionEmp" id="fonctionEmp" name="fonctionEmp" required>
                <span class="error" id="fonctionEmpError">fonctionEmp invalide</span>
            </div>

            <div class="form-group">
                <label for="serviceEmp">Service</label>
                <input type="serviceEmp" id="serviceEmp" name="serviceEmp" required>
                <span class="error" id="serviceEmpError">serviceEmp invalide</span>
            </div>
            
            
            <div class="form-group">
                <label for="sexeEmp">Sexe</label>
                <select id="sexeEmp" name="sexeEmp" required>
                    <option value="">Sélectionnez</option>
                    <option value="M">Masculin</option>
                    <option value="F">Féminin</option>
                </select>
                <span class="error" id="sexeEmpError">Veuillez sélectionner un sexeEmp</span>
            </div>

            <div class="form-group">
                <label for="dateEmbauche">Date Embauche</label>
                <input type="date" id="dateEmbauche" name="dateEmbauche" required>
                <span class="error" id="dateEmbaucheError">Numéro de téléphone invalide</span>
            </div>
            
            <div class="form-group">
                <label for="salaireBase">Salaire Base</label>
                <input type="text" id="salaireBase" name="salaireBase" required>
                <span class="error" id="salaireBaseError">La nationalité est requise</span>
            </div>
			
		<div class="form-group">
    <label for="entrepriseId">Entreprise :</label>
    <select id="entrepriseId" name="entrepriseId" required>
        <option value="">Sélectionnez une entreprise</option>
        <%
            // Ne déclarez pas à nouveau "entreprises"
            if (entreprises != null) {
                for (Entreprise entreprise : entreprises) {
        %>
                    <option value="<%= entreprise.getId() %>"><%= entreprise.getNomEntrep() %></option>
        <%
                }
            }
        %>
    </select>
    <span class="error" id="entrepriseError">Veuillez sélectionner une entreprise</span>
</div>

			
            

            <button type="submit">S'inscrire</button>
        </form>
    </div>
    
    

    <script>
    function validForm() {
        let isValid = true;
        const form = document.getElementById('inscriptionForm');
        
        // Reset all errors
        document.querySelectorAll('.error').forEach(error => {
            error.style.display = 'none';
        });

        // Valider nom
        if (!form.nomEmp.value.trim()) {
            document.getElementById('nomError').style.display = 'block';
            isValid = false;
        }

        // Valider prénom
        if (!form.prenomEmp.value.trim()) {
            document.getElementById('prenomError').style.display = 'block';
            isValid = false;
        }

        // Valider fonction
        if (!form.fonctionEmp.value.trim()) {
            document.getElementById('fonctionEmpError').style.display = 'block';
            isValid = false;
        }

        // Valider service
        if (!form.serviceEmp.value.trim()) {
            document.getElementById('serviceEmpError').style.display = 'block';
            isValid = false;
        }

        // Valider sexe
        if (!form.sexeEmp.value) {
            document.getElementById('sexeEmpError').style.display = 'block';
            isValid = false;
        }

        // Valider date
        if (!form.dateEmbauche.value) {
            document.getElementById('dateEmbaucheError').style.display = 'block';
            isValid = false;
        }

        // Valider salaire
        if (!form.salaireBase.value) {
            document.getElementById('salaireBaseError').style.display = 'block';
            isValid = false;
        }

        // Valider entreprise
        if (!form.entrepriseId.value) {
            document.getElementById('entrepriseError').style.display = 'block';
            isValid = false;
        }

        return isValid;
    }    </script>
</body>
</html>