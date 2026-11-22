
package com.aquavida.dto;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;

import com.aquavida.model.Usuario;

public class UsuarioRespostaDTO {

    private Long id;
    private String nomeUsuario;
    private String email;
    private String nome;
    private BigDecimal pesoKg;
    private LocalDate dataNascimento;
    private String nivelAtividade;
    private Integer metaDiariaMl;
    private Boolean lembretesAtivo;
    private LocalTime lembretesInicio;
    private LocalTime lembretesFim;
    private Integer lembretesIntervaloMin;

    // Construtor que recebe um usuário e copia seus dados
    public UsuarioRespostaDTO(Usuario usuario) {

        this.id = usuario.getId();
        this.nomeUsuario = usuario.getNomeUsuario();
        this.email = usuario.getEmail();
        this.nome = usuario.getNome();
        this.pesoKg = usuario.getPesoKg();
        this.dataNascimento = usuario.getDataNascimento();
        this.nivelAtividade = usuario.getNivelAtividade();
        this.metaDiariaMl = usuario.getMetaDiariaMl();
        this.lembretesAtivo = usuario.getLembretesAtivo();
        this.lembretesInicio = usuario.getLembretesInicio();
        this.lembretesFim = usuario.getLembretesFim();
        this.lembretesIntervaloMin = usuario.getLembretesIntervaloMin();
    }

    public Long getId() {
        return id;
    }

    public String getNomeUsuario() {
        return nomeUsuario;
    }

    public String getEmail() {
        return email;
    }

    public String getNome() {
        return nome;
    }

    public BigDecimal getPesoKg() {
        return pesoKg;
    }

    public LocalDate getDataNascimento() {
        return dataNascimento;
    }

    public String getNivelAtividade() {
        return nivelAtividade;
    }

    public Integer getMetaDiariaMl() {
        return metaDiariaMl;
    }

    public Boolean getLembretesAtivo() {
        return lembretesAtivo;
    }

    public LocalTime getLembretesInicio() {
        return lembretesInicio;
    }

    public LocalTime getLembretesFim() {
        return lembretesFim;
    }

    public Integer getLembretesIntervaloMin() {
        return lembretesIntervaloMin;
    }
}
