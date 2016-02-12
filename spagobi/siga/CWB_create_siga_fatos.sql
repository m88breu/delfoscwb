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

-----------------------------------------
-- Tabela de Fatos
---
DROP TABLE IF EXISTS siga_fatos CASCADE;
create table siga_fatos (
    id                   integer primary key,
    fk_data              integer REFERENCES dim_data(id),
    fk_hora              integer REFERENCES dim_hora(id),
    fk_assunto           integer REFERENCES dim_assunto(id),
    fk_orgao_responsavel integer REFERENCES dim_orgao_responsavel(id),
    fk_tipo_solicitacao  integer REFERENCES dim_tipo_solicitacao(id),
    fk_subdivisao        integer REFERENCES dim_subdivisao(id),
    fk_bairro_assunto    integer REFERENCES dim_bairro_assunto(id),
    solicitacao          text, 
    descricao            text,
    logradouro_assunto   text,
    regional             text,
    meio_responsta       text,
    observacao           text,
    sexo_cidadao		 text,
    bairro_cidadao       text,
    regional_cidadao     text,
    data_nascimento_cidadao text,
    tipo_cidadao         text,
    orgao_responsavel    text, 
    historico            text, 
    responsta_final      text 
    );
-- popula:
INSERT INTO siga_fatos (id, 
fk_data, fk_hora, fk_assunto, fk_orgao_responsavel, 
fk_tipo_solicitacao, fk_subdivisao, fk_bairro_assunto,
descricao, logradouro_assunto, regional, 
meio_responsta, observacao, sexo_cidadao, 
bairro_cidadao, regional_cidadao, data_nascimento_cidadao, 
tipo_cidadao, orgao_responsavel, historico, responsta_final)
(
SELECT siga_raw.solicitacao::INTEGER, 
dim_data.id, dim_hora.id, dim_assunto.id, dim_orgao_responsavel.id,
dim_tipo_solicitacao.id, dim_subdivisao.id, dim_bairro_assunto.id,
siga_raw.descricao, siga_raw.logradouro_ass, siga_raw.regional_ass,
siga_raw.meio_resposta, siga_raw.observacao, siga_raw.sexo, 
siga_raw.bairro_cidadao, siga_raw.regional_cidadao, siga_raw.data_nasc, 
siga_raw.tipo_cidadao, siga_raw.orgao_resp, siga_raw.historico, siga_raw.resposta_final
    FROM siga_raw
	INNER JOIN dim_data ON (substring(siga_raw.data from 1 for 10) = substring(to_char(dim_data.data_d,'DD/MM/YYYY') from 1 for 10))
	INNER JOIN dim_hora ON (substring(dim_hora.hora_do_dia from 1 for 5) = substring(siga_raw.horario from 1 for 5))
	INNER JOIN dim_assunto ON dim_assunto.assunto = siga_raw.assunto
	INNER JOIN dim_orgao_responsavel ON dim_orgao_responsavel.orgao_responsavel = siga_raw.orgao
	INNER JOIN dim_tipo_solicitacao ON dim_tipo_solicitacao.tipo_solicitacao = siga_raw.tipo
	INNER JOIN dim_subdivisao ON dim_subdivisao.subdivisao = siga_raw.subdivisao
	INNER JOIN dim_bairro_assunto ON dim_bairro_assunto.bairro = siga_raw.bairro_ass

);


