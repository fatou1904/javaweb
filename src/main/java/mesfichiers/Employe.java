package mesfichiers;

import java.time.LocalDate;

public class Employe {
	private int matricule;
	private String nomEmp;
	private String prenomEmp;
	private String fonctionEmp;
	private String serviceEmp;
	private LocalDate dateEmbauche;
	private String sexeEmp;
	private double salaireBase;
	private Entreprise entreprise;
	
	public int getMatricule() {
		return matricule;
	}
	public void setMatricule(int matricule) {
		this.matricule = matricule;
	}
	public String getNomEmp() {
		return nomEmp;
	}
	public void setNomEmp(String nomEmp) {
		this.nomEmp = nomEmp;
	}
	public String getPrenomEmp() {
		return prenomEmp;
	}
	public void setPrenomEmp(String prenomEmp) {
		this.prenomEmp = prenomEmp;
	}
	public String getFonctionEmp() {
		return fonctionEmp;
	}
	public void setFonctionEmp(String fonctionEmp) {
		this.fonctionEmp = fonctionEmp;
	}
	public String getServiceEmp() {
		return serviceEmp;
	}
	public void setServiceEmp(String serviceEmp) {
		this.serviceEmp = serviceEmp;
	}
	public LocalDate getDateEmbauche() {
		return dateEmbauche;
	}
	public void setDateEmbauche(LocalDate dateEmbauche) {
		this.dateEmbauche = dateEmbauche;
	}
	public String getSexeEmp() {
		return sexeEmp;
	}
	public void setSexeEmp(String sexeEmp) {
		this.sexeEmp = sexeEmp;
	}
	public double getSalaireBase() {
		return salaireBase;
	}
	public void setSalaireBase(double salaireBase) {
		this.salaireBase = salaireBase;
	}
	public Entreprise getnomEntrep() {
		return entreprise;
	}
	public void setnomEntrep(Entreprise nomEntrep) {
		this.entreprise = nomEntrep;
	}

	
	
}
