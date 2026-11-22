
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

    public Usuario consultarPerfil() {

        Long usuarioId =
                usuarioAutenticadoService.obterIdUsuarioAutenticado();

        return usuarioRepository.findById(usuarioId)
                .orElseThrow(() -> new RecursoNaoEncontradoException(
                        "Usuário não encontrado."
                ));
    }

    @Transactional
    public Usuario atualizarPerfil(AtualizarPerfilDTO dados) {

        if (dados == null) {
            throw new RegraNegocioException(
                    "Informe os dados para atualização."
            );
        }

        if (dados.getNome() != null && dados.getNome().isBlank()) {
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

        Integer intervalo = dados.getLembretesIntervaloMin();

        if (intervalo != null && intervalo <= 0) {
            throw new RegraNegocioException(
                    "O intervalo dos lembretes deve ser maior que zero."
            );
        }

        Long usuarioId =
                usuarioAutenticadoService.obterIdUsuarioAutenticado();

        Usuario usuario = usuarioRepository.findById(usuarioId)
                .orElseThrow(() -> new RecursoNaoEncontradoException(
                        "Usuário não encontrado."
                ));

        if (dados.getNome() != null) {
            usuario.setNome(dados.getNome().trim());
        }

        if (peso != null) {
            usuario.setPesoKg(peso);
        }

        if (dados.getDataNascimento() != null) {
            usuario.setDataNascimento(nascimento);
        }

        if (atividade != null) {
            usuario.setNivelAtividade(atividade);
        }

        if (meta != null) {
            usuario.setMetaDiariaMl(meta);
        }

        if (dados.getLembretesAtivo() != null) {
            usuario.setLembretesAtivo(dados.getLembretesAtivo());
        }

        if (dados.getLembretesInicio() != null) {
            usuario.setLembretesInicio(dados.getLembretesInicio());
        }

        if (dados.getLembretesFim() != null) {
            usuario.setLembretesFim(dados.getLembretesFim());
        }

        if (intervalo != null) {
            usuario.setLembretesIntervaloMin(intervalo);
        }

        return usuarioRepository.save(usuario);
    }
}
