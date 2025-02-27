package mesfichiers;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class EntrepriseDAO {
    
    // Constructeur par défaut
    public EntrepriseDAO() {}
    
    // Récupérer une entreprise par son ID
    public Entreprise getById(int id) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Entreprise entreprise = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            String sql = "SELECT * FROM entreprise WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                entreprise = new Entreprise();
                entreprise.setId(rs.getInt("id"));
                entreprise.setNomEntrep(rs.getString("nomEntrep"));
                entreprise.setAdresseEntrep(rs.getString("adresseEntrep"));
                entreprise.setChiffreAffaire(rs.getDouble("chiffreAffaire"));
                
                java.sql.Date sqlDate = rs.getDate("dateCreation");
                if (sqlDate != null) {
                    entreprise.setDateCreation(sqlDate.toLocalDate());
                }
            }
        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }
        
        return entreprise;
    }
    
    // Récupérer une entreprise par son nom
    public Entreprise getByNom(String nom) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Entreprise entreprise = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            String sql = "SELECT * FROM entreprise WHERE nomEntrep = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, nom);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                entreprise = new Entreprise();
                entreprise.setId(rs.getInt("id"));
                entreprise.setNomEntrep(rs.getString("nomEntrep"));
                entreprise.setAdresseEntrep(rs.getString("adresseEntrep"));
                entreprise.setChiffreAffaire(rs.getDouble("chiffreAffaire"));
                
                java.sql.Date sqlDate = rs.getDate("dateCreation");
                if (sqlDate != null) {
                    entreprise.setDateCreation(sqlDate.toLocalDate());
                }
            }
        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }
        
        return entreprise;
    }
    
    // Récupérer toutes les entreprises
    public List<Entreprise> getAllEntreprises() throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Entreprise> entreprises = new ArrayList<>();
        
        try {
            conn = DatabaseConnection.getConnection();
            String sql = "SELECT * FROM entreprise";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Entreprise entreprise = new Entreprise();
                entreprise.setId(rs.getInt("id"));
                entreprise.setNomEntrep(rs.getString("nomEntrep"));
                entreprise.setAdresseEntrep(rs.getString("adresseEntrep"));
                entreprise.setChiffreAffaire(rs.getDouble("chiffreAffaire"));
                
                java.sql.Date sqlDate = rs.getDate("dateCreation");
                if (sqlDate != null) {
                    entreprise.setDateCreation(sqlDate.toLocalDate());
                }
                
                entreprises.add(entreprise);
            }
        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }
        
        return entreprises;
    }
    
    // Mettre à jour une entreprise
    public void update(Entreprise entreprise) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            String sql = "UPDATE entreprise SET nomEntrep = ?, adresseEntrep = ?, chiffreAffaire = ?, dateCreation = ? WHERE id = ?";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, entreprise.getNomEntrep());
            pstmt.setString(2, entreprise.getAdresseEntrep());
            pstmt.setDouble(3, entreprise.getChiffreAffaire());
            
            if (entreprise.getDateCreation() != null) {
                pstmt.setDate(4, java.sql.Date.valueOf(entreprise.getDateCreation()));
            } else {
                pstmt.setNull(4, Types.DATE);
            }
            
            pstmt.setInt(5, entreprise.getId());
            
            pstmt.executeUpdate();
        } finally {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }
    }
    
    // Insérer une nouvelle entreprise
    public boolean insert(Entreprise entreprise) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet generatedKeys = null;
        boolean success = false;
        
        try {
            conn = DatabaseConnection.getConnection();
            String sql = "INSERT INTO entreprise (nomEntrep, adresseEntrep, chiffreAffaire, dateCreation) VALUES (?, ?, ?, ?)";
            
            pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, entreprise.getNomEntrep());
            pstmt.setString(2, entreprise.getAdresseEntrep());
            pstmt.setDouble(3, entreprise.getChiffreAffaire());
            
            if (entreprise.getDateCreation() != null) {
                pstmt.setDate(4, java.sql.Date.valueOf(entreprise.getDateCreation()));
            } else {
                pstmt.setNull(4, Types.DATE);
            }
            
            int rowsAffected = pstmt.executeUpdate();
            
            if (rowsAffected > 0) {
                // Récupérer l'ID auto-généré
                generatedKeys = pstmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    entreprise.setId(generatedKeys.getInt(1));
                }
                success = true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (generatedKeys != null) generatedKeys.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return success;
    }
    
    // Supprimer une entreprise
    public boolean delete(int id) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        
        try {
            conn = DatabaseConnection.getConnection();
            // Vous pourriez avoir besoin de gérer les contraintes de clé étrangère ici
            // Peut-être mettre à null les entreprise_id dans la table employe avant de supprimer
            
            String sql = "DELETE FROM entreprise WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            
            int rowsAffected = pstmt.executeUpdate();
            success = (rowsAffected > 0);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return success;
    }
    
    // Récupérer la liste des employés d'une entreprise
    public List<Employe> getEmployesByEntreprise(int entrepriseId) throws SQLException {
        EmployeDAO employeDAO = new EmployeDAO();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Employe> employes = new ArrayList<>();
        
        try {
            conn = DatabaseConnection.getConnection();
            String sql = "SELECT matricule FROM employe WHERE entreprise_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, entrepriseId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                int matricule = rs.getInt("matricule");
                Employe employe = employeDAO.getById(matricule);
                if (employe != null) {
                    employes.add(employe);
                }
            }
        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }
        
        return employes;
    }
}