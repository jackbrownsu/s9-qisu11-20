#!/bin/bash
 
USER=$(whoami)
USER_LOWER="${USER,,}"
USER_HOME="/home/${USER_LOWER}"
WORKDIR="${USER_HOME}/.nezha-agent"
FILE_PATH="${USER_HOME}/.s5"
HYSTERIA_WORKDIR="${USER_HOME}/.hysteria"
HYSTERIA_CONFIG="${HYSTERIA_WORKDIR}/config.yaml"  # Hysteria 配置文件路径
CRON_S5="nohup ${FILE_PATH}/s5 -c ${FILE_PATH}/config.json >/dev/null 2>&1 &"
CRON_NEZHA="nohup ${WORKDIR}/start.sh >/dev/null 2>&1 &"
CRON_HYSTERIA="nohup ${HYSTERIA_WORKDIR}/web server $HYSTERIA_CONFIG >/dev/null 2>&1 &"  # Hysteria 启动命令

# Cleanup existing processes
ps aux | grep "$(whoami)" | grep -v "sshd\|bash\|grep" | awk '{print $2}' | xargs -r kill -9 > /dev/null 2>&1

echo "检查并添加 crontab 任务"

# 检查所需文件是否存在，并添加 crontab 任务
  if [ -f "${WORKDIR}/start.sh" ] && [ -f "${FILE_PATH}/config.json" ] && [ -f "$HYSTERIA_CONFIG" ]; then
    echo "添加 nezha, socks5 和 Hysteria 的 crontab 重启任务"
    (crontab -l | grep -F "@reboot pkill -kill -u $USER && ${CRON_S5} && ${CRON_NEZHA} && ${CRON_HYSTERIA}") || (crontab -l; echo "@reboot pkill -kill -u $USER && ${CRON_S5} && ${CRON_NEZHA} && ${CRON_HYSTERIA}") | crontab -
    (crontab -l | grep -F "pgrep -x \"nezha-agent\" > /dev/null || ${CRON_NEZHA}") || (crontab -l; echo "*/15 * * * * pgrep -x \"nezha-agent\" > /dev/null || ${CRON_NEZHA}") | crontab -
    (crontab -l | grep -F "pgrep -x \"s5\" > /dev/null || ${CRON_S5}") || (crontab -l; echo "*/15 * * * * pgrep -x \"s5\" > /dev/null || ${CRON_S5}") | crontab -
    (crontab -l | grep -F "pgrep -x \"web\" > /dev/null || ${CRON_HYSTERIA}") || (crontab -l; echo "*/15 * * * * pgrep -x \"web\" > /dev/null || ${CRON_HYSTERIA}") | crontab -
    eval ${CRON_S5}
    eval ${CRON_HYSTERIA}
    eval ${CRON_NEZHA}
    sleep 3
  elif [ -f "${WORKDIR}/start.sh" ] && [ -f "$HYSTERIA_CONFIG" ]; then
    echo "添加 nezha 和 Hysteria 的 crontab 重启任务"
    (crontab -l | grep -F "@reboot pkill -kill -u $USER && ${CRON_NEZHA} && ${CRON_HYSTERIA}") || (crontab -l; echo "@reboot pkill -kill -u $USER && ${CRON_NEZHA} && ${CRON_HYSTERIA}") | crontab -
    (crontab -l | grep -F "pgrep -x \"nezha-agent\" > /dev/null || ${CRON_NEZHA}") || (crontab -l; echo "*/15 * * * * pgrep -x \"nezha-agent\" > /dev/null || ${CRON_NEZHA}") | crontab -
   (crontab -l | grep -F "pgrep -x \"web\" > /dev/null || ${CRON_HYSTERIA}") || (crontab -l; echo "*/15 * * * * pgrep -x \"web\" > /dev/null || ${CRON_HYSTERIA}") | crontab -
    eval ${CRON_HYSTERIA}
    eval ${CRON_NEZHA}
    sleep 3
  elif [ -f "${FILE_PATH}/config.json" ] && [ -f "$HYSTERIA_CONFIG" ]; then
    echo "添加 socks5 和 Hysteria 的 crontab 重启任务"
    (crontab -l | grep -F "@reboot pkill -kill -u $USER && ${CRON_S5} && ${CRON_HYSTERIA}") || (crontab -l; echo "@reboot pkill -kill -u $USER && ${CRON_S5} && ${CRON_HYSTERIA}") | crontab -
    (crontab -l | grep -F "pgrep -x \"s5\" > /dev/null || ${CRON_S5}") || (crontab -l; echo "*/15 * * * * pgrep -x \"s5\" > /dev/null || ${CRON_S5}") | crontab -
    (crontab -l | grep -F "pgrep -x \"web\" > /dev/null || ${CRON_HYSTERIA}") || (crontab -l; echo "*/15 * * * * pgrep -x \"web\" > /dev/null || ${CRON_HYSTERIA}") | crontab -
    eval ${CRON_S5}
    eval ${CRON_HYSTERIA}
  elif [ -f "${WORKDIR}/start.sh" ] && [ -f "${FILE_PATH}/config.json" ]; then
    echo "添加 nezha 和 socks5 的 crontab 重启任务"
    (crontab -l | grep -F "@reboot pkill -kill -u $USER && ${CRON_NEZHA} && ${CRON_S5}") || (crontab -l; echo "@reboot pkill -kill -u $USER && ${CRON_NEZHA} && ${CRON_S5}") | crontab -
    (crontab -l | grep -F "pgrep -x \"nezha-agent\" > /dev/null || ${CRON_NEZHA}") || (crontab -l; echo "*/15 * * * * pgrep -x \"nezha-agent\" > /dev/null || ${CRON_NEZHA}") | crontab -
    (crontab -l | grep -F "pgrep -x \"s5\" > /dev/null || ${CRON_S5}") || (crontab -l; echo "*/15 * * * * pgrep -x \"s5\" > /dev/null || ${CRON_S5}") | crontab -
    eval ${CRON_S5}
    eval ${CRON_NEZHA}
    sleep 3
  elif [ -f "${WORKDIR}/start.sh" ]; then
    echo "添加 nezha 的 crontab 重启任务"
    (crontab -l | grep -F "@reboot pkill -kill -u $USER && ${CRON_NEZHA}") || (crontab -l; echo "@reboot pkill -kill -u $USER && ${CRON_NEZHA}") | crontab -
    (crontab -l | grep -F "pgrep -x \"nezha-agent\" > /dev/null || ${CRON_NEZHA}") || (crontab -l; echo "*/15 * * * * pgrep -x \"nezha-agent\" > /dev/null || ${CRON_NEZHA}") | crontab -
    eval ${CRON_NEZHA}
    sleep 3
  elif [ -f "${FILE_PATH}/config.json" ]; then
    echo "添加 socks5 的 crontab 重启任务"
    (crontab -l | grep -F "@reboot pkill -kill -u $USER && ${CRON_S5}") || (crontab -l; echo "@reboot pkill -kill -u $USER && ${CRON_S5}") | crontab -
    (crontab -l | grep -F "pgrep -x \"s5\" > /dev/null || ${CRON_S5}") || (crontab -l; echo "*/15 * * * * pgrep -x \"s5\" > /dev/null || ${CRON_S5}") | crontab -
    eval ${CRON_S5}
  elif [ -f "$HYSTERIA_CONFIG" ]; then
    echo "添加 Hysteria 的 crontab 重启任务"
    (crontab -l | grep -F "@reboot pkill -kill -u $USER && ${CRON_HYSTERIA}") || (crontab -l; echo "@reboot pkill -kill -u $USER && ${CRON_HYSTERIA}") | crontab -
    (crontab -l | grep -F "pgrep -x \"web\" > /dev/null || ${CRON_HYSTERIA}") || (crontab -l; echo "*/15 * * * * pgrep -x \"web\" > /dev/null || ${CRON_HYSTERIA}") | crontab -
    eval ${CRON_HYSTERIA}
else
    echo "No valid configuration files found."
fi

