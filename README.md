# Alura - Challenge Data Science

Repository to keep track on [Data Science Challenge](https://www.alura.com.br/challenges/dados?host=https://cursos.alura.com.br) created by Alura.

Main goals are:
* Week 1 - Data Processing: Understanding how to process data with SQL;
* Week 2 - Learning with data: Creating a non-payment prediction model; and
* Week 3 & 4 - Analyzing metrics: Creating views with Power BI.

## Week 1
Main tasks for this week are ([Trello board](https://trello.com/b/wjOlcef2/challenge-dados-semana-1)):
1. [Download data](https://github.com/brunavasques/Alura-Challenge-Data-Science/edit/main/README.md#task-1---download-data);
2. [Understand data in the database](https://github.com/brunavasques/Alura-Challenge-Data-Science/edit/main/README.md#task-2---understand-data-in-the-database);
3. [Analyze data types](https://github.com/brunavasques/Alura-Challenge-Data-Science/edit/main/README.md#task-3---analyze-data-types);
4. [Verify any inconsistency in data](https://github.com/brunavasques/Alura-Challenge-Data-Science/edit/main/README.md#task-4---verify-any-inconsistency-in-data);
5. [Correct the inconsistencies](https://github.com/brunavasques/Alura-Challenge-Data-Science/edit/main/README.md#task-5---correct-the-inconsistencies);
6. [Join tables by ID](https://github.com/brunavasques/Alura-Challenge-Data-Science/edit/main/README.md#task-6---join-tables-by-id);
7. [Translate columns from english to portuguese](https://github.com/brunavasques/Alura-Challenge-Data-Science/edit/main/README.md#task-7---translate-columns-from-english-to-portuguese);
8. [Export joined data to csv file](https://github.com/brunavasques/Alura-Challenge-Data-Science/edit/main/README.md#task-8---export-joined-data-to-csv-file).

### Task 1 - Download data
Data can be downloaded from ([Mirla's Repository](https://github.com/Mirlaa/Challenge-Data-Science-1ed)).

### Task 2 - Understand data in the database
There is a data dictionary by table in ([Mirla's Repository](https://github.com/Mirlaa/Challenge-Data-Science-1ed)).

The database has 4 tables ("dados_mutuarios", "emprestimos", "historicos_banco" and "id").

With this data it is possible to link each person with its loan and bank history.

### Task 3 - Analyze data types
[MySQL Workbench](https://dev.mysql.com/downloads/workbench/) was used to import and analyze data following [this article from Alura](https://www.alura.com.br/artigos/restaurar-backup-banco-de-dados-mysql).

Query to create the database:
`CREATE DATABASE analise_risco;`

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
|`loan_id`| Loan's ID. | varchar(16)
| `loan_intent` | Reason for the loan: *Pessoal* (`Personal`), *Educativo* (`Education`), *Médico* (`Medical`), *Empreendimento* (`Venture`), *Melhora do lar* (`Homeimprovement`), *Pagamento de débitos* (`Debtconsolidation`). | varchar(32) |
| `loan_grade` | Loan's grade, by level from `A` to `G`. | varchar(1) |
| `loan_amnt` | Total amount of the requested loan. | int(11) |
| `loan_int_rate` | Interest rate. | double |
| `loan_status` | Non-payment possibility. | int(11) |
| `loan_percent_income` | Percentage income between *total loan amount* and *annual income*. | double |

#### Table "historicos_banco":

Table containing bank histories.

| Feature | Description | Data Type |
| --- | --- | --- |
|`cb_id`| Bank history's ID. | varchar(16) |
| `cb_person_default_on_file` | Indicates if the person has already been in default: (`Y`,`YES`) e (`N`,`NO`). | varchar(1) |
| `cb_person_cred_hist_length` | Time, in years, since the first credit request or credit card acquisition. | int(11) |

#### Table "id":

Table containing the relationship between the other three tables.

| Feature | Description | Data Type |
| --- | --- | --- |
|`person_id`| Person's ID. | text |
|`loan_id`| Loan's ID. | text |
|`cb_id`| Bank history's ID. | text |

### Task 4 - Verify any inconsistency in data

  * The IDs are 16 size strings, but all the IDs have size of 13, and format XXXXXXXX-XXXX.
    * `SELECT * FROM dados_mutuarios WHERE person_id NOT REGEXP '[a-zA-Z0-9]{8}-[a-zA-Z0-9]{4}'`;
  * Some parameters have null value.
  * loan_status in "emprestimos" table is defined as int(11) but it assumes [0,1] values. Could be one bit.
  * In some rows, loan_percent_income doesn't match loan_amnt/person_income.
    * `SELECT dados_mutuarios.person_income, emprestimos.loan_amnt, emprestimos.loan_percent_income, emprestimos.loan_int_rate
FROM dados_mutuarios
    INNER JOIN ids ON dados_mutuarios.person_id = ids.person_id
    INNER JOIN emprestimos ON ids.loan_id  = emprestimos.loan_id
WHERE ROUND(emprestimos.loan_amnt/person_income,2) = emprestimos.loan_percent_income;`
  * IDs in the table "id" are defined as text, could be varchar(13).
  
 Other verifications:
 * Duplicated entries:
   * `SELECT person_id, COUNT(person_id)
FROM dados_mutuarios
GROUP BY person_id
HAVING COUNT(person_id) > 1;`
 * IDs format:
   * `SELECT * FROM dados_mutuarios WHERE person_id NOT REGEXP '[a-zA-Z0-9]{8}-[a-zA-Z0-9]{4}';`

### Task 5 - Correct the inconsistencies

### Task 6 - Join tables by ID

`SELECT * FROM ids
INNER JOIN dados_mutuarios d ON d.person_id = ids.person_id
INNER JOIN emprestimos e ON e.loan_id = ids.loan_id
INNER JOIN historicos_banco h ON h.cb_id = ids.cb_id;`

### Task 7 - Translate columns from english to portuguese

`    SELECT m.person_id                  AS pessoa_id
     , m.person_age                 AS pessoa_idade
     , m.person_income              AS pessoa_salario_anual
     , CASE
           WHEN m.person_home_ownership = 'Rent' THEN 'Alugada'
           WHEN m.person_home_ownership = 'Mortgage' THEN 'Hipotecada'
           WHEN m.person_home_ownership = 'Own' THEN 'Própria'
           WHEN m.person_home_ownership = 'Other' THEN 'Outro'
           ELSE m.person_home_ownership
    END                             AS pessoa_situacao_propriedade
     , m.person_emp_length          AS pessoa_anos_trabalhados
     , CASE
           WHEN h.cb_person_default_on_file = 'Y' THEN 'S'
           WHEN h.cb_person_default_on_file = 'N' THEN 'N'
           ELSE h.cb_person_default_on_file
    END                             AS historico_inadimplencia
     , h.cb_person_cred_hist_length AS historico_tempo_primeiro_credito
     , CASE
           WHEN e.loan_intent = 'Personal' THEN 'Pessoal'
           WHEN e.loan_intent = 'Education' THEN 'Educativo'
           WHEN e.loan_intent = 'Medical' THEN 'Médico'
           WHEN e.loan_intent = 'Venture' THEN 'Empreendimento'
           WHEN e.loan_intent = 'Homeimprovement' THEN 'Melhora do lar'
           WHEN e.loan_intent = 'Debtconsolidation' THEN 'Pagamento de débitos'
           ELSE e.loan_intent
    END                             AS emprestimo_motivo
     , e.loan_grade                 AS emprestimo_pontuacao
     , e.loan_amnt                  AS emprestimo_valor
     , e.loan_int_rate              AS emprestimo_taxa_juros
     , e.loan_status                AS emprestimo_possibilidade_inadimplencia
     , e.loan_percent_income        AS emprestimo_renda_percentual
FROM dados_mutuarios m
         INNER JOIN ids id ON id.person_id = m.person_id
         INNER JOIN emprestimos e ON e.loan_id = id.loan_id
         INNER JOIN historicos_banco h ON h.cb_id = id.cb_id;`


### Task 8 - Export joined data to csv file

MySQL Workbench provides a feature to save files in csv format.

## Week 2

## Week 3 & 4

#alura #alurachallengedatascience2
