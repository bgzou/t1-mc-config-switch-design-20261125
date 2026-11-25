#!/bin/bash
set -e

# --------------------------------------------------------------------------------------------------------------
# 软件分区的开机自启动的入口脚本
# --------------------------------------------------------------------------------------------------------------

# 工作目录在 entry 下
cd "$(dirname "$0")"

# -------------------------------------------------------------
# 按字典序运行给定目录下的所有脚本
# -------------------------------------------------------------
execute_all_scripts() {
    dir=$1
    tmp="$(mktemp)"
    find "${dir}" -maxdepth 1 -type f -regex "${dir}/[0-9][0-9][0-9]-.*sh" | sort > "${tmp}"

    while IFS= read -r script_path; do
      echo "[RUN] ${script_path}"
      "${script_path}"
    done < "${tmp}"

    sync
}

# -------------------------------------------------------------
# 执行特定 boot 阶段的脚本，并设置 flag
# -------------------------------------------------------------
execute_boot_scripts() {
  name=$1

  # 该阶段的 flag
  flag="/robot/flag/software_${name}.flag"

  # 仅该 flag 不存在时，执行本阶段的脚本
  if [ ! -f "${flag}" ]; then
    execute_all_scripts "${name}"

    # 设置本阶段已经执行完毕的 flag
    touch "${flag}"
    sync "${flag}"
    echo "[FLAG] ${name} done."
  fi
}

# -------------------------------------------------------------
# 开始执行各个阶段的 boot 脚本
# -------------------------------------------------------------

execute_boot_scripts "first_boot"
execute_boot_scripts "data_reset_boot"
execute_all_scripts "every_boot"
