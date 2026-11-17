
package com.aquavida.dto;

import java.time.LocalDate;

public class ResumoDiarioDTO {

    private LocalDate data;
    private Long totalConsumidoMl;
    private Integer metaDiariaMl;
    private Double percentualAtingido;
    private Integer faltaConsumirMl;

    public ResumoDiarioDTO() {
    }

    public ResumoDiarioDTO(
            LocalDate data,
            Long totalConsumidoMl,
            Integer metaDiariaMl,
            Double percentualAtingido,
            Integer faltaConsumirMl) {

        this.data = data;
        this.totalConsumidoMl = totalConsumidoMl;
        this.metaDiariaMl = metaDiariaMl;
        this.percentualAtingido = percentualAtingido;
        this.faltaConsumirMl = faltaConsumirMl;
    }

    public LocalDate getData() {
        return data;
    }

    public void setData(LocalDate data) {
        this.data = data;
    }

    public Long getTotalConsumidoMl() {
        return totalConsumidoMl;
    }

    public void setTotalConsumidoMl(Long totalConsumidoMl) {
        this.totalConsumidoMl = totalConsumidoMl;
    }

    public Integer getMetaDiariaMl() {
        return metaDiariaMl;
    }

    public void setMetaDiariaMl(Integer metaDiariaMl) {
        this.metaDiariaMl = metaDiariaMl;
    }

    public Double getPercentualAtingido() {
        return percentualAtingido;
    }

    public void setPercentualAtingido(Double percentualAtingido) {
        this.percentualAtingido = percentualAtingido;
    }

    public Integer getFaltaConsumirMl() {
        return faltaConsumirMl;
    }

    public void setFaltaConsumirMl(Integer faltaConsumirMl) {
        this.faltaConsumirMl = faltaConsumirMl;
    }
}
