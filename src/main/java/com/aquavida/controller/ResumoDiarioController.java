
package com.aquavida.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.aquavida.dto.ResumoDiarioDTO;
import com.aquavida.service.ResumoDiarioService;

@RestController
@RequestMapping("/resumo-diario")
public class ResumoDiarioController {

    private final ResumoDiarioService resumoDiarioService;

    public ResumoDiarioController(
            ResumoDiarioService resumoDiarioService) {

        this.resumoDiarioService = resumoDiarioService;
    }

    // Consultar resumo diário de consumo de água
    @GetMapping
    public ResponseEntity<ResumoDiarioDTO> consultarResumoDiario() {

        ResumoDiarioDTO resposta =
                resumoDiarioService.consultarResumoDiario();

        return ResponseEntity.ok(resposta);
    }
}
