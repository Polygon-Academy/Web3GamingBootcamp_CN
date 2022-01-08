#! /bin/bash

ROOT=$(dirname "$0")

module="monkserver"

confFile="args/$module.args"
if [ -e $confFile ];then
  args=$(cat $confFile)
fi


function op_start()
{
  pid=$(is_running)
  if [ $pid -ge 1 ]; then
      echo "start $module failed: already started"
      return
  fi
  nohup ./$module $args >> ./log/nohup.log 2>&1 &
  echo "start monkserver"
}

function op_stop()
{
  pid=$(is_running)
  if [ $pid -lt 1 ]; then
      echo "stop $module failed: already stopped"
      return
  fi
  kill -15 $pid
  echo "stop monkserver"
}

function op_restart()
{
    op_stop
    sleep 1
    op_start
}

function is_running()
{
  ps -ef | grep -w $module | grep -v grep > .run.tmp
  count=`cat .run.tmp | wc -l`
  if [ $count -lt 1 ]; then
      echo -1
  else
    pid=`cat .run.tmp | awk '{print $2}'`
    echo $pid
  fi
}

op=$1
if [ "$op" = "" ]; then
    usage
    exit 0
fi

case $op in
  start)
    op_start
    ;;
  stop)
    op_stop
    ;;
  restart)
    op_restart
    ;;
  *)
esac