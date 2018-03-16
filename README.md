# Emoncms ready Vagrant build

Using Ubuntu [ubuntu/trusty64](https://app.vagrantup.com/ubuntu/boxes/trusty64) Vagrant box.

Configured according to [Emoncms on Ubuntu](https://github.com/emoncms/emoncms/blob/master/docs/LinuxInstall.md) configuration guide

Node, NPM, MongoDB included for local JavaScript development

Download [vargant](https://www.vagrantup.com/downloads.html).

Start the vagrant box (will be auto-provisioned):
```
vagrant up
```

Connect to the vargant box by SSH:
```
vagrnat ssh
```

Manually provision the vagrant box:
```
vagrant provision
```
