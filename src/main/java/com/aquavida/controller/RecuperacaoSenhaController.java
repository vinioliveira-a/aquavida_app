
package com.aquavida.controller;

import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.aquavida.service.RecuperacaoSenhaService;

@RestController
@RequestMapping("/auth")
public class RecuperacaoSenhaController {

    private final RecuperacaoSenhaService recuperacaoService;

    public RecuperacaoSenhaController(
            RecuperacaoSenhaService recuperacaoService) {
        this.recuperacaoService = recuperacaoService;
    }

    @PostMapping("/recuperar-senha")
    public ResponseEntity<Map<String, String>> recuperarSenha(
            @RequestBody EmailRequest dados) {

        recuperacaoService.criarCodigoRecuperacao(
                dados.getEmail()
        );

        return ResponseEntity.ok(
                Map.of("mensagem",
                        "Se o e-mail estiver cadastrado, você receberá um código de recuperação.")
        );
    }

    @PostMapping("/validar-codigo")
    public ResponseEntity<Void> validarCodigo(
            @RequestBody CodigoRequest dados) {

        recuperacaoService.validarCodigo(
                dados.getEmail(),
                dados.getCodigo()
        );

        return ResponseEntity.ok().build();
    }

    @PostMapping("/nova-senha")
    public ResponseEntity<Void> novaSenha(
            @RequestBody NovaSenhaRequest dados) {

        recuperacaoService.redefinirSenha(
                dados.getEmail(),
                dados.getCodigo(),
                dados.getNovaSenha()
        );

        return ResponseEntity.ok().build();
    }

    public static class EmailRequest {
        private String email;

        public String getEmail() {
            return email;
        }

        public void setEmail(String email) {
            this.email = email;
        }
    }

    public static class CodigoRequest {
        private String email;
        private String codigo;

        public String getEmail() {
            return email;
        }

        public void setEmail(String email) {
            this.email = email;
        }

        public String getCodigo() {
            return codigo;
        }

        public void setCodigo(String codigo) {
            this.codigo = codigo;
        }
    }

    public static class NovaSenhaRequest {
        private String email;
        private String codigo;
        private String novaSenha;

        public String getEmail() {
            return email;
        }

        public void setEmail(String email) {
            this.email = email;
        }

        public String getCodigo() {
            return codigo;
        }

        public void setCodigo(String codigo) {
            this.codigo = codigo;
        }

        public String getNovaSenha() {
            return novaSenha;
        }

        public void setNovaSenha(String novaSenha) {
            this.novaSenha = novaSenha;
        }
    }
}
