# IntegerSolver

Calcula a solução exata de uma instância do problema "atrapalhando fugitivos", informada pelo *stdin*, utilizando o *solver* de programação inteira GLPK. Existe um tempo limite de 30 minutos para finalizar a execução, e se não tiver obtido uma resposta nesse tempo, o programa para independentemente. O formato do comando é o seguinte:

```bash
julia <dir_arquivo_run> <arquivo_de_saida> <valor_de_n>
```

Para informar uma instância para o programa a partir de um arquivo chamado `instancia.dat`, utilize o comando a seguir. A estrutura da instância precisa ser compatível com os modelos localizados em `af/instances`.

```bash
cat instancia.dat | julia <dir_arquivo_run> <arquivo_de_saida> <valor_de_n>
```

A saída do programa lista, em cada linha, uma informação diferente. O conteúdo das linhas está listado em ordem abaixo.

- Status de fim de execução
- Tempo de execução
- Valor ótimo encontrado