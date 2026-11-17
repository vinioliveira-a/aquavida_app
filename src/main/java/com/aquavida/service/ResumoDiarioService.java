
package com.aquavida.service;

import java.time.LocalDate;
import java.time.LocalDateTime;

import org.springframework.stereotype.Service;

import com.aquavida.dto.ResumoDiarioDTO;
import com.aquavida.exception.RegraNegocioException;
import com.aquavida.exception.RecursoNaoEncontradoException;
import com.aquavida.model.Usuario;
import com.aquavida.repository.RegistroAguaRepository;
import com.aquavida.repository.UsuarioRepository;
import com.aquavida.security.UsuarioAutenticadoService;

@Service
public class ResumoDiarioService {

    private final RegistroAguaRepository registroAguaRepository;
    private final UsuarioRepository usuarioRepository;
    private final UsuarioAutenticadoService usuarioAutenticadoService;

    public ResumoDiarioService(
            RegistroAguaRepository registroAguaRepository,
            UsuarioRepository usuarioRepository,
            UsuarioAutenticadoService usuarioAutenticadoService) {

        this.registroAguaRepository = registroAguaRepository;
        this.usuarioRepository = usuarioRepository;
        this.usuarioAutenticadoService = usuarioAutenticadoService;
    }

    public ResumoDiarioDTO consultarResumoDiario() {

        Long usuarioId =
                usuarioAutenticadoService.obterIdUsuarioAutenticado();

        Usuario usuario = usuarioRepository.findById(usuarioId)
                .orElseThrow(() -> new RecursoNaoEncontradoException(
                        "Usuário não encontrado."
                ));

        Integer metaDiaria = usuario.getMetaDiariaMl();

        if (metaDiaria == null || metaDiaria <= 0) {
            throw new RegraNegocioException(
                    "O usuário ainda não possui uma meta diária válida."
            );
        }

        LocalDate hoje = LocalDate.now();

        LocalDateTime inicio = hoje.atStartOfDay();
        LocalDateTime fim = hoje.plusDays(1).atStartOfDay();

        Long totalConsumido =
                registroAguaRepository.somarConsumoDoDia(
                        usuarioId,
                        inicio,
                        fim
                );

        double percentual =
                (totalConsumido.doubleValue() / metaDiaria) * 100;

        int faltaConsumir = (int) Math.max(
                0,
                metaDiaria - totalConsumido
        );

        return new ResumoDiarioDTO(
                hoje,
                totalConsumido,
                metaDiaria,
                Math.round(percentual * 100.0) / 100.0,
                faltaConsumir
        );
    }
}
