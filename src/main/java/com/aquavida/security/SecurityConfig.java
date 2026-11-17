package com.aquavida.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import com.aquavida.repository.UsuarioRepository;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    // Criptografia de senhas
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    // Registra o filtro JWT
    @Bean
    public JwtAuthenticationFilter jwtAuthenticationFilter(
            JwtService jwtService,
            UsuarioRepository usuarioRepository) {

        return new JwtAuthenticationFilter(
                jwtService,
                usuarioRepository
        );
    }

    // Configura a segurança da aplicação
    @Bean
    public SecurityFilterChain securityFilterChain(
            HttpSecurity http,
            JwtAuthenticationFilter jwtAuthenticationFilter)
            throws Exception {

        http
            // Desabilita CSRF para API REST
            .csrf(csrf -> csrf.disable())

            // Não mantém sessões no servidor
            .sessionManagement(session ->
                session.sessionCreationPolicy(
                    SessionCreationPolicy.STATELESS
                )
            )

            // Define as permissões
            .authorizeHttpRequests(auth -> auth

                // Cadastro público
                .requestMatchers(
                    HttpMethod.POST, "/usuarios"
                ).permitAll()

                // Rotas de autenticação públicas
                .requestMatchers("/auth/**").permitAll()

                // Demais rotas exigem autenticação
                .anyRequest().authenticated()
            )

            // Desabilita autenticação básica
            .httpBasic(basic -> basic.disable())

            // Desabilita formulário de login
            .formLogin(form -> form.disable())

            // Adiciona o filtro JWT antes do filtro de autenticação padrão
            .addFilterBefore(
                jwtAuthenticationFilter,
                UsernamePasswordAuthenticationFilter.class
            );

        return http.build();
    }
}
