# Nomes e importação no Eclipse

São três projetos Maven independentes, cada um com seu próprio pom.xml, código e Dockerfile: `terrabyte`, `terrabyte-ia` e `servidor-eureka`. Os nomes nos POMs, nos arquivos .project e nas classes principais correspondem a essas pastas.

1. Pare as aplicações e remova as referências antigas da lista de projetos do Eclipse. Se aparecer uma opção para apagar conteúdo em disco, deixe desmarcada.
2. As pastas antigas gestao_faculdade e gestao-faculdade-ia foram removidas. servidor-eureka agora é o projeto ativo do registro e deve ser mantido. A pasta externa é apenas um agrupamento: não importe ela como projeto General.
3. Use File > Import > Maven > Existing Maven Projects e selecione a raiz. Marque os três módulos TerraByte.
4. Em Run Configurations, crie execuções para TerraByteApiApplication, TerraByteIaApplication e TerraByteEurekaApplication. Configure JDK 21 e as variáveis do README. As execuções antigas não acompanham automaticamente a mudança das classes.
5. Inicie Eureka, IA e API.

A pasta externa `Projeto - 20_10_2026 - Turma I` pode manter esse nome; o Render usa as pastas dos módulos. Se quiser chamá-la `terrabyte-java`, feche o Eclipse e os terminais antes de renomeá-la pelo Explorer e depois importe os projetos no novo local. Não é necessário alterar pacotes nem caminhos de API por causa do nome dessa pasta externa.
