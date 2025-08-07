# Desafio API de Quadros e Círculos

### Introdução

Implementação de uma api para cadastro de formas geométricas

### Ferramentas utilizadas

* [Ruby](https://www.ruby-lang.org/) 3.3.4
* [Rails](https://rubyonrails.org/) 8.0.2
* [Postgresql](https://www.postgresql.org/) 16.1
* [Rspec](https://github.com/rspec/rspec-rails) 8.0
* [Rswag](https://github.com/rswag/rswag) 2.16 
* [Shoulda Matchers](https://github.com/thoughtbot/shoulda-matchers) 6.5

### Configuração

Para executar é necessário ter o [Docker](https://docker.com) instalado.

Realize os seguintes comandos no terminal:

```sh
docker compose build
```
Para fazer o build inicial da imagem.

```sh
docker compose run --rm app bundle install
```
Para instalar as dependências do projeto.

```sh
docker compose up
```

Para subir a aplicação

### Execução

Com a aplicação rodando, é só acessar http://localhost:3000/api-docs para ter acesso ao swagger

### Testes

Para executar os testes, é só rodar o comando:

```sh
docker compose run --rm app bundle exec rspec
```
