# Banco de dados

O perfil `oracle` usa o schema do usuário autenticado e valida as tabelas com Hibernate. Flyway fica desativado nesse perfil. Os IDs públicos são UUID e a persistência Oracle usa RAW(16).

Se o schema já funciona, mantenha os dados e não execute scripts de recriação.

Para um schema novo, `database/terrabyte_oracle.sql` é o script completo do projeto e começa removendo objetos e tabelas. Execute somente em um schema destinado a essa instalação. Os arquivos `terrabyte_oracle_dados.sql` e `terrabyte_oracle_programacao.sql` separam dados e programação PL/SQL; examine o script completo antes de executar partes novamente.

`database/terrabyte_java_oracle.sql` e a cópia em `terrabyte/src/main/resources/db/oracle/` contêm a estrutura Java complementar. Não execute scripts com CREATE TABLE sobre as mesmas tabelas já instaladas. Os testes de persistência em modo Oracle usam H2 e não comprovam conectividade ou execução em Oracle real.

Para desenvolvimento descartável use o perfil `dev`, com H2 em memória e migrations de `src/main/resources/db/migration`. Essas migrations fazem parte do domínio agrícola; o nome AgroConnect identifica o contrato compartilhado com o C#, não o antigo exemplo acadêmico.
