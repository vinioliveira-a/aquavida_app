
package com.aquavida.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.aquavida.dto.CadastroUsuarioDTO;
import com.aquavida.dto.UsuarioRespostaDTO;
import com.aquavida.model.Usuario;
import com.aquavida.service.UsuarioService;

@RestController
@RequestMapping("/usuarios")
public class UsuarioController {

    private final UsuarioService usuarioService;

    public UsuarioController(UsuarioService usuarioService) {
        this.usuarioService = usuarioService;
    }

    @PostMapping
    public ResponseEntity<UsuarioRespostaDTO> cadastrar(
            @RequestBody CadastroUsuarioDTO dados) {

        Usuario usuario = usuarioService.cadastrar(dados);

        UsuarioRespostaDTO resposta =
                new UsuarioRespostaDTO(usuario);

        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(resposta);
    }
}

