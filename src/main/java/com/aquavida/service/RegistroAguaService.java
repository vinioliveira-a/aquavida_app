
package com.aquavida.service;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.stereotype.Service;

import com.aquavida.exception.RegraNegocioException;
import com.aquavida.model.RegistroAgua;
import com.aquavida.repository.RegistroAguaRepository;
import com.aquavida.security.UsuarioAutenticadoService;

@Service
public class RegistroAguaService {

    private final RegistroAguaRepository registroAguaRepository;
    private final UsuarioAutenticadoService usuarioAutenticadoService;

    public RegistroAguaService(
            RegistroAguaRepository registroAguaRepository,
            UsuarioAutenticadoService usuarioAutenticadoService) {

        this.registroAguaRepository = registroAguaRepository;
        this.usuarioAutenticadoService = usuarioAutenticadoService;
    }

    // Cadastra um novo registro de consumo
    public RegistroAgua registrarConsumo(Integer quantidadeMl) {

        if (quantidadeMl == null || quantidadeMl <= 0) {
            throw new RegraNegocioException(
                    "A quantidade de água deve ser maior que zero."
            );
        }

        RegistroAgua registro = new RegistroAgua();

        registro.setQuantidadeMl(quantidadeMl);
        registro.setDataHora(LocalDateTime.now());

        registro.setUsuario(
                usuarioAutenticadoService.obterUsuarioAutenticado()
        );

        return registroAguaRepository.save(registro);
    }

    // Lista os registros do usuário autenticado
    public List<RegistroAgua> listarRegistros() {

        Long usuarioId =
                usuarioAutenticadoService.obterIdUsuarioAutenticado();

        return registroAguaRepository.findByUsuarioId(usuarioId);
    }



// Exclui um registro pertencente ao usuário autenticado
public void excluirRegistro(Long registroId) {

    Long usuarioId =
            usuarioAutenticadoService.obterIdUsuarioAutenticado();

    RegistroAgua registro = registroAguaRepository
            .findById(registroId)
            .orElseThrow(() -> new com.aquavida.exception.RecursoNaoEncontradoException(
                    "Registro de consumo não encontrado."
            ));

    if (!registro.getUsuario().getId().equals(usuarioId)) {
        throw new RegraNegocioException(
                "Você não tem permissão para excluir este registro."
        );
    }

    registroAguaRepository.delete(registro);
}
}