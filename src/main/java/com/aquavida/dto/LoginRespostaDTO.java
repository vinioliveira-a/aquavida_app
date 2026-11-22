
package com.aquavida.dto;

public class LoginRespostaDTO {

    private String token;
    private UsuarioRespostaDTO usuario;

    public LoginRespostaDTO() {
    }

    public LoginRespostaDTO(
            String token,
            UsuarioRespostaDTO usuario) {

        this.token = token;
        this.usuario = usuario;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public UsuarioRespostaDTO getUsuario() {
        return usuario;
    }

    public void setUsuario(UsuarioRespostaDTO usuario) {
        this.usuario = usuario;
    }
}
