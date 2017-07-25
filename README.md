# discourse-battlenet-auth

This plugin is an OmniAuth login provider allowing Battle.net login to Discourse. This plugin utilizes [omniauth-bnet](https://github.com/Blizzard/omniauth-bnet).

__Note: I do not know Ruby/RoR and this is my very first dabbling with such.
Things have surely been done poorly and I apologize for that ahead of time.__

## Features

* Allow users to signup/login to Discourse via their Battle.net Account
* Sets their username as their Battletag (\# is replaced with \_)
* Allows editing of imported info before account creation
* Customizable button text

## Requirements

1. A working Discourse installation through Docker [[reference](https://github.com/discourse/discourse/blob/master/docs/INSTALL-cloud.md)]
2. (optional) SSL

## Installation and Setup

### Installing the Plugin in Discourse

Install the plugin by editing your `app.yml` file:

`$ cd /var/discourse && sudo vim containers/app.yml`

Add the following line to the hooks:  
_Note: spacing is no joke in YAML, be precise!_

`- git clone https://github.com/coryjreid/discourse-battlenet-auth.git`

It should look like this:

```yaml
## Plugins go here
## see https://meta.discourse.org/t/19157 for details
hooks:
  after_code:
    - exec:
        cd: $home/plugins
        cmd:
          - git clone https://github.com/discourse/docker_manager.git
          - git clone https://github.com/coryjreid/discourse-battlenet-auth.git
```

Now run:

`$ sudo ./launcher rebuild app`

You need an application with Battle.net to allow authentication. If you don't 
have one yet you can easily register a new application at the [Battle.net Developer Portal](https://dev.battle.net/). I suggest doing this while Discourse 
rebuilds.

### Creating a Battle.net Application

1. Navigate to `Applications > Create A New Application`
2. Fill in the info as you see fit
3. Add the following to __REGISTER CALLBACK URL__  
   `https://YOUR.DISCOURSE.COM/auth/bnet/callback`  
   _Note: Use http or https depending on what your site supports_
4. Check __ISSUE A NEW GAME KEY FOR GAME APIS__
5. __BASIC PLAN__ should be selected by default
6. Agree to the Terms and click __Register Application__
7. Copy down the __Key__ and __Secret__ as you will need them shortly.

### Configuring the Plugin

Assuming your Discourse has finished rebuilding and is online, login and access 
the admin control panel, navigate to `Settings > Login`, and scroll down to find
 your Battle.net settings (tip: filter using `battlenet` in the search box).

1. Check the box to enable login with Battle.net
2. Copy and paste your Application Key into the appropriate field
3. Copy and paste your Application Secret into the appropriate field
4. Logout to see your plugin in action!

## Getting Plugin Updates

Simply rebuild your Discourse instance!

`$ cd /var/discourse && sudo ./launcher rebuild app`

## Contributing / Helping

* Create a Pull Request with a new translation
* Log Issues
* Submit Pull Requests to help resolve issues or add new features


## License

MIT
