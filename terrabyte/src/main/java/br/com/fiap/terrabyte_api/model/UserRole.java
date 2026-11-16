package br.com.fiap.terrabyte_api.model;

public enum UserRole {
	
	ADMIN("Administrador"), USER("Usuário");
	
	private String descricao;
	
	UserRole(String descricao) {
		this.descricao = descricao;
	}
	
	public String getDescricao() {
		return this.descricao;
	}

}
