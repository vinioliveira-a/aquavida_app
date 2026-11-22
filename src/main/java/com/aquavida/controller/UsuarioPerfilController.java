
package com.aquavida.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.aquavida.dto.AtualizarPerfilDTO;
import com.aquavida.dto.UsuarioRespostaDTO;
import com.aquavida.model.Usuario;
import com.aquavida.service.UsuarioPerfilService;

@RestController
@RequestMapping("/usuarios/perfil")
public class UsuarioPerfilController {

    private final UsuarioPerfilService usuarioPerfilService;

    public UsuarioPerfilController(
            UsuarioPerfilService usuarioPerfilService) {

        this.usuarioPerfilService = usuarioPerfilService;
    }

    // Consultar perfil do usuário autenticado
    @GetMapping
    public ResponseEntity<UsuarioRespostaDTO> consultarPerfil() {

        Usuario usuario = usuarioPerfilService.consultarPerfil();

        return ResponseEntity.ok(new UsuarioRespostaDTO(usuario));
    }

    // Atualizar perfil do usuário autenticado
    @PutMapping
    public ResponseEntity<UsuarioRespostaDTO> atualizarPerfil(
            @RequestBody AtualizarPerfilDTO dados) {

        Usuario usuario = usuarioPerfilService.atualizarPerfil(dados);

        return ResponseEntity.ok(new UsuarioRespostaDTO(usuario));
    }
}
