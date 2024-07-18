#!/usr/bin/env bash

docker_status=$(sudo systemctl is-active docker)

if [[ "$docker_status" != "active" ]]; then
  sudo systemctl start docker
  docker_status=$(sudo systemctl is-active docker)

  if [[ "$docker_status" == "active" ]]; then
    sudo docker start sql1

    mssql_status=$(sudo docker ps --filter "name=sql1" --format '{{.Names}}')
    if [[ "$mssql_status" == "sql1" ]]; then
      echo "mssql is now running"
      exit 0
    else
      echo "error starting mssql"
      exit 1
    fi
  fi
fi

mssql_status=$(sudo docker ps --filter "name=sql1" --format '{{.Names}}')
if [[ "$mssql_status" == "sql1" ]]; then
  echo "mssql is already running"
  exit 0
else
  sudo docker start sql1
  mssql_status=$(sudo docker ps --filter "name=sql1" --format '{{.Names}}')
  if [[ "$mssql_status" == "sql1" ]]; then
    echo "mssql is now running"
    exit 0
  else
    echo "error starting mssql"
    exit 1
  fi
fi
