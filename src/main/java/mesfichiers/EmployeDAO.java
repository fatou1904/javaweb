package mesfichiers;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class EmployeDAO {
    
    // Constructeur par défaut
    public EmployeDAO() {}
    
    // Pour gérer la relation avec Entreprise
    private EntrepriseDAO entrepriseDAO = new EntrepriseDAO();
    
    public Employe getById(int matricule) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Employe employe = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            String sql = "SELECT e.*, ent.* FROM employe e " +
                         "LEFT JOIN entreprise ent ON e.entreprise_id = ent.id " +
                         "WHERE e.matricule = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, matricule);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                employe = new Employe();
                employe.setMatricule(rs.getInt("matricule"));
                employe.setNomEmp(rs.getString("nomEmp"));
                employe.setPrenomEmp(rs.getString("prenomEmp"));
                employe.setFonctionEmp(rs.getString("fonctionEmp"));
                employe.setServiceEmp(rs.getString("serviceEmp"));
                employe.setDateEmbauche(rs.getDate("dateEmbauche").toLocalDate());
                employe.setSexeEmp(rs.getString("sexeEmp"));
                employe.setSalaireBase(rs.getDouble("salaireBase"));
                
                // Récupération de l'entreprise
                int entrepriseId = rs.getInt("entreprise_id");
                if (!rs.wasNull()) {
                    Entreprise entreprise = new Entreprise();
                    entreprise.setId(entrepriseId);
                    entreprise.setNomEntrep(rs.getString("ent.nom"));
                    // Ajouter d'autres propriétés de l'entreprise si nécessaire
                    
                    employe.setnomEntrep(entreprise);
                }
            }
        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }
        
        return employe;
    }
    
    public void update(Employe employe) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            String sql = "UPDATE employe SET nomEmp=?, prenomEmp=?, fonctionEmp=?, serviceEmp=?, " +
                        "dateEmbauche=?, sexeEmp=?, salaireBase=?, entreprise_id=? " +
                        "WHERE matricule=?";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, employe.getNomEmp());
            pstmt.setString(2, employe.getPrenomEmp());
            pstmt.setString(3, employe.getFonctionEmp());
            pstmt.setString(4, employe.getServiceEmp());
            pstmt.setDate(5, java.sql.Date.valueOf(employe.getDateEmbauche()));
            pstmt.setString(6, employe.getSexeEmp());
            pstmt.setDouble(7, employe.getSalaireBase());
            
            // Gestion de la relation avec Entreprise
            if (employe.getnomEntrep() != null) {
                pstmt.setInt(8, employe.getnomEntrep().getId());
            } else {
                pstmt.setNull(8, Types.INTEGER);
            }
            
            pstmt.setInt(9, employe.getMatricule());
            
            pstmt.executeUpdate();
        } finally {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }
    }
    
    public List<Employe> getAllEmployes() throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Employe> employes = new ArrayList<>();

        try {
            conn = DatabaseConnection.getConnection();
            String sql = "SELECT * FROM employe";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Employe employe = new Employe();
                employe.setMatricule(rs.getInt("matricule"));
                employe.setNomEmp(rs.getString("nomEmp"));
                employe.setPrenomEmp(rs.getString("prenomEmp"));
                employe.setFonctionEmp(rs.getString("fonctionEmp"));
                employe.setSalaireBase(rs.getDouble("salaireBase"));
                employes.add(employe);
            }

            System.out.println("Nombre d'employés récupérés : " + employes.size());

        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }

        return employes;
    }

    public boolean delete(int matricule) {
        String sql = "DELETE FROM employe WHERE matricule = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, matricule);
            int rowsAffected = pstmt.executeUpdate();
            
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Erreur lors de la suppression de l'employé avec matricule " + matricule + " : " + e.getMessage());
        }
        
        return false;
    }
    
    public boolean insert(Employe employe) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        
        try {
            conn = DatabaseConnection.getConnection();
            String sql = "INSERT INTO employe (nomEmp, prenomEmp, fonctionEmp, serviceEmp, dateEmbauche, " +
                         "sexeEmp, salaireBase, entreprise_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, employe.getNomEmp());
            pstmt.setString(2, employe.getPrenomEmp());
            pstmt.setString(3, employe.getFonctionEmp());
            pstmt.setString(4, employe.getServiceEmp());
            pstmt.setDate(5, java.sql.Date.valueOf(employe.getDateEmbauche()));
            pstmt.setString(6, employe.getSexeEmp());
            pstmt.setDouble(7, employe.getSalaireBase());
            
            // Gestion de la relation avec Entreprise
            if (employe.getnomEntrep() != null) {
                pstmt.setInt(8, employe.getnomEntrep().getId());
            } else {
                pstmt.setNull(8, Types.INTEGER);
            }
            
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
    
    

        public Employe getEmployeDetails(int matricule) {
            Employe employe = null;
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            
            try {
                conn = DatabaseConnection.getConnection();
                String sql = "SELECT e.*, ent.* FROM employe e " +
                             "INNER JOIN entreprise ent ON e.entreprise_id = ent.id " +
                             "WHERE e.matricule = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, matricule);
                rs = pstmt.executeQuery();
                
                if (rs.next()) {
                    employe = new Employe();
                    employe.setMatricule(rs.getInt("matricule"));
                    employe.setNomEmp(rs.getString("nomEmp"));
                    employe.setPrenomEmp(rs.getString("prenomEmp"));
                    employe.setFonctionEmp(rs.getString("fonctionEmp"));
                    employe.setServiceEmp(rs.getString("serviceEmp"));
                    employe.setDateEmbauche(rs.getDate("dateEmbauche").toLocalDate());
                    employe.setSexeEmp(rs.getString("sexeEmp"));
                    employe.setSalaireBase(rs.getDouble("salaireBase"));
                    
                    // Récupérer les détails de l'entreprise
                    Entreprise entreprise = new Entreprise();
                    entreprise.setId(rs.getInt("id"));
                    entreprise.setNomEntrep(rs.getString("nomEntrep"));
                    entreprise.setAdresseEntrep(rs.getString("adresseEntrep"));
                    entreprise.setChiffreAffaire(rs.getDouble("chiffreAffaire"));
                    entreprise.setDateCreation(rs.getDate("dateCreation").toLocalDate());
                    
                    employe.setnomEntrep(entreprise); // Associer l'entreprise à l'employé
                }
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                // Fermer les ressources
                if (rs != null) try { rs.close(); } catch (SQLException e) { }
                if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { }
                if (conn != null) try { conn.close(); } catch (SQLException e) { }
            }
            
            return employe;
        }
    

}