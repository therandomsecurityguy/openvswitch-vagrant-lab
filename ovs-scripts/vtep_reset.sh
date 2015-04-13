echo "Stopping ovsdb-server and ovs-vswitchd"
ovs-appctl -t ovs-vswitchd exit
ovs-appctl -t ovsdb-server exit

echo "Clearing OVSDB logs at /var/log/openvswitch"
truncate /var/log/openvswitch/ovsdb-server.log --size 0

echo "Re-generating hardware_vtep databases"
rm /etc/openvswitch/vtep.db
ovsdb-tool create /etc/openvswitch/vtep.db /usr/share/openvswitch/vtep/vtep.ovsschema

echo "Starting ovsdb-server and ovs-vswitchd"
/etc/init.d/openvswitch-switch start

echo "Configuring SSL"
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

echo "Adding hardware_vtep database"
ovs-appctl -t ovsdb-server ovsdb-server/add-db /etc/openvswitch/vtep.db

echo "Registering 'physical' switch to hardware_vtep db"
vtep-ctl add-ps br0
vtep-ctl set Physical_Switch br0 tunnel_ips=10.21.111.184

vtep-ctl add-port br0 p1

echo "Starting ovs-vtep script"
killall -15 ovs-vtep
/usr/share/openvswitch/scripts/ovs-vtep --log-file=/var/log/openvswitch/ovs-vtep.log \
      --pidfile=/var/run/openvswitch/ovs-vtep.pid \
      --detach br0

echo "Connecting to remote host at ssl:10.0.131.1:6632"
ovs-appctl -t ovsdb-server ovsdb-server/add-remote ssl:10.0.131.1:6632

