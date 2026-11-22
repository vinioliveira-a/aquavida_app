
package com.aquavida.service;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.aquavida.dto.CadastroUsuarioDTO;
import com.aquavida.dto.LoginRespostaDTO;
import com.aquavida.dto.UsuarioRespostaDTO;
import com.aquavida.exception.RegraNegocioException;
import com.aquavida.model.Usuario;
import com.aquavida.repository.UsuarioRepository;
import com.aquavida.security.JwtService;

@Service
public class UsuarioService {

    private final UsuarioRepository usuarioRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;

    // Injeção de dependência
    public UsuarioService(
            UsuarioRepository usuarioRepository,
            PasswordEncoder passwordEncoder,
            JwtService jwtService) {

        this.usuarioRepository = usuarioRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
    }

    // Método responsável pelo cadastro
    public LoginRespostaDTO cadastrar(CadastroUsuarioDTO dados) {

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
        String senhaCriptografada =
                passwordEncoder.encode(dados.getSenha());

        // Salva o mesmo hash nas duas colunas do banco
        usuario.setSenha(senhaCriptografada);
        usuario.setSenhaHash(senhaCriptografada);

        usuario.setPesoKg(dados.getPesoKg());
        usuario.setDataNascimento(dados.getDataNascimento());
        usuario.setNivelAtividade(dados.getNivelAtividade());
        usuario.setMetaDiariaMl(dados.getMetaDiariaMl());

        // Salva o usuário no banco de dados
        Usuario usuarioSalvo = usuarioRepository.save(usuario);

        // Gera o token JWT para o usuário cadastrado
        String token = jwtService.gerarToken(usuarioSalvo.getEmail());

        // Prepara os dados públicos do usuário
        UsuarioRespostaDTO usuarioDTO =
                new UsuarioRespostaDTO(usuarioSalvo);

        // Retorna o token e os dados do usuário
        return new LoginRespostaDTO(token, usuarioDTO);
    }
}
