# AquaVida --- Backend

Backend do **AquaVida**, aplicação acadêmica para acompanhamento do
consumo diário de água. O backend está sendo desenvolvido em Java com
Spring Boot e MySQL e será integrado ao aplicativo Flutter.

> **Status:** em desenvolvimento. A inicialização da aplicação e a
> conexão local com o MySQL foram verificadas. Os endpoints e contratos
> descritos neste documento devem ser conferidos e alinhados pela equipe
> antes de serem considerados concluídos.

## Objetivo

Disponibilizar uma camada de serviços para cadastro e autenticação de
usuários, gerenciamento de perfil e registro do consumo de água, além de
fornecer dados para histórico e relatórios.

## Tecnologias

-   Java 17
-   Spring Boot 4.1.2
-   Spring Data JPA
-   Spring Security
-   JWT (JSON Web Token)
-   BCrypt para hash de senhas
-   MySQL 8
-   Maven / Maven Wrapper

## Estrutura do projeto

``` text
aquavida-backend/
├── .mvn/
├── src/
│   ├── main/
│   │   ├── java/com/aquavida/
│   │   │   ├── controller/
│   │   │   ├── dto/
│   │   │   ├── exception/
│   │   │   ├── model/
│   │   │   ├── repository/
│   │   │   ├── security/
│   │   │   └── service/
│   │   └── resources/
│   │       └── application.properties.example
│   └── test/
├── .gitignore
├── HELP.md
├── mvnw
├── mvnw.cmd
├── pom.xml
└── README.md
```

### Responsabilidade dos pacotes

  Pacote         Responsabilidade
  -------------- ----------------------------------------------------
  `controller`   Receber requisições HTTP e devolver respostas.
  `dto`          Definir os dados aceitos e retornados pela API.
  `exception`    Centralizar o tratamento de erros.
  `model`        Representar as entidades persistidas.
  `repository`   Consultar e persistir dados com Spring Data JPA.
  `security`     Configurar Spring Security, filtro e serviços JWT.
  `service`      Implementar regras de negócio.

## Pré-requisitos

-   JDK 17 ou versão compatível com a configuração do projeto.
-   MySQL 8.
-   IDE Java (Eclipse com Spring Tools, IntelliJ IDEA ou VS Code).
-   Git.

## Configuração local

### 1. Criar o banco

No MySQL, crie o banco de dados:

``` sql
CREATE DATABASE aquavida;
```

Configure um usuário local com permissões somente para esse banco,
conforme a política do ambiente de desenvolvimento.

### 2. Criar o arquivo de configuração

Copie `src/main/resources/application.properties.example` para:

`src/main/resources/application.properties`

Preencha os valores locais. Exemplo de propriedades esperadas:

``` properties
spring.application.name=aquavida-backend

app.jwt.secret=SUA_CHAVE_BASE64
app.jwt.expiration=86400000

spring.datasource.url=jdbc:mysql://localhost:3306/aquavida
spring.datasource.username=SEU_USUARIO
spring.datasource.password=SUA_SENHA

spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.format_sql=true

server.port=8080
```

**Nunca faça commit do `application.properties`, de senhas, tokens ou
chaves JWT.** O arquivo local deve permanecer ignorado pelo Git. O
arquivo `.example` deve conter apenas valores ilustrativos.

### 3. Executar

No Windows, na pasta raiz do projeto:

``` bat
mvnw.cmd spring-boot:run
```

Em Linux/macOS:

``` bash
./mvnw spring-boot:run
```

Com Maven instalado, também é possível usar:

``` bash
mvn spring-boot:run
```

Endereço local padrão: `http://localhost:8080`.

## Segurança e regras importantes

-   Senhas devem ser armazenadas somente como hash BCrypt; nunca
    retornar senha em DTO.
-   Rotas de cadastro e autenticação são públicas. Rotas privadas exigem
    `Authorization: Bearer <token>`.
-   O backend deve identificar o usuário pelo token autenticado. Não
    confiar em `usuario_id` enviado pelo aplicativo para definir o
    proprietário de um registro.
-   Consultas, alterações e exclusões de registros de consumo devem
    sempre ser limitadas ao usuário autenticado.
-   Não registrar senhas, tokens ou chaves em logs.
-   Em produção, usar segredo JWT forte e configuração segura; não
    reutilizar credenciais locais.

## Contrato da API --- alinhamento e implementação

Esta seção é uma **orientação de trabalho para a implementação da camada
HTTP**. Antes de codificar, o responsável pelos controllers deve
conferir os DTOs e serviços já existentes no projeto e combinar
alterações com quem mantém a lógica de negócio. Não duplicar regras de
negócio nos controllers.

### Endpoints previstos

  -------------------------------------------------------------------------------
  Método            Rota                      Finalidade        Acesso
  ----------------- ------------------------- ----------------- -----------------
  `POST`            `/usuarios`               Cadastrar usuário Público

  `POST`            `/auth/login`             Autenticar e      Público
                                              obter JWT         

  `POST`            `/auth/recuperar-senha`   Solicitar         Público
                                              recuperação       

  `POST`            `/auth/validar-codigo`    Validar código de Público
                                              recuperação       

  `POST`            `/auth/nova-senha`        Definir nova      Público, com
                                              senha após        código válido
                                              validação         

  `GET`             `/usuarios/me`            Consultar perfil  JWT
                                              do usuário        
                                              autenticado       

  `PUT`             `/usuarios/me`            Atualizar perfil  JWT
                                              do usuário        
                                              autenticado       

  `GET`             `/registros-agua`         Listar registros  JWT
                                              do usuário        
                                              autenticado       

  `POST`            `/registros-agua`         Criar registro de JWT
                                              consumo           
  -------------------------------------------------------------------------------

Os caminhos acima representam o contrato planejado. Confirmar se já
existem controllers ou rotas no código antes de criar novos.

### Formatos de referência

**Cadastro --- `POST /usuarios`**

Exemplo de requisição:

``` json
{
  "nomeUsuario": "usuario_teste",
  "email": "teste@example.com",
  "senha": "SenhaForte123!",
  "nome": "Usuário de Teste",
  "pesoKg": 70.5,
  "dataNascimento": "2000-01-15",
  "nivelAtividade": "Moderado"
}
```

A equipe deve decidir e padronizar se o cadastro também retorna JWT. O
formato desejado pelo aplicativo é:

``` json
{
  "token": "JWT_GERADO",
  "usuario": {
    "id": 1,
    "nomeUsuario": "usuario_teste",
    "email": "teste@example.com",
    "nome": "Usuário de Teste"
  }
}
```

**Login --- `POST /auth/login`**

Requisição:

``` json
{
  "email": "teste@example.com",
  "senha": "SenhaForte123!"
}
```

Resposta de referência:

``` json
{
  "token": "JWT_GERADO",
  "usuario": {
    "id": 1,
    "nomeUsuario": "usuario_teste",
    "email": "teste@example.com",
    "nome": "Usuário de Teste"
  }
}
```

**Criar registro --- `POST /registros-agua`**

Requisição de referência:

``` json
{
  "quantidadeMl": 250,
  "dataHora": "2026-11-14T10:30:00"
}
```

O usuário proprietário deve ser obtido da autenticação JWT, não do corpo
da requisição.

**Listar registros --- `GET /registros-agua`**

Resposta de referência:

``` json
[
  {
    "id": 1,
    "quantidadeMl": 250,
    "dataHora": "2026-11-14T10:30:00"
  }
]
```

### Orientações para quem implementará os controllers (Miquéias)

1.  Conferir os serviços, DTOs, entidades e exceções existentes antes de
    criar classes ou métodos.
2.  Manter os controllers enxutos: receber e validar a entrada, chamar o
    service e devolver o status HTTP e DTO apropriados.
3.  Não colocar consultas SQL, regras de negócio ou geração de
    senha/token diretamente no controller; delegar aos serviços
    existentes.
4.  Usar DTOs de entrada e saída. Nunca expor a entidade `Usuario`
    diretamente nem retornar o campo de senha.
5.  Para rotas privadas, obter o usuário autenticado pelo contexto de
    segurança/serviço de usuário autenticado. Não aceitar o ID do
    proprietário enviado pelo Flutter como fonte de autorização.
6.  Padronizar os códigos HTTP: `201 Created` para criação, `200 OK`
    para consultas/alterações bem-sucedidas, `400 Bad Request` para
    entrada/regra inválida, `401 Unauthorized` para ausência ou
    invalidade de autenticação e `404 Not Found` para recurso
    inexistente ou não pertencente ao usuário, conforme a política
    acordada.
7.  Para recuperação de senha, evitar revelar se um e-mail está
    cadastrado. O fluxo também precisa de envio do código, validade,
    limite de tentativas e proteção contra abuso; não considerar o fluxo
    completo enquanto esses pontos não estiverem implementados.
8.  Alinhar o formato de resposta do cadastro: atualmente o controller
    revisado retorna o DTO do usuário; o formato planejado para o
    aplicativo inclui `token` e `usuario`. Ajustar somente após acordo
    entre os responsáveis.
9.  Documentar cada rota com método, caminho, autenticação, JSON de
    entrada, JSON de saída e possíveis erros.
10. Testar as rotas com Postman ou ferramenta equivalente e compartilhar
    exemplos reais de requisição/resposta com quem fará a integração
    Flutter.

## Critérios de integração

Antes de considerar a API pronta para integração com o aplicativo:

-   Confirmar todos os caminhos e nomes de campos com a equipe Flutter.
-   Confirmar quais campos são obrigatórios e quais podem ser nulos.
-   Confirmar formatos de data/hora e unidades (por exemplo,
    mililitros).
-   Verificar respostas de erro e códigos HTTP.
-   Testar cadastro, login, token ausente/inválido e acesso a dados de
    dois usuários diferentes.
-   Confirmar que um usuário não consegue consultar ou alterar registros
    de outro.
-   Testar a recuperação de senha de ponta a ponta antes de documentá-la
    como concluída.

## Colaboração

O AquaVida é um projeto acadêmico desenvolvido em equipe. A
implementação de regras de negócio e persistência deve permanecer
alinhada com a camada de API e com a integração do aplicativo Flutter.
Alterações em DTOs compartilhados, contratos de endpoints ou respostas
devem ser discutidas entre os responsáveis antes de serem incorporadas.

------------------------------------------------------------------------

**AquaVida --- Aplicativo de Controle de Consumo de Água**\
Backend desenvolvido com Java, Spring Boot e MySQL.
