<h1 align="center">
      <img alt="Code Comparison" title="Code Comparison" src=".github/logo.png" width="300px" />
</h1>

<h3 align="center">
  Code Comparison
</h3>

<p align="center">Learn by seeing the differences between programming languages 📚</p>
<p align="center">Made with Elixir LiveView 🚀</p>

<div align="center">
🔗 <a href="https://www.codecomparison.me">codecomparison.me</a>
</div>
<br/>

<p align="center">
  <img alt="GitHub language count" src="https://img.shields.io/github/languages/count/Lgdev07/code_comparison?color=%2304D361">

  <img alt="Made by Lgdev07" src="https://img.shields.io/badge/made%20by-Lgdev07-%2304D361">

  <img alt="License" src="https://img.shields.io/badge/license-MIT-%2304D361">

  <a href="https://github.com/Lgdev07/code_comparison/stargazers">
    <img alt="Stargazers" src="https://img.shields.io/github/stars/Lgdev07/code_comparison?style=social">
  </a>
</p>

<p align="center">
  <a href="#-installation-and-execution">Installation and execution</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
  <a href="#-tests">Tests</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
  <a href="#-how-to-contribute">How to contribute</a>&nbsp;&nbsp;&nbsp;
</p>


## 🎉 Presentation

<h1 align="left">
  <img style="border-radius: 10%;"src=".github/code_comparison.gif" width="500" />
</h1>

## 🚀 Installation and execution

1. Clone this repository and go to the directory;
2. Install mix dependencies `docker-compose run --rm web mix deps.get`;
5. Install npm dependencies `docker-compose run --rm web npm install --prefix assets`;

## 🧪 Tests

1. Run `docker-compose run --rm web mix test`;

## 😊 We encorage you to submit your code!!

- Help us to increase the available code base.

- Go to /topics and create a new one or submit with the language you know.

- Please be concise and add comments explaining what the code is doing.

## 🤔 How to contribute

- Fork this repository;
- Create a branch with your feature: `git checkout -b my-feature`;
- Commit your changes: `git commit -m 'feat: My new feature'`;
- Push to your branch: `git push origin my-feature`.
- After the merge of your pull request is done, you can delete your branch.

---

## Deployment Notes

The `topics/` directory, which contains all the code examples, is crucial for the application's functionality. The provided `Dockerfile` ensures that this directory is copied into the Docker image during the build process. The application then locates this directory at runtime using application-aware path construction (specifically, `Path.join(Application.app_dir(:code_comparison), "topics")`), making its access reliable in containerized environments like Render.
