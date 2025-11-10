# 🚗 Projeto: Sistema de Gestão de Oficina (Oficina DB)

## 🧰 Descrição
Este projeto apresenta o esquema lógico e implementação (script SQL) de um banco de dados para o contexto de uma oficina mecânica.  
O esquema contempla clientes, veículos, mecânicos, peças, serviços, ordens de serviço (OS), itens de serviço e pagamentos.  
Foi pensado para suportar operações comuns: registrar atendimento, controlar peças/estoque, faturamento e geração de orçamentos/ordens.

---

## 🗂️ Estrutura (resumo)
- `cliente`: dados do proprietário do veículo.  
- `veiculo`: veículos atendidos na oficina (FK → cliente).  
- `mecanico`: mecânicos que executam os serviços.  
- `fornecedor`: fornecedores de peças.  
- `peca`: peças em estoque (FK → fornecedor).  
- `servico`: catálogo de serviços oferecidos.  
- `ordem_servico`: ordens abertas para atendimento de um veículo.  
- `item_servico`: itens associados à ordem (mão de obra e peças).  
- `pagamento`: registro de pagamentos por ordem.

---

## ⚙️ Como executar
1. No MySQL (Workbench / DBeaver / terminal), importe o arquivo `oficina_banco_dados.sql` (ou cole o conteúdo e execute).  
   - Pelo terminal:  
     ```bash
     mysql -u usuario -p < oficina_banco_dados.sql
     ```
2. O script cria o banco `oficina_db`, as tabelas e insere dados de exemplo (seed).

---

## 💻 Tecnologias utilizadas
- **MySQL 8+** – Sistema gerenciador de banco de dados.  
- **MySQL Workbench** – Ambiente de desenvolvimento e modelagem.  
- **Git e GitHub** – Controle de versão e hospedagem do projeto.  
- **Markdown (README.md)** – Documentação do projeto.  

---

## 🧠 Queries de exemplo
O arquivo SQL já inclui várias queries que demonstram:
- `SELECT` simples e com filtros (`WHERE`)  
- Atributos derivados (soma de itens por ordem)  
- Ordenação (`ORDER BY`)  
- Filtros em grupos (`HAVING`)  
- Junções múltiplas para relatórios (`JOIN`)  
- Queries analíticas (média de gasto por cliente; top serviços)

---

## 🚀 Próximos passos / sugestões
- Criar **procedimentos armazenados** para reduzir estoque ao confirmar peças usadas.  
- Implementar **gatilhos (triggers)** que atualizem `estoque` automaticamente a cada inserção de `item_servico` do tipo 'Peça'.  
- Implementar **controle de usuários e permissões** (login, roles).  
- Adicionar **views** para relatórios mais frequentes e integração com frontend.

---

## 👨‍💻 Autor
Desenvolvido por **Felipe Landovski da Silva**  
📚 *Estudante de Engenharia Mecânica e Técnico em Automação Industrial*  
📍 *Telêmaco Borba - PR, Brasil*  
💬 “Aprendendo SQL na prática para criar soluções reais.”  
