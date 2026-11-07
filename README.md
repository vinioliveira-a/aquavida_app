# AquaVida (Flutter)

Aplicativo de acompanhamento de hidratação (trabalho acadêmico de ADS).
Este projeto reúne o **front-end completo**: telas de entrada, cadastro,
recuperação de senha e as telas internas do app.

Hoje o app roda em **modo mock** (dados de mentira, sem servidor). Quando a API
em Java estiver pronta, basta ligar o modo real (veja a seção 4).

---

## 1. Como rodar

```
flutter pub get
flutter run
```

No modo mock, qualquer e-mail e senha entram. Na recuperação de senha, qualquer
código de 6 dígitos é aceito. Os dados voltam ao início quando o app fecha.

Testes automáticos: `flutter test`

---

## 2. Mapa das telas

```
Inicial (/)
 └─ Começar ─> Login (/login)
      ├─ Entrar ──────────────> Principal (/home)
      ├─ Registre-se ─> Cadastro passo 1 ─> passo 2 ─> passo 3 ─> Principal
      └─ Esqueceu a senha? ─> E-mail ─> Código ─> Nova senha ─> Login

Principal (/home) ── Adicionar água (/adicionar-agua)
                  ── Histórico (/historico)
Menu de baixo:  Início | Estatísticas (/estatisticas) | Configurações (/configuracoes)
Configurações ── Editar perfil (/perfil), meta, lembretes, unidade, tema, sair
```

---

## 3. Estrutura de pastas

```
lib/
├── main.dart                 Rotas e tema do app
├── core/
│   ├── config/app_config.dart   <<< URL da API, endpoints e chave do mock
│   ├── theme/                   Cores (app_colors) e temas claro/escuro (app_theme)
│   └── utils/                   Validações, mensagens e máscaras
├── models/                   Classes de dados (viram JSON): Usuario, RegistroAgua...
├── services/                 <<< Conversa com a API: login, perfil, registros
├── dados/dados_app.dart      Estado em memória + cálculos (histórico, estatísticas)
├── screens/                  Uma tela por arquivo
└── widgets/                  Peças reutilizáveis (botão, campos, layouts...)
```

**Regra de ouro:** as telas nunca chamam a API diretamente. Elas chamam os
arquivos de `services/`. Assim, quem faz o back-end só mexe em `core/config` e
`services/`, sem encostar no visual.

---

## 4. Para a equipe do back-end (Java + MySQL)

Fluxo: **App Flutter → (HTTP/JSON) → API em Java → MySQL.**
O app nunca acessa o banco direto, só a API.

### Passo a passo para ligar o app na API
1. Abrir `lib/core/config/app_config.dart`.
2. Trocar `usarMock` para `false`.
3. Ajustar `apiBaseUrl` (o arquivo explica qual endereço usar no emulador,
   no simulador e no celular real).
4. Se algum caminho de endpoint for diferente, mudar nas constantes `ep...`.
5. Android: para usar `http://` (sem HTTPS) em testes, adicionar em
   `android/app/src/main/AndroidManifest.xml`, dentro de `<application`:
   `android:usesCleartextTraffic="true"`. Em produção, usar HTTPS.

### Contrato da API (sugestão: ajustem à vontade e avisem o front)

Regras gerais: JSON em UTF-8. Sucesso = status 2xx. Erro = 4xx/5xx com
`{"mensagem": "texto que aparece para o usuário"}`. Rotas protegidas recebem
`Authorization: Bearer <token>`. Datas: `AAAA-MM-DD`; data e hora:
`AAAA-MM-DDTHH:mm:ss`; horas: `HH:mm`.

| Ação no app | Método e caminho | Envia | Recebe |
|---|---|---|---|
| Entrar | `POST /auth/login` | `{email, senha}` | `{token, usuario}` |
| Cadastrar | `POST /usuarios` | ver abaixo | `{token, usuario}` |
| Pedir código | `POST /auth/recuperar-senha` | `{email}` | 200 |
| Validar código | `POST /auth/validar-codigo` | `{email, codigo}` | 200 ou 400 |
| Nova senha | `POST /auth/nova-senha` | `{email, codigo, novaSenha}` | 200 |
| Ver perfil | `GET /usuarios/me` | — | `usuario` |
| Alterar perfil, meta ou lembretes | `PUT /usuarios/me` | `usuario` completo | `usuario` |
| Listar registros | `GET /registros-agua` | — | `[ {id, quantidadeMl, dataHora} ]` |
| Registrar água | `POST /registros-agua` | `{quantidadeMl, dataHora}` | o registro, com `id` |

Corpo do cadastro (`POST /usuarios`):

```json
{
  "nomeUsuario": "ana123",
  "email": "ana@email.com",
  "senha": "minhasenha",
  "nome": "Ana",
  "pesoKg": 62.5,
  "dataNascimento": "2000-03-15",
  "metaDiariaMl": 2000,
  "lembretes": { "ativo": true, "inicio": "08:00", "fim": "20:00", "intervaloMin": 10 }
}
```

Objeto `usuario` (a senha **nunca** volta para o app):

```json
{
  "id": 1, "nomeUsuario": "ana123", "email": "ana@email.com", "nome": "Ana",
  "pesoKg": 62.5, "dataNascimento": "2000-03-15", "nivelAtividade": "Moderado",
  "metaDiariaMl": 2000,
  "lembretes": { "ativo": true, "inicio": "08:00", "fim": "20:00", "intervaloMin": 10 }
}
```

`nivelAtividade` pode ser: `Sedentário`, `Leve`, `Moderado` ou `Intenso`.
O histórico e as estatísticas são calculados no app a partir da lista de
registros; se preferirem, a API pode devolver os números prontos (nesse caso,
ajustar `RegistroAguaService`).

### Sugestão de tabelas no MySQL

```sql
CREATE TABLE usuarios (
  id                    BIGINT AUTO_INCREMENT PRIMARY KEY,
  nome_usuario          VARCHAR(50)  NOT NULL UNIQUE,
  email                 VARCHAR(120) NOT NULL UNIQUE,
  senha_hash            VARCHAR(100) NOT NULL,          -- BCrypt, nunca a senha pura
  nome                  VARCHAR(80)  NOT NULL,
  peso_kg               DECIMAL(5,1) NOT NULL,
  data_nascimento       DATE         NULL,
  nivel_atividade       ENUM('Sedentário','Leve','Moderado','Intenso') NOT NULL DEFAULT 'Moderado',
  meta_diaria_ml        INT          NOT NULL DEFAULT 2000,
  lembrete_ativo        TINYINT(1)   NOT NULL DEFAULT 0,
  lembrete_inicio       TIME         NULL,
  lembrete_fim          TIME         NULL,
  lembrete_intervalo_min INT         NOT NULL DEFAULT 10,
  criado_em             DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE registros_agua (
  id            BIGINT AUTO_INCREMENT PRIMARY KEY,
  usuario_id    BIGINT   NOT NULL,
  quantidade_ml INT      NOT NULL,
  data_hora     DATETIME NOT NULL,
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
  INDEX idx_usuario_data (usuario_id, data_hora)
);

CREATE TABLE codigos_recuperacao (
  id          BIGINT AUTO_INCREMENT PRIMARY KEY,
  usuario_id  BIGINT      NOT NULL,
  codigo      VARCHAR(6)  NOT NULL,
  expira_em   DATETIME    NOT NULL,   -- ex.: 15 minutos depois de gerado
  usado       TINYINT(1)  NOT NULL DEFAULT 0,
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);
```

### Cuidados de segurança (vale combinar já)
- Guardar só o **hash** da senha (BCrypt), nunca a senha pura.
- A API deve devolver um **token (JWT)** no login; o app o envia nas rotas protegidas.
- Em produção, usar **HTTPS**.
- A API deve **sempre** filtrar os dados pelo usuário do token. Nunca confiar em
  um `usuario_id` enviado pelo app.
- Em `/auth/recuperar-senha`, responder 200 mesmo se o e-mail não existir.

### O que ainda não existe no app (combinar com o grupo)
- **Lembretes reais:** as notificações ainda são só visuais. As configurações já
  são salvas na API (ligado, horários e intervalo).
- **Manter o login:** a caixinha "Lembrar de mim" ainda não guarda nada no aparelho.
- **Trocar a senha logado:** a recuperação por e-mail existe; "trocar senha"
  dentro das Configurações não foi feito.

---

## 5. Observações
- Fonte Poppins incluída em `assets/fonts` (licença SIL OFL), sem depender de internet.
- A unidade (ml ou L) e o tema escuro são preferências só do aparelho: não vão para a API.
- Valores de água são sempre guardados em ml; a unidade muda só a exibição.
- Os pontos de integração estão marcados nos serviços e neste README. Procure por
  `AppConfig` e pela pasta `services/`.
