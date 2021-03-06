#! /bin/sh
### BEGIN INIT INFO
# Provides: starbound
# Required-Start: networking
# Default-Start: 2 3 4 5
# Default-Stop: S 0 1 6
# Short-Description: Starbound Server Daemon
# Description: Starts/Stops/Restarts the Starbound Server Daemon
### END INIT INFO
 
PATH=/sbin:/usr/sbin:/bin:/usr/bin
DESC="Starbound Server Daemon"
NAME=starbound
DIR=/home/steam/steamcmd/starbound/linux64
DAEMON=$DIR/starbound_server
PIDFILE=/var/run/$NAME.pid
SCRIPTNAME=/etc/init.d/$NAME
 
USER=steam
GROUP=steam
DAEMON_ARGS=""
 
STEAM_DIR=/home/steam/steamcmd
STEAM_DAEMON=$STEAM_DIR/steamcmd.sh
 
STEAM_USER=anonymous
STEAM_PASS=
STEAM_APP=211820
 
[ -x "$DAEMON" ] || exit 0
 
. /lib/init/vars.sh
. /lib/lsb/init-functions
 
do_start() {
if [ -e $PIDFILE ]; then
PID=`cat $PIDFILE`
 
if ( ps -p $PID > /dev/null ); then
log_failure_msg "$DESC '$NAME' is already running."
return 1
else
rm -f $PIDFILE
 
start-stop-daemon --start --background --chdir $DIR --chuid $USER:$GROUP --make-pidfile --pidfile $PIDFILE --quiet --exec $DAEMON --test > /dev/null || return 1
start-stop-daemon --start --background --chdir $DIR --chuid $USER:$GROUP --make-pidfile --pidfile $PIDFILE --quiet --exec $DAEMON -- $DAEMON_ARGS || return 2
fi
else
start-stop-daemon --start --background --chdir $DIR --chuid $USER:$GROUP --make-pidfile --pidfile $PIDFILE --quiet --exec $DAEMON --test > /dev/null || return 1
start-stop-daemon --start --background --chdir $DIR --chuid $USER:$GROUP --make-pidfile --pidfile $PIDFILE --quiet --exec $DAEMON -- $DAEMON_ARGS || return 2
fi
}
 
do_stop() {
if [ -e $PIDFILE ]; then
PID=`cat $PIDFILE`
 
if ( ps -p $PID > /dev/null ); then
start-stop-daemon --stop --signal 2 --quiet --pidfile $PIDFILE
[ "$?" = 2 ] && return 2
else
log_failure_msg "$DESC '$NAME' is not running."
rm -f $PIDFILE
return 1
fi
else
log_failure_msg "$DESC '$NAME' is not running."
return 1
fi
}
 
case "$1" in
start)
log_daemon_msg "Starting $DESC..." "$NAME"
do_start
 
case "$?" in
0|1) log_end_msg 0 ;;
1) log_end_msg 1 ;;
esac
;;
stop)
log_daemon_msg "Stopping $DESC..." "$NAME"
do_stop
 
case "$?" in
0|1) log_end_msg 0 ;;
2) log_end_msg 1 ;;
esac
;;
restart)
log_daemon_msg "Restarting $DESC..." "$NAME"
do_stop
 
case "$?" in
0|1)
do_start
 
case "$?" in
0) log_end_msg 0 ;;
*) log_end_msg 1 ;;
esac
;;
*)
log_end_msg 1
;;
esac
;;
status)
if [ -e $PIDFILE ]; then
PID=`cat $PIDFILE`
 
if ( ps -p $PID > /dev/null ); then
log_success_msg "$DESC '$NAME' is running (pid $PID)."
exit 0
else
log_failure_msg "$DESC '$NAME' is not running."
rm -f $PIDFILE
exit 1
fi
else
log_failure_msg "$DESC '$NAME' is not running."
exit 1
fi
;;
update)
su - $USER -c "$STEAM_DAEMON +login $STEAM_USER $STEAM_PASS +app_update $STEAM_APP +quit"
;;
*)
log_action_msg "Usage: $SCRIPTNAME {start|stop|restart|status|update}"
exit 0
;;
esac 