
package com.aquavida.dto;

import java.time.LocalDateTime;

import com.aquavida.model.RegistroAgua;

public class RegistroAguaRespostaDTO {

    private Long id;
    private Integer quantidadeMl;
    private LocalDateTime dataHora;

    public RegistroAguaRespostaDTO(RegistroAgua registro) {
        this.id = registro.getId();
        this.quantidadeMl = registro.getQuantidadeMl();
        this.dataHora = registro.getDataHora();
    }

    public Long getId() {
        return id;
    }

    public Integer getQuantidadeMl() {
        return quantidadeMl;
    }

    public LocalDateTime getDataHora() {
        return dataHora;
    }
}
