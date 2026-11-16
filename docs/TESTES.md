# Verificação da API

Execute `./scripts/testar.ps1` no PowerShell com JAVA_HOME apontando para o JDK 21. O script executa Maven verify em API, IA e Eureka. Não exige testar o aplicativo mobile.

No Swagger, os caminhos abaixo usam o prefixo `/api/v1`.

1. Cadastre uma conta em `POST /auth/register`: `{"name":"Teste TerraByte","email":"teste@terrabyte.test","password":"SenhaDeTeste123!"}`. Espere 201 e accessToken. Use um e-mail novo se a conta já existir.
2. Faça login em `POST /auth/login` com email e password. Espere 200. Autorize as chamadas com o token retornado.
3. Crie uma propriedade em `POST /properties`: `{"name":"Horta de teste","city":"Sao Paulo","state":"SP","areaHectares":1.5,"description":"Demonstracao"}`. Espere 201 e guarde o id.
4. Liste `/properties?page=1&size=20`. Confira items e os metadados em page.
5. Crie um talhão em `POST /properties/{propertyId}/fields`: `{"name":"Canteiro 01","areaHectares":0.2}`. Confira consulta, edição e exclusão pelos caminhos exibidos no Swagger.
6. Envie nome vazio ou área negativa. Espere 400 com code, message, details e timestamp.
7. Consulte sem JWT: espere 401. Com USER, consulte `/admin/users`: espere 403. Uma conta ADMIN provisionada pode acessar a listagem.
8. Com uma segunda conta, tente consultar a propriedade da primeira: espere 404.
9. Faça logout e reutilize o token revogado: espere 401.
10. Com os serviços registrados no Eureka, gere recomendações para um dispositivo com alertas e leituras da conta. Confira a resposta e a persistência. A geração real requer a chave OpenAI.

Os testes automatizados cobrem também idempotência, contrato Swagger/C#, CRUDs adicionais e respostas de erro. A validação no app será feita pelo responsável pelo mobile após receber a URL publicada.
