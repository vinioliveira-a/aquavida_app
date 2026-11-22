
package com.aquavida.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.Arrays;

@Configuration
public class CorsConfig {

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {

        CorsConfiguration configuration = new CorsConfiguration();

        // Permite requisições dos ambientes de desenvolvimento
        configuration.setAllowedOriginPatterns(
                Arrays.asList("*")
        );

        // Métodos HTTP permitidos
        configuration.setAllowedMethods(
                Arrays.asList("GET", "POST", "PUT", "DELETE", "OPTIONS")
        );

        // Cabeçalhos permitidos, incluindo JWT
        configuration.setAllowedHeaders(
                Arrays.asList("*")
        );

        // Não utiliza cookies ou autenticação por sessão
        configuration.setAllowCredentials(false);

        UrlBasedCorsConfigurationSource source =
                new UrlBasedCorsConfigurationSource();

        source.registerCorsConfiguration("/**", configuration);

        return source;
    }
}
