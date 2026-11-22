
package com.aquavida.dto;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;

public class AtualizarPerfilDTO {

    private String nome;
    private BigDecimal pesoKg;
    private LocalDate dataNascimento;
    private String nivelAtividade;
    private Integer metaDiariaMl;

    private Boolean lembretesAtivo;
    private LocalTime lembretesInicio;
    private LocalTime lembretesFim;
    private Integer lembretesIntervaloMin;

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

    public Boolean getLembretesAtivo() {
        return lembretesAtivo;
    }

    public void setLembretesAtivo(Boolean lembretesAtivo) {
        this.lembretesAtivo = lembretesAtivo;
    }

    public LocalTime getLembretesInicio() {
        return lembretesInicio;
    }

    public void setLembretesInicio(LocalTime lembretesInicio) {
        this.lembretesInicio = lembretesInicio;
    }

    public LocalTime getLembretesFim() {
        return lembretesFim;
    }

    public void setLembretesFim(LocalTime lembretesFim) {
        this.lembretesFim = lembretesFim;
    }

    public Integer getLembretesIntervaloMin() {
        return lembretesIntervaloMin;
    }

    public void setLembretesIntervaloMin(Integer lembretesIntervaloMin) {
        this.lembretesIntervaloMin = lembretesIntervaloMin;
    }
}
