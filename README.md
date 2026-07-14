# Base de Dados para Gestão de Eventos

Sistema de base de dados relacional desenvolvido como projeto académico para a Unidade Curricular de Bases de Dados da Universidade do Minho.

## Visão Geral

O projeto modela e implementa uma base de dados para a gestão de eventos tecnológicos, incluindo participantes, inscrições, atividades, espaços (*venues*), oradores, júris, *workshops*, *hackathons* e equipas.

O trabalho percorreu as principais fases de desenvolvimento de uma base de dados, desde a análise de requisitos e modelação conceptual até ao desenho lógico, normalização e implementação física em MySQL.

## Principais Funcionalidades

- Gestão de eventos, atividades e espaços
- Registo de participantes e inscrição em eventos
- Suporte para *workshops* e *hackathons*
- Gestão de oradores, júris e equipas
- Controlo de lotação e do estado de inscrição
- Controlo de acessos baseado em perfis (*Role-Based Access Control*)
- *Views* para relatórios e exploração de dados
- *Queries* para cenários operacionais e analíticos
- Índices para otimização de desempenho
- *Stored function* e *stored procedure*
- *Triggers* para aplicação de regras de negócio e consistência de dados

## Tecnologia

- MySQL

## Modelos da Base de Dados

### Modelo Conceptual

![Conceptual model](diagrams/conceptual-model.png)

### Modelo Lógico

![Logical model](diagrams/logical-model.png)

## Estrutura do Projeto

```text
.
├── diagrams/
│   ├── conceptual-model.png
│   └── logical-model.png
├── SQL/
│   ├── 01-create-database.sql
│   ├── 02-create-tables.sql
│   ├── 03-users.sql
│   ├── 04-insert-data.sql
│   ├── 05-views.sql
│   ├── 06-queries.sql
│   ├── 07-indices.sql
│   ├── 08-procedures.sql
│   └── views-queries.sql
├── .gitignore
└── README.md
```

## Como Executar o Projeto

### Requisitos

- MySQL 8.0 ou posterior
- Um cliente MySQL, como o MySQL Workbench ou o cliente de linha de comandos do MySQL

### Ordem de Execução

Execute os *scripts* SQL na seguinte ordem:

```text
01-create-database.sql
02-create-tables.sql
03-users.sql
04-insert-data.sql
05-views.sql
06-queries.sql
07-indices.sql
08-procedures.sql
```

Utilizando o cliente de linha de comandos do MySQL:

```bash
mysql -u root -p < SQL/01-create-database.sql
mysql -u root -p < SQL/02-create-tables.sql
mysql -u root -p < SQL/03-users.sql
mysql -u root -p < SQL/04-insert-data.sql
mysql -u root -p < SQL/05-views.sql
mysql -u root -p < SQL/06-queries.sql
mysql -u root -p < SQL/07-indices.sql
mysql -u root -p < SQL/08-procedures.sql
```

A base de dados é criada com o nome:

```text
nextevents
```

## Destaques da Implementação

A implementação inclui:

- 14 tabelas relacionais com chaves primárias, chaves estrangeiras, restrições de unicidade e regras de validação
- Uma *view* que combina eventos, atividades e espaços
- Várias *queries* SQL operacionais e analíticas
- Cinco índices desenhados para melhorar pesquisas e junções (*joins*) comuns
- Uma *stored function* para calcular a receita de eventos confirmados
- Uma *stored procedure* para o registo de participantes e gestão de lista de espera
- Três *triggers* para aplicar regras de negócio relacionadas com inscrições e equipas
- Três perfis de acesso com diferentes níveis de permissão

## A Minha Contribuição

Fui o principal responsável pela implementação física da base de dados e pelo desenvolvimento do SQL.

## Contexto Académico

- Unidade Curricular: Bases de Dados
- Curso: Ciências da Computação
- Instituição: Universidade do Minho
- Ano letivo: 2025/2026
- Nota do projeto: 18/20
- Projeto de grupo
```

### Conceptual Model

![Conceptual model](diagrams/conceptual-model.png)

### Logical Model

![Logical model](diagrams/logical-model.png)

## Project Structure

```text
.
├── diagrams/
│   ├── conceptual-model.png
│   └── logical-model.png
├── SQL/
│   ├── 01-create-database.sql
│   ├── 02-create-tables.sql
│   ├── 03-users.sql
│   ├── 04-insert-data.sql
│   ├── 05-views.sql
│   ├── 06-queries.sql
│   ├── 07-indices.sql
│   ├── 08-procedures.sql
│   └── views-queries.sql
├── .gitignore
└── README.md
```

## Running the Project

### Requirements

- MySQL 8.0 or later
- A MySQL client, such as MySQL Workbench or the MySQL command-line client

### Execution Order

Run the SQL scripts in the following order:

```text
01-create-database.sql
02-create-tables.sql
03-users.sql
04-insert-data.sql
05-views.sql
06-queries.sql
07-indices.sql
08-procedures.sql
```

Using the MySQL command-line client:

```bash
mysql -u root -p < SQL/01-create-database.sql
mysql -u root -p < SQL/02-create-tables.sql
mysql -u root -p < SQL/03-users.sql
mysql -u root -p < SQL/04-insert-data.sql
mysql -u root -p < SQL/05-views.sql
mysql -u root -p < SQL/06-queries.sql
mysql -u root -p < SQL/07-indices.sql
mysql -u root -p < SQL/08-procedures.sql
```

The database is created with the name:

```text
nextevents
```

## Implementation Highlights

The implementation includes:

- 14 relational tables with primary keys, foreign keys, uniqueness constraints and validation rules
- A view combining events, activities and venues
- Several operational and analytical SQL queries
- Five indexes designed to improve common searches and joins
- A stored function for calculating confirmed event revenue
- A stored procedure for participant registration and waiting-list management
- Three triggers for enforcing registration and team-related business rules
- Three access roles with different permission levels

## My Contribution

I was primarily responsible for the physical implementation of the database and the SQL development.

## Academic Context

- Course: Databases
- Degree: Computer Science
- University: University of Minho
- Academic year: 2025/2026
- Project grade: 18/20
- Group project
