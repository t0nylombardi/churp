# ChrupSocial

## Build in 7 easy steps

(About 42 sub-steps and procedures but who's counting ...)

###  macOS Ventura (13.2.*)
1. Install [Homebrew](//brew.sh):
   > **What about the Command Line Tools?**
   > If you're not developing software for an Apple device, you won't need the full Xcode application (it requires over 40GB of disk space!).
   >  - Download the latest Command Line Tools from the [Apple developer's page](https://developer.apple.com/download/more/)
   >  - You'll need to log in with your Apple ID
   >  - (No need to download all of XCode just for the Command Line Tools)
   >  - Filter out everything but "Developer Tools" on the left menu, or type in "Command Line Tools" in the left side search.
   >  - Download the latest Command Line Tools DMG file not in Beta.
   > -  You can also enter the command `xcode-select --install` in your the terminal to begin the installation process. You'll see a panel that asks you to install Xcode Command Line Tools.

   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
   ```
   - Follow the prompts
   - Run `brew doctor` and fix any issues it mentions

1. Install Churp dependencies with the following `brew` command:

     ```bash
     brew install ImageMagick Caskroom/cask/wkhtmltopdf
     # Install Nokogiri dependencies
     brew install libxml2
     brew install libpq-dev
     brew install libvips
     brew install openssl
     brew install cmake
     ```

    - **Install postgres**
      - download [postgres.app](https://github.com/PostgresApp/PostgresApp/releases/download/v2.6.5/Postgres-2.6.5-14.dmg)
       ```
    - **Install redis**
      - Run `brew install redis`
      - Follow the instructions homebrew prints out to auto start redis, which should be:

       ```bash
       brew services start redis
       ```
1. Install **ASDF** *(The Multiple Runtime Version Manager)* 
  
    - Install ASDF via Homebrew

      `echo -e "\n. $(brew --prefix asdf)/libexec/asdf.sh" >> ${ZDOTDIR:-~}/.zshrc`
    - OR use a ZSH Framework plugin like [asdf for oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/asdf) which will source this script and setup completions.

    - Install NodeJS to ASDF

      `asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git`

    - Install nodejs version
    
      ```bash
      # Make sure to install correct version of the node. Currently the highest version that is used for Churp is 19.8.1 As of this writting the lastest version of node is 21.1.0
      asdf install nodejs 19.8.1
      # Set nodejs version
      asdf global nodejs 19.8.1
      ```
    - Install Ruby to ASDF

    `asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git`

    - If you want to keep a more current version of Ruby to be the default you can so:
  
    ```bash
    asdf install ruby 3.2.1
    asdf global ruby 3.2.1  #sets it as the system default
    ```

1. Clone the repository to your local machine
    - If you can't already communicate with Github via SSH, follow the below directions taken from [Github's guide](https://help.github.com/articles/generating-ssh-keys/) to create a key and add it to your account:
      - Create an SSH key to communicate with Github

      ```bash
        ssh-keygen -t rsa -b 4096 -C "your@email-in.quotes"
        ```
      - Just keep pressing enter ... unless you want/need a passphrase ... then:

        ```bash
        pbcopy < ~/.ssh/id_rsa.pub
        #copies the key to your clipboard
        ```
      - Log in to Github, and in the top right corner of any page, click your profile photo, then click **Settings**.
      - In the user settings sidebar, click **SSH keys**.
      - Click **Add SSH key**.
      - In the Title field, add a descriptive label for the new key. For example, if you're using a personal Mac, you might call this key "Personal MacBook Pro".
      - Paste your key into the "Key" field.
      - Click **Add key**.
      - Confirm the action by entering your GitHub password.
      - Test the connection from the CLI

        ```bash
        ssh -T git@github.com
        #Hit enter to accept the fingerprint. If you get a message from Github referencing your username, you're good.
        ```
      - If you get an access denied error, have a look at [these instructions](https://help.github.com/articles/error-permission-denied-publickey/).
      - Clone the actual repo somewhere nice:

     ```bash
      git clone git@github.com:t0nylombardi/churp.git

1. Install the gems: **MAKE SURE YOU HAVE THE CORRECT BUNDLER VERSION.**

   ```bash
   # Assuming you're still in the Churp repo
   gem install bundler -v 2.4.6
   ```
1. Get that database ready with pre-populated data:

   ```bash
   # Assuming you're still in the Churp repo 
   rails db:setup
   rails seed:db_populate

1. Take 'er for a spin:
  
  ```bash
  rails bin/dev
  ```