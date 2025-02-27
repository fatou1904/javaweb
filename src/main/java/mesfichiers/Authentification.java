package mesfichiers;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.mindrot.jbcrypt.BCrypt;

public class Authentification {
    
    public boolean authenticateAdmin(String login, String password) {
        if (login == null || password == null) {
            return false;
        }
        
        String query = "SELECT password FROM admin WHERE login = ?";
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {
            
            statement.setString(1, login.trim().toLowerCase());
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    String storedHash = resultSet.getString("password");
                    return BCrypt.checkpw(password, storedHash);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public static void main(String[] args) {
        Authentification authService = new Authentification();
        String loginAdmin = "admin@entreprise.sn";
        String passwordAdmin = "passer1234";
        
        if (authService.authenticateAdmin(loginAdmin, passwordAdmin)) {
            System.out.println("Authentification admin réussie!");
        } else {
            System.out.println("Authentification admin échouée.");
        }
    }
}