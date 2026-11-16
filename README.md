# 🌱 TerraByte – Backend Java Spring Boot

## Global Solution – 2026 | CitizenTech

## 👥 Dev do projeto

#### NOME: Emanuelly Ventura Do Nascimento

RM562339 - 2TDSPJ

#### NOME: Carolina Nascimento Gonçalves

RM564786 - 2TDSPJ

#### NOME: Julia Sayuri Kina

RM564555 - 2TDSPJ

---

# 📌 Descrição do Projeto

O TerraByte é uma solução agrícola desenvolvida com Java e Spring Boot para auxiliar no acompanhamento de hortas e pequenas plantações. O sistema organiza propriedades, talhões, plantios, dispositivos e sensores, permitindo consultar leituras ambientais, acompanhar alertas e obter recomendações contextualizadas com inteligência artificial generativa.

A API foi preparada para ser consumida pelo aplicativo mobile. Os caminhos e nomes dos campos JSON seguem o contrato AgroConnect utilizado pelo backend C# do grupo, mantendo informações como `deviceId`, `fieldId`, `cropName` e `accessToken`.

Os dados são separados por usuário: cada conta acessa suas propriedades e os registros vinculados a elas.

---

# 🏗️ Solução do Projeto

A solução utiliza arquitetura REST, Spring Data JPA, autenticação JWT e três projetos Maven independentes. Cada projeto possui seu próprio `pom.xml`, aplicação Spring Boot e Dockerfile, podendo ser compilado, executado e publicado separadamente.

A pasta externa apenas reúne os projetos e a documentação. Não existe um POM agregador na raiz.

| Projeto | Responsabilidade | Porta local | Classe principal |
| --- | --- | --- | --- |
| `terrabyte` | API REST, autenticação, autorização, persistência e coordenação das recomendações | 8080 | `TerraByteApiApplication` |
| `terrabyte-ia` | Geração de recomendações com Spring AI e OpenAI | 8082 | `TerraByteIaApplication` |
| `servidor-eureka` | Registro e descoberta dos serviços | 8761 | `TerraByteEurekaApplication` |

## 📂 Estrutura dos projetos

| Local | Conteúdo |
| --- | --- |
| `terrabyte/src/main/java/br/com/fiap/terrabyte_api/config` | Configurações da API, OpenAPI e persistência |
| `terrabyte/src/main/java/br/com/fiap/terrabyte_api/control` | Controllers REST e tratamento global de erros |
| `terrabyte/src/main/java/br/com/fiap/terrabyte_api/model` | Entidades e enumerações do domínio |
| `terrabyte/src/main/java/br/com/fiap/terrabyte_api/record` | DTOs de entrada, saída e paginação |
| `terrabyte/src/main/java/br/com/fiap/terrabyte_api/repository` | Repositórios Spring Data JPA |
| `terrabyte/src/main/java/br/com/fiap/terrabyte_api/security` | JWT, sessões, papéis e configurações de segurança |
| `terrabyte/src/main/java/br/com/fiap/terrabyte_api/service` | Regras de negócio e cliente OpenFeign |
| `terrabyte/src/main/java/br/com/fiap/terrabyte_api/validation` | Validações complementares dos DTOs |
| `terrabyte/src/main/resources` | Configurações, migrations, mapeamento Oracle e prompts |
| `terrabyte-ia/src/main` | Aplicação de IA, endpoint interno, DTOs, serviço e prompt agrícola |
| `servidor-eureka/src/main` | Aplicação Eureka, segurança e endpoint de saúde |
| `database` | Scripts SQL do projeto |
| `docs` | Guias de banco, execução, testes, IA e Render |
| `scripts/testar.ps1` | Verificação dos três projetos com Maven |
| `compose.yaml` | Execução dos três serviços com Docker Compose |
| `render.yaml` | Configuração de publicação dos três serviços no Render |

## 🔄 Arquitetura distribuída

**Opção escolhida no requisito 5: B – microsserviços com Eureka e OpenFeign.**

A API principal e o serviço de IA se registram no Eureka. Quando o usuário solicita recomendações, a API reúne o contexto do dispositivo e localiza `terrabyte-ia` pelo registro. A comunicação entre os serviços utiliza OpenFeign e o endpoint `POST /internal/recommendations`, protegido por uma chave interna.

O aplicativo acessa apenas a API principal. A chave interna e a chave OpenAI permanecem no servidor.

---

# 🚀 Link do Deploy

**Pendente: preencher com a URL desta versão após a publicação no Render.**

Serão publicados três serviços: `servidor-eureka`, `terrabyte-ia` e `terrabyte`. A URL entregue ao aplicativo será a do serviço `terrabyte`, com o prefixo `/api/v1`.

O passo a passo está em [docs/RENDER.md](docs/RENDER.md).

---

# 📚 Documentação da API

| Recurso | Endereço local |
| --- | --- |
| Swagger UI | [http://localhost:8080/swagger-ui/index.html](http://localhost:8080/swagger-ui/index.html) |
| OpenAPI JSON | [http://localhost:8080/v3/api-docs/terrabyte-v1](http://localhost:8080/v3/api-docs/terrabyte-v1) |
| API base | `http://localhost:8080/api/v1` |
| Saúde da API | [http://localhost:8080/actuator/health](http://localhost:8080/actuator/health) |
| Painel Eureka | [http://localhost:8761/](http://localhost:8761/) |

Após o deploy, substitua `http://localhost:8080` pela URL pública da API. O Swagger apresenta os DTOs, parâmetros e respostas completos de cada operação.

---

# 🎥 Vídeos

### Apresentação

**Pendente: inserir o link da apresentação da versão atual.**

### Pitch

**Pendente: inserir o link do pitch, com duração de até 5 minutos.**

---

# 🔗 Endpoints

Todos os caminhos das tabelas abaixo já incluem `/api/v1`. Os exemplos usam JSON e IDs UUID. Substitua os valores indicados como `UUID-...` pelos IDs retornados pela API.

As chamadas protegidas exigem:

```http
Authorization: Bearer <accessToken>
```

## 🔐 Autenticação

| Método | Caminho | Descrição |
| --- | --- | --- |
| POST | `/api/v1/auth/register` | Cadastra uma conta USER e retorna o token (201) |
| POST | `/api/v1/auth/login` | Autentica por e-mail e senha |
| GET | `/api/v1/auth/me` | Consulta o usuário autenticado |
| POST | `/api/v1/auth/logout` | Revoga a sessão atual e remove seu token de push (204) |

### ➕ Cadastro

```json
{
  "name": "Produtor de teste",
  "email": "produtor@terrabyte.test",
  "password": "SenhaDeExemplo123!"
}
```

A senha deve ter entre 8 e 128 caracteres. O exemplo representa uma conta a ser cadastrada; não é uma credencial já provisionada.

### 🔑 Login

```json
{
  "email": "produtor@terrabyte.test",
  "password": "SenhaDeExemplo123!"
}
```

A resposta contém `accessToken`, `tokenType`, `expiresIn` e `user`. No Swagger, clique em **Authorize** e informe o `accessToken`. O token dura uma hora; após a expiração, faça login novamente. Esta versão não possui endpoint de refresh token.

## 👤 Perfil e administração de usuários

| Método | Caminho | Descrição |
| --- | --- | --- |
| GET | `/api/v1/users/me` | Consulta o próprio perfil |
| PUT | `/api/v1/users/me` | Atualiza nome e e-mail do próprio perfil |
| GET | `/api/v1/admin/users` | Lista usuários; somente ADMIN |
| PATCH | `/api/v1/admin/users/{id}/role` | Altera o papel; somente ADMIN |
| PATCH | `/api/v1/admin/users/{id}/status` | Ativa ou desativa uma conta; somente ADMIN |

Exemplo de atualização do perfil:

```json
{
  "name": "Produtor TerraByte",
  "email": "produtor@terrabyte.test"
}
```

## 🏡 Propriedades

| Método | Caminho | Descrição |
| --- | --- | --- |
| GET | `/api/v1/properties` | Lista propriedades do usuário com paginação |
| GET | `/api/v1/properties/{id}` | Consulta uma propriedade |
| POST | `/api/v1/properties` | Cadastra uma propriedade |
| PATCH | `/api/v1/properties/{id}` | Atualiza os campos enviados |
| DELETE | `/api/v1/properties/{id}` | Exclui a propriedade e seus dados vinculados |

### ➕ Cadastro

```json
{
  "name": "Sítio Primavera",
  "city": "São Paulo",
  "state": "SP",
  "areaHectares": 1.5,
  "description": "Área destinada ao cultivo de hortaliças."
}
```

## 🌱 Talhões

| Método | Caminho | Descrição |
| --- | --- | --- |
| GET | `/api/v1/properties/{propertyId}/fields` | Lista os talhões da propriedade |
| POST | `/api/v1/properties/{propertyId}/fields` | Cadastra um talhão na propriedade |
| GET | `/api/v1/fields/{id}` | Consulta um talhão |
| PUT | `/api/v1/fields/{id}` | Atualiza um talhão |
| DELETE | `/api/v1/fields/{id}` | Exclui um talhão |

### ➕ Cadastro

```json
{
  "name": "Canteiro 01",
  "areaHectares": 0.2
}
```

O `propertyId` é informado no caminho da requisição.

## 🌾 Plantios

| Método | Caminho | Descrição |
| --- | --- | --- |
| GET | `/api/v1/fields/{fieldId}/plantings` | Lista os plantios do talhão |
| POST | `/api/v1/fields/{fieldId}/plantings` | Registra um plantio |
| GET | `/api/v1/fields/{fieldId}/plantings/{id}` | Consulta um plantio |
| GET | `/api/v1/fields/{fieldId}/plantings/{id}/details` | Consulta detalhes adicionais do plantio |
| PUT | `/api/v1/fields/{fieldId}/plantings/{id}` | Atualiza um plantio |
| DELETE | `/api/v1/fields/{fieldId}/plantings/{id}` | Exclui um plantio |

### ➕ Cadastro

```json
{
  "cropName": "Alface",
  "plantedAt": "2026-11-01T12:00:00Z",
  "stage": "SEEDLING"
}
```

Estágios aceitos: `SEEDLING`, `VEGETATIVE`, `MATURATION` e `HARVEST`. O DTO também permite informar cultura cadastrada, variedade, status e observações; consulte o Swagger.

## 📡 Dispositivos

| Método | Caminho | Descrição |
| --- | --- | --- |
| GET | `/api/v1/devices` | Lista dispositivos do usuário |
| GET | `/api/v1/devices/{id}` | Consulta um dispositivo |
| POST | `/api/v1/devices` | Cadastra um dispositivo vinculado a um talhão |
| PUT | `/api/v1/devices/{id}` | Atualiza um dispositivo |
| DELETE | `/api/v1/devices/{id}` | Exclui um dispositivo |
| GET | `/api/v1/devices/{id}/readings/latest` | Consulta as últimas leituras |
| GET | `/api/v1/devices/{id}/readings` | Consulta o histórico de leituras |

### ➕ Cadastro

```json
{
  "fieldId": "UUID-DO-TALHAO",
  "code": "ESP32-001",
  "name": "Estação do Canteiro 01",
  "firmwareVersion": "1.0.0",
  "transport": "WIFI",
  "simulatedData": true,
  "soilMoistureThreshold": 30
}
```

O histórico permite filtros por `sensorId` ou `type`, período (`from` e `to`) e `interval`. Os parâmetros e valores aceitos estão no Swagger.

## 🌡️ Sensores e leituras

| Método | Caminho | Descrição |
| --- | --- | --- |
| GET | `/api/v1/devices/{deviceId}/sensors` | Lista sensores do dispositivo |
| GET | `/api/v1/sensors/{id}` | Consulta um sensor |
| POST | `/api/v1/sensors` | Cadastra um sensor |
| PUT | `/api/v1/sensors/{id}` | Atualiza um sensor |
| DELETE | `/api/v1/sensors/{id}` | Exclui um sensor |
| GET | `/api/v1/sensors/{sensorId}/readings` | Lista leituras do sensor |
| GET | `/api/v1/readings/{id}` | Consulta uma leitura |
| POST | `/api/v1/readings` | Registra uma leitura |
| PUT | `/api/v1/readings/{id}` | Atualiza uma leitura |
| DELETE | `/api/v1/readings/{id}` | Exclui uma leitura |

### ➕ Cadastro de sensor

```json
{
  "deviceId": "UUID-DO-DISPOSITIVO",
  "type": "SOIL_MOISTURE",
  "label": "Umidade do solo",
  "unit": "%",
  "code": "SOLO-001",
  "calibrated": true
}
```

Tipos aceitos: `SOIL_MOISTURE`, `AIR_TEMPERATURE`, `AIR_HUMIDITY`, `LIGHT_ILLUMINANCE`, `RAINFALL` e `WATER_LEVEL`.

### ➕ Registro de leitura

```json
{
  "sensorId": "UUID-DO-SENSOR",
  "value": 25.5,
  "quality": "VALID",
  "recordedAt": "2026-11-01T12:00:00Z",
  "simulatedData": true,
  "origin": "SIMULATED"
}
```

Use uma data que não esteja no futuro. Leituras com qualidade `SENSOR_ERROR` exigem `value` nulo; leituras `VALID` exigem valor informado.

## 🚨 Alertas

| Método | Caminho | Descrição |
| --- | --- | --- |
| GET | `/api/v1/alerts` | Lista alertas e permite filtrar por status |
| GET | `/api/v1/alerts/{id}` | Consulta um alerta |
| POST | `/api/v1/alerts` | Cadastra um alerta |
| PUT | `/api/v1/alerts/{id}` | Atualiza um alerta |
| PATCH | `/api/v1/alerts/{id}/read` | Marca o alerta como lido; sem corpo |
| DELETE | `/api/v1/alerts/{id}` | Exclui um alerta |

### ➕ Cadastro

```json
{
  "deviceId": "UUID-DO-DISPOSITIVO",
  "severity": "WARNING",
  "title": "Umidade do solo baixa",
  "message": "A leitura está abaixo do limite configurado.",
  "reason": "Umidade inferior ao limite de 30%."
}
```

Severidades aceitas: `INFO`, `WARNING` e `CRITICAL`.

## 🤖 Recomendações com Spring AI

| Método | Caminho | Descrição |
| --- | --- | --- |
| POST | `/api/v1/recommendations` | Solicita recomendações com IA para um dispositivo |
| GET | `/api/v1/recommendations?deviceId={deviceId}` | Lista recomendações do dispositivo |
| GET | `/api/v1/recommendations/{id}` | Consulta uma recomendação |
| POST | `/api/v1/recommendations/records` | Cadastra um registro de recomendação pelo CRUD |
| PUT | `/api/v1/recommendations/{id}` | Atualiza um registro |
| DELETE | `/api/v1/recommendations/{id}` | Exclui um registro |

### ➕ Gerar recomendações

```json
{
  "deviceId": "UUID-DO-DISPOSITIVO"
}
```

A API utiliza os plantios, alertas e leituras disponíveis para orientar a geração. A funcionalidade faz parte do acompanhamento agrícola e não é um chat genérico. Requisições com contexto já processado podem reutilizar recomendações em cache.

A geração real exige os serviços disponíveis, o registro no Eureka e uma chave OpenAI válida. O cadastro manual em `/recommendations/records` não representa uma geração pelo modelo.

## 📋 Recursos complementares

| Recurso | Listagem | Cadastro | Consulta / atualização / exclusão |
| --- | --- | --- | --- |
| Culturas | `GET /api/v1/crops` | `POST /api/v1/crops` | `GET / PUT / DELETE /api/v1/crops/{id}` |
| Eventos dos dispositivos | `GET /api/v1/device-events` | `POST /api/v1/device-events` | `GET / PUT / DELETE /api/v1/device-events/{id}` |
| Histórico climático | `GET /api/v1/weather-history` | `POST /api/v1/weather-history` | `GET / PUT / DELETE /api/v1/weather-history/{id}` |
| Interações de IA | `GET /api/v1/ai-interactions` | `POST /api/v1/ai-interactions` | `GET / PUT / DELETE /api/v1/ai-interactions/{id}` |
| Auditoria de alertas | `GET /api/v1/alert-audits` | — | `GET /api/v1/alert-audits/{id}` |

Os filtros obrigatórios e os corpos dos recursos complementares estão descritos no Swagger.

### 📲 Token de notificação

`POST /api/v1/me/push-tokens` registra o token Expo associado à sessão e retorna 204. O envio externo de notificações push ainda não está implementado neste backend Java.

## 📄 Paginação e respostas de erro

Nas listagens paginadas, utilize `page` e `size`. A página começa em 1 e o tamanho máximo é 100.

```json
{
  "items": [],
  "page": {
    "number": 1,
    "size": 20,
    "totalItems": 0,
    "totalPages": 0
  }
}
```

Os erros seguem o formato `code`, `message`, `details` e `timestamp`.

| Status | Significado |
| --- | --- |
| 400 | Dados ou parâmetros inválidos |
| 401 | Autenticação ausente, inválida ou sessão revogada |
| 403 | Papel sem permissão para a operação |
| 404 | Recurso inexistente ou pertencente a outra conta |
| 409 | Conflito de dados ou de idempotência |

As criações de propriedades, talhões, plantios e alertas aceitam `Idempotency-Key` opcional, com até 128 caracteres. A mesma chave e conteúdo reutilizam a resposta; conteúdo diferente com a mesma chave retorna 409. Sem chave, requisições idênticas do mesmo usuário podem reutilizar a resposta durante cinco minutos.

---

# 🚀 Instruções de execução

## Pré-requisitos

- JDK 21, configurado no `JAVA_HOME`.
- Acesso à internet para baixar Maven e dependências no primeiro uso.
- Eclipse, IntelliJ IDEA ou outra IDE Java.
- Oracle acessível e schema preparado para execução persistente.
- Chave OpenAI para a geração real de recomendações.
- Docker e Docker Compose, caso escolha executar em contêineres.

O Maven Wrapper está incluído em cada projeto. Não é necessário instalar Maven globalmente.

## 📥 Obter e importar os projetos

Baixe ou clone o repositório desta versão e entre na pasta que contém `terrabyte`, `terrabyte-ia` e `servidor-eureka`. O link público do repositório Java deve ser preenchido na seção de entrega após a publicação.

No Eclipse, utilize **File → Import → Maven → Existing Maven Projects**, selecione a pasta externa e marque os três projetos. Configure o JDK 21. Não importe a pasta externa como um projeto Java único.

As instruções de atualização das referências antigas estão em [docs/ECLIPSE.md](docs/ECLIPSE.md).

## ⚙️ Variáveis de ambiente

Configure em **Run Configurations → Environment** ou no terminal que executará cada aplicação.

| Variável | API `terrabyte` | `terrabyte-ia` | `servidor-eureka` |
| --- | --- | --- | --- |
| `SPRING_PROFILES_ACTIVE` | `oracle,microservices` | Não precisa para execução local | Não precisa para execução local |
| `ORACLE_URL` | `jdbc:oracle:thin:@oracle.fiap.com.br:1521:orcl` | — | — |
| `ORACLE_USERNAME` | Usuário do schema | — | — |
| `ORACLE_PASSWORD` | Senha Oracle | — | — |
| `JWT_KEY` | Segredo de pelo menos 32 bytes | — | — |
| `AI_INTERNAL_KEY` | Segredo de pelo menos 32 caracteres | Mesmo valor da API | — |
| `EUREKA_PASSWORD` | Senha do registro | Mesma senha | Mesma senha, pelo menos 32 caracteres |
| `EUREKA_USERNAME` | — | — | `terrabyte` |
| `OPENAI_API_KEY` | — | Chave OpenAI | — |
| `OPENAI_MODEL` | `gpt-4o-mini` | Mesmo modelo da API | — |
| `CORS_ALLOWED_ORIGINS` | Origens web autorizadas, separadas por vírgula, se necessário | — | — |

Use três segredos independentes para JWT, comunicação interna e Eureka. Para gerar um valor hexadecimal com 32 bytes no PowerShell, execute o comando abaixo; repita três vezes:

```powershell
$bytes = New-Object byte[] 32
$rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()
$rng.GetBytes($bytes)
[BitConverter]::ToString($bytes).Replace('-', '')
$rng.Dispose()
```

Por padrão, os clientes usam `http://terrabyte:SENHA@localhost:8761/eureka/`, com `SENHA` obtida de `EUREKA_PASSWORD`. Caso utilize outro usuário ou host, configure `EUREKA_URL` completa na API e na IA. Senhas hexadecimais evitam caracteres que precisariam de escape na URL.

Arquivos `.env` não são carregados automaticamente pelas aplicações Spring Boot; utilize as variáveis da IDE/terminal ou o Docker Compose.

## 🗄️ Banco de dados

O perfil `oracle` utiliza Oracle por JDBC e Spring Data JPA. Os IDs são UUID no JSON e RAW(16) no banco. A conexão de exemplo usa o SID `orcl`.

O Hibernate valida o schema existente e não recria as tabelas nesse perfil. Se o banco já está configurado, não execute novamente os scripts de recriação. Para instalação em um schema novo, consulte [docs/BANCO.md](docs/BANCO.md).

Para desenvolvimento descartável, utilize o perfil `dev`, que executa migrations no H2 em memória. Para executar esse ambiente com os três serviços, use `dev,microservices` na API. Os dados H2 são perdidos ao encerrar a aplicação; o deploy está preparado para Oracle.

## ▶️ Executar pela IDE

Inicie nesta ordem:

1. `br.com.fiap.terrabyte_eureka.TerraByteEurekaApplication`.
2. `br.com.fiap.terrabyte_ia.TerraByteIaApplication`.
3. `br.com.fiap.terrabyte_api.TerraByteApiApplication`.

Acesse o painel Eureka com usuário `terrabyte` e a senha configurada. Aguarde a API e a IA aparecerem no registro antes de gerar recomendações.

## ▶️ Executar pelo terminal

Abra três terminais a partir da pasta externa. Configure em cada terminal as variáveis correspondentes da tabela anterior.

### Terminal 1 – Eureka

```powershell
cd servidor-eureka
.\mvnw.cmd package
java -jar target/servidor-eureka-0.0.1-SNAPSHOT.jar
```

### Terminal 2 – IA

```powershell
cd terrabyte-ia
.\mvnw.cmd package
java -jar target/terrabyte-ia-0.0.1-SNAPSHOT.jar
```

### Terminal 3 – API

```powershell
cd terrabyte
.\mvnw.cmd package
java -jar target/terrabyte-0.0.1-SNAPSHOT.jar
```

No Linux/macOS, utilize `sh mvnw package` no lugar de `.\mvnw.cmd package`.

## 🐳 Executar com Docker Compose

Na pasta externa:

```powershell
Copy-Item .env.example .env
```

Preencha o `.env` com suas configurações e execute:

```powershell
docker compose up --build
```

A API estará em `http://localhost:8080` e o Eureka em `http://localhost:8761`. A IA permanece acessível pela rede interna do Compose. Os contêineres usam Oracle externo e não instalam nem apagam o banco.

## 👥 Usuários de teste

Não há senha fixa de administrador no código. Para provisionar contas de demonstração com credenciais escolhidas pela equipe, acrescente temporariamente `bootstrap` aos perfis da API: `oracle,microservices,bootstrap`.

| Variáveis | Finalidade |
| --- | --- |
| `ADMIN_EMAIL` e `ADMIN_PASSWORD` | Criam uma conta ADMIN, se ainda não existir |
| `DEMO_USER_EMAIL` e `DEMO_USER_PASSWORD` | Criam uma conta USER, se ainda não existir |
| `DEMO_DATA_ENABLED=true` | Cria a base agrícola simulada vinculada ao usuário de demonstração |

Exemplos de e-mail: `admin@terrabyte.test` e `demo@agroconnect.com`. Defina senhas de 8 a 128 caracteres e informe ao avaliador as credenciais efetivamente provisionadas. As contas dos scripts SQL não representam credenciais prontas para login.

O bootstrap não redefine a senha de contas existentes nem altera seu papel. Após criar as contas, remova o perfil `bootstrap` e as senhas de provisionamento. Cadastros públicos recebem sempre o papel USER.

---

# ⚙️ Funcionalidades

- **Usuários e segurança:** cadastro, login JWT, consulta e atualização do perfil, logout com revogação de sessão e papéis USER/ADMIN.
- **Administração:** listagem de usuários, alteração de papel e ativação/desativação de contas.
- **Propriedades e talhões:** cadastro, consulta, atualização, exclusão e organização das áreas de cultivo.
- **Plantios e culturas:** registro de plantios, estágios de desenvolvimento e dados complementares das culturas.
- **Dispositivos e sensores:** cadastro das estações, vinculação aos talhões e configuração dos sensores.
- **Leituras:** registro, consulta das últimas medições e histórico com filtros e intervalos.
- **Alertas e auditoria:** acompanhamento de ocorrências, classificação de severidade e marcação de leitura.
- **Recomendações com IA:** orientações contextualizadas por dispositivo, com persistência e cache do contexto.
- **Registros complementares:** eventos de dispositivos, histórico climático e interações de IA.
- **Integração:** contrato REST compatível com os nomes públicos do C# e registro de tokens Expo por sessão.

O ADMIN gerencia contas, mas não recebe acesso geral às plantações de outros usuários. O envio externo de notificações push ainda não está implementado no Java.

---

# ⚡ Tecnologias Utilizadas

| Área | Tecnologias |
| --- | --- |
| Backend | Java, Spring Boot, Spring Web MVC, Maven |
| Persistência | Spring Data JPA, Hibernate, Oracle JDBC |
| Desenvolvimento e testes | H2, Flyway, JUnit, Spring Boot Test e MockMvc |
| Segurança | Spring Security, JWT HS256 e sessões revogáveis |
| Validação | Bean Validation e validadores personalizados |
| IA generativa | Spring AI, ChatClient, OpenAI e respostas estruturadas |
| Arquitetura distribuída | Eureka, OpenFeign e Spring Cloud LoadBalancer |
| Documentação | Swagger UI e OpenAPI com springdoc |
| Execução e deploy | Docker, Docker Compose e configuração para Render |

API e IA utilizam Spring Boot 4.0.3 e Spring AI 2.0.1. O Eureka utiliza Spring Boot 4.1.1. O ambiente de execução e as imagens Docker usam JDK 21. O cache de recomendações e a idempotência são implementados pelo projeto; não representam uso de Spring Cache.

---

# ✅ Testes e validação

Para verificar os três projetos, execute na pasta externa:

```powershell
.\scripts\testar.ps1
```

Também é possível executar `.\mvnw.cmd verify` dentro de cada projeto.

Os testes verificam CRUDs, paginação, isolamento entre usuários, JWT, papéis, validação, idempotência, fluxo de IA e comparação do contrato C# com o Swagger Java. Eles usam H2 e modelos controlados, sem consumir créditos OpenAI. O teste de persistência em modo Oracle usa H2 e não substitui a execução com Oracle real.

Na revisão foram executados **87 testes sem falhas ou erros**: 83 da API, dois da IA e dois do Eureka. A etapa posterior de empacotamento executável ficou pendente por dependências ausentes no cache e indisponibilidade de acesso ao Maven Central naquele ambiente. O build completo e o deploy ainda precisam de confirmação.

A conexão real com Oracle e a geração real com OpenAI serão conferidas no ambiente publicado. O teste no aplicativo será feito pelo responsável pelo mobile após receber a URL da API.

---

# 📦 Entrega e documentação complementar

| Item | Situação |
| --- | --- |
| Repositório Java público desta versão | Pendente: preencher a URL |
| Deploy da API | Pendente: preencher após publicar |
| Vídeo de apresentação | Pendente: preencher o link |
| Pitch de até 5 minutos | Pendente: preencher o link |
| TXT de identificação | [IDENTIFICACAO.txt](IDENTIFICACAO.txt): conferir os integrantes e atualizar os links antes da entrega |

A entrega solicitada contém um ZIP com o TXT de identificação e os links do repositório e do vídeo. Não inclua `.env`, senhas, tokens, logs, configurações locais da IDE ou diretórios `target`.

| Guia | Conteúdo |
| --- | --- |
| [Eclipse](docs/ECLIPSE.md) | Importação dos três projetos independentes |
| [Banco](docs/BANCO.md) | Configuração e scripts Oracle |
| [Render](docs/RENDER.md) | Publicação dos serviços e variáveis |
| [Testes](docs/TESTES.md) | Roteiro de verificação da API |
| [Spring AI](docs/SPRING_AI.md) | Fluxo de geração das recomendações |
| [Revisão](docs/REVISAO.md) | Requisitos da disciplina e evidências |

Referência de integração: [repositório C# do grupo](https://github.com/Emanuelly0ventura/GS_DotNet), commit `e0afc71888067fa8693e57521a6a1b1c32f5eb99`. A comparação cobre os nomes e formatos públicos do contrato; não implica equivalência de todas as funcionalidades internas do C#.

---

# 🤖 Declaração de uso de IA

O produto utiliza Spring AI com OpenAI para gerar recomendações agrícolas a partir do contexto de dispositivos, alertas, leituras e plantios. Os dados simulados da demonstração são identificados como tal, e as orientações geradas precisam de conferência humana. Chaves e credenciais de autenticação não são enviadas ao modelo.

Foi utilizada assistência do ChatGPT/Codex no desenvolvimento, revisão, testes e documentação do backend Java. A equipe é responsável por revisar o código e os textos, compreender a implementação e validar o funcionamento da solução.
