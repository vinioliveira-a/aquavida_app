
package com.aquavida.dto;

import java.time.LocalDate;

public class ConsumoDiarioDTO {

    private LocalDate data;
    private Long totalConsumidoMl;

    public ConsumoDiarioDTO() {
    }

    public ConsumoDiarioDTO(
            LocalDate data,
            Long totalConsumidoMl) {

        this.data = data;
        this.totalConsumidoMl = totalConsumidoMl;
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
}
