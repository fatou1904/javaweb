package mesfichiers;

import org.mindrot.jbcrypt.BCrypt;

public class HashAdminPassword {
    public static void main(String[] args) {
        String password = "passer1234";  // Remplacez par le mot de passe actuel
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

        System.out.println("Mot de passe haché : " + hashedPassword);
        // Utilisez cette valeur pour mettre à jour la base de données
    }
}
