echo "Stopping ovsdb-server and ovs-vswitchd"
ovs-appctl -t ovs-vswitchd exit
ovs-appctl -t ovsdb-server exit
 
echo "Starting ovsdb-server and ovs-vswitchd"
/etc/init.d/openvswitch-switch start
 
echo "Configuring SSL"
rm /etc/openvswitch/nsx-controller-cacert.pem
ovs-vsctl --bootstrap set-ssl /etc/openvswitch/switch-privkey.pem /etc/openvswitch/switch-cert.pem /etc/openvswitch/nsx-controller-cacert.pem
# The above SSL configuration does not get picked up until
# ovs-vswitchd and ovsdb-server are restarted
/etc/init.d/openvswitch-switch restart
 
echo "Setting loglevel to debug"
ovs-appctl -t ovsdb-server vlog/set dbg
ovs-appctl -t ovs-vswitchd vlog/set dbg

echo "Listening on port ptcp:6640"
ovs-appctl -t ovsdb-server ovsdb-server/add-remote ptcp:6640
echo "Listening on port pssl:6632"
ovs-appctl -t ovsdb-server ovsdb-server/add-remote pssl:6632
 
echo "Connecting to remote host at ssl:10.21.111.251:6632"
ovs-appctl -t ovsdb-server ovsdb-server/add-remote ssl:10.21.111.251:6632

