package com.aquavida.security;

import java.io.IOException;
import java.util.Collections;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.web.filter.OncePerRequestFilter;

import com.aquavida.model.Usuario;
import com.aquavida.repository.UsuarioRepository;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtService jwtService;
    private final UsuarioRepository usuarioRepository;

    public JwtAuthenticationFilter(
            JwtService jwtService,
            UsuarioRepository usuarioRepository) {

        this.jwtService = jwtService;
        this.usuarioRepository = usuarioRepository;
    }

    @Override
    protected void doFilterInternal(
            HttpServletRequest request,
            HttpServletResponse response,
            FilterChain filterChain)
            throws ServletException, IOException {

        // Obtém o cabeçalho Authorization
        String authorizationHeader =
                request.getHeader("Authorization");

        // Verifica se existe um token Bearer
        if (authorizationHeader != null
                && authorizationHeader.startsWith("Bearer ")) {

            String token = authorizationHeader.substring(7);

            // Continua somente se ainda não houver autenticação
            if (SecurityContextHolder.getContext().getAuthentication() == null) {

                try {
                    // Extrai o e-mail do token
                    String email = jwtService.extrairEmail(token);

                    // Valida o token
                    if (jwtService.validarToken(token, email)) {

                        // Busca o usuário no banco de dados
                        Usuario usuario = usuarioRepository
                                .findByEmail(email)
                                .orElse(null);

                        if (usuario != null) {

                            // Cria a autenticação do usuário
                            UsernamePasswordAuthenticationToken autenticacao =
                                    new UsernamePasswordAuthenticationToken(
                                            usuario,
                                            null,
                                            Collections.emptyList()
                                    );

                            autenticacao.setDetails(
                                    new WebAuthenticationDetailsSource()
                                            .buildDetails(request)
                            );

                            // Registra a autenticação no Spring Security
                            SecurityContextHolder.getContext()
                                    .setAuthentication(autenticacao);
                        }
                    }

                } catch (io.jsonwebtoken.JwtException
                        | IllegalArgumentException e) {

                    SecurityContextHolder.clearContext();
                }
            }
        }

        // Continua o processamento da requisição
        filterChain.doFilter(request, response);
    }
}
