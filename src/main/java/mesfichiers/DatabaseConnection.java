package mesfichiers;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/employe_gestion_db";
    private static final String USER = "root";
    private static final String PASSWORD = "";

    public static Connection getConnection() throws SQLException {
        try {
            System.out.println("Chargement du driver JDBC...");
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("Driver JDBC chargé avec succès !");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            throw new SQLException("Driver JDBC non trouvé !", e);
        }

        System.out.println("Connexion à la base de données...");
        Connection connection = DriverManager.getConnection(URL, USER, PASSWORD);
        System.out.println("Connexion réussie !");
        return connection;
    }

    public static void main(String[] args) {
        try (Connection conn = getConnection()) {
            if (conn != null) {
                System.out.println("🔌 Connexion test OK.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
