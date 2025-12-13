# 🚀 2025.2-Gilgamesh: Apoia+ (Backend + Mobile)

Repositório principal do projeto **Apoia+**, desenvolvido para a disciplina de Métodos de Desenvolvimento de Software, lecionada pelos professores Ricardo Ajax e Hilmer Neri.

O projeto consiste em uma aplicação de **Backend (Django)**, que gerencia a API e o banco de dados, e um **Aplicativo Móvel (Flutter)**, utilizado por Doadores e ONGs.

---

## 🛠️ Estrutura do Repositório e Clonagem

Este repositório adota a estratégia de **Submodules** para manter a documentação técnica (Arquitetura, Requisitos, etc.) sincronizada com o código.

### Como Clonar o Projeto Completo (Código + Documentação)

Para garantir que a pasta `docs/` seja baixada corretamente, utilize a flag `--recursive`:

```bash
git clone --recursive https://github.com/fga-eps-mds/2025.2-Gilgamesh.git
```

Caso já tenha o projeto clonado, execute:

```bash
git submodule update --init --recursive
```

---

### 📚 Documentação Técnica

A documentação completa, incluindo Diagramas e Arquitetura, está integrada na pasta:
* `/docs`: Contém os arquivos fontes do MkDocs e toda a documentação gerada.

---

## 🛠️ Tecnologias Utilizadas (Stack)

O projeto é construído em uma arquitetura separada (Backend e Mobile) utilizando as seguintes tecnologias:

| Componente | Linguagem/Framework |
| :--- | :--- |
| **Backend (API)** | Python (Django Rest Framework) |
| **Mobile (Frontend)** | Dart (Flutter) |
| **Database** | PostgreSQL |

---

## 📲 Guia Rápido (Mobile - Flutter)

O frontend mobile reside na pasta `/mobile_apoia`.

### Pré-requisitos
Certifique-se de ter o **SDK do Flutter** instalado, um emulador ou dispositivo conectado e o **Backend** rodando (item 1 da seção de testes).

1.  **Acesse a pasta do projeto mobile:**
    ```bash
    cd mobile_apoia
    ```

2.  **Instale as dependências:**
    ```bash
    flutter pub get
    ```

3.  **Verifique os dispositivos conectados:**
    ```bash
    flutter devices
    ```

4.  **Execute o aplicativo:**
    ```bash
    flutter run
    ```
    *(O Flutter irá compilar e iniciar o aplicativo no dispositivo/emulador selecionado.)*

---

## 🧪 Testes e Qualidade de Código (Backend)

A garantia de qualidade utiliza uma suíte de testes automatizados com **Pytest** rodando em ambiente containerizado (Docker), garantindo a integridade da API.

### Pré-requisitos
Para rodar os testes, certifique-se de ter o **Docker Desktop** instalado e em execução.

1. Suba o ambiente de desenvolvimento:
```bash
docker-compose up -d --build
```

### 🚀 Comandos Rápidos (Via Docker)

1. **Rodar todos os testes:**
Executa a suíte completa dentro do container da aplicação.
```bash
docker-compose exec web pytest
```

2. **Verificar cobertura (Coverage):**
Exibe a porcentagem de código coberto e lista as linhas exatas que não foram testadas.
```bash
docker-compose exec web pytest --cov=. --cov-report=term-missing
```

3. **Relatório Visual (HTML):**
Gera um site estático navegável com o detalhe de cada linha de código.
```bash
docker-compose exec web pytest --cov=. --cov-report=html
```

---

## ⚙️ Branching Model

O projeto segue um modelo de desenvolvimento baseado em *feature branches* e integração contínua:

* **main:** Versão de produção (estável). Contém apenas código testado e validado (Releases).
* **develop:** Ambiente de desenvolvimento e integração (pré-produção). É o destino dos Pull Requests de novas funcionalidades.
* **feature/nome-da-feature:** Branches temporárias criadas a partir da `develop` para desenvolver novas funcionalidades.
