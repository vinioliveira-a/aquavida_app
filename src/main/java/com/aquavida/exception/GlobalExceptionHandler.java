
package com.aquavida.exception;

import java.time.LocalDateTime;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class GlobalExceptionHandler {

    // Trata recursos não encontrados
    @ExceptionHandler(RecursoNaoEncontradoException.class)
    public ResponseEntity<RespostaErro> tratarRecursoNaoEncontrado(
            RecursoNaoEncontradoException exception) {

        RespostaErro erro = new RespostaErro(
                HttpStatus.NOT_FOUND.value(),
                exception.getMessage(),
                LocalDateTime.now()
        );

        return ResponseEntity
                .status(HttpStatus.NOT_FOUND)
                .body(erro);
    }

    // Trata violações de regras de negócio
    @ExceptionHandler(RegraNegocioException.class)
    public ResponseEntity<RespostaErro> tratarRegraNegocio(
            RegraNegocioException exception) {

        RespostaErro erro = new RespostaErro(
                HttpStatus.BAD_REQUEST.value(),
                exception.getMessage(),
                LocalDateTime.now()
        );

        return ResponseEntity
                .status(HttpStatus.BAD_REQUEST)
                .body(erro);
    }

    // Estrutura padronizada das respostas de erro
    public record RespostaErro(
            int status,
            String mensagem,
            LocalDateTime dataHora
    ) {
    }
}
