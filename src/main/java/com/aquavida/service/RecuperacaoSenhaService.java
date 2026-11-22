
package com.aquavida.service;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.List;

import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
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
    private final JavaMailSender mailSender;

    private final SecureRandom random = new SecureRandom();

    public RecuperacaoSenhaService(
            CodigoRecuperacaoRepository codigoRepository,
            UsuarioRepository usuarioRepository,
            PasswordEncoder passwordEncoder,
            JavaMailSender mailSender) {

        this.codigoRepository = codigoRepository;
        this.usuarioRepository = usuarioRepository;
        this.passwordEncoder = passwordEncoder;
        this.mailSender = mailSender;
    }

    private String gerarCodigo() {
        int numero = 100000 + random.nextInt(900000);
        return String.valueOf(numero);
    }

    @Transactional
    public String criarCodigoRecuperacao(String email) {

        if (email == null || email.isBlank()) {
            throw new RegraNegocioException("Informe o e-mail.");
        }

        Usuario usuario = usuarioRepository
                .findByEmail(email.trim())
                .orElseThrow(() -> new RegraNegocioException(
                        "Usuário não encontrado."
                ));

        String codigo = gerarCodigo();

        LocalDateTime expiracao = LocalDateTime.now().plusMinutes(10);

        CodigoRecuperacao recuperacao = new CodigoRecuperacao();

        recuperacao.setCodigo(passwordEncoder.encode(codigo));
        recuperacao.setDataExpiracao(expiracao);
        recuperacao.setExpiraEm(expiracao);
        recuperacao.setUtilizado(false);
        recuperacao.setUsado(false);
        recuperacao.setUsuario(usuario);

        codigoRepository.save(recuperacao);

        // Envia o código por e-mail
        SimpleMailMessage mensagem = new SimpleMailMessage();

        mensagem.setTo(usuario.getEmail());
        mensagem.setSubject("Recuperação de senha - AquaVida");
        mensagem.setText(
                "Olá!\n\n"
                + "Seu código de recuperação de senha é: " + codigo
                + "\n\nEsse código expira em 10 minutos."
                + "\n\nSe você não solicitou essa recuperação, ignore este e-mail."
                + "\n\nEquipe AquaVida."
        );

        mailSender.send(mensagem);

        return codigo;
    }

    public CodigoRecuperacao validarCodigo(
            String email,
            String codigo) {

        if (email == null || email.isBlank()
                || codigo == null || codigo.isBlank()) {

            throw new RegraNegocioException(
                    "Informe o e-mail e o código de recuperação."
            );
        }

        List<CodigoRecuperacao> recuperacoes =
                codigoRepository.findAllByUsuarioEmailAndUtilizadoFalse(
                        email.trim()
                );

        LocalDateTime agora = LocalDateTime.now();

        for (CodigoRecuperacao recuperacao : recuperacoes) {

            if (recuperacao.getDataExpiracao().isAfter(agora)
                    && Boolean.FALSE.equals(recuperacao.getUsado())
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

        CodigoRecuperacao recuperacao =
                validarCodigo(email, codigo);

        Usuario usuario = recuperacao.getUsuario();

        String senhaCriptografada =
                passwordEncoder.encode(novaSenha);

        usuario.setSenha(senhaCriptografada);
        usuario.setSenhaHash(senhaCriptografada);

        usuarioRepository.save(usuario);

        recuperacao.setUtilizado(true);
        recuperacao.setUsado(true);

        codigoRepository.save(recuperacao);
    }
}
