package com.aquavida.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "usuarios")
public class Usuario {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "nome_usuario", nullable = false, unique = true, length = 50)
    private String nomeUsuario;

    @Column(nullable = false, unique = true, length = 150)
    private String email;

    @Column(nullable = false, length = 255)
    private String senha;

    @Column(nullable = false, length = 100)
    private String nome;

    @Column(name = "peso_kg", precision = 5, scale = 2)
    private BigDecimal pesoKg;

    @Column(name = "data_nascimento")
    private LocalDate dataNascimento;

    @Column(name = "nivel_atividade", length = 20)
    private String nivelAtividade;

    @Column(name = "meta_diaria_ml")
    private Integer metaDiariaMl;

    @Column(name = "lembretes_ativo")
    private Boolean lembretesAtivo;

    @Column(name = "lembretes_inicio")
    private LocalTime lembretesInicio;

    @Column(name = "lembretes_fim")
    private LocalTime lembretesFim;

    @Column(name = "lembretes_intervalo_min")
    private Integer lembretesIntervaloMin;

    // Construtor padrão exigido pelo JPA
    public Usuario() {
    }

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getNomeUsuario() {
		return nomeUsuario;
	}

	public void setNomeUsuario(String nomeUsuario) {
		this.nomeUsuario = nomeUsuario;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getSenha() {
		return senha;
	}

	public void setSenha(String senha) {
		this.senha = senha;
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
