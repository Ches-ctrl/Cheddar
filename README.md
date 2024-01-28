Welcome to Cheddar 🧀!

## Problem 🌍

Getting a job is super difficult. Getting a job at a company committed to Net Zero is almost impossible.

In the UK alone, 1m students graduate each year. 37% of them list climate change as their 'No.1 concern'.

This means that 370k graduates each year cannot make career choices matching their No.1 Concern.

And this is just in the UK...

## Solution 🌱

Cheddar 🧀! The frictionless climate-first job site. The only site you need to get hired.

## Basic Setup 🛠️

1. Clone the repo
2. Bundle install
3. Run: `rails db:create db:migrate db:seed`
4. Run the server: `bin/dev` (runs server + sidekiq automatically)
5. You're up and running 🎉

## Additional Setup 🧰

To make full use of Cheddar's features (scraping, cloundinary files, chatgpt):

6. Add a .env file:
```shell
# Scraper functionality
* SCRAPE_EMAIL_1 = "your_email"
* SCRAPE_PASSWORD_1 = "your_password"

# File uploads
* CLOUDINARY_URL = "your_cloudinary_api_key"

# AI functionality
* OPENAI_ACCESS_TOKEN = "your_openai_api_key"
```

## Tech Stack 🧑‍💻

<p align="left">
  <a href="https://www.ruby-lang.org/en/" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/ruby/ruby-original.svg" alt="ruby" width="40" height="40"/> </a>
  <a href="https://rubyonrails.org" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/rails/rails-original-wordmark.svg" alt="rails" width="40" height="40"/> </a>
  <a href="https://www.postgresql.org" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/postgresql/postgresql-original-wordmark.svg" alt="postgresql" width="40" height="40"/> </a>
  <a href="https://www.ecma-international.org/publications-and-standards/standards/ecma-262/" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/yurijserrano/Github-Profile-Readme-Logos/042e36c55d4d757621dedc4f03108213fbb57ec4/programming%20languages/javascript.svg" alt="JavaScript" width="40" height="40"/> </a>
  <a href="https://stimulus.hotwired.dev/" target="_blank" rel="noreferrer"> <img src="https://seeklogo.com/images/S/stimulus-logo-00C9C155E0-seeklogo.com.png" alt="stimulus" width="40" height="40"/> </a>
  <a href="https://www.w3.org/html/" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/html5/html5-original-wordmark.svg" alt="html5" width="40" height="40"/> </a>
  <a href="https://www.w3schools.com/css/" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/css3/css3-original-wordmark.svg" alt="css3" width="40" height="40"/> </a>
  <a href="https://getbootstrap.com" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/bootstrap/bootstrap-plain-wordmark.svg" alt="bootstrap" width="40" height="40"/> </a>
  <a href="https://git-scm.com/" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/git-scm/git-scm-icon.svg" alt="git" width="40" height="40"/> </a>
  <a href="https://heroku.com" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/heroku/heroku-icon.svg" alt="heroku" width="40" height="40"/> </a>
</p>

## Team 👫
[//]: contributor-faces

  <a href="https://github.com/Ches-ctrl"><img src="https://avatars.githubusercontent.com/u/65985457?v=4" title="charlie-cheesman" width="50" height="50"></a>
  <a href="https://github.com/obreil54"><img src="https://avatars.githubusercontent.com/u/89271092?v=4" title="ilya-obretetskiy" width="50" height="50"></a>
  <a href="https://github.com/daniel-sussman"><img src="https://avatars.githubusercontent.com/u/56164007?v=4" title="dan-sussman" width="50" height="50"></a>
  <a href="https://github.com/chrisgeek"><img src="https://avatars.githubusercontent.com/u/12730606?v=4" title="chris-opara" width="50" height="50"></a>
  <a href="https://github.com/Alejndrosanz"><img src="https://avatars.githubusercontent.com/u/64278497?v=4" title="alejandro-sanz" width="50" height="50"></a>

[//]: contributor-faces



## Roadmap 🛣️
* For access to `Product Roadmap` and `Notion Workspace`, get in touch 👉 charles.cheesman1@gmail.com

## Getting Involved 👋

### Contributing 🧑‍💻
* Bug reports and pull requests welcome 👉 https://github.com/Ches-Ctrl/Cheddar
* Get in touch if you'd like to be involved 👉 charles.cheesman1@gmail.com

### Collecting Net Zero data 📊
* We have a volunteer team collecting Net Zero data, similar to 👉 [Net Zero Tracker](https://zerotracker.net/)
* If you'd like to join those volunteers, get in touch 👉 charles.cheesman1@gmail.com

### Supporting the project 💚
* Money means we achieve our mission more quickly! You can support us here 👉

## License 📜

© Charlie Cheesman - All rights reserved

## Code of Conduct 😇

Summary - Be nice! Everyone interacting in the Cheddar's codebases, issue trackers, chat rooms and mailing lists is expected to follow the code of conduct

## Troubleshooting 😵

If you get an error on load, you may need to install redis:
```shell
# install redis for your local server
* brew install redis

# start redis in the background
* redis-server

# run the server
* bin/dev
```

Also if you get a chromedriver error:
```shell
# install chromedriver
* brew install cask chromedriver

# allow it for your system
* Go to Security & Privacy and click ‘Allow Anyway’
```
