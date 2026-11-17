
package com.aquavida.service;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.List;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.aquavida.exception.RegraNegocioException;
import com.aquavida.model.CodigoRecuperacao;
import com.aquavida.model.Usuario;
import com.aquavida.repository.CodigoRecuperacaoRepository;
import com.aquavida.repository.UsuarioRepository;

@Service
public class RecuperacaoSenhaService {

    private final CodigoRecuperacaoRepository codigoRepository;
    private final UsuarioRepository usuarioRepository;
    private final PasswordEncoder passwordEncoder;

    private final SecureRandom random = new SecureRandom();

    public RecuperacaoSenhaService(
            CodigoRecuperacaoRepository codigoRepository,
            UsuarioRepository usuarioRepository,
            PasswordEncoder passwordEncoder) {

        this.codigoRepository = codigoRepository;
        this.usuarioRepository = usuarioRepository;
        this.passwordEncoder = passwordEncoder;
    }

    // Gera um código numérico de seis dígitos
    private String gerarCodigo() {

        int numero = 100000 + random.nextInt(900000);

        return String.valueOf(numero);
    }

    // Cria e armazena um código de recuperação
    public String criarCodigoRecuperacao(String email) {

        Usuario usuario = usuarioRepository
                .findByEmail(email)
                .orElseThrow(() -> new RegraNegocioException(
                        "Usuário não encontrado."
                ));

        String codigo = gerarCodigo();

        CodigoRecuperacao recuperacao = new CodigoRecuperacao();

        // Armazena somente o hash do código
        recuperacao.setCodigo(passwordEncoder.encode(codigo));

        recuperacao.setDataExpiracao(
                LocalDateTime.now().plusMinutes(10)
        );

        recuperacao.setUtilizado(false);
        recuperacao.setUsuario(usuario);

        codigoRepository.save(recuperacao);

        // Retorna o código original para futura entrega ao usuário
        return codigo;
    }

    // Valida o código de recuperação
    public CodigoRecuperacao validarCodigo(
            String email,
            String codigo) {

        if (email == null || email.isBlank()
                || codigo == null || codigo.isBlank()) {

            throw new RegraNegocioException(
                    "Informe o e-mail e o código de recuperação."
            );
        }

        // Busca os códigos ativos associados ao e-mail
        List<CodigoRecuperacao> recuperacoes =
                codigoRepository.findAllByUsuarioEmailAndUtilizadoFalse(email);

        LocalDateTime agora = LocalDateTime.now();

        // Procura um código correspondente
        for (CodigoRecuperacao recuperacao : recuperacoes) {

            if (recuperacao.getDataExpiracao().isAfter(agora)
                    && passwordEncoder.matches(
                            codigo,
                            recuperacao.getCodigo())) {

                return recuperacao;
            }
        }

        throw new RegraNegocioException(
                "Código de recuperação inválido ou expirado."
        );
    }

    // Redefine a senha utilizando um código válido
    @Transactional
    public void redefinirSenha(
            String email,
            String codigo,
            String novaSenha) {

        if (novaSenha == null || novaSenha.isBlank()) {

            throw new RegraNegocioException(
                    "Informe a nova senha."
            );
        }

        if (novaSenha.length() < 8) {

            throw new RegraNegocioException(
                    "A senha deve possuir pelo menos 8 caracteres."
            );
        }

        // Valida o código informado
        CodigoRecuperacao recuperacao =
                validarCodigo(email, codigo);

        Usuario usuario = recuperacao.getUsuario();

        // Criptografa a nova senha
        usuario.setSenha(
                passwordEncoder.encode(novaSenha)
        );

        usuarioRepository.save(usuario);

        // Marca o código como utilizado
        recuperacao.setUtilizado(true);

        codigoRepository.save(recuperacao);
    }
}
