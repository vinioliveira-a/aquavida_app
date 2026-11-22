
package com.aquavida.controller;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.aquavida.dto.RegistrarConsumoDTO;
import com.aquavida.dto.RegistroAguaRespostaDTO;
import com.aquavida.model.RegistroAgua;
import com.aquavida.service.RegistroAguaService;

@RestController
@RequestMapping("/registros-agua")
public class RegistroAguaController {

    private final RegistroAguaService registroAguaService;

    public RegistroAguaController(RegistroAguaService registroAguaService) {
        this.registroAguaService = registroAguaService;
    }

    // Registrar consumo de água
    @PostMapping
    public ResponseEntity<RegistroAguaRespostaDTO> registrarConsumo(
            @RequestBody RegistrarConsumoDTO dados) {

        RegistroAgua registro = registroAguaService.registrarConsumo(
                dados.getQuantidadeMl()
        );

        RegistroAguaRespostaDTO resposta =
                new RegistroAguaRespostaDTO(registro);

        return ResponseEntity.status(HttpStatus.CREATED).body(resposta);
    }

    // Listar registros de consumo
    @GetMapping
    public ResponseEntity<List<RegistroAguaRespostaDTO>> listarRegistros() {

        List<RegistroAguaRespostaDTO> resposta =
                registroAguaService.listarRegistros()
                        .stream()
                        .map(RegistroAguaRespostaDTO::new)
                        .toList();

        return ResponseEntity.ok(resposta);
    }

    // Excluir registro de consumo
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> excluirRegistro(@PathVariable Long id) {

        registroAguaService.excluirRegistro(id);

        return ResponseEntity.noContent().build();
    }
}
