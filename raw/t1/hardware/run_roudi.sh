#!/bin/bash

cd "$(dirname "$0")"

# 加载环境变量
source cfg/env.sh

# 定义路径（使用环境变量 ROBOT_SOFTWARE_HOME）
ROUDI_BIN="/opt/iceoryx/bin/iox-roudi"
ROUDI_CONFIG="${ROBOT_SOFTWARE_HOME}/entry/cfg/roudi_config.toml"

# 检查 ROBOT_SERIES 环境变量是否存在且为 T1
if [ -n "$ROBOT_SERIES" ] && [ "$ROBOT_SERIES" = "T1" ]; then

    # 强校验：检查 iox-roudi 可执行文件是否存在
    if [ ! -f "$ROUDI_BIN" ]; then
        echo "ERROR: iox-roudi executable not found: $ROUDI_BIN"
        exit 1
    fi

    # 检查是否有执行权限
    if [ ! -x "$ROUDI_BIN" ]; then
        echo "ERROR: iox-roudi is not executable: $ROUDI_BIN"
        exit 1
    fi

    # 强校验：检查配置文件是否存在
    if [ ! -f "$ROUDI_CONFIG" ]; then
        echo "ERROR: roudi config file not found: $ROUDI_CONFIG"
        exit 1
    fi

    if [ -d "/dev/shm/iox-*" ]; then
        echo "清理iceoryx残留共享内存..."
        rm -rf /dev/shm/iox-*
    fi

    /opt/iceoryx/bin/iox-roudi -c ${ROBOT_SOFTWARE_HOME}/entry/cfg/roudi_config.toml -m on
    echo "iox-roudi started in background with PID: $!"
else
    echo "ROBOT_SERIES is not set or not equal to Q1, skipping iox-roudi startup"
fi
