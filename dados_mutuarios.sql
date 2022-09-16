# Database creation
CREATE DATABASE IF NOT EXISTS analise_risco;
USE analise_risco;

# Data initial verification
SELECT * FROM dados_mutuarios;
SELECT * FROM emprestimos;
SELECT * FROM historicos_banco;
SELECT * FROM ids;

# Check if all tables have the same number of lines
SELECT(
	SELECT COUNT(*) FROM dados_mutuarios) AS mutuario,
    (SELECT COUNT(*) FROM emprestimos) AS emprestimo,
    (SELECT COUNT(*) FROM historicos_banco) AS historico,
    (SELECT COUNT(*) FROM ids) AS ids;

# Looking for inconsistencies
# Null values
SELECT(
	SELECT COUNT(*) FROM dados_mutuarios WHERE person_id IS NULL) AS ID,
    (SELECT COUNT(*) FROM dados_mutuarios WHERE person_age IS NULL) AS age,
    (SELECT COUNT(*) FROM dados_mutuarios WHERE person_income IS NULL) AS income,
    (SELECT COUNT(*) FROM dados_mutuarios WHERE person_home_ownership IS NULL) AS home,
    (SELECT COUNT(*) FROM dados_mutuarios WHERE person_emp_length IS NULL) AS emp_length;

SELECT(
	SELECT COUNT(*) FROM emprestimos WHERE loan_id IS NULL) AS ID,
    (SELECT COUNT(*) FROM emprestimos WHERE loan_intent IS NULL) AS intent,
    (SELECT COUNT(*) FROM emprestimos WHERE loan_grade IS NULL) AS grade,
    (SELECT COUNT(*) FROM emprestimos WHERE loan_amnt IS NULL) AS amnt,
    (SELECT COUNT(*) FROM emprestimos WHERE loan_int_rate IS NULL) AS int_rate,
    (SELECT COUNT(*) FROM emprestimos WHERE loan_status IS NULL) AS loan_status,
    (SELECT COUNT(*) FROM emprestimos WHERE loan_percent_income IS NULL) AS percent;
    
SELECT(
	SELECT COUNT(*) FROM historicos_banco WHERE cb_id IS NULL) AS ID,
    (SELECT COUNT(*) FROM historicos_banco WHERE cb_person_default_on_file IS NULL) AS default_on_file,
    (SELECT COUNT(*) FROM historicos_banco WHERE cb_person_cred_hist_length IS NULL) AS cred_hist;

SELECT(
	SELECT COUNT(*) FROM ids WHERE person_id IS NULL) AS person,
    (SELECT COUNT(*) FROM ids WHERE loan_id IS NULL) AS loan,
    (SELECT COUNT(*) FROM ids WHERE cb_id IS NULL) AS cb;
    
# Empty values
SELECT(
	SELECT COUNT(*) FROM dados_mutuarios WHERE person_id ='') AS ID,
    (SELECT COUNT(*) FROM dados_mutuarios WHERE person_age ='') AS age,
    (SELECT COUNT(*) FROM dados_mutuarios WHERE person_income ='') AS income,
    (SELECT COUNT(*) FROM dados_mutuarios WHERE person_home_ownership ='') AS home,
    (SELECT COUNT(*) FROM dados_mutuarios WHERE person_emp_length ='') AS emp_length;

SELECT(
	SELECT COUNT(*) FROM emprestimos WHERE loan_id = '' ) AS ID,
    (SELECT COUNT(*) FROM emprestimos WHERE loan_intent = '') AS intent,
    (SELECT COUNT(*) FROM emprestimos WHERE loan_grade = '') AS grade,
    (SELECT COUNT(*) FROM emprestimos WHERE loan_amnt = '') AS amnt,
    (SELECT COUNT(*) FROM emprestimos WHERE loan_int_rate = '') AS int_rate,
    (SELECT COUNT(*) FROM emprestimos WHERE loan_status = '') AS loan_status,
    (SELECT COUNT(*) FROM emprestimos WHERE loan_percent_income = '') AS percent_income;
    
SELECT(
	SELECT COUNT(*) FROM historicos_banco WHERE cb_id = '') AS ID,
    (SELECT COUNT(*) FROM historicos_banco WHERE cb_person_default_on_file ='') AS default_on_file,
    (SELECT COUNT(*) FROM historicos_banco WHERE cb_person_cred_hist_length = '') AS cred_hist;
    
SELECT(
	SELECT COUNT(*) FROM ids WHERE person_id ='') AS person,
    (SELECT COUNT(*) FROM ids WHERE loan_id ='') AS loan,
    (SELECT COUNT(*) FROM ids WHERE cb_id ='') AS cb;
    
# Other verifications

# Ids verifications
SELECT * FROM dados_mutuarios WHERE length(person_id) <> 13;
SELECT * FROM historicos_banco WHERE length(cb_id) <> 13;
SELECT * FROM ids WHERE length(person_id) <> 13;
SELECT * FROM ids WHERE length(loan_id) <> 13;
SELECT * FROM ids WHERE length(cb_id) <> 13;

SELECT * FROM dados_mutuarios WHERE person_id NOT REGEXP '[a-zA-Z0-9]{8}-[a-zA-Z0-9]{4}';
SELECT * FROM emprestimos WHERE loan_id NOT REGEXP '[a-zA-Z0-9]{8}-[a-zA-Z0-9]{4}';
SELECT * FROM historicos_banco WHERE cb_id NOT REGEXP '[a-zA-Z0-9]{8}-[a-zA-Z0-9]{4}';
SELECT * FROM ids WHERE person_id NOT REGEXP '[a-zA-Z0-9]{8}-[a-zA-Z0-9]{4}';
SELECT * FROM ids WHERE loan_id NOT REGEXP '[a-zA-Z0-9]{8}-[a-zA-Z0-9]{4}';
SELECT * FROM ids WHERE cb_id NOT REGEXP '[a-zA-Z0-9]{8}-[a-zA-Z0-9]{4}';

# loan_status length verification
SELECT * FROM emprestimos WHERE length(loan_status) > 1;

# Min/max values
SELECT MIN(person_age) FROM dados_mutuarios;
SELECT MAX(person_age) FROM dados_mutuarios;

SELECT MIN(person_income) FROM dados_mutuarios;
SELECT MAX(person_income) FROM dados_mutuarios;

SELECT MIN(person_emp_length) FROM dados_mutuarios;
SELECT MAX(person_emp_length) FROM dados_mutuarios;

SELECT MIN(loan_grade) FROM emprestimos;
SELECT MAX(loan_grade) FROM emprestimos;

SELECT MIN(loan_amnt) FROM emprestimos;
SELECT MAX(loan_amnt) FROM emprestimos;

SELECT MIN(loan_int_rate) FROM emprestimos;
SELECT MAX(loan_int_rate) FROM emprestimos;

SELECT MIN(loan_status) FROM emprestimos;
SELECT MAX(loan_status) FROM emprestimos;

SELECT MIN(loan_percent_income) FROM emprestimos;
SELECT MAX(loan_percent_income) FROM emprestimos;

# Working years greater than age
SELECT * FROM dados_mutuarios WHERE person_age <= person_emp_length;

# loan_percent_income verification
SELECT dados_mutuarios.person_income, emprestimos.loan_amnt, emprestimos.loan_percent_income, emprestimos.loan_int_rate
FROM dados_mutuarios
    INNER JOIN ids ON dados_mutuarios.person_id = ids.person_id
    INNER JOIN emprestimos ON ids.loan_id  = emprestimos.loan_id
WHERE ROUND(emprestimos.loan_amnt/person_income,2) = emprestimos.loan_percent_income;

SELECT COUNT(person_id), person_income
FROM dados_mutuarios
GROUP BY person_age
ORDER BY COUNT(person_age) DESC;

# Joining tables
# Simple
SELECT dados_mutuarios.person_income, emprestimos.loan_amnt, emprestimos.loan_percent_income, emprestimos.loan_int_rate, historicos_banco.cb_person_cred_hist_length
FROM dados_mutuarios
    INNER JOIN ids ON dados_mutuarios.person_id = ids.person_id
    INNER JOIN emprestimos ON ids.loan_id  = emprestimos.loan_id
    INNER JOIN historicos_banco ON ids.cb_id = historicos_banco.cb_id;
    
# Selecting desired fields
CREATE TABLE risk_analysis_joint_data AS SELECT

dm.person_age,
dm.person_income,
dm.person_home_ownership,
dm.person_emp_length,
e.loan_intent,
e.loan_grade,
e.loan_amnt,
e.loan_int_rate,
e.loan_status,
e.loan_percent_income,
hb.cb_person_default_on_file,
hb.cb_person_cred_hist_length

FROM ids i

JOIN dados_mutuarios dm ON dm.person_id = i.person_id
JOIN emprestimos e ON e.loan_id = i.loan_id
JOIN historicos_banco hb ON hb.cb_id = i.cb_id;

# Translating from english to portuguese
SELECT * FROM ids
INNER JOIN dados_mutuarios d ON d.person_id = ids.person_id
INNER JOIN emprestimos e ON e.loan_id = ids.loan_id
INNER JOIN historicos_banco h ON h.cb_id = ids.cb_id;

SELECT m.person_id                  AS PESSOA
     , m.person_age                 AS IDADE
     , m.person_income              AS RENDA_ANUAL
     , CASE
           WHEN m.person_home_ownership = 'Rent' THEN 'Alugada'
           WHEN m.person_home_ownership = 'Mortgage' THEN 'Hipotecada'
           WHEN m.person_home_ownership = 'Own' THEN 'Própria'
           WHEN m.person_home_ownership = 'Other' THEN 'Outro'
           ELSE m.person_home_ownership
    END                             AS TIPO_RESIDENCIA
     , m.person_emp_length          AS ANOS_TRABALHADOS
     , CASE
           WHEN h.cb_person_default_on_file = 'Y' THEN 1
           WHEN h.cb_person_default_on_file = 'N' THEN 0
           ELSE h.cb_person_default_on_file
    END                             AS INADIMPLENTE
     , h.cb_person_cred_hist_length AS ANOS_PRIMEIRO_CREDITO
     , CASE
           WHEN e.loan_intent = 'Personal' THEN 'Pessoal'
           WHEN e.loan_intent = 'Education' THEN 'Educativo'
           WHEN e.loan_intent = 'Medical' THEN 'Médico'
           WHEN e.loan_intent = 'Venture' THEN 'Empreendimento'
           WHEN e.loan_intent = 'Homeimprovement' THEN 'Melhora do lar'
           WHEN e.loan_intent = 'Debtconsolidation' THEN 'Pagamento de débitos'
           ELSE e.loan_intent
    END                             AS MOTIVO_EMPRESTIMO
     , e.loan_grade                 AS PONTUACAO
     , e.loan_amnt                  AS VALOR_EMPRESTIMO_SOLICITADO
     , e.loan_int_rate              AS TAXA_JUROS
     , e.loan_status                AS POSSIB_INADIMPLENCIA
     , e.loan_percent_income        AS EMPRESTIMO_PERC_RENDA_ANUAL
FROM dados_mutuarios m
         INNER JOIN ids id ON id.person_id = m.person_id
         INNER JOIN emprestimos e ON e.loan_id = id.loan_id
         INNER JOIN historicos_banco h ON h.cb_id = id.cb_id
WHERE m.person_id != ''
  AND m.person_age IS NOT NULL
  AND m.person_income IS NOT NULL
  AND m.person_home_ownership != ''
  AND m.person_emp_length IS NOT NULL
  AND h.cb_person_default_on_file != ''
  AND h.cb_person_cred_hist_length IS NOT NULL
  AND e.loan_intent != ''
  AND e.loan_grade != ''
  AND e.loan_int_rate IS NOT NULL
  AND e.loan_status IS NOT NULL
  AND e.loan_percent_income IS NOT NULL;
  
  SELECT m.person_id                  AS pessoa_id
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
         INNER JOIN historicos_banco h ON h.cb_id = id.cb_id
WHERE m.person_id != ''
  AND m.person_age IS NOT NULL
  AND m.person_income IS NOT NULL
  AND m.person_home_ownership != ''
  AND m.person_emp_length IS NOT NULL
  AND h.cb_person_default_on_file != ''
  AND h.cb_person_cred_hist_length IS NOT NULL
  AND e.loan_intent != ''
  AND e.loan_grade != ''
  AND e.loan_int_rate IS NOT NULL
  AND e.loan_status IS NOT NULL
  AND e.loan_percent_income IS NOT NULL;
  
  
    SELECT m.person_id                  AS pessoa_id
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
         INNER JOIN historicos_banco h ON h.cb_id = id.cb_id;
         
SELECT person_id, COUNT(person_id)
FROM dados_mutuarios
GROUP BY person_id
HAVING COUNT(person_id) > 1;

SELECT loan_id, COUNT(loan_id)
FROM emprestimos
GROUP BY loan_id
HAVING COUNT(loan_id) > 1;

SELECT cb_id, COUNT(cb_id)
FROM historicos_banco
GROUP BY cb_id
HAVING COUNT(cb_id) > 1;