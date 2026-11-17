
package com.aquavida.service;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;
import com.aquavida.security.UsuarioAutenticadoService;
import com.aquavida.dto.ConsumoDiarioDTO;
import com.aquavida.exception.RegraNegocioException;
import com.aquavida.repository.RegistroAguaRepository;

@Service
public class RelatorioConsumoService {

    private final RegistroAguaRepository registroAguaRepository;
    private final UsuarioAutenticadoService usuarioAutenticadoService;

    public RelatorioConsumoService(
            RegistroAguaRepository registroAguaRepository,
            UsuarioAutenticadoService usuarioAutenticadoService) {

        this.registroAguaRepository = registroAguaRepository;
        this.usuarioAutenticadoService = usuarioAutenticadoService;
    }

    // Consulta o consumo de água agrupado por dia
    public List<ConsumoDiarioDTO> consultarConsumoPorDia(
            LocalDate dataInicio,
            LocalDate dataFim) {

        // Verifica se as datas foram informadas
        if (dataInicio == null || dataFim == null) {
            throw new RegraNegocioException(
                    "Informe a data inicial e a data final."
            );
        }

        // Verifica se a data inicial é posterior à final
        if (dataInicio.isAfter(dataFim)) {
            throw new RegraNegocioException(
                    "A data inicial não pode ser posterior à data final."
            );
        }

        // Impede consultas com data futura
        if (dataFim.isAfter(LocalDate.now())) {
            throw new RegraNegocioException(
                    "A data final não pode ser futura."
            );
        }

        // Limita o período de consulta a um ano
        if (dataInicio.plusYears(1).isBefore(dataFim)) {
            throw new RegraNegocioException(
                    "O período máximo de consulta é de um ano."
            );
        }

        // Obtém o ID do usuário autenticado
        Long usuarioId =
                usuarioAutenticadoService.obterIdUsuarioAutenticado();

        // Busca os resultados no banco de dados
        List<Object[]> resultados =
                registroAguaRepository.consultarConsumoAgrupadoPorDia(
                        usuarioId,
                        dataInicio.atStartOfDay(),
                        dataFim.plusDays(1).atStartOfDay()
                );

        // Converte os resultados em DTOs
        List<ConsumoDiarioDTO> relatorio = new ArrayList<>();

        for (Object[] linha : resultados) {

            java.sql.Date data = (java.sql.Date) linha[0];
            Number total = (Number) linha[1];

            ConsumoDiarioDTO dto = new ConsumoDiarioDTO();

            dto.setData(data.toLocalDate());
            dto.setTotalConsumidoMl(total.longValue());

            relatorio.add(dto);
        }

        return relatorio;
    }
}
