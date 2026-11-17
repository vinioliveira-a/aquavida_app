
package com.aquavida.repository;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.aquavida.model.RegistroAgua;

public interface RegistroAguaRepository
        extends JpaRepository<RegistroAgua, Long> {

    // Lista os registros de um usuário
    List<RegistroAgua> findByUsuarioId(Long usuarioId);

    // Soma o consumo de água em determinado dia
    @Query("""
            SELECT COALESCE(SUM(r.quantidadeMl), 0)
            FROM RegistroAgua r
            WHERE r.usuario.id = :usuarioId
            AND r.dataHora >= :inicio
            AND r.dataHora < :fim
            """)
    Long somarConsumoDoDia(
            @Param("usuarioId") Long usuarioId,
            @Param("inicio") LocalDateTime inicio,
            @Param("fim") LocalDateTime fim
    );

    // Consulta o consumo agrupado por dia
    @Query(value = """
            SELECT
                DATE(data_hora),
                SUM(quantidade_ml)
            FROM registros_agua
            WHERE usuario_id = :usuarioId
            AND data_hora >= :inicio
            AND data_hora < :fim
            GROUP BY DATE(data_hora)
            ORDER BY DATE(data_hora) DESC
            """, nativeQuery = true)
    List<Object[]> consultarConsumoAgrupadoPorDia(
            @Param("usuarioId") Long usuarioId,
            @Param("inicio") LocalDateTime inicio,
            @Param("fim") LocalDateTime fim
    );
    // Consulta o histórico de consumo por período
    List<RegistroAgua> findByUsuarioIdAndDataHoraGreaterThanEqualAndDataHoraLessThanOrderByDataHoraDesc(
            Long usuarioId,
            LocalDateTime inicio,
            LocalDateTime fim
    );
}
