package com.aquavida.service;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.aquavida.dto.CadastroUsuarioDTO;
import com.aquavida.model.Usuario;
import com.aquavida.repository.UsuarioRepository;
import com.aquavida.exception.RegraNegocioException;
@Service
public class UsuarioService {

    private final UsuarioRepository usuarioRepository;
    private final PasswordEncoder passwordEncoder;

    // Injeção de dependência
    public UsuarioService(
            UsuarioRepository usuarioRepository,
            PasswordEncoder passwordEncoder) {

        this.usuarioRepository = usuarioRepository;
        this.passwordEncoder = passwordEncoder;
    }

    // Método responsável pelo cadastro
    public Usuario cadastrar(CadastroUsuarioDTO dados) {

        // Verifica campos obrigatórios
        if (dados == null
                || dados.getNomeUsuario() == null
                || dados.getNomeUsuario().isBlank()
                || dados.getEmail() == null
                || dados.getEmail().isBlank()
                || dados.getSenha() == null
                || dados.getSenha().isBlank()
                || dados.getNome() == null
                || dados.getNome().isBlank()) {

            throw new RegraNegocioException(
                    "Preencha todos os campos obrigatórios."
            );
        }

        // Verifica se o e-mail já está cadastrado
        if (usuarioRepository.existsByEmail(dados.getEmail())) {
            throw new RegraNegocioException(
                    "Este e-mail já está cadastrado."
            );
        }

        // Verifica se o nome de usuário já existe
        if (usuarioRepository.existsByNomeUsuario(dados.getNomeUsuario())) {
            throw new RegraNegocioException(
                    "Este nome de usuário já está em uso."
            );
        }

        // Cria o usuário
        Usuario usuario = new Usuario();

        usuario.setNomeUsuario(dados.getNomeUsuario());
        usuario.setEmail(dados.getEmail());
        usuario.setNome(dados.getNome());

        // Criptografa a senha antes de salvar
        usuario.setSenha(passwordEncoder.encode(dados.getSenha()));

        usuario.setPesoKg(dados.getPesoKg());
        usuario.setDataNascimento(dados.getDataNascimento());
        usuario.setNivelAtividade(dados.getNivelAtividade());

        // Salva no banco de dados
        return usuarioRepository.save(usuario);
    }
}
