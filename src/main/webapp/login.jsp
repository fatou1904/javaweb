<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion</title>
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
            max-width: 400px;
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
            position: relative;
        }

        label {
            display: block;
            margin-bottom: 0.5rem;
            color: var(--darkblue);
            font-weight: 600;
        }

        input {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 1rem;
            transition: border-color 0.3s ease;
        }

        input:focus {
            outline: none;
            border-color: var(--lightblue);
            box-shadow: 0 0 0 2px rgba(83, 75, 174, 0.2);
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
            color: #dc3545;
            font-size: 0.875rem;
            margin-top: 0.25rem;
            display: none;
        }

        .alert {
            padding: 1rem;
            margin-bottom: 1rem;
            border-radius: 5px;
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
            display: none;
        }

        .alert.show {
            display: block;
        }

        .password-toggle {
            position: absolute;
            right: 10px;
            top: 35px;
            cursor: pointer;
            color: var(--darkblue);
        }

        .signup-link {
            text-align: center;
            margin-top: 1rem;
        }

        .signup-link a {
            color: var(--darkblue);
            text-decoration: none;
        }

        .signup-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Connexion</h1>
        
        <!-- Affichage des messages d'erreur du serveur -->
        <% if(request.getAttribute("errorMessage") != null) { %>
            <div class="alert show">
                <%= request.getAttribute("errorMessage") %>
            </div>
        <% } %>

        <form id="loginForm" method="post" action="traitement.jsp" onsubmit="return validateForm()">
            <div class="form-group">
                <label for="login">login</label>
                <input type="login" id="login" name="login" required>
                <span class="error" id="loginError">Veuillez entrer un login valide</span>
            </div>
            
            <div class="form-group">
                <label for="password">Mot de passe</label>
                <input type="password" id="password" name="password" required>
                <span class="password-toggle" onclick="togglePassword()">👁️</span>
                <span class="error" id="passwordError">Le mot de passe est requis</span>
            </div>
            
            <button type="submit">Se connecter</button>
        </form>
    </div>
     

    <script>
        function validateForm() {
            const form = document.getElementById('loginForm');
            let isValid = true;

            // Réinitialiser les messages d'erreur
            document.querySelectorAll('.error').forEach(error => {
                error.style.display = 'none';
            });

            // Valider login
            const login = form.login.value.trim();
            const loginRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!loginRegex.test(login)) {
                document.getElementById('loginError').style.display = 'block';
                isValid = false;
            }

            // Valider mot de passe
            const password = form.password.value.trim();
            if (!password) {
                document.getElementById('passwordError').style.display = 'block';
                isValid = false;
            }

            return isValid;
        }

        function togglePassword() {
            const passwordInput = document.getElementById('password');
            const toggle = document.querySelector('.password-toggle');
            
            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                toggle.textContent = '🔒';
            } else {
                passwordInput.type = 'password';
                toggle.textContent = '👁️';
            }
        }

        // Masquer les messages d'erreur lors de la saisie
        document.querySelectorAll('input').forEach(input => {
            input.addEventListener('input', function() {
                const errorId = this.id + 'Error';
                const errorElement = document.getElementById(errorId);
                if (errorElement) {
                    errorElement.style.display = 'none';
                }
            });
        });

        // Masquer l'alerte après 5 secondes
        setTimeout(() => {
            const alert = document.querySelector('.alert');
            if (alert) {
                alert.style.display = 'none';
            }
        }, 5000);
    </script>
</body>
</html>