# TerraByte — Java Advanced

Referência de integração: [API C# do grupo](https://github.com/Emanuelly0ventura/GS_DotNet), commit `e0afc71888067fa8693e57521a6a1b1c32f5eb99`. Os nomes públicos AgroConnect e os campos JSON são preservados para o aplicativo.

Para importar os módulos renomeados e remover as referências antigas do Eclipse, siga [docs/ECLIPSE.md](docs/ECLIPSE.md).

Backend Java da solução CitizenTech para acompanhar hortas e pequenas plantações. A API mantém o contrato AgroConnect utilizado pelo mobile e gera recomendações agrícolas com Spring AI a partir de alertas e leituras de sensores.

## Serviços

São três projetos Maven independentes, sem POM agregador na raiz. Cada um compila e inicia separadamente. A pasta externa apenas reúne os projetos e a documentação; no Render, cada projeto é publicado como um serviço.

| Pasta | Classe principal | Porta local | Responsabilidade |
| --- | --- | --- | --- |
| `terrabyte` | `br.com.fiap.terrabyte_api.TerraByteApiApplication` | 8080 | REST, JWT, autorização, JPA/Oracle, Swagger e coordenação das recomendações |
| `terrabyte-ia` | `br.com.fiap.terrabyte_ia.TerraByteIaApplication` | 8082 | Spring AI, ChatClient e OpenAI |
| `servidor-eureka` | `br.com.fiap.terrabyte_eureka.TerraByteEurekaApplication` | 8761 | Registro e descoberta dos serviços |

Arquitetura escolhida no requisito 5: **opção B — microsserviços com Eureka e OpenFeign**. A API encontra `terrabyte-ia` pelo Eureka e chama `POST /internal/recommendations`. O mobile consome apenas a API pública, inclusive para recomendações. A chave interna e a chave OpenAI não vão para o aplicativo.

Tecnologias: Java 17 ou superior (JDK 21 recomendado), Maven, Spring Boot, Spring Data JPA, Bean Validation, Spring Security, JWT HS256, Spring AI, Eureka, OpenFeign e springdoc OpenAPI. API/IA usam Spring Boot 4.0.3; o registro mantém Spring Boot 4.1.1. O Spring AI está na versão 2.0.1.

## Executar com Oracle

1. Configure JDK 21 no Eclipse e no `JAVA_HOME`.
2. Importe **Existing Maven Projects**, selecionando a pasta raiz e os três módulos novos. Remova do workspace do Eclipse as referências aos projetos antigos; as configurações de execução antigas apontam para classes que foram renomeadas. As pastas antigas vazias foram removidas; mantenha os três projetos da tabela acima.
3. Se o banco TerraByte já funciona, **não recrie as tabelas**. A limpeza do Java não exige apagar ou migrar dados. Leia [database](docs/BANCO.md) apenas se precisar instalar um schema novo.
4. Gere três segredos diferentes, um para `JWT_KEY`, outro para `AI_INTERNAL_KEY` e outro para `EUREKA_PASSWORD`. No PowerShell, este comando gera uma chave hexadecimal; execute-o três vezes:

```powershell
[Convert]::ToHexString([System.Security.Cryptography.RandomNumberGenerator]::GetBytes(32))
```

5. Configure as variáveis em **Run Configurations → Environment**, em cada aplicação:

| Variável | API | IA | Eureka |
| --- | --- | --- | --- |
| `SPRING_PROFILES_ACTIVE` | `oracle,microservices` | não precisa | não precisa |
| `ORACLE_URL` | `jdbc:oracle:thin:@oracle.fiap.com.br:1521:orcl` | — | — |
| `ORACLE_USERNAME` | seu usuário | — | — |
| `ORACLE_PASSWORD` | sua senha | — | — |
| `JWT_KEY` | segredo JWT, mínimo 32 bytes | — | — |
| `AI_INTERNAL_KEY` | segredo interno, mínimo 32 caracteres | **mesmo valor da API** | — |
| `EUREKA_PASSWORD` | senha do registro | **mesmo valor** | **mesmo valor**, mínimo 32 caracteres |
| `EUREKA_USERNAME` | — | — | `terrabyte` |
| `OPENAI_API_KEY` | — | sua chave OpenAI | — |
| `OPENAI_MODEL` | `gpt-4o-mini` | **mesmo modelo** | — |
| `CORS_ALLOWED_ORIGINS` | origens web separadas por vírgula, quando houver | — | — |

O endereço Oracle usa **SID `orcl`**, não service name. As tabelas ficam no usuário Oracle autenticado. Os IDs continuam UUID em JSON e RAW(16) no Oracle. O JDBC/JPA continua sendo o responsável pela persistência; o Hibernate valida o schema e não recria tabelas.

Por padrão, os clientes usam `http://terrabyte:SENHA@localhost:8761/eureka/`, substituindo `SENHA` por `EUREKA_PASSWORD`. Para outro usuário/host, configure `EUREKA_URL` completa na API e na IA. Gere a senha em hexadecimal para que não precise escapar caracteres na URL.

6. Inicie **Eureka → IA → API**. No Eclipse, execute as classes da tabela anterior. Pelo terminal, compile cada módulo com `mvnw.cmd package` e execute o JAR correspondente com as mesmas variáveis de ambiente:

```powershell
cd servidor-eureka
.\mvnw.cmd package
java -jar target/servidor-eureka-0.0.1-SNAPSHOT.jar
```

Em outros dois terminais, repita para `terrabyte-ia` e `terrabyte`, substituindo os nomes no comando. No Linux/macOS use `sh mvnw package`. O Maven Wrapper baixa o Maven no primeiro uso; as dependências também precisam de internet na primeira compilação.

7. Consulte os serviços:

- Eureka: `http://localhost:8761/` — login HTTP Basic com usuário `terrabyte` e `EUREKA_PASSWORD`.
- Swagger: `http://localhost:8080/swagger-ui/index.html`.
- OpenAPI JSON: `http://localhost:8080/v3/api-docs/terrabyte-v1`.
- Saúde API/IA: `/actuator/health`; saúde Eureka: `/health`.

Espere API e IA aparecerem no Eureka antes de gerar recomendações. A descoberta pode levar alguns ciclos de atualização. Login e CRUD não dependem de uma chamada ao modelo de IA.

## Usuários para demonstração

Não há senha fixa de administrador no código. As contas inseridas pelos scripts SQL estão bloqueadas para login e existem apenas para a demonstração do banco.

Para criar contas de teste com senha conhecida, acrescente temporariamente `bootstrap` aos perfis da API (`oracle,microservices,bootstrap`) e configure:

| Variável | Exemplo de e-mail | Regra |
| --- | --- | --- |
| `ADMIN_EMAIL` / `ADMIN_PASSWORD` | `admin@terrabyte.test` | Cria ADMIN se a conta ainda não existir |
| `DEMO_USER_EMAIL` / `DEMO_USER_PASSWORD` | `demo@agroconnect.com` | Cria USER se a conta ainda não existir |
| `DEMO_DATA_ENABLED` | `true` | Cria a base agrícola simulada para DEMO_USER_EMAIL |

Escolha senhas de 8 a 128 caracteres e forneça as credenciais de demonstração ao avaliador por um canal adequado. O bootstrap não redefine senhas existentes, não altera o papel de outra conta e não vincula dados antigos a uma conta nova. Após provisionar, remova `bootstrap` e os segredos de provisionamento da configuração. Novos cadastros públicos sempre recebem USER.

Para testar sem Oracle, use o perfil `dev`: o H2 é em memória, executa somente as migrations do domínio TerraByte e perde os dados ao encerrar. Para a demonstração distribuída, use `dev,microservices` e configure os segredos dos serviços; para produção no Render, use Oracle. Arquivos `.env` não são carregados automaticamente pelo Spring: configure as variáveis no Eclipse/terminal, ou use o Compose.

## Executar com Docker Compose

Copie `.env.example` para `.env`, preencha seus dados e segredos e execute na raiz:

```powershell
docker compose up --build
```

Os contêineres usam Oracle externo; não instalam nem apagam o banco. O Compose inicia os três serviços, mas a descoberta é assíncrona: aguarde o registro da IA antes de chamar recomendações. A API fica em `localhost:8080` e o Eureka em `localhost:8761`. A porta da IA fica apenas na rede do Compose.

## Contrato público e endpoints principais

Prefixo `/api/v1`. IDs UUID; datas UTC com `Z`; `Authorization: Bearer <accessToken>`. Listas usam `{ "items": [], "page": { "number": 1, "size": 20, "totalItems": 0, "totalPages": 0 } }`. A página começa em 1 e o tamanho máximo é 100. Os dados são separados por usuário; um recurso de outro usuário retorna 404. O papel ADMIN não permite consultar a plantação de outra conta.

| Método | Caminho | Uso |
| --- | --- | --- |
| POST | `/auth/register` | Cadastro e início de sessão (201) |
| POST | `/auth/login` | Login por e-mail e senha |
| GET / POST | `/auth/me` / `/auth/logout` | Perfil / encerramento da sessão |
| GET / POST | `/properties` | Listagem paginada / criação |
| GET / PATCH / DELETE | `/properties/{id}` | Consulta / edição parcial / exclusão |
| GET / POST | `/properties/{propertyId}/fields` | Talhões da propriedade |
| GET / PUT / DELETE | `/fields/{id}` | CRUD de talhão |
| GET / POST | `/fields/{fieldId}/plantings` | Plantios de um talhão existente |
| GET / PUT / DELETE | `/fields/{fieldId}/plantings/{id}` | CRUD de plantio |
| GET / POST | `/devices` | Dispositivos |
| GET | `/devices/{id}/readings/latest` | Últimas leituras, incluindo falhas com valor nulo |
| GET | `/devices/{id}/readings` | Histórico por `sensorId` ou `type`, `from`, `to`, `interval` |
| GET | `/devices/{deviceId}/sensors` | Sensores do dispositivo |
| GET / POST | `/alerts` | Alertas por status / criação |
| PATCH | `/alerts/{id}/read` | Marcar como lido, sem corpo |
| POST | `/recommendations` | Gerar recomendações com Spring AI |
| POST | `/me/push-tokens` | Registrar token Expo da sessão (204) |
| GET | `/admin/users` | Listar usuários; somente ADMIN |
| PATCH | `/admin/users/{id}/role` | Alterar papel; somente ADMIN |
| PATCH | `/admin/users/{id}/status` | Ativar/desativar; somente ADMIN |

Há CRUDs complementares para sensores, leituras, culturas, eventos, clima e interações de IA, além da consulta de auditoria. Os parâmetros e DTOs completos ficam no Swagger. Os caminhos com barra final continuam aceitos quando já existiam, mas o Swagger mostra só a versão sem barra.

A criação de propriedades, talhões, plantios e alertas aceita `Idempotency-Key` opcional (até 128 caracteres). Mesma chave/conteúdo repete a resposta 201 e o mesmo Location; conteúdo diferente com a mesma chave retorna 409. Sem chave, o mesmo corpo/caminho para o mesmo usuário é reutilizado por 5 minutos, conforme o comportamento do C#.

Erros têm `code`, `message`, `details` e `timestamp`. Validação retorna 400, autenticação inválida 401, papel insuficiente 403, recurso ausente/alheio 404 e conflito 409. O JWT dura uma hora e a sessão é consultada no banco; logout revoga apenas a sessão atual e remove seu token de push. Mudanças administrativas de papel/status revogam as sessões da conta.

## Testar e apresentar

Execute `scripts/testar.ps1` na raiz para verificar os três módulos com Maven, ou `mvnw.cmd verify` em cada módulo. Os testes usam H2 e modelos controlados, sem consumir créditos OpenAI nem depender do Oracle de produção. Eles verificam CRUD, isolamento de dados, JWT/papéis, validação, idempotência, o fluxo de IA e o contrato do Swagger. O teste de Oracle usa H2 em modo Oracle e não substitui o teste com Oracle real.

O roteiro com JSON está em [docs/TESTES.md](docs/TESTES.md). A revisão dos requisitos e do contrato C# está em [docs/REVISAO.md](docs/REVISAO.md). Os exemplos e a explicação da IA estão em [docs/SPRING_AI.md](docs/SPRING_AI.md).

## Deploy e entrega

O [guia do Render](docs/RENDER.md) explica os três serviços, as variáveis e o endereço que deve ser entregue ao desenvolvedor mobile. `render.yaml` prepara três Web Services no plano Free; ele não publica nada por conta própria. O acesso real do Render ao Oracle precisa ser confirmado no deploy.

- Repositório Java público: **PENDENTE — preencher com a URL deste projeto Java**.
- API publicada: **PENDENTE — preencher após o deploy**.
- Vídeo pitch (até 5 minutos): **PENDENTE — preencher com o link**.
- Identificação: [IDENTIFICACAO.txt](IDENTIFICACAO.txt); conferir os integrantes antes da entrega.

A entrega pede um ZIP com o TXT de identificação e os links do repositório e do vídeo. Não inclua `.env`, senhas, tokens, `.settings`, logs nem os diretórios `target` no ZIP/repositório.

## Declaração de uso de IA

A funcionalidade do produto usa Spring AI com OpenAI para produzir orientações agrícolas contextualizadas; não é um chat genérico. Os dados de sensores da demonstração são simulados e identificados nas respostas; os textos são produzidos pelo LLM e precisam de conferência humana. Chaves e dados de autenticação não são enviados no contexto do modelo.

Foi utilizada assistência do ChatGPT/Codex no desenvolvimento, revisão, testes e documentação do backend Java. A equipe deve revisar o material, conhecer o funcionamento e validar a solução antes da entrega.

O registro de tokens Expo está implementado. **O envio externo de notificações push presente no C# não está implementado neste Java**; não habilite nem anuncie envio de push como funcionalidade entregue. A revisão confirma os nomes e formatos públicos, não equivalência de todas as funcionalidades internas do C#. O teste no aplicativo será feito pelo responsável pelo mobile após o deploy.
