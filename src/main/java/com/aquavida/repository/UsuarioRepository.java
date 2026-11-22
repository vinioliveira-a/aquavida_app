package com.aquavida.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.aquavida.model.Usuario;

public interface UsuarioRepository extends JpaRepository<Usuario, Long> {

    Optional<Usuario> findByEmail(String email);

    Optional<Usuario> findByNomeUsuario(String nomeUsuario);

    boolean existsByEmail(String email);

    boolean existsByNomeUsuario(String nomeUsuario);

}