# Heuristic

Calcula uma aproximação da solução de uma instância do problema "atrapalhando fugitivos", informada pelo *stdin*, utilizando a meta-heurística de recozimento simulado. Existe um tempo limite de 30 minutos para finalizar a execução, e se o programa ainda não tiver convergido, ele para retornando a melhor solução encontrada. O formato do comando é o seguinte:

```bash
julia <Heuristic.jl> <arquivo_de_saida>
```

Para informar uma instância para o programa a partir de um arquivo chamado `instancia.dat`, utilize o comando a seguir. A estrutura da instância precisa ser compatível com os modelos localizados em `af/instances`.

```bash
cat <instancia.dat> | julia <Heuristic.jl> <arquivo_de_saida>
```

A saída do programa lista, em cada linha, uma informação diferente. O conteúdo das linhas está listado em ordem abaixo.

- Semente utilizada
- Tempo de execução
- Melhor valor encontrado