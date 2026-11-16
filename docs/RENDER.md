# Publicar o TerraByte no Render

O aplicativo deve consumir apenas a URL pública de `terrabyte`, com o prefixo `/api/v1`. Os outros dois serviços fazem parte da arquitetura exigida no trabalho.

## Preparação

1. Publique esta pasta em um repositório GitHub. Não envie `.env`, senhas ou `target`.
2. No Render, crie um Blueprint a partir desse repositório e do `render.yaml` da raiz. Alternativamente, crie três Web Services Docker usando a tabela abaixo.

| Serviço | Root Directory | Dockerfile | Health Check |
| --- | --- | --- | --- |
| servidor-eureka | servidor-eureka | ./Dockerfile | /health |
| terrabyte-ia | terrabyte-ia | ./Dockerfile | /actuator/health |
| terrabyte | terrabyte | ./Dockerfile | /actuator/health |

Use JDK 21 nas imagens Docker já fornecidas. Não configure comando Maven ou start command no painel: o Dockerfile cuida disso.

## Variáveis por serviço

Gere três segredos independentes de pelo menos 32 caracteres: senha Eureka, chave interna e chave JWT. Use valores hexadecimais para a senha Eureka, pois ela entra na URL.

| Serviço | Variável | Valor |
| --- | --- | --- |
| Eureka | EUREKA_USERNAME | terrabyte |
| Eureka | EUREKA_PASSWORD | senha do registro |
| IA | SPRING_PROFILES_ACTIVE | render |
| IA e API | EUREKA_URL | https://terrabyte:SENHA@HOST-DO-EUREKA/eureka/ |
| IA e API | AI_INTERNAL_KEY | mesma chave interna nos dois serviços |
| IA | OPENAI_API_KEY | chave de API com crédito disponível |
| IA e API | OPENAI_MODEL | gpt-4o-mini, ou o mesmo modelo nos dois |
| API | SPRING_PROFILES_ACTIVE | oracle,microservices,render |
| API | JWT_KEY | chave JWT |
| API | ORACLE_URL | jdbc:oracle:thin:@oracle.fiap.com.br:1521:orcl |
| API | ORACLE_USERNAME | usuário do schema |
| API | ORACLE_PASSWORD | senha Oracle |
| API | CORS_ALLOWED_ORIGINS | origens web autorizadas, separadas por vírgula; deixe vazio para app nativo sem origem web |

Use o hostname efetivamente fornecido pelo Render em `EUREKA_URL`; não copie um hostname ilustrativo. `PORT` e `RENDER_EXTERNAL_HOSTNAME` são fornecidos pelo Render.

Publique primeiro Eureka, depois IA e API. Aguarde os dois clientes aparecerem no painel Eureka. Configure as contas iniciais conforme a seção de bootstrap do README; depois retire o perfil `bootstrap` e as senhas de provisionamento.

## Conferência após publicar

1. Abra `https://HOST-DA-API/actuator/health` e `https://HOST-DA-API/swagger-ui/index.html`.
2. Faça login pelo Swagger; copie `accessToken` para Authorize.
3. Consulte `/api/v1/auth/me` e `/api/v1/properties`.
4. Gere uma recomendação para um dispositivo da conta com alertas e leituras. Isso confere também a descoberta Eureka, a chave interna e o provedor de IA.
5. Entregue ao responsável pelo app a base `https://HOST-DA-API/api/v1`, o Swagger e uma conta USER de demonstração. A validação no aplicativo fica com ele.

O acesso do Render ao Oracle precisa ser confirmado em execução. Se houver timeout JDBC, confira conectividade externa e disponibilidade do banco; não troque produção para H2, pois ele perde os dados ao reiniciar. Serviços Free podem suspender por inatividade, então acorde os três serviços antes da apresentação e aguarde novo registro no Eureka.

Preencha os links reais de deploy, repositório e vídeo no README e em IDENTIFICACAO.txt antes da entrega.

Referências oficiais: [Blueprint](https://render.com/docs/blueprint-spec) e [limites do plano Free](https://render.com/docs/free). As horas gratuitas são compartilhadas pelo workspace; três serviços ativos consomem três horas de instância por hora de relógio.
