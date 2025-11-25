# template-repository - Branch Main

Template de Repositório para a matéria de Métodos de Desenvolvimento de Software lecionado pelo professor Ricardo Ajax.

Essa Branch deve ser usada exclusivamente para a versão de produção dos softwares da equipe.

O repositório conta com mais 3 branchs:
* **docs:** Usada para armazenar a documentação do projeto.
* **develop:** Usada como um intermediário antes do código chegar realmente para produção. É o ambiente ideal para realizar os últimos testes antes das apresentações.
* **gh-pages:** Local dos arquivos estáticos de deploy da documentação. (Para deploy da documentação, consultar seu monitor)

---

## 🧪 Testes e Qualidade de Código

A garantia de qualidade do projeto utiliza uma suíte de testes automatizados com **Pytest** e verificação de cobertura (coverage).

### Pré-requisitos
Para rodar os testes localmente, certifique-se de que as dependências estão instaladas:

```bash
pip install -r requirements.txt
```

### 🚀 Comandos Rápidos

**1. Rodar todos os testes:**
Executa todos os testes unitários e de integração do backend.

```bash
pytest
```

**2. Verificar cobertura (Coverage):**
Este comando exibe a porcentagem de código coberto e lista as linhas exatas que não foram testadas no terminal.

```bash
pytest --cov=. --cov-report=term-missing
```

**3. Relatório Visual (HTML):**
Para gerar um site estático navegável com o detalhe de cada linha (útil para debugging):

```bash
pytest --cov=. --cov-report=html
```

*O relatório será gerado na pasta `htmlcov/`. Abra o arquivo `index.html` no navegador para visualizar.*

### ⚙️ Configuração

  * As configurações de exclusão (arquivos que não precisam de teste, como migrações e configs) estão definidas no arquivo `.coveragerc`.
  * O projeto conta com **Integração Contínua (CI)** via GitHub Actions, rodando a bateria de testes automaticamente a cada *push* ou *Pull Request* nas branches principais.

---
