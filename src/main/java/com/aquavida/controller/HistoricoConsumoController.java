
package com.aquavida.controller;

import java.time.LocalDate;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.aquavida.dto.RegistroAguaRespostaDTO;
import com.aquavida.model.RegistroAgua;
import com.aquavida.service.HistoricoConsumoService;

@RestController
@RequestMapping("/historico-consumo")
public class HistoricoConsumoController {

    private final HistoricoConsumoService historicoConsumoService;

    public HistoricoConsumoController(
            HistoricoConsumoService historicoConsumoService) {

        this.historicoConsumoService = historicoConsumoService;
    }

    // Consultar histórico por período
    @GetMapping
    public ResponseEntity<List<RegistroAguaRespostaDTO>> consultarHistorico(
            @RequestParam
            @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
            LocalDate dataInicio,

            @RequestParam
            @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
            LocalDate dataFim) {

        List<RegistroAgua> registros =
                historicoConsumoService.consultarHistorico(
                        dataInicio,
                        dataFim
                );

        List<RegistroAguaRespostaDTO> resposta = registros.stream()
                .map(RegistroAguaRespostaDTO::new)
                .toList();

        return ResponseEntity.ok(resposta);
    }
}
