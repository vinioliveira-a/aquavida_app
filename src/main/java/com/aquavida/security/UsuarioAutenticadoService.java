
package com.aquavida.security;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import com.aquavida.model.Usuario;

@Service
public class UsuarioAutenticadoService {

    // Recupera o usuário que está autenticado
    public Usuario obterUsuarioAutenticado() {

        Authentication autenticacao =
                SecurityContextHolder.getContext().getAuthentication();

        if (autenticacao == null
                || !autenticacao.isAuthenticated()
                || !(autenticacao.getPrincipal() instanceof Usuario)) {

            throw new IllegalStateException(
                    "Nenhum usuário autenticado foi encontrado."
            );
        }

        return (Usuario) autenticacao.getPrincipal();
    }

    // Recupera o ID do usuário autenticado
    public Long obterIdUsuarioAutenticado() {

        return obterUsuarioAutenticado().getId();
    }
}
