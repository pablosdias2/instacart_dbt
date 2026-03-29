# Instacart dbt

Projeto dbt para modelagem analitica da base Instacart, organizando os dados em camadas de staging, intermediate e marts.

## Objetivo

Este projeto transforma tabelas brutas do schema `public` em modelos analiticos prontos para consumo. O fluxo atual cobre:

- padronizacao das tabelas fonte do Instacart
- consolidacao dos detalhes de pedido por produto
- criacao de um mart com os produtos mais vendidos

## Fontes de dados

As fontes estao definidas em `models/staging/instacart/source.yml` e apontam para as tabelas:

- `orders`
- `products`
- `departments`
- `aisles`
- `order_products__prior`
- `order_products__train`

## Estrutura do projeto

```text
models/
	staging/instacart/
		stg_orders.sql
		stg_order_products.sql
		stg_products.sql
		stg_departments.sql
		stg_aisles.sql
	intermediate/instacart/
		int_order_details.sql
	marts/instacart/
		mart_top_products.sql
```

## Fluxo dos models

O pipeline segue a estrutura classica do dbt:

```text
sources
	-> staging
	-> intermediate
	-> marts
```

### 1. Sources

O arquivo `source.yml` registra as tabelas brutas e permite usar `source()` com rastreabilidade e documentacao.

### 2. Staging

Os modelos da camada `staging` fazem a leitura inicial das fontes e deixam os dados prontos para reuso nas proximas camadas.

- `stg_orders.sql`: dados basicos dos pedidos
- `stg_order_products.sql`: relacao entre pedidos e produtos
- `stg_products.sql`: cadastro de produtos
- `stg_departments.sql`: dimensao de departamentos
- `stg_aisles.sql`: dimensao de corredores

Nesta camada o foco e isolar a origem e padronizar o acesso aos dados.

### 3. Intermediate

O modelo `int_order_details.sql` consolida os detalhes do pedido por produto, juntando pedidos, produtos, departamentos e corredores.

Ele centraliza:

- joins entre entidades principais
- enriquecimento dimensional
- tipagem explicita das colunas com `cast`

Colunas principais geradas:

- `order_id`
- `user_id`
- `order_number`
- `order_dow`
- `order_hour_of_day`
- `product_id`
- `product_name`
- `department`
- `aisles_name`
- `add_to_cart_order`
- `reordered`

### 4. Mart

O modelo `mart_top_products.sql` agrega os dados de `int_order_details` para gerar um ranking de produtos.

Metricas disponiveis:

- `total_vendas`: quantidade total de vendas por produto
- `total_usuarios`: quantidade de usuarios distintos que compraram o produto
- `total_recompras`: quantidade de recompras do produto

Esse mart e o ponto ideal para analise de performance de produtos e dashboards.

## Como usar

### 1. Pre-requisitos

Voce precisa ter:

- `dbt` instalado
- o adapter do seu banco instalado
- um profile dbt configurado com o nome `instacart_dbt`
- acesso ao banco onde as tabelas fonte estao no schema `public`

O projeto usa no `dbt_project.yml`:

```yaml
name: instacart_dbt
profile: instacart_dbt
```

### 2. Validar a conexao

```bash
dbt debug
```

### 3. Rodar o projeto inteiro

```bash
dbt run
```

### 4. Rodar testes

```bash
dbt test
```

### 5. Rodar por camada

Staging:

```bash
dbt run --select staging.instacart
```

Intermediate:

```bash
dbt run --select intermediate.instacart
```

Mart:

```bash
dbt run --select marts.instacart
```

### 6. Rodar um modelo especifico

```bash
dbt run --select int_order_details
dbt run --select mart_top_products
```

### 7. Gerar documentacao

```bash
dbt docs generate
dbt docs serve
```

## Ordem recomendada de leitura do projeto

Para entender rapidamente a modelagem, siga esta ordem:

1. `models/staging/instacart/source.yml`
2. modelos `stg_*`
3. `models/intermediate/instacart/int_order_details.sql`
4. `models/marts/instacart/mart_top_products.sql`

## Casos de uso

Este projeto pode ser usado para:

- analise de produtos mais vendidos
- comportamento de recompra
- exploracao por departamento e corredor
- base para dashboards de vendas e sortimento

## Proximos passos

- adicionar testes de qualidade para chaves e nulos
- criar descricoes em arquivos `schema.yml` para os modelos
- expandir os marts com analises por departamento, corredor e horario
