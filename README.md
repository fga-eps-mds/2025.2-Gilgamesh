# 2025.2-Gilgamesh - Backend (Apoia+)

Repositório de código fonte para a matéria de Métodos de Desenvolvimento de Software, lecionada pelos professores Ricardo Ajax e Hilmer Neri.

Essa Branch deve ser usada exclusivamente para a versão de produção dos softwares da equipe.

O repositório conta com mais 3 branchs:
* **docs:** Usada para armazenar a documentação do projeto.
* **develop:** Usada como um intermediário antes do código chegar realmente para produção. É o ambiente ideal para realizar os últimos testes antes das apresentações.
* **gh-pages:** Local dos arquivos estáticos de deploy da documentação. (Para deploy da documentação, consultar seu monitor)

---

## 🧪 Testes e Qualidade de Código

A garantia de qualidade do projeto utiliza uma suíte de testes automatizados com **Pytest** rodando em ambiente containerizado (Docker).

### Pré-requisitos
Para rodar certifique-se de ter o **Docker Desktop** instalado e em execução.

1. Suba o ambiente de desenvolvimento:
```bash
docker-compose up -d --build
```

### 🚀 Comandos Rápidos(Via Docker)

**1. Rodar todos os testes:**
Executa a suíte completa dentro do container da aplicação.

```bash
docker-compose exec web pytest
```

**2. Verificar cobertura (Coverage):**
Exibe a porcentagem de código coberto e lista as linhas exatas que não foram testadas.

```bash
docker-compose exec web pytest --cov=. --cov-report=term-missing
```

**3. Relatório Visual (HTML):**
Para gerar um site estático navegável com o detalhe de cada linha (útil para debugging):

```bash
docker-compose exec web pytest --cov=. --cov-report=html
```

*O relatório será gerado na pasta `htmlcov/`. Abra o arquivo `index.html` no navegador para visualizar.*

### ⚙️ Configuração

  * Ambiente: Os testes rodam isolados no container web, garantindo paridade com o ambiente de produção.
  * Exclusões: Arquivos de configuração e migrações são ignorados na contagem de cobertura (via .coveragerc).
  * O projeto conta com **Integração Contínua (CI)** via GitHub Actions, rodando a bateria de testes automaticamente a cada *push* ou *Pull Request* nas branches principais.

---
