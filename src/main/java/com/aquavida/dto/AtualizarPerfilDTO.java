
package com.aquavida.dto;

import java.math.BigDecimal;
import java.time.LocalDate;

public class AtualizarPerfilDTO {

    private String nome;
    private BigDecimal pesoKg;
    private LocalDate dataNascimento;
    private String nivelAtividade;
    private Integer metaDiariaMl;

    public AtualizarPerfilDTO() {
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public BigDecimal getPesoKg() {
        return pesoKg;
    }

    public void setPesoKg(BigDecimal pesoKg) {
        this.pesoKg = pesoKg;
    }

    public LocalDate getDataNascimento() {
        return dataNascimento;
    }

    public void setDataNascimento(LocalDate dataNascimento) {
        this.dataNascimento = dataNascimento;
    }

    public String getNivelAtividade() {
        return nivelAtividade;
    }

    public void setNivelAtividade(String nivelAtividade) {
        this.nivelAtividade = nivelAtividade;
    }

    public Integer getMetaDiariaMl() {
        return metaDiariaMl;
    }

    public void setMetaDiariaMl(Integer metaDiariaMl) {
        this.metaDiariaMl = metaDiariaMl;
    }
}
