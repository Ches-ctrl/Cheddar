Welcome to Cheddar! The only site you need to get hired

## Get Started

In order to get setup:
1. Clone the repo
2. Bundle install
3. Add a .env file

========

.env file contents:
* ADMIN_EMAIL=“add email here”
* ADMIN_PASSWORD=“add password here”
* SCRAPE_EMAIL_1=“add email here”
* SCRAPE_PASSWORD_1=“add password here”
* Repeat for other accounts/passwords or remove from the Seed file

========

4. Run: rails db:create db:migrate db:seed
5. Run the server - NB. You cannot run rails s to get the server going, please instead run bin/dev. This runs sidekiq as well as the server automatically for you so you can complete the job applications as background jobs

You’ll also need to add the following API keys to get all the features working:
* CLOUDINARY_URL
* OPENAI_ACCESS_TOKEN

If you get an error on load, you may need to install redis:
* brew install redis - installs redis for your local server
* redis-server - starts it in the background
* bin/dev - runs the server

Also if you get a chromedriver error:
* brew install cask chromedriver
* Go to Security & Privacy and click ‘Allow Anyway’

## The Tech Stack

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

## Contributing

* Bug reports and pull requests are welcome on GitHub at https://github.com/Ches-Ctrl/Cheddar. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the code of conduct
* Get in touch if you're interested in getting involved and to get a copy of the roadmap - charles.cheesman1@gmail.com

## License

© Charlie Cheesman - All rights reserved

## Code of Conduct

Everyone interacting in the Cheddar's codebases, issue trackers, chat rooms and mailing lists is expected to follow the code of conduct
