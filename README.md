# Alura-Challenge-Data-Science

Repository to keep track on [Data Science Challenge](https://www.alura.com.br/challenges/dados?host=https://cursos.alura.com.br) created by Alura.

Main goals are:
* Week 1 - Data Processing: Understanding how to process data with SQL;
* Week 2 - Learning with data: Creating a non-payment prediction model; and
* Week 3 & 4 - Analyzing metrics: Creating views with Power BI.

## Week 1
Main tasks for this week are ([Trello board](https://trello.com/b/wjOlcef2/challenge-dados-semana-1)):
1. [Download data](https://github.com/brunavasques/Alura-Challenge-Data-Science/edit/main/README.md#task-1---download-data);
2. Understand data in the database;
3. Analyze data types;
4. Verify any inconsistency in data;
5. Correct the inconsistencies;
6. Join tables by ID;
7. Translate columns from english to portuguese;
8. Export joined data to csv file.

### Task 1 - Download data
Data can be downloaded from ([Mirla's Repository](https://github.com/Mirlaa/Challenge-Data-Science-1ed)).

### Task 2 - Understand data in the database
There is a data dictionary by table in ([Mirla's Repository](https://github.com/Mirlaa/Challenge-Data-Science-1ed)).

The database has 4 tables (dados_mutuarios, emprestimos, historicos_banco and id).

With this data it is possible to link each person with its loan and bank history.

### Task 3 - Analyze data types
[MySQL Workbench](https://dev.mysql.com/downloads/workbench/) was used to import and analyze data.

#### Table "dados_mutuarios":

Table containing the personal data of each applicant.

| Feature | Description | Data Type |
| --- | --- | --- |
|`person_id`| Person's ID. | varchar(16) |
| `person_age` | Person's age in years. | int(11) |
| `person_income` | Person's annual income. | int(11) |
| `person_home_ownership` | Home ownership situation: *Alugada* (`Rent`), *Própria* (`Own`), *Hipotecada* (`Mortgage`) e *Outros casos* (`Other`). | varchar(8) |
| `person_emp_length` | Time, in years, that the person has worked. | double |

#### Table "emprestimos":

Table containing the requested loan information.

| Feature | Description | Data Type |
| --- | --- | --- |
|`loan_id`|ID da solicitação de empréstico de cada solicitante| varchar(16)
| `loan_intent` | Motivo do empréstimo: *Pessoal* (`Personal`), *Educativo* (`Education`), *Médico* (`Medical`), *Empreendimento* (`Venture`), *Melhora do lar* (`Homeimprovement`), *Pagamento de débitos* (`Debtconsolidation`) | varchar(32) |
| `loan_grade` | Pontuação de empréstimos, por nível variando de `A` a `G` | varchar(1) |
| `loan_amnt` | Valor total do empréstimo solicitado | int(11) |
| `loan_int_rate` | Taxa de juros | double |
| `loan_status` | Possibilidade de inadimplência | int(11) |
| `loan_percent_income` | Renda percentual entre o *valor total do empréstimo* e o *salário anual* | double |

#### Table "historicos_banco":

Histório de emprétimos de cada cliente

| Feature | Description | Data Type |
| --- | --- | --- |
|`cb_id`|ID do histórico de cada solicitante| varchar(16) |
| `cb_person_default_on_file` | Indica se a pessoa já foi inadimplente: sim (`Y`,`YES`) e não (`N`,`NO`) | varchar(1) |
| `cb_person_cred_hist_length` | Tempo - em anos - desde a primeira solicitação de crédito ou aquisição de um cartão de crédito | int(11) |

#### Table "id":

Tabela que relaciona os IDs de cada informação da pessoa solicitante

| Feature | Description | Data Type |
| --- | --- | --- |
|`person_id`|ID da pessoa solicitante| text |
|`loan_id`|ID da solicitação de empréstico de cada solicitante| text |
|`cb_id`|ID do histórico de cada solicitante| text |

### Task 4 - Verify any inconsistency in data

  * The IDs are 16 size strings, but all the IDs have size of 13, and format XXXXXXXX-XXXX.
    * SELECT * FROM dados_mutuarios WHERE person_id NOT REGEXP '[a-zA-Z0-9]{8}-[a-zA-Z0-9]{4}';
  * Some parameters have null value.
  * loan_status in "emprestimos" table is defined as int(11) but it assumes [0,1] values. Could be one bit.
  * loan_percent_income doesn't match loan_amnt/person_income.
  * IDs in the table "id" are defined as text, could be varchar(13).

### Task 5 - Correct the inconsistencies

### Task 6 - Join tables by ID
### Task 7 - Translate columns from english to portuguese
### Task 8 - Export joined data to csv file

## Week 2

## Week 3 & 4

#alura #alurachallengedatascience2
