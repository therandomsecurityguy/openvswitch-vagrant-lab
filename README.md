# openvswitch-vagrant-lab

This is a quick OVS/Mininet lab for testing the latest OVS features.


**Requirements**


1. VirtualBox. Install from https://www.virtualbox.org/wiki/Downloads

2. Vagrant v1.6.3 or above. Install from http://www.vagrantup.com/downloads.html

3. The vagrant-vbguest plugin. Install with 'vagrant plugin install vagrant-vbguest'

4. If using a MAC, you NEED Xcode!!!


**Installation**


1. Clone this repo and cd to it

2. Run 'vagrant up'


**Lab**


![Lab](https://github.com/therandomsecurityguy/openvswitch-vagrant-lab/blob/master/lab-connectivity.png)


Two servers are spawned via Vagrant. They are Ubuntu VMs with mininet and OVS 2.3.1 installed. The Internet server is really a VM with IP forwarding enabled. All networks above are implemented as VirtualBox internal networks which are not directly accessible from anywhere else including your local machine. If you wish to use different subnets, modify the variables in the Vagrantfile file included in the repo. You can SSH to any of the three VMs using ‘vagrant ssh’. 

For example: ‘vagrant ssh internet’, or ’vagrant ssh server1’ and then get to the internal networks from there.


**Stopping and starting Vagrant VMs**


To suspend your VMs, run 'vagrant suspend'. To shut them down, run
'vagrant halt'.


**Viewing VM status**

Run the following:

'vagrant status'


