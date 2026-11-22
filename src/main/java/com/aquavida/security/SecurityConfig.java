
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
import org.springframework.web.cors.CorsConfigurationSource;

import com.aquavida.repository.UsuarioRepository;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public JwtAuthenticationFilter jwtAuthenticationFilter(
            JwtService jwtService,
            UsuarioRepository usuarioRepository) {

        return new JwtAuthenticationFilter(
                jwtService,
                usuarioRepository
        );
    }

    @Bean
    public SecurityFilterChain securityFilterChain(
            HttpSecurity http,
            JwtAuthenticationFilter jwtAuthenticationFilter,
            CorsConfigurationSource corsConfigurationSource)
            throws Exception {

        http
            // Ativa CORS
            .cors(cors ->
                cors.configurationSource(corsConfigurationSource)
            )

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

                // Demais rotas exigem JWT
                .anyRequest().authenticated()
            )

            .httpBasic(basic -> basic.disable())
            .formLogin(form -> form.disable())

            // Filtro JWT
            .addFilterBefore(
                jwtAuthenticationFilter,
                UsernamePasswordAuthenticationFilter.class
            );

        return http.build();
    }
}
