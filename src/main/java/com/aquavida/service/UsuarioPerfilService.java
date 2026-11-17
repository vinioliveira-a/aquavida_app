
package com.aquavida.service;

import java.math.BigDecimal;
import java.time.LocalDate;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.aquavida.dto.AtualizarPerfilDTO;
import com.aquavida.exception.RegraNegocioException;
import com.aquavida.exception.RecursoNaoEncontradoException;
import com.aquavida.model.Usuario;
import com.aquavida.repository.UsuarioRepository;
import com.aquavida.security.UsuarioAutenticadoService;

@Service
public class UsuarioPerfilService {

    private final UsuarioRepository usuarioRepository;
    private final UsuarioAutenticadoService usuarioAutenticadoService;

    public UsuarioPerfilService(
            UsuarioRepository usuarioRepository,
            UsuarioAutenticadoService usuarioAutenticadoService) {

        this.usuarioRepository = usuarioRepository;
        this.usuarioAutenticadoService = usuarioAutenticadoService;
    }

    // Consulta o perfil do usuário autenticado
    public Usuario consultarPerfil() {

        Long usuarioId =
                usuarioAutenticadoService.obterIdUsuarioAutenticado();

        return usuarioRepository.findById(usuarioId)
                .orElseThrow(() -> new RecursoNaoEncontradoException(
                        "Usuário não encontrado."
                ));
    }

    // Atualiza as informações do perfil
    @Transactional
    public Usuario atualizarPerfil(AtualizarPerfilDTO dados) {

        if (dados == null) {
            throw new RegraNegocioException(
                    "Informe os dados para atualização."
            );
        }

        if (dados.getNome() == null || dados.getNome().isBlank()) {
            throw new RegraNegocioException(
                    "O nome não pode ficar vazio."
            );
        }

        BigDecimal peso = dados.getPesoKg();

        if (peso != null && peso.compareTo(BigDecimal.ZERO) <= 0) {
            throw new RegraNegocioException(
                    "O peso deve ser maior que zero."
            );
        }

        Integer meta = dados.getMetaDiariaMl();

        if (meta != null && meta <= 0) {
            throw new RegraNegocioException(
                    "A meta diária deve ser maior que zero."
            );
        }

        String atividade = dados.getNivelAtividade();

        if (atividade != null
                && !atividade.equals("Sedentário")
                && !atividade.equals("Leve")
                && !atividade.equals("Moderado")
                && !atividade.equals("Intenso")) {

            throw new RegraNegocioException(
                    "Nível de atividade inválido."
            );
        }

        LocalDate nascimento = dados.getDataNascimento();

        if (nascimento != null && nascimento.isAfter(LocalDate.now())) {
            throw new RegraNegocioException(
                    "A data de nascimento não pode ser futura."
            );
        }

        Long usuarioId =
                usuarioAutenticadoService.obterIdUsuarioAutenticado();

        Usuario usuario = usuarioRepository.findById(usuarioId)
                .orElseThrow(() -> new RecursoNaoEncontradoException(
                        "Usuário não encontrado."
                ));

        usuario.setNome(dados.getNome().trim());
        usuario.setPesoKg(peso);
        usuario.setDataNascimento(nascimento);
        usuario.setNivelAtividade(atividade);
        usuario.setMetaDiariaMl(meta);

        return usuarioRepository.save(usuario);
    }
}
