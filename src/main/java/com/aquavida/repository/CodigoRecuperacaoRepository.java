
package com.aquavida.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.aquavida.model.CodigoRecuperacao;

public interface CodigoRecuperacaoRepository
        extends JpaRepository<CodigoRecuperacao, Long> {

    List<CodigoRecuperacao> findAllByUsuarioEmailAndUtilizadoFalse(
            String email
    );

}

