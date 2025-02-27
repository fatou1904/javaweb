package mesfichiers;

import java.time.LocalDate;

public class Entreprise {
	private int id;
	private String nomEntrep;
	private String adresseEntrep;
	private double chiffreAffaire;
	private LocalDate dateCreation;
	
	public Entreprise() {
		// TODO Auto-generated constructor stub
	}
	
	
	
	public Entreprise(int id, String nomEntrep, String adresseEntrep, double chiffreAffaire, LocalDate dateCreation) {
		super();
		this.id = id;
		this.nomEntrep = nomEntrep;
		this.adresseEntrep = adresseEntrep;
		this.chiffreAffaire = chiffreAffaire;
		this.dateCreation = dateCreation;
	}
	public String getNomEntrep() {
		return nomEntrep;
	}
	public void setNomEntrep(String nomEntrep) {
		this.nomEntrep = nomEntrep;
	}
	public String getAdresseEntrep() {
		return adresseEntrep;
	}
	public void setAdresseEntrep(String adresseEntrep) {
		this.adresseEntrep = adresseEntrep;
	}
	public double getChiffreAffaire() {
		return chiffreAffaire;
	}
	public void setChiffreAffaire(Double chiffreAffaire) {
		this.chiffreAffaire = chiffreAffaire;
	}
	public LocalDate getDateCreation() {
		return dateCreation;
	}
	public void setDateCreation(LocalDate dateCreation) {
		this.dateCreation = dateCreation;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}
	
	

}
