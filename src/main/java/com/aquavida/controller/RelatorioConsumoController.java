
package com.aquavida.controller;

import java.time.LocalDate;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.aquavida.dto.ConsumoDiarioDTO;
import com.aquavida.service.RelatorioConsumoService;

@RestController
@RequestMapping("/relatorios-consumo")
public class RelatorioConsumoController {

    private final RelatorioConsumoService relatorioConsumoService;

    public RelatorioConsumoController(
            RelatorioConsumoService relatorioConsumoService) {

        this.relatorioConsumoService = relatorioConsumoService;
    }

    // Consultar relatório de consumo por dia
    @GetMapping
    public ResponseEntity<List<ConsumoDiarioDTO>> consultarConsumoPorDia(
            @RequestParam
            @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
            LocalDate dataInicio,

            @RequestParam
            @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
            LocalDate dataFim) {

        List<ConsumoDiarioDTO> resposta =
                relatorioConsumoService.consultarConsumoPorDia(
                        dataInicio,
                        dataFim
                );

        return ResponseEntity.ok(resposta);
    }
}
