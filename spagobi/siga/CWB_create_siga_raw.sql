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

--------------------
---- Esta tabela receber os dados do arquivo CSV
----
CREATE TABLE siga_raw (
     id            serial primary key,
     solicitacao   text,
     tipo          text,
     orgao         text,
     data          text,
     horario       text,
     assunto       text,
     subdivisao    text,
     descricao     text,
     logradouro_ass    text,
     bairro_ass    text,
     regional_ass  text,
     meio_resposta text,
     observacao    text,
     sexo          text,
     bairro_cidadao    text,
     regional_cidadao  text,
     data_nasc     text,
     tipo_cidadao  text,
     historico     text,
     orgao_resp    text,
     resposta_final    text);

