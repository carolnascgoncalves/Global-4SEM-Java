# Recomendações com Spring AI

O fluxo público começa em `POST /api/v1/recommendations` com `{"deviceId":"UUID-DO-DISPOSITIVO"}` e JWT. A API verifica a propriedade do dispositivo, reúne plantios, alertas e leituras e chama o serviço `terrabyte-ia` via OpenFeign e descoberta Eureka.

O serviço de IA recebe `POST /internal/recommendations` com `X-Internal-Key`, usa ChatClient e o prompt de `src/main/resources/prompts/recommendations-system.txt`, e produz uma resposta estruturada para o contexto agrícola. A chave OpenAI fica somente no servidor de IA. O aplicativo não chama esse endpoint interno.

As recomendações são validadas e persistidas pela API. Há cache de contexto; requisições repetidas podem reutilizar recomendações existentes. A demonstração identifica dados simulados. Erros do modelo ou configuração ausente não devem ser apresentados como resposta gerada com sucesso.

Os testes automatizados usam modelos controlados. Confirmar uma geração real exige executar os serviços com Eureka, chave interna correspondente e uma chave OpenAI válida, usando um dispositivo com contexto disponível. A orientação gerada exige conferência humana.
