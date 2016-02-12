-- Copyright 2015 Marcos Santos Abreu
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--    http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.


-------------------------------------------
-- dim_tipo_solicitacao
--
DROP TABLE IF EXISTS dim_tipo_solicitacao CASCADE;
create table dim_tipo_solicitacao (
   id_tipo_solicitacao  serial primary key,
   tipo_solicitacao     text 
   );
-- popula:
insert into dim_tipo_solicitacao(tipo_solicitacao) (select distinct(tipo) from siga_raw order by tipo);

-------------------------------------------
-- dim_assunto
--
DROP TABLE IF EXISTS dim_assunto CASCADE;
create table dim_assunto (
   id_assunto serial primary key,
   assunto    text 
   );
-- popula:
insert into dim_assunto(assunto) (select distinct(assunto) from siga_raw order by assunto);

----------------------------------
-- dim_subdivisao
--
DROP TABLE IF EXISTS dim_subdivisao CASCADE;
create table dim_subdivisao (
    id_subdivisao serial primary key,
    subdivisao    text
    );
insert into dim_subdivisao(subdivisao) 
   (select distinct(subdivisao) from siga_raw order by subdivisao);

-------------------------------------------
-- dim_orgao_responsavel
--
DROP TABLE IF EXISTS dim_orgao_responsavel CASCADE;
create table dim_orgao_responsavel (
   id_orgao_responsavel   serial primary key,
   orgao_responsavel      text 
   );
-- popula:
insert into dim_orgao_responsavel(orgao_responsavel) (select distinct(orgao) from siga_raw order by orgao);

----------------------------------
-- dim_bairro
--
DROP TABLE IF EXISTS dim_bairro_assunto CASCADE;
create table dim_bairro_assunto (
    id_bairro_assunto serial primary key,
    bairro_assunto    text
    );
insert into dim_bairro_assunto(bairro_assunto) 
   (select distinct(bairro_ass) from siga_raw order by bairro_ass);

----------------------------------
-- dim_data
--
DROP TABLE IF EXISTS dim_data CASCADE;
CREATE TABLE dim_data (
  id_data        serial primary key,
  data_d         date,
  ano            double precision,
  mes            double precision,
  mes_nome       text,
  dia            double precision,
  data_formatada text,
  ano_mes        text,
  dia_semana     text
  );
-- popula:
insert into dim_data (data_d, ano, mes, mes_nome, dia, data_formatada, ano_mes, dia_semana) (
  SELECT
	datum AS DATE,
	EXTRACT(YEAR FROM datum) AS ano,
	EXTRACT(MONTH FROM datum) AS mes,
	to_char(datum, 'TMMonth') AS mes_nome,
	EXTRACT(DAY FROM datum) AS dia,
	to_char(datum, 'dd. mm. yyyy') AS data_formatada,
	to_char(datum, 'yyyy/mm') AS ano_mes,
	-- dia-da-semana:
	CASE EXTRACT(dow FROM datum) 
	   WHEN 0 THEN 'domingo' 
	   WHEN 1 THEN 'segunda-feira'
	   WHEN 2 THEN 'terça-feira'
	   WHEN 3 THEN 'quarta-feira'
	   WHEN 4 THEN 'quinta-feira-feira'
	   WHEN 5 THEN 'sexta-feira-feira'
	   WHEN 6 THEN 'sábado'
	   END AS dia_semana
FROM (
	-- Sequencia de dias entre 2010 e 2019 (atenço: 2012 e 2016 so bissextos): 365 * 10 + 2 registros.
	SELECT '2010-01-01'::DATE + SEQUENCE.DAY AS datum
	FROM generate_series(0,3651) AS SEQUENCE(DAY)
	GROUP BY SEQUENCE.DAY
     ) DQ
ORDER BY 1
);


---------------------------------
-- dim_hora
--
DROP TABLE IF EXISTS dim_hora CASCADE;
CREATE TABLE dim_hora (
 id_hora        serial primary key,
 hora_do_dia    text,
 hora           double precision,
 quarto_de_hora text,
 minuto         double precision,
 periodo        text,
 dia_ou_noite   text);
-- popula:
 insert into dim_hora (hora_do_dia, hora, quarto_de_hora, minuto, periodo, dia_ou_noite) (
SELECT to_char(MINUTE, 'hh24:mi') AS hora_do_dia,
	-- hora do dia (0 - 23)
	EXTRACT(HOUR FROM MINUTE) AS hora, 
	-- extrai e formata quartos de hora
	to_char(MINUTE - (EXTRACT(MINUTE FROM MINUTE)::INTEGER % 15 || 'minutes')::INTERVAL, 'hh24:mi') ||
	'  ' ||
	to_char(MINUTE - (EXTRACT(MINUTE FROM MINUTE)::INTEGER % 15 || 'minutes')::INTERVAL + '14 minutes'::INTERVAL, 'hh24:mi')
		AS quarto_de_hora,
	-- minuto do dia (0 - 1439)
	EXTRACT(HOUR FROM MINUTE)*60 + EXTRACT(MINUTE FROM MINUTE) AS minuto,
	-- perodo do dia:
	CASE WHEN to_char(MINUTE, 'hh24:mi') BETWEEN '06:00' AND '08:29'
		THEN 'Amanhecer'
	     WHEN to_char(MINUTE, 'hh24:mi') BETWEEN '08:30' AND '11:59'
		THEN 'Manh'
	     WHEN to_char(MINUTE, 'hh24:mi') BETWEEN '12:00' AND '17:59'
		THEN 'Tarde'
	     WHEN to_char(MINUTE, 'hh24:mi') BETWEEN '18:00' AND '22:29'
		THEN 'Entardecer'
	     ELSE 'Noite'
	END AS periodo_do_dia,
	-- Indicador de dia ou noite
	CASE WHEN to_char(MINUTE, 'hh24:mi') BETWEEN '07:00' AND '19:59' THEN 'Dia'
	     ELSE 'Noite'
	END AS dia_ou_noite
FROM (SELECT '0:00'::TIME + (SEQUENCE.MINUTE || ' minutes')::INTERVAL AS MINUTE
	FROM generate_series(0,1439) AS SEQUENCE(MINUTE)
	GROUP BY SEQUENCE.MINUTE
     ) DQ
ORDER BY 1
);



