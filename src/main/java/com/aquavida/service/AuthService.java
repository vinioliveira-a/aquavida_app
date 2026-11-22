
package com.aquavida.service;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.aquavida.dto.LoginRespostaDTO;
import com.aquavida.dto.UsuarioRespostaDTO;
import com.aquavida.exception.RegraNegocioException;
import com.aquavida.model.Usuario;
import com.aquavida.repository.UsuarioRepository;
import com.aquavida.security.JwtService;

@Service
public class AuthService {

    private final UsuarioRepository usuarioRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;

    public AuthService(
            UsuarioRepository usuarioRepository,
            PasswordEncoder passwordEncoder,
            JwtService jwtService) {

        this.usuarioRepository = usuarioRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
    }

    // Realiza a autenticação do usuário
    public LoginRespostaDTO autenticar(String email, String senha) {

        if (email == null || email.isBlank()
                || senha == null || senha.isBlank()) {

            throw new RegraNegocioException(
                    "Informe o e-mail e a senha."
            );
        }

        // Busca o usuário pelo e-mail
        Usuario usuario = usuarioRepository
                .findByEmail(email)
                .orElseThrow(() -> new RegraNegocioException(
                        "E-mail ou senha inválidos."
                ));

        // Confere a senha utilizando BCrypt
        if (!passwordEncoder.matches(senha, usuario.getSenha())) {

            throw new RegraNegocioException(
                    "E-mail ou senha inválidos."
            );
        }

        // Gera o token JWT
        String token = jwtService.gerarToken(usuario.getEmail());

        // Prepara os dados públicos do usuário
        UsuarioRespostaDTO usuarioDTO =
                new UsuarioRespostaDTO(usuario);

        // Retorna o token e os dados do usuário
        return new LoginRespostaDTO(token, usuarioDTO);
    }
}
