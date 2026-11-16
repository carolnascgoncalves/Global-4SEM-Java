# Revisão dos requisitos Java Advanced

Referência C#: https://github.com/Emanuelly0ventura/GS_DotNet, commit `e0afc71888067fa8693e57521a6a1b1c32f5eb99`. Esse é também o commit registrado no arquivo de contrato dos testes Java.

| Requisito | Implementação e evidência |
| --- | --- |
| REST, três entidades relacionadas, JPA e paginação | Usuário, propriedade, talhão e plantio, além de dispositivos, sensores e demais entidades. Controllers, repositories e testes de domínio. |
| Bean Validation e erros padronizados | Validações nos records e ApiExceptionHandler com RestControllerAdvice. |
| JWT e dois papéis | Spring Security, USER/ADMIN, rotas administrativas e sessões revogáveis. AuthenticationTests. |
| Spring AI integrado ao domínio | Recomendações a partir de leituras, alertas e plantios; ChatClient e resposta estruturada. Testes de IA. |
| Arquitetura distribuída | Opção B: API e IA, registro Eureka e comunicação OpenFeign. É necessário executar os serviços para demonstrar a descoberta real. |
| Swagger, README e integração | OpenAPI público, instruções de execução e contrato JSON/rotas de referência. O teste no app fica com o responsável pelo mobile após o deploy. |

SwaggerTests compara os campos e caminhos do contrato salvo com o OpenAPI Java. A referência atual do GitHub foi conferida em 16/11/2026 e apresenta o mesmo commit. Os nomes públicos AgroConnect, properties, fields, plantings, deviceId e accessToken são mantidos por compatibilidade com o C#.

Essa comparação não implica equivalência de todas as funcionalidades internas: o Java registra tokens Expo, mas não implementa o worker de envio externo de push do C#.

As pastas e classes dos serviços já usam TerraByte. Não foram encontrados controllers, entidades ou referências de gestão de faculdade nos módulos atuais. As três pastas antigas estavam vazias na revisão.

Antes da entrega, preencher os links reais do repositório Java, deploy e vídeo (até cinco minutos), conferir os integrantes no TXT e preparar o ZIP exigido. A publicação, a conexão real com Oracle, a chamada real ao LLM e o teste no app não podem ser comprovados apenas pelos testes locais.

## Resultado da verificação desta revisão

Foram executados 87 testes com JDK 21: 83 na API, dois na IA e dois no Eureka, todos sem falhas ou erros. Isso inclui a comparação do Swagger com o contrato C#.

O Maven foi executado em modo offline usando o cache disponível. Os testes terminaram, mas a etapa posterior `spring-boot:repackage` falhou nos três módulos por dependências do plugin ausentes no cache, sem acesso ao Maven Central. Portanto, o empacotamento executável e a imagem Docker ainda precisam de confirmação em um ambiente com acesso às dependências, como o build do Render. Não foi alterado código para omitir essa etapa.

Foi corrigida a URL do Wrapper da API para que a pasta da versão e o arquivo de distribuição apontem ambos para Maven 3.10.0. Também foi alinhado OPENAI_MODEL entre API e IA no Compose e no Blueprint.
