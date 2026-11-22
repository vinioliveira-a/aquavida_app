
package com.aquavida.service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

import org.springframework.stereotype.Service;

import com.aquavida.exception.RegraNegocioException;
import com.aquavida.model.RegistroAgua;
import com.aquavida.repository.RegistroAguaRepository;
import com.aquavida.security.UsuarioAutenticadoService;

@Service
public class HistoricoConsumoService {

    private final RegistroAguaRepository registroAguaRepository;
    private final UsuarioAutenticadoService usuarioAutenticadoService;

    public HistoricoConsumoService(
            RegistroAguaRepository registroAguaRepository,
            UsuarioAutenticadoService usuarioAutenticadoService) {

        this.registroAguaRepository = registroAguaRepository;
        this.usuarioAutenticadoService = usuarioAutenticadoService;
    }

    public List<RegistroAgua> consultarHistorico(
            LocalDate dataInicio,
            LocalDate dataFim) {

        if (dataInicio == null || dataFim == null) {
            throw new RegraNegocioException(
                    "Informe a data inicial e a data final."
            );
        }

        if (dataInicio.isAfter(dataFim)) {
            throw new RegraNegocioException(
                    "A data inicial não pode ser posterior à data final."
            );
        }

        if (dataFim.isAfter(LocalDate.now())) {
            throw new RegraNegocioException(
                    "A data final não pode ser futura."
            );
        }

        if (dataInicio.plusYears(1).isBefore(dataFim)) {
            throw new RegraNegocioException(
                    "O período máximo de consulta é de um ano."
            );
        }

        Long usuarioId =
                usuarioAutenticadoService.obterIdUsuarioAutenticado();

        LocalDateTime inicio = dataInicio.atStartOfDay();

        LocalDateTime fim = dataFim
                .plusDays(1)
                .atStartOfDay();

        return registroAguaRepository
                .findByUsuarioIdAndDataHoraGreaterThanEqualAndDataHoraLessThanOrderByDataHoraDesc(
                        usuarioId,
                        inicio,
                        fim
                );
    }
}
