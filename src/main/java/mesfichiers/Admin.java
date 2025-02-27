package mesfichiers;

public class Admin {
	private int id;
	private String login;
	private String password;
	
	
	public Admin(int id, String login, String password) {
		super();
		this.id = id;
		this.login = login;
		this.password = password;
	}
	public String getLogin() {
		return login;
	}
	public void setLogin(String login) {
		this.login = login;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public Admin(String login, String password) {
		super();
		this.login = login;
		this.password = password;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	
	

}
