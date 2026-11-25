# 05_ROBOPARTY_DEPLOY · roboparty_deploy 基线（配置+源码）

> 自动生成的阅读包：把多个原始文件按主题拼接，便于一次读多份。
> 引用行号/上下文时请回到 `raw/` 下的同名文件；`FILE:` 行给出原始路径。
> 文件数：20

---

## FILE: raw/roboparty/README_CN.md

- bytes: 25960

````markdown
# roboparty_deploy

[![许可证：GPL v3](https://img.shields.io/badge/许可证-GPLv3-blue.svg)](LICENSE)

[![ROS2](https://img.shields.io/badge/ROS2-Humble-silver)](https://docs.ros.org/en/humble/index.html)
![C++](https://img.shields.io/badge/C++-17-blue)
[![Linux platform](https://img.shields.io/badge/platform-linux--x86_64-orange.svg)](https://releases.ubuntu.com/22.04/)
[![Linux platform](https://img.shields.io/badge/platform-linux--aarch64-orange.svg)](https://releases.ubuntu.com/22.04/)

[English](README.md) | [中文](README_CN.md)

## 概述

`roboparty_deploy` 是 Roboparty 面向 RPO/Roboto 机器人的 ROS2 部署框架。它采用模块化架构，便于硬件驱动、推理、主控工具和用户脚本独立维护与扩展。

开源地址：[https://github.com/Roboparty/roboparty_deploy](https://github.com/Roboparty/roboparty_deploy)

**维护者**: RoboParty
**支持渠道**: GitHub Issues

**主要特性:**

- **易于上手**: 提供全部细节代码，便于学习并允许修改代码。
- **隔离性**: 不同功能由不同包实现，支持加入自定义功能包。
- **长期支持**: 本仓库将随着训练仓库代码的更新而更新，并将长期支持。

## 主控连接

部署框架在 **Orange Pi 5 Plus** 与 **RDK X5** 上经过了充分验证。

- **Orange Pi 5 Plus**: 系统为 `Ubuntu 22.04`，内核版本为 `5.10`
- **RDK X5**: 系统为 `Ubuntu 22.04`，内核版本为 `6.1.83`

关于主控的连接方法和相关资料，参见 [Orange Pi 5 Plus Wiki](http://www.orangepi.cn/orangepiwiki/index.php/Orange_Pi_5_Plus) 与 [RDK X5 Doc](https://d-robotics.github.io/rdk_doc/Quick_start/hardware_introduction/rdk_x5)。

## 环境配置

1. 首先安装 ROS2 Humble，参考 [ROS 官方](https://docs.ros.org/en/humble/Installation.html) 进行安装。

2. 部署还依赖 `ccache`、`fmt`、`spdlog`、`eigen3`、`screen` 等库，在主控中执行指令进行安装：

   ```bash
   sudo apt update && sudo apt install -y ccache libfmt-dev libspdlog-dev libeigen3-dev screen
   ```

3. 若需使用手柄控制，还需安装 ROS2 的 `joy` 包：

   ```bash
   sudo apt install -y ros-humble-joy
   ```

4. 若需使用仓库中的 Python 脚本（如 `scripts/set_zero.py`），还需安装对应 Python 依赖：

   ```bash
   sudo apt install -y python3-yaml python3-numpy
   ```

5. 接着拉取部署代码：

   ```bash
   git clone --recursive https://github.com/Roboparty/roboparty_deploy.git
   cd roboparty_deploy
   git submodule update --init --recursive
   ```

6. 如果使用 Orange Pi 5 Plus，执行下面的指令为其安装 **5.10 实时内核**：
   
   > **注意**：RDK X5 无需执行此步骤，请直接烧录我们提供的、已预装实时内核的镜像。

   ```bash
   cd assets
   sudo apt install ./*.deb
   cd ..
   ```

7. 接下来为用户授予实时优先级设置权限：

   ```bash
   sudo nano /etc/security/limits.conf
   ```

   在文件末尾添加以下两行（**请务必将 `orangepi` 替换为你的实际用户名**，例如 RDK X5 的默认用户名为 `sunrise`）：

   ```bash
   # Allow user 'orangepi' to set real-time priorities
   orangepi   -   rtprio   98
   orangepi   -   memlock  unlimited
   ```

   重启设备使配置生效，随后通过以下指令验证：

   ```bash
   ulimit -r
   ```

   > **提示**：输出为 **98** 即代表配置成功。

## AP配置（可选）

为方便脱离网线和显示器调试，可以为主控板开启 WiFi 热点（AP）。配置相关文件在 `tools/create_ap` 目录中。

> **注意**：由于单网卡限制，开启 AP 模式后，主控板自带的 WiFi 将难以连接家用路由器等其他外部网络。
>
> - **如需连接外网加载包或环境**，请为主控板**接入有线网络**。
> - **如想暂时恢复无线上网**，可以通过以下命令停止服务（需要外接显示器或网线登录）：
>   ```bash
>   sudo systemctl stop create_ap.service
>   ```

1. 在项目根目录下执行，安装并赋予权限：

   ```bash
   sudo cp tools/create_ap/create_ap /usr/bin/
   sudo chmod +x /usr/bin/create_ap
   ```

2. 部署 systemd 服务文件：

   ```bash
   sudo cp tools/create_ap/create_ap.service /etc/systemd/system/
   ```

3. 根据你的主控板复制配置文件：

   **Orange Pi 5 Plus** 请使用该配置：

   ```bash
   sudo cp tools/create_ap/create_ap_orangepi.conf /etc/create_ap.conf
   ```

   **RDK X5** 请使用该配置：

   ```bash
   sudo cp tools/create_ap/create_ap_sunrise.conf /etc/create_ap.conf
   ```

   > **说明**：默认配置下的热点名称（`SSID`）为 **`atom`**，连接密码（`PASSPHRASE`）为 **`<REDACTED_DEFAULT_AP_PASSWORD>`**。如需自定义热点名称或密码，可编辑 `/etc/create_ap.conf` 文件并修改对应的字段。

4. 开启开机自启并立即启动热点：

   ```bash
   sudo systemctl daemon-reload
   sudo systemctl enable create_ap.service
   sudo systemctl start create_ap.service
   ```

## 硬件配置

在连接之前，请先完成对电机 ID 和 IMU 波特率以及频率的设置。

对于 **电机 ID**，请参见 [产品安装手册](https://roboparty.feishu.cn/wiki/OiO2wF4NiiE08Yk1yJjcgnumnUw) 中对电机 ID 的定义，并使用达妙上位机工具进行设置，使用教程参见 [达妙科技文档](https://gitee.com/kit-miao/damiao-document)。

对于 **IMU**，我们默认使用 **`921600` 波特率** 与 **`500HZ` 频率**。如何使用上位机进行修改参见 [HiPNUC 产品手册](https://www.hipnuc.com/resource_hi14.html)。
> **提示**：也可以使用其他波特率，但请 **保证频率大于 200HZ**。若使用其他波特率，请同步修改 `src/inference/robots/rpo/robot.yaml` 中的 IMU 配置。

## 硬件连接

电机驱动的默认 CAN 映射关系如下（按照 USB 转 CAN 插入主控的顺序编号，先插的为 `can0`）：
- **`can0`** 对应 **左腿**
- **`can1`** 对应 **右腿加腰**
- **`can2`** 对应 **左手**
- **`can3`** 对应 **右手**

> **建议**：将 USB 转 CAN 插在主控的 **USB 3.0 接口**上。如果使用 USB 扩展坞，也请使用 3.0 接口的扩展坞并插在 3.0 接口上；IMU 和手柄插在 USB 2.0 接口即可。具体可参见 [走线说明](https://roboparty.feishu.cn/wiki/QeY2wozbiiIivlkBfdccvqVlnog)。

### 方式一：手动配置（不推荐）
如果不配置 udev 规则，则需要严格按照上文顺序插入 USB 转 CAN，并插入 IMU 后手动配置 CAN 和 IMU 串口：

```bash
# CAN 配置
sudo ip link set canX up type can bitrate 1000000
sudo ip link set canX txqueuelen 1000
# canX 为 can0 can1 can2 can3，需要为每个 can 都输入一遍上面两个指令

# IMU 配置
sudo chmod 666 /dev/ttyUSB0
```

### 方式二：使用 udev 规则自动绑定（推荐）
编写 udev 规则将 USB 接口与对应设备物理绑定，这样就**不需要按顺序插入设备**。示例提供了 `99-auto-up-devs-orangepi.rules` 与 `99-auto-up-devs-sunrise.rules`。如果连线方式与 [走线说明](https://roboparty.feishu.cn/wiki/QeY2wozbiiIivlkBfdccvqVlnog) 完全一致，可直接使用。

接线不一致则需要修改文件中的 `KERNELS` 项，将其对应到实际绑定的 USB 接口。在主控输入以下指令以监视 USB 事件：

```bash
sudo udevadm monitor
```

在 USB 接口插入设备时，终端就会显示该 USB 接口的 `KERNELS` 属性项，如 `/devices/pci0000:00/0000:00:14.0/usb3/3-8`，在匹配 `KERNELS` 属性项时使用 `3-8` 即可。如果绑定在该 USB 接口上的扩展坞上的 USB 口，则会有 `3-8.x` 出现，此时使用 `3-8.x` 匹配扩展坞上的 USB 口即可。

编写完成后在项目根目录下执行：

```bash
# RDK X5 使用 assets/99-auto-up-devs-sunrise.rules
sudo cp assets/99-auto-up-devs-orangepi.rules /etc/udev/rules.d/
sudo udevadm control --reload
sudo udevadm trigger
```

重启主控即可生效。

该 udev 规则还包括 IMU 串口配置。如果规则正常生效，CAN 接口应该全部自动配置完毕并使能，可以在主控中输入 `ip a` 指令查看结果。

## 软件使用

### 首次构建与终端环境

以下命令均在仓库根目录执行。`/opt/ros/humble/setup.bash` 由 ROS2 Humble 安装提供；本仓库的 `install/setup.bash` 不随源码提供，而是在工作空间首次成功编译后生成。

首次构建，或代码更新后需要重新构建时，按以下顺序执行：

```bash
source /opt/ros/humble/setup.bash
colcon build --symlink-install
source install/setup.bash
```

工作空间已经编译后，每次打开新终端只需重新加载环境：

```bash
source /opt/ros/humble/setup.bash
source install/setup.bash
```

`source` 只对当前终端生效。`start_robot.sh` 和 `start_camera.sh` 会在各自脚本内部执行所需构建并加载工作空间，因此直接运行它们前无需手动生成 `install/setup.bash`；但脚本内部加载的环境不会回传到调用它的终端。脚本返回后，如果还要在当前终端或其他终端调用 ROS2 服务、运行 Python SDK，仍需执行上面的两条 `source` 命令。

### 电机标零（首次使用/零点丢失时）

> **说明**：电机标零通常只需要在首次使用时执行一次；如果电机经过检修、更换，或出现零点丢失，也需要重新执行标零。

仓库内提供了两种零点标定方式，适用于不同场景：

- `ros2 service call /set_zeros std_srvs/srv/Trigger`
  用于在机器人软件已经启动、电机已经初始化且推理未运行时，将当前关节位置写入电机零点。
- `python3 scripts/set_zero.py`
  用于逐个电机进行人工摆位标零，更适合首次装机、检修后重标定或只想对部分电机重新标零的场景。

使用 `/set_zeros` 服务时，建议按以下顺序操作：

1. 在仓库根目录运行 `./tools/start_robot.sh`；脚本会先完成所需构建并生成 `install/setup.bash`，再通过后台 `screen` 会话启动软件并返回当前终端。
2. 脚本启动成功并返回后，在同一终端加载 ROS2 和工作空间环境。
3. 调用 `/init_motors` 初始化电机。
4. 确认机器人处于目标零位，且此时没有运行推理。
5. 调用 `/set_zeros` 写入当前零点。

```bash
# 仓库根目录；以下命令均在同一终端执行
./tools/start_robot.sh
source /opt/ros/humble/setup.bash
source install/setup.bash
ros2 service call /init_motors std_srvs/srv/Trigger
ros2 service call /set_zeros std_srvs/srv/Trigger
```

使用脚本 `scripts/set_zero.py` 时：

1. 在仓库根目录加载 ROS2 环境。
2. 编译工作空间，生成 `install/setup.bash`。
3. 在当前终端加载工作空间环境。
4. 确认 CAN 接口与 udev 映射已正常生效。
5. 按需检查或修改 `scripts/config/set_zero.yaml`，确认电机 ID、CAN 接口、电机型号与实际硬件一致。
6. 在可交互终端中运行脚本后，按提示将当前电机手动摆到零位。
7. 按 `Enter` 写入该电机零点，按空格跳过当前电机。

```bash
source /opt/ros/humble/setup.bash
colcon build --symlink-install
source install/setup.bash
python3 scripts/set_zero.py
```

`scripts/set_zero.py` 会按 `scripts/config/set_zero.yaml` 中的顺序依次标定各电机，并在标定过程中将电机切换到阻尼模式，便于手动调整姿态。

### 启动软件

> **警告**：启动机器人前，确保机器人完成零点标定，**请务必阅读 [安全操作指南](https://roboparty.feishu.cn/wiki/ZGtnwpHCjii2XykBYMGchoBBnSl)！**

此外，请特别注意 `src/inference/robots/rpo/robot.yaml` 中的零点偏移配置：

```yaml
motor_zero_offset: 
    [0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
     0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.093,
     0.0, 0.0, 0.0, 0.0, 0.0,
     0.0, 0.0, 0.0, 0.0, 0.0]
```

- 如果是**将腰部 yaw 转至限位块处**进行标定：保留 `2.093`。
- 如果是**使用打印件固定腰部 yaw** 进行标定：将 `2.093` 改为 `0.0`。

一切准备就绪后，运行脚本启动软件：

```bash
./tools/start_robot.sh
```

默认会启动 `rpo` 机器人的 `default` 策略。也可以显式选择机器人和策略：

```bash
./tools/start_robot.sh --robot rpo --policy amp
./tools/start_robot.sh rpo beyondmimic
```

`./tools/start_robot.sh` 会自动执行 `colcon build --symlink-install` 编译工作空间，并在后台启动以下两个 `screen` 会话：

- `inference_session`：推理节点
- `joy_session`：手柄节点

可使用以下命令查看后台输出：

```bash
screen -r inference_session
screen -r joy_session
```

可使用以下命令停止对应后台组件：

```bash
screen -S inference_session -X quit
screen -S joy_session -X quit
```

如果需要切换不同的策略模型，可以通过 `policy` 参数选择 `src/inference/robots/rpo/configs/` 下的配置：

```bash
./tools/start_robot.sh --robot rpo --policy default
./tools/start_robot.sh --robot rpo --policy amp
./tools/start_robot.sh --robot rpo --policy attn_enc
./tools/start_robot.sh --robot rpo --policy beyondmimic
./tools/start_robot.sh --robot rpo --policy getup
./tools/start_robot.sh --robot rpo --policy interrupt
./tools/start_robot.sh --robot rpo --policy parkour
```

`parkour` 依赖 `/depth_obs` 深度观测。启动机器人推理前，请先在另一个终端启动 RealSense 与深度处理：

```bash
./tools/start_camera.sh --policy parkour
```

#### 稀疏历史观测

`obs_layouts` 中的观测项支持 `name:size@tap|tap` 格式，用于选择该观测项的特定历史帧。`tap` 以推理步为单位：`0` 表示当前帧，`1` 表示上一帧。`tap` 必须是非负整数、不能重复，并且必须小于对应的 `frame_stacks`。未指定 `@` 的观测项仍使用全部历史帧；只要任一观测项指定了 `tap`，该策略就会启用稀疏历史模式。

例如，`parkour` 仅使用当前帧的感知观测，同时保留其他观测项的 8 帧历史：

```yaml
obs_layouts:
  - "ang_vel:3, gravity_b:3, cmd_vel:3, dof_pos:23, dof_vel:23, last_action:23, perception:128@0"
frame_stacks: [8]
obs_stack_orders: ["obs_major"]
```

此配置的输入长度为 `78 × 8 + 128 = 752`。历史观测的排列方式由 `obs_stack_orders` 决定：

- `obs_major`：先按观测项排列，再按 tap 排列；显式指定的 tap 保留书写顺序，未指定 tap 的观测项按最旧帧到当前帧排列。
- `frame_major`：按最旧帧到当前帧排列，每帧内遵循 `obs_layouts` 的顺序；显式 `tap` 必须按严格降序书写，例如 `@4|2|0`。

策略初始化或重置后的首次推理时，当前观测会用于填充全部历史帧。程序启动时会检查最终输入长度是否与 ONNX 模型一致。

### 手柄控制

- **X 键**: 使能 / 失能电机
- **A 键**: 复位电机
- **B 键**: 开始 / 暂停推理
- **Y 键**: 切换手柄控制 / cmd_vel 指令控制
- **LB 键**: 切换策略模式（在 beyondmimic / interrupt 模式下可用）
- **RB 键**: 切换运动序列（在 beyondmimic 模式下可用）
- **右摇杆**: 控制前后左右移动
- **LT/RT**: 控制转向（左 / 右旋转）

### 服务接口

可以通过命令行调用 ROS2 服务来控制机器人：

- **初始化电机**:
  
  ```bash
  ros2 service call /init_motors std_srvs/srv/Trigger
  ```

- **去初始化电机**:

  ```bash
  ros2 service call /deinit_motors std_srvs/srv/Trigger
  ```

- **开始推理**:

  ```bash
  ros2 service call /start_inference std_srvs/srv/Trigger
  ```

- **停止推理**:

  ```bash
  ros2 service call /stop_inference std_srvs/srv/Trigger
  ```

- **清除错误**:

  ```bash
  ros2 service call /clear_errors std_srvs/srv/Trigger
  ```

- **设置零点**:

  ```bash
  ros2 service call /set_zeros std_srvs/srv/Trigger
  ```

  该服务会将机器人当前姿态写入电机零点。调用前请确保当前终端已 source ROS2 和工作空间环境，且电机已初始化、机器人已摆到目标零位、当前没有运行推理。

- **重置关节**:

  ```bash
  ros2 service call /reset_joints std_srvs/srv/Trigger
  ```

- **刷新关节状态**:

  ```bash
  ros2 service call /refresh_joints std_srvs/srv/Trigger
  ```

- **读取关节状态**:

  ```bash
  ros2 service call /read_joints std_srvs/srv/Trigger
  ```

- **读取 IMU 状态**:

  ```bash
  ros2 service call /read_imu std_srvs/srv/Trigger
  ```

## Python SDK

本仓库提供了 Python SDK，方便用户使用 Python 脚本控制硬件。

> **注意**：`imu_py`、`motors_py`、`robot_py` 这三个模块来自工作空间编译产物。运行任何 Python SDK 示例或脚本前，请先完成工作空间编译，并 source ROS2 环境和本工作空间的 `install/setup.bash`。

```bash
source /opt/ros/humble/setup.bash
colcon build --symlink-install
source install/setup.bash
```

> **安全提示**：电机和机器人 SDK 会直接控制真实硬件。运行前请确认机器人已可靠支撑、急停可用，且设备 ID、接口和型号配置正确；不要让多个程序同时控制同一设备。下列相对路径均以仓库根目录为当前目录。

> **提示**：详细 Python 脚本示例请参考 `scripts/` 目录。

### 1. IMU SDK (`imu_py`)

#### 静态方法

- `create_imu(imu_id: int, interface_type: str, interface: str, imu_type: str, baudrate: int = 0) -> IMUDriver`: 创建 IMU 驱动。当前支持 `imu_type="HIPNUC"`，以及 `interface_type="serial"` 或 `"can"`。

`interface` 为串口设备节点（如 `/dev/ttyUSB0`）或 SocketCAN 接口名（如 `can0`）。串口和 CAN 配置都会读取并传递 `baudrate`：串口用它设置通信速率，CAN 则使用已配置为相同波特率的 SocketCAN 接口。`imu_id` 在 CAN 模式下用于匹配设备报文，串口模式下仅作为配置 ID 保存。

#### 成员方法

- `get_imu_id() -> int`: 返回创建实例时传入的 IMU ID，不读取硬件。
- `get_ang_vel() -> List[float]`: 获取最新缓存的角速度 `[x, y, z]` (rad/s)。
- `get_quat() -> List[float]`: 获取最新缓存的四元数 `[w, x, y, z]`。
- `get_lin_acc() -> List[float]`: 获取最新缓存的线加速度 `[x, y, z]` (m/s²)。
- `get_temperature() -> float`: 获取缓存的温度 (°C)；当前串口实现不会更新该字段。

getter 返回 IMU 坐标系中的异步缓存，不会同步读取设备。缓存初始值均为零，且 SDK 不提供时间戳或就绪状态；使用前应等待首个有效数据，并自行处理超时或断线。

#### 使用示例

```python
import time
import imu_py
imu = imu_py.IMUDriver.create_imu(8, "serial", "/dev/ttyUSB0", "HIPNUC", 921600)
time.sleep(0.1)  # 反馈异步更新，先等待首帧
quat = imu.get_quat()
```

### 2. 电机 SDK (`motors_py`)

提供 `MotorControlMode` 枚举：`MIT`、`POS` 和 `SPD` 是工作模式；`NONE` 仅表示尚未设置模式，不应作为控制模式传入。

#### 静态方法

- `create_motor(motor_id: int, interface_type: str, interface: str, motor_type: str, motor_model: int, master_id_offset: int = 0, motor_zero_offset: float = 0.0) -> MotorDriver`: 创建电机驱动并立即打开通信接口。

支持 `DM`、`EVO`、`LRO`、`XYN`；DM/EVO 可使用 CAN 或 CAN-FD，LRO/XYN 使用 CAN-FD。`interface` 为接口名（如 `can0`），`motor_model` 必须与实际型号一致，`master_id_offset` 仅 DM 使用，`motor_zero_offset` 为以 rad 计的软件位置偏移。

#### 成员方法

- `init_motor() -> int`: 初始化并使能电机，返回驱动状态/错误码；该值不是统一的布尔成功标志。
- `deinit_motor()`: 发送失能指令。
- `set_motor_control_mode(mode: MotorControlMode)`: 设置控制模式。
- `motor_mit_cmd(pos: float, vel: float, kp: float, kd: float, torque: float)`: 发送单电机 MIT 指令。位置为 rad，速度为 rad/s，前馈力矩按 N·m 使用，`kp`/`kd` 为驱动协议的刚度/阻尼增益。
- `motors_mit_cmd(f_p: List[float], f_v: List[float], f_kp: List[float], f_kd: List[float], f_t: List[float])`: 发送最多 8 个槽位的批量 MIT 指令；支持情况取决于驱动。
- `motor_pos_cmd(pos: float, spd: float, ignore_limit: bool = False)`: 发送位置指令，单位分别为 rad 和 rad/s。当前所有驱动都忽略 `ignore_limit`；传入 `True` 不会绕过限位。
- `motor_spd_cmd(spd: float)`: 发送速度指令 (rad/s)。
- `set_motor_zero() -> bool`: 将当前电机轴位置设为硬件零点，并返回驱动检查结果。
- `write_motor_flash() -> bool`: 请求保存参数并返回驱动结果。
- `get_motor_param(param_cmd: int)`: 请求驱动参数；当前 Python API 不直接返回参数值。
- `reset_motor_id()`: 按驱动规则重置硬件 ID。
- `clear_motor_error()`: 发送清错指令。
- `get_motor_pos() -> float`: 获取最新缓存的位置 (rad)。
- `get_motor_spd() -> float`: 获取最新缓存的速度 (rad/s)。
- `get_motor_current() -> float`: 获取最新缓存的力矩/电流反馈；物理量取决于驱动。
- `get_motor_temperature() -> float`: 获取最新缓存的温度 (°C)。
- `get_error_id() -> int`: 获取缓存的错误码。
- `get_motor_id() -> int`: 获取本地电机 ID。
- `get_motor_control_mode() -> int`: 获取本地控制模式。
- `get_response_count() -> int`: 获取离线检测计数器；发送请求时递增，收到反馈时清零。
- `refresh_motor_status()`: 执行驱动相关的状态刷新。
- `get_can_name() -> str`: 返回创建时配置的 CAN/CAN-FD 接口名。

首次使用或切换控制模式时，应先调用一次 `set_motor_control_mode()`；否则本次控制调用可能只完成模式切换而不发送目标。反馈 getter 均读取异步缓存，不会主动请求硬件状态。

批量控制、参数持久化、ID 重置和状态刷新的支持情况取决于驱动，使用前请确认对应实现。

#### 使用示例

```python
import motors_py
motor = motors_py.MotorDriver.create_motor(1, "can", "can0", "DM", 0, 16)
try:
    motor.init_motor()
    motor.set_motor_control_mode(motors_py.MotorControlMode.MIT)
    # kp=0，仅施加阻尼，不跟踪位置目标
    motor.motor_mit_cmd(0.0, 0.0, 0.0, 1.0, 0.0)
finally:
    motor.deinit_motor()
```

### 3. 机器人 SDK (`robot_py`)

`RobotInterface` 类用于统一控制整个机器人，读取配置文件自动加载电机和 IMU。

#### 构造函数

- `RobotInterface(config_file: str)`: 读取 YAML 并创建电机和 IMU 驱动。构造时会打开硬件接口，但不会使能电机；相对路径按当前工作目录解析。

所有关节向量均采用配置中的逻辑关节顺序。`p`、`reset_joints()` 的目标以及非空的 `v`、`kp`、`kd`、`tau` 必须与电机数量一致；当前实现不检查长度。

#### 成员方法

- `init_motors() -> None`: 初始化并使能所有电机。
- `deinit_motors() -> None`: 失能所有电机。
- `apply_action(p: List[float], v: List[float] = [], kp: List[float] = [], kd: List[float] = [], tau: List[float] = []) -> None`: 发送关节 MIT 指令；位置为 rad、速度为 rad/s、`tau` 为前馈力矩。空的 `v`/`tau` 使用零值，空的 `kp`/`kd` 使用配置值。电机未初始化时不会发送指令。
- `reset_joints(joint_default_angle: List[float]) -> None`: 用约 5 秒将机器人平滑移动到目标角度。
- `read_joints() -> None`: 将电机异步缓存转换到逻辑关节顺序并更新关节缓存，不主动请求状态。
- `refresh_joints() -> None`: 调用各驱动刷新状态，等待 1 秒后更新关节缓存；具体刷新行为取决于驱动。
- `read_imu() -> None`: 将 IMU 异步缓存转换到机身坐标系并更新 IMU 缓存。
- `set_zeros() -> None`: 将当前电机轴位置设为硬件零点；不会修改配置中的软件偏移或立即刷新关节缓存。
- `clear_errors() -> None`: 向所有电机发送清错指令。
- `get_joint_q() -> List[float]`: 获取缓存的逻辑关节位置 (rad)。
- `get_joint_vel() -> List[float]`: 获取缓存的逻辑关节速度 (rad/s)。
- `get_joint_tau() -> List[float]`: 获取缓存的逻辑关节 effort；其底层物理量和单位取决于电机驱动。
- `get_quat() -> List[float]`: 获取最近一次 `read_imu()` 写入的机身四元数 `[w, x, y, z]`。
- `get_ang_vel() -> List[float]`: 获取最近一次 `read_imu()` 写入的机身角速度 `[x, y, z]` (rad/s)。

getter 只返回 `RobotInterface` 缓存；读取前应先调用对应的 `read_*()` 或 `refresh_joints()`。

#### 属性

- `is_init: bool`: 只读的软件状态，表示已调用初始化且尚未去初始化；不代表所有电机均在线或无故障。

#### 使用示例

```python
import robot_py
robot = robot_py.RobotInterface("src/inference/robots/rpo/robot.yaml")
try:
    robot.init_motors()
    robot.refresh_joints()
    joint_q = robot.get_joint_q()
    robot.apply_action(joint_q)
finally:
    if robot.is_init:
        robot.deinit_motors()
```

## 许可证

除另有说明外，本仓库中由 RoboParty 创作的原创内容依据 [GNU General Public License v3.0 only](LICENSE)（`GPL-3.0-only`）授权。

Git 子模块、已打包二进制文件及其他第三方资料继续遵循其各自的版权和许可证条款；仓库级 GPLv3 声明不会替代这些条款。当前许可证清单和再分发说明见 [LICENSES.md](LICENSES.md)。
````


---

## FILE: raw/roboparty/robot.yaml

- bytes: 1522

```yaml
imu:
    imu_id: 8
    imu_interface_type: "serial"
    imu_interface: "/dev/ttyUSB0"
    imu_type: "HIPNUC"
    baudrate: 921600

motors:
    motor_id: 
        [1, 2, 3, 4, 5, 6,
         7, 8, 9, 10, 11, 12, 13,
         14, 15, 16, 17, 18,
         19, 20, 21, 22, 23]
    motor_interface_type: ["can", "can", "can", "can"]
    motor_interface: ["can0", "can1", "can2", "can3"]
    motor_num: [6, 7, 5, 5]
    motor_type: ["DM", "DM", "DM", "DM"]
    motor_model: 
        [1, 1, 1, 1, 0, 0,
         1, 1, 1, 1, 0, 0, 1,
         0, 0, 0, 0, 0,
         0, 0, 0, 0, 0]
    master_id_offset: 16
    motor_zero_offset: 
        [0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
         0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.093,
         0.0, 0.0, 0.0, 0.0, 0.0,
         0.0, 0.0, 0.0, 0.0, 0.0]

robot:
    type: "rpo"
    kp: 
        [100.0, 100.0, 100.0, 150.0, 40.0, 40.0,
         100.0, 100.0, 100.0, 150.0, 40.0, 40.0, 150.0,
         40.0, 40.0, 40.0, 30.0, 20.0,
         40.0, 40.0, 40.0, 30.0, 20.0]
    kd: 
        [3.3, 3.3, 3.3, 5.0, 2.0, 2.0,
         3.3, 3.3, 3.3, 5.0, 2.0, 2.0, 5.0,
         2.0, 2.0, 2.0, 1.5, 1.0,
         2.0, 2.0, 2.0, 1.5, 1.0]
    motor_sign: 
        [1, 1, 1, 1, 1, 1,
         1, 1,-1,-1,-1,-1, 1,
         1, 1, 1, 1, 1,
        -1, 1, 1,-1, 1]
    close_chain_motor_idx:
        [4, 5,
        10,11]
    urdf2motor: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22]
    extrinsic_R: 
        [1.0, 0.0, 0.0, 
         0.0, 1.0, 0.0, 
         0.0, 0.0, 1.0]
```


---

## FILE: raw/roboparty/configs/default.yaml

- bytes: 1643

```yaml
inference_node:
    ros__parameters:
        model_names: ["policy.onnx"]
        obs_layouts:
          - "ang_vel:3, gravity_b:3, cmd_vel:3, dof_pos:23, dof_vel:23, last_action:23"
        frame_stacks: [10]
        obs_stack_orders: ["frame_major"]
        act_alpha: 1.0
        joint_num: 23
        decimation: 5
        intra_threads: 1
        dt: 0.004
        obs_scales_lin_vel: 1.0
        obs_scales_ang_vel: 1.0
        obs_scales_dof_pos: 1.0
        obs_scales_dof_vel: 1.0
        obs_scales_gravity_b: 1.0
        clip_observations: 100.0
        action_scale: [0.25]
        clip_actions: 100.0
        usd2urdf: [0, 6, 12, 1, 7, 13, 18, 2, 8, 14, 19, 3, 9, 15, 20, 4, 10, 16, 21, 5, 11, 17, 22]
        clip_cmd: 
            [-0.4, 0.6,
             -0.4, 0.4,
             -0.8, 0.8]
        joint_default_angle: 
            [0.0, 0.0, -0.1, 0.3, -0.2, 0.0,
             0.0, 0.0, -0.1, 0.3, -0.2, 0.0, 0.0,
             0.18, 0.06, 0.0, 0.78, 0.0,
             0.18, -0.06, 0.0, 0.78, 0.0]
        joint_limits: 
            [-1.0, 0.6,
             -0.6, 1.0,
             -1.57, 1.57,
             -0.2, 2.5,
             -0.6, 0.6,
             -0.5, 0.5,
             -0.6, 1.0,
             -1.0, 0.6,
             -1.57, 1.57,
             -0.2, 2.5,
             -0.6, 0.6,
             -0.5, 0.5,
             -3.14, 3.14,
             -3.14, 1.57,
             -0.25, 3.14,
             -1.57, 1.57,
             -0.6, 1.57,
             -1.57, 1.57,
             -3.14, 1.57,
             -3.14, 0.25,
             -1.57, 1.57,
             -0.6, 1.57,
             -1.57, 1.57]
        gravity_z_upper: -0.5
```


---

## FILE: raw/roboparty/configs/amp.yaml

- bytes: 1668

```yaml
inference_node:
    ros__parameters:
        model_names: ["policy_amp.onnx"]
        obs_layouts:
          - "ang_vel:3, gravity_b:3, cmd_vel:3, dof_pos:23, dof_vel:23, last_action:23"
        frame_stacks: [3]
        obs_stack_orders: ["obs_major"]
        act_alpha: 1.0
        joint_num: 23
        decimation: 5
        intra_threads: 1
        dt: 0.004
        obs_scales_lin_vel: 1.0
        obs_scales_ang_vel: 1.0
        obs_scales_dof_pos: 1.0
        obs_scales_dof_vel: 1.0
        obs_scales_gravity_b: 1.0
        clip_observations: 100.0
        action_scale: [0.25]
        clip_actions: 100.0
        usd2urdf: [0, 6, 12, 1, 7, 13, 18, 2, 8, 14, 19, 3, 9, 15, 20, 4, 10, 16, 21, 5, 11, 17, 22]
        clip_cmd: 
            [-0.5, 2.0,
             -0.6, 0.6,
             -1.57, 1.57]
        joint_default_angle: 
            [0.0, 0.0, -0.1, 0.3, -0.2, 0.0,
             0.0, 0.0, -0.1, 0.3, -0.2, 0.0, 0.0,
             0.18, 0.06, 0.0, 0.78, 0.0,
             0.18, -0.06, 0.0, 0.78, 0.0]
        joint_limits: 
            [-3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14]
        gravity_z_upper: -0.3
```


---

## FILE: raw/roboparty/configs/attn_enc.yaml

- bytes: 1725

```yaml
inference_node:
    ros__parameters:
        model_names: ["policy_attn_enc.onnx"]
        obs_layouts:
          - "ang_vel:3, gravity_b:3, cmd_vel:3, dof_pos:23, dof_vel:23, last_action:23, perception:187@0"
        frame_stacks: [5]
        obs_stack_orders: ["frame_major"]
        act_alpha: 1.0
        perception_obs_topic: "/robot_0/elevation_data"
        joint_num: 23
        decimation: 5
        intra_threads: 1
        dt: 0.004
        obs_scales_lin_vel: 1.0
        obs_scales_ang_vel: 1.0
        obs_scales_dof_pos: 1.0
        obs_scales_dof_vel: 1.0
        obs_scales_gravity_b: 1.0
        clip_observations: 100.0
        action_scale: [0.25]
        clip_actions: 100.0
        usd2urdf: [0, 6, 12, 1, 7, 13, 18, 2, 8, 14, 19, 3, 9, 15, 20, 4, 10, 16, 21, 5, 11, 17, 22]
        clip_cmd: 
            [-0.4, 0.6,
             -0.4, 0.4,
             -0.8, 0.8]
        joint_default_angle: 
            [0.0, 0.0, -0.1, 0.3, -0.2, 0.0,
             0.0, 0.0, -0.1, 0.3, -0.2, 0.0, 0.0,
             0.18, 0.06, 0.0, 0.78, 0.0,
             0.18, -0.06, 0.0, 0.78, 0.0]
        joint_limits: 
            [-1.0, 0.6,
             -0.6, 1.0,
             -1.57, 1.57,
             -0.2, 2.5,
             -0.6, 0.6,
             -0.5, 0.5,
             -0.6, 1.0,
             -1.0, 0.6,
             -1.57, 1.57,
             -0.2, 2.5,
             -0.6, 0.6,
             -0.5, 0.5,
             -3.14, 3.14,
             -3.14, 1.57,
             -0.25, 3.14,
             -1.57, 1.57,
             -0.6, 1.57,
             -1.57, 1.57,
             -3.14, 1.57,
             -3.14, 0.25,
             -1.57, 1.57,
             -0.6, 1.57,
             -1.57, 1.57]
        gravity_z_upper: -0.5
```


---

## FILE: raw/roboparty/configs/beyondmimic.yaml

- bytes: 2170

```yaml
inference_node:
    ros__parameters:
        model_names: ["policy.onnx", "policy_wave.onnx", "policy_dance0.onnx", "policy_dance1.onnx"]
        motion_names: ["", "wave.npz", "dance0.npz", "dance1.npz"]
        obs_layouts:
          - "ang_vel:3, gravity_b:3, cmd_vel:3, dof_pos:23, dof_vel:23, last_action:23"
          - "motion_pos:23, motion_vel:23, ang_vel:3, gravity_b:3, dof_pos:23, dof_vel:23, last_action:23"
          - "motion_pos:23, motion_vel:23, ang_vel:3, gravity_b:3, dof_pos:23, dof_vel:23, last_action:23"
          - "motion_pos:23, motion_vel:23, ang_vel:3, gravity_b:3, dof_pos:23, dof_vel:23, last_action:23"
        frame_stacks: [10, 1, 1, 1]
        obs_stack_orders: ["frame_major", "frame_major", "frame_major", "frame_major"]
        act_alpha: 1.0
        joint_num: 23
        decimation: 5
        intra_threads: 1
        dt: 0.004
        obs_scales_lin_vel: 1.0
        obs_scales_ang_vel: 1.0
        obs_scales_dof_pos: 1.0
        obs_scales_dof_vel: 1.0
        obs_scales_gravity_b: 1.0
        clip_observations: 100.0
        action_scale: [0.25]
        clip_actions: 100.0
        usd2urdf: [0, 6, 12, 1, 7, 13, 18, 2, 8, 14, 19, 3, 9, 15, 20, 4, 10, 16, 21, 5, 11, 17, 22]
        clip_cmd: 
            [-0.4, 0.6,
             -0.4, 0.4,
             -0.8, 0.8]
        joint_default_angle: 
            [0.0, 0.0, -0.1, 0.3, -0.2, 0.0,
             0.0, 0.0, -0.1, 0.3, -0.2, 0.0, 0.0,
             0.18, 0.06, 0.0, 0.78, 0.0,
             0.18, -0.06, 0.0, 0.78, 0.0]
        joint_limits: 
            [-3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14]
        gravity_z_upper: 1.0
```


---

## FILE: raw/roboparty/configs/getup.yaml

- bytes: 1850

```yaml
inference_node:
    ros__parameters:
        model_names: ["policy.onnx", "policy_getup.onnx"]
        motion_names: ["", "getup.npz"]
        obs_layouts:
          - "ang_vel:3, gravity_b:3, cmd_vel:3, dof_pos:23, dof_vel:23, last_action:23"
          - "motion_pos:23, motion_vel:23, ang_vel:3, gravity_b:3, dof_pos:23, dof_vel:23, last_action:23"
        frame_stacks: [10, 1]
        obs_stack_orders: ["frame_major", "frame_major"]
        act_alpha: 1.0
        joint_num: 23
        decimation: 5
        intra_threads: 1
        dt: 0.004
        obs_scales_lin_vel: 1.0
        obs_scales_ang_vel: 1.0
        obs_scales_dof_pos: 1.0
        obs_scales_dof_vel: 1.0
        obs_scales_gravity_b: 1.0
        clip_observations: 100.0
        action_scale: [0.25]
        clip_actions: 100.0
        usd2urdf: [0, 6, 12, 1, 7, 13, 18, 2, 8, 14, 19, 3, 9, 15, 20, 4, 10, 16, 21, 5, 11, 17, 22]
        clip_cmd: 
            [-0.4, 0.6,
             -0.4, 0.4,
             -0.8, 0.8]
        joint_default_angle: 
            [0.0, 0.0, -0.1, 0.3, -0.2, 0.0,
             0.0, 0.0, -0.1, 0.3, -0.2, 0.0, 0.0,
             0.18, 0.06, 0.0, 0.78, 0.0,
             0.18, -0.06, 0.0, 0.78, 0.0]
        joint_limits: 
            [-3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14]
        gravity_z_upper: 1.0
```


---

## FILE: raw/roboparty/configs/interrupt.yaml

- bytes: 1666

```yaml
inference_node:
    ros__parameters:
        model_names: ["policy_interrupt.onnx"]
        obs_layouts:
          - "ang_vel:3, gravity_b:3, cmd_vel:3, dof_pos:23, dof_vel:23, last_action:23, interrupt:1"
        frame_stacks: [10]
        obs_stack_orders: ["frame_major"]
        act_alpha: 1.0
        joint_num: 23
        decimation: 5
        intra_threads: 1
        dt: 0.004
        obs_scales_lin_vel: 1.0
        obs_scales_ang_vel: 1.0
        obs_scales_dof_pos: 1.0
        obs_scales_dof_vel: 1.0
        obs_scales_gravity_b: 1.0
        clip_observations: 100.0
        action_scale: [0.25]
        clip_actions: 100.0
        usd2urdf: [0, 6, 12, 1, 7, 13, 18, 2, 8, 14, 19, 3, 9, 15, 20, 4, 10, 16, 21, 5, 11, 17, 22]
        clip_cmd: 
            [-0.4, 0.6,
             -0.4, 0.4,
             -0.8, 0.8]
        joint_default_angle: 
            [0.0, 0.0, -0.1, 0.3, -0.2, 0.0,
             0.0, 0.0, -0.1, 0.3, -0.2, 0.0, 0.0,
             0.18, 0.06, 0.0, 0.78, 0.0,
             0.18, -0.06, 0.0, 0.78, 0.0]
        joint_limits: 
            [-1.0, 0.6,
             -0.6, 1.0,
             -1.57, 1.57,
             -0.2, 2.5,
             -0.6, 0.6,
             -0.5, 0.5,
             -0.6, 1.0,
             -1.0, 0.6,
             -1.57, 1.57,
             -0.2, 2.5,
             -0.6, 0.6,
             -0.5, 0.5,
             -3.14, 3.14,
             -3.14, 1.57,
             -0.25, 3.14,
             -1.57, 1.57,
             -0.6, 1.57,
             -1.57, 1.57,
             -3.14, 1.57,
             -3.14, 0.25,
             -1.57, 1.57,
             -0.6, 1.57,
             -1.57, 1.57]
        gravity_z_upper: -0.5
```


---

## FILE: raw/roboparty/configs/parkour.yaml

- bytes: 1753

```yaml
inference_node:
    ros__parameters:
        use_depth: true
        perception_obs_topic: "/depth_obs"
        model_names: ["policy_parkour.onnx"]
        obs_layouts:
          - "ang_vel:3, gravity_b:3, cmd_vel:3, dof_pos:23, dof_vel:23, last_action:23, perception:128@0"
        frame_stacks: [8]
        obs_stack_orders: ["obs_major"]
        act_alpha: 1.0
        joint_num: 23
        decimation: 5
        intra_threads: 1
        dt: 0.004
        obs_scales_lin_vel: 1.0
        obs_scales_ang_vel: 0.25
        obs_scales_dof_pos: 1.0
        obs_scales_dof_vel: 0.05
        obs_scales_gravity_b: 1.0
        clip_observations: 100.0
        action_scale: [0.25]
        clip_actions: 10.0
        usd2urdf: [0, 6, 12, 1, 7, 13, 18, 2, 8, 14, 19, 3, 9, 15, 20, 4, 10, 16, 21, 5, 11, 17, 22]
        clip_cmd:
            [-0.5, 0.5,
             -0.5, 0.5,
             -1.0, 1.0]
        joint_default_angle:
            [0.0, 0.0, -0.1, 0.3, -0.2, 0.0,
             0.0, 0.0, -0.1, 0.3, -0.2, 0.0, 0.0,
             0.18, 0.06, 0.0, 0.78, 0.0,
             0.18, -0.06, 0.0, 0.78, 0.0]
        joint_limits:
            [-3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14,
             -3.14, 3.14]
        gravity_z_upper: -0.5
```


---

## FILE: raw/roboparty/configs/camera_parkour.yaml

- bytes: 909

```yaml
# SPDX-License-Identifier: GPL-3.0-only
# Depth node parameters for parkour (camera package)
# RealSense topic must match configs/realsense_d435i.yaml

depth_node:
    ros__parameters:
        depth_topic: "/camera/camera/depth/image_rect_raw"
        depth_obs_topic: "/depth_obs"
        depth_process_hz: 50.0
        use_depth_encoder: true
        depth_encoder_model_name: "encoder.onnx"
        depth_encoder_output_dim: 128
        depth_history_taps: [35, 30, 25, 20, 15, 10, 5, 0]
        intra_threads: 1
        debug_vis: true
        debug_depth_vis_topic: "/debug_depth_vis"
        depth_use_bilinear: true
        depth_input_width: 480
        depth_input_height: 270
        depth_width: 64
        depth_height: 36
        depth_crop_up: 18
        depth_crop_down: 0
        depth_crop_left: 16
        depth_crop_right: 16
        depth_min_distance: 0.0
        depth_max_distance: 2.5
```


---

## FILE: raw/roboparty/scripts/motion_player.py

- bytes: 5026

```python
#!/usr/bin/env python3
import sys
import time
import logging
import argparse
import numpy as np
import robot_py

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')

class MotionLoader:
    def __init__(self, motion_file: str, logger, usd2urdf: bool = False):
        try:
            data = np.load(motion_file)
            self.joint_default_angle = np.array([0.0, 0.0, -0.1, 0.3, -0.2, 0.0, 0.0, 0.0, -0.1, 0.3, -0.2, 0.0, 0.0, 0.18, 0.06, 0.0, 0.78, 0.0, 0.18, -0.06, 0.0, 0.78, 0.0])
            self.fps = int(data['fps'].item())
            pos_usd = data['joint_pos']
            vel_usd = data['joint_vel']
            self.joint_pos = pos_usd.copy()
            self.joint_vel = vel_usd.copy()
            if usd2urdf:
                logger.info("Converting joint order from USD to URDF")
                joint_map = [0, 6, 12, 1, 7, 13, 18, 2, 8, 14, 19, 3, 9, 15, 20, 4, 10, 16, 21, 5, 11, 17, 22]
                self.joint_pos[:, joint_map] = pos_usd
                self.joint_vel[:, joint_map] = vel_usd
            self.joint_pos -= self.joint_default_angle
            
            self.num_frames = self.joint_pos.shape[0]
            self.num_joints = self.joint_pos.shape[1]
            
            logger.info(f"Loaded motion file: {motion_file}")
            logger.info(f"FPS: {self.fps}, Frames: {self.num_frames}, Joints: {self.num_joints}")
            
        except Exception as e:
            raise RuntimeError(f"Failed to load motion file: {e}")
    
    def get_pos(self, frame: int) -> np.ndarray:
        return self.joint_pos[frame]
    
    def get_vel(self, frame: int) -> np.ndarray:
        return self.joint_vel[frame]


class MotionPlayer: 
    def __init__(self, motion_file: str, config_file: str, speed: float = 1.0, usd2urdf: bool = False):
        self.logger = logging.getLogger("MotionPlayer")
        self.motion_loader = MotionLoader(motion_file, self.logger, usd2urdf)
        self.positions = [0.0] * self.motion_loader.num_joints
        
        # 初始化 RobotInterface
        try:
            self.robot = robot_py.RobotInterface(config_file)
        except Exception as e:
            raise RuntimeError(f"Failed to initialize robot interface: {e}")
        
        self.robot.init_motors()
        time.sleep(1)
        self.robot.reset_joints(self.motion_loader.joint_default_angle) 
        time.sleep(1)

        # 播放控制
        self.is_playing = False
        self.speed = min(max(0.1, speed), 1.0)
        self.logger.info(f"Playback speed: {self.speed}x")

        self.step = int(200 / (self.motion_loader.fps * self.speed))
        self.i = 0
        self.is_playing = True
        self.period = 1.0/200


    def update_frame(self, frame_idx: int):
        if frame_idx >= self.motion_loader.num_frames:
            self.logger.warning(f"Frame index {frame_idx} out of range")
            return
        positions = self.motion_loader.get_pos(frame_idx)
        self.positions = positions.tolist()
    
    def step_once(self):
        if self.is_playing:
            if self.i % self.step == 0:
                frame_idx = self.i // self.step
                if frame_idx >= self.motion_loader.num_frames:
                    self.is_playing = False
                    self.logger.info("Motion playback finished")
                    return
                self.update_frame(frame_idx)
            self.robot.apply_action(self.positions)
            self.i += 1
    
    def run(self):
        self.logger.info("Starting playback loop...")
        try:
            while self.is_playing:
                start_time = time.time()
                self.step_once()
                elapsed = time.time() - start_time
                sleep_time = max(0, self.period - elapsed)
                time.sleep(sleep_time)
        except KeyboardInterrupt:
            self.stop()
            self.logger.info("Interrupted by user")

    def stop(self):
        self.is_playing = False

def parse_args():
    parser = argparse.ArgumentParser(description='Motion Player - 播放 motion 数据并发布关节状态')
    parser.add_argument('--motion_file', type=str, required=True, help='Motion 文件路径')
    parser.add_argument('--config_file', type=str, required=True, help='Robot config 文件路径')
    parser.add_argument('--speed', type=float, default=1.0, help='播放速度倍率')
    parser.add_argument('--usd2urdf', action='store_true',  help='是否将 USD 关节顺序转换为 URDF 关节顺序，默认关闭')
    
    args = parser.parse_args()
    return args

def main():
    args = parse_args()
    try:
        player = MotionPlayer(args.motion_file, args.config_file, args.speed, args.usd2urdf)
        player.run()
    except Exception as e:
        if 'player' in locals():
            player.logger.error(f"Error: {e}")
        else:
            print(f"Error: {e}")
        return 1
    finally:
        pass
    return 0

if __name__ == '__main__':
    sys.exit(main())
```


---

## FILE: raw/roboparty/scripts/motion_player.yaml

- bytes: 1338

```yaml
motors:
    motor_id: 
        [1, 2, 3, 4, 5, 6,
         7, 8, 9, 10, 11, 12, 13,
         14, 15, 16, 17, 18,
         19, 20, 21, 22, 23]
    motor_interface_type: "can"
    motor_interface: ["can0", "can1", "can2", "can3"]
    motor_num: [6, 7, 5, 5]
    motor_type: "DM"
    motor_model: 
        [1, 1, 1, 1, 0, 0,
         1, 1, 1, 1, 0, 0, 1,
         0, 0, 0, 0, 0,
         0, 0, 0, 0, 0]
    master_id_offset: 16
    motor_zero_offset: 
        [0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
         0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
         0.0, 0.0, 0.0, 0.0, 0.0,
         0.0, 0.0, 0.0, 0.0, 0.0]

robot:
    kp: 
        [100.0, 100.0, 100.0, 150.0, 40.0, 40.0,
         100.0, 100.0, 100.0, 150.0, 40.0, 40.0, 150.0,
         40.0, 40.0, 40.0, 30.0, 20.0,
         40.0, 40.0, 40.0, 30.0, 20.0]
    kd: 
        [3.3, 3.3, 3.3, 5.0, 2.0, 2.0,
         3.3, 3.3, 3.3, 5.0, 2.0, 2.0, 5.0,
         2.0, 2.0, 2.0, 1.5, 1.0,
         2.0, 2.0, 2.0, 1.5, 1.0]
    motor_sign: 
        [1, 1, 1, 1, 1, 1,
         1, 1, -1, -1, -1, -1, 1,
         1, 1, 1, 1, 1,
         -1, 1, 1, -1, 1]
    close_chain_motor_id:
        [5, 6,
         11, 12]
    urdf2motor: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22]
    extrinsic_R: 
        [1.0, 0.0, 0.0, 
         0.0, 1.0, 0.0, 
         0.0, 0.0, 1.0]
```


---

## FILE: raw/roboparty/launch/inference.launch.py

- bytes: 2335

```python
# SPDX-License-Identifier: GPL-3.0
# Copyright (C) 2025-2026 Luo1imasi

##launch file
from launch import LaunchDescription
from launch.actions import DeclareLaunchArgument, OpaqueFunction
from launch.substitutions import LaunchConfiguration
from launch_ros.actions import Node
from ament_index_python.packages import get_package_share_directory
import os
import re

NAME_PATTERN = re.compile(r"^[A-Za-z0-9][A-Za-z0-9_.-]*$")

def launch_setup(context, *args, **kwargs):
    robot = LaunchConfiguration("robot").perform(context)
    policy = LaunchConfiguration("policy").perform(context)
    if not NAME_PATTERN.fullmatch(robot):
        raise ValueError(f"Invalid robot name: {robot}")
    if not NAME_PATTERN.fullmatch(policy):
        raise ValueError(f"Invalid policy name: {policy}")

    policy_file = policy if policy.endswith(".yaml") else f"{policy}.yaml"

    robot_dir = os.path.join(
        get_package_share_directory("roboparty_inference"),
        "robots",
        robot,
    )
    robot_config = os.path.join(robot_dir, "robot.yaml")
    policy_config = os.path.join(robot_dir, "configs", policy_file)

    if not os.path.isfile(robot_config):
        raise FileNotFoundError(f"Robot config not found: {robot_config}")
    if not os.path.isfile(policy_config):
        raise FileNotFoundError(f"Inference config not found: {policy_config}")

    return [
        Node(
            package="roboparty_inference",
            executable="inference_node",
            name="inference_node",
            parameters=[
                policy_config,
                {
                    "robot_name": robot,
                    "policy_name": policy,
                    "robot_config": robot_config,
                    "model_dir": os.path.join(robot_dir, "models"),
                    "motion_dir": os.path.join(robot_dir, "motions"),
                    "latent_dir": os.path.join(robot_dir, "latents"),
                },
            ],
            output="screen",
            # prefix=["xterm -e gdb -ex run --args"],
        ),
    ]


def generate_launch_description():
    return LaunchDescription(
        [
            DeclareLaunchArgument("robot", default_value="rpo"),
            DeclareLaunchArgument("policy", default_value="default"),
            OpaqueFunction(function=launch_setup),
        ]
    )
```


---

## FILE: raw/roboparty/tools/start_robot.sh

- bytes: 9143

```bash
#!/bin/bash

# 颜色定义，用于美化输出
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # 无颜色

# 函数：打印成功消息
print_success() {
    echo -e "${GREEN}$1${NC}"
}

# 函数：打印提示消息
print_info() {
    echo -e "${YELLOW}$1${NC}"
}

# 函数：打印错误消息
print_error() {
    echo -e "${RED}$1${NC}"
}

show_usage() {
    echo "用法: $0 [--robot ROBOT] [--policy POLICY]"
    echo "      $0 [ROBOT] [POLICY]"
    echo
    echo "默认: robot=rpo, policy=default"
    echo "示例: $0 --robot rpo --policy amp"
    echo "示例: $0 rpo beyondmimic"
}

validate_name() {
    local label=$1
    local value=$2

    if [[ ! "$value" =~ ^[A-Za-z0-9][A-Za-z0-9_.-]*$ ]]; then
        print_error "$label 必须以字母或数字开头，且只能包含字母、数字、下划线、短横线和点: $value"
        exit 1
    fi
}

ROBOT="rpo"
POLICY="default"
ROBOT_SET=0
POLICY_SET=0

while [ $# -gt 0 ]; do
    case "$1" in
        --robot|-r)
            if [ $# -lt 2 ]; then
                print_error "缺少 --robot 参数值"
                show_usage
                exit 1
            fi
            ROBOT="$2"
            ROBOT_SET=1
            shift 2
            ;;
        --policy|-p)
            if [ $# -lt 2 ]; then
                print_error "缺少 --policy 参数值"
                show_usage
                exit 1
            fi
            POLICY="$2"
            POLICY_SET=1
            shift 2
            ;;
        --help|-h)
            show_usage
            exit 0
            ;;
        *)
            if [ "$ROBOT_SET" -eq 0 ]; then
                ROBOT="$1"
                ROBOT_SET=1
            elif [ "$POLICY_SET" -eq 0 ]; then
                POLICY="$1"
                POLICY_SET=1
            else
                print_error "未知参数: $1"
                show_usage
                exit 1
            fi
            shift
            ;;
    esac
done

validate_name "robot" "$ROBOT"
validate_name "policy" "$POLICY"

# 函数：启动组件并检查（先启动ROS节点，再设置实时优先级）
start_component() {
    local session_name=$1
    local launch_cmd=$2
    local node_name=$3
    local sleep_time=$4

    print_info "启动 $session_name ..."
    # 在screen会话中启动ROS命令，并确保传递DDS配置环境变量
    screen -dmS $session_name bash -c "source install/setup.bash; export RMW_IMPLEMENTATION='$RMW_IMPLEMENTATION'; export RMW_FASTRTPS_USE_QOS_FROM_XML='$RMW_FASTRTPS_USE_QOS_FROM_XML'; export FASTRTPS_DEFAULT_PROFILES_FILE='$FASTRTPS_DEFAULT_PROFILES_FILE'; $launch_cmd; exec bash"
    sleep $sleep_time

    if ! ros2 node list | grep -q "$node_name"; then
        print_error "$session_name 启动失败！未检测到 $node_name 节点。"
        cleanup_sessions
        exit 1
    fi
}

# 函数：清理所有会话
cleanup_sessions() {
    screen -S inference_session -X quit 2>/dev/null
    screen -S joy_session -X quit 2>/dev/null
}

# 函数：详细验证 DDS 配置是否生效
verify_dds_effectiveness() {
    print_info "详细验证 DDS 配置是否生效..."
    sleep 2
    
    # 1. 检查环境变量
    print_info "检查环境变量..."
    echo "RMW_IMPLEMENTATION: $RMW_IMPLEMENTATION"
    echo "FASTRTPS_DEFAULT_PROFILES_FILE: $FASTRTPS_DEFAULT_PROFILES_FILE"
    
    # 2. 验证配置文件是否被读取
    print_info "验证配置文件读取..."
    if [ -f "$FASTRTPS_DEFAULT_PROFILES_FILE" ]; then
        print_success "配置文件存在"
        
        # 检查XML语法
        if command -v xmllint &> /dev/null; then
            if xmllint --noout "$FASTRTPS_DEFAULT_PROFILES_FILE" 2>/dev/null; then
                print_success "XML 格式正确"
            else
                print_error "XML 格式错误"
                xmllint "$FASTRTPS_DEFAULT_PROFILES_FILE"
                return 1
            fi
        fi
    else
        print_error "配置文件不存在: $FASTRTPS_DEFAULT_PROFILES_FILE"
        return 1
    fi
    
    # 3. 检查进程是否使用了 Fast DDS
    print_info "检查进程 DDS 实现..."
    for node in "inference_node" "joy_node"; do
        local pid=$(pgrep -x "$node" 2>/dev/null)
        if [ -n "$pid" ]; then
            # 检查进程环境变量
            local env_file="/proc/$pid/environ"
            if [ -f "$env_file" ]; then
                if grep -z "FASTRTPS_DEFAULT_PROFILES_FILE" "$env_file" >/dev/null 2>&1; then
                    print_success "$node 环境变量设置正确"
                else
                    print_error "$node 缺少 FASTRTPS_DEFAULT_PROFILES_FILE 环境变量"
                fi
                
                if grep -z "RMW_IMPLEMENTATION=rmw_fastrtps_cpp" "$env_file" >/dev/null 2>&1; then
                    print_success "$node RMW 实现正确"
                else
                    print_error "$node RMW 实现不正确"
                fi
            fi
        fi
    done
    
    # 4. 检查共享内存传输
    print_info "检查共享内存传输..."
    local shm_files=$(ls /dev/shm/ 2>/dev/null | grep -E "(fastrtps|fast_dds|rmw)" | wc -l)
    if [ "$shm_files" -gt 0 ]; then
        print_success "共享内存传输活跃 ($shm_files 个文件)"
    else
        print_error "共享内存传输未检测到"
    fi
    
    # 5. 测试 DDS 发现性能
    print_info "测试 DDS 发现性能..."
    local start_time=$(date +%s%3N)
    ros2 node list >/dev/null 2>&1
    local end_time=$(date +%s%3N)
    local discovery_time=$((end_time - start_time))
    
    if [ "$discovery_time" -lt 500 ]; then
        print_success "DDS 发现延迟: ${discovery_time}ms (优秀)"
    elif [ "$discovery_time" -lt 1000 ]; then
        print_info "DDS 发现延迟: ${discovery_time}ms (良好)"
    else
        print_error "DDS 发现延迟: ${discovery_time}ms (较慢)"
    fi
}

# 切换到脚本目录
cd "$(dirname "$0")"
cd ..

POLICY_FILE="$POLICY"
if [[ "$POLICY_FILE" != *.yaml ]]; then
    POLICY_FILE="${POLICY_FILE}.yaml"
fi

ROBOT_DIR="src/inference/robots/$ROBOT"
if [ ! -f "$ROBOT_DIR/robot.yaml" ]; then
    print_error "机器人配置不存在: $ROBOT_DIR/robot.yaml"
    exit 1
fi
if [ ! -f "$ROBOT_DIR/configs/$POLICY_FILE" ]; then
    print_error "推理配置不存在: $ROBOT_DIR/configs/$POLICY_FILE"
    exit 1
fi

print_info "选择机器人: $ROBOT"
print_info "选择策略: $POLICY"

# 设置 DDS 配置文件
export RMW_IMPLEMENTATION=rmw_fastrtps_cpp
export RMW_FASTRTPS_USE_QOS_FROM_XML=1
export FASTRTPS_DEFAULT_PROFILES_FILE="$(pwd)/assets/rt_fastdds_profile.xml"
print_info "设置 DDS 配置文件: $FASTRTPS_DEFAULT_PROFILES_FILE"

# 检查 DDS 配置文件是否存在
if [ ! -f "$FASTRTPS_DEFAULT_PROFILES_FILE" ]; then
    print_error "DDS 配置文件不存在: $FASTRTPS_DEFAULT_PROFILES_FILE"
    exit 1
fi

# 检查是否已source setup文件
if [ -z "$AMENT_PREFIX_PATH" ]; then
    print_info "未检测到ROS 2环境，正在执行source..."
    source /opt/ros/humble/setup.bash || {
        print_error "无法source /opt/ros/humble/setup.bash，请检查路径是否正确"
        exit 1
    }
fi

# 检查 colcon 和 ros2
if ! command -v colcon &> /dev/null; then
    print_error "colcon 未安装，请安装 ROS 2 开发工具"
    exit 1
fi
if ! command -v ros2 &> /dev/null; then
    print_error "ros2 未安装"
    exit 1
fi

# 检查是否已安装screen
if ! command -v screen &> /dev/null; then
    print_error "screen 未安装"
    exit 1
fi

# 编译推理包
print_info "编译推理包..."
colcon build --symlink-install || {
    print_error "推理包编译失败"
    exit 1
}
source install/setup.bash

# 停止可能正在运行的screen会话
print_info "停止现有相关screen会话..."
cleanup_sessions

start_component "inference_session" "ros2 launch roboparty_inference inference.launch.py robot:=$ROBOT policy:=$POLICY" "inference_node" 5
start_component "joy_session" "ros2 run joy joy_node" "joy_node" 2

# 验证节点的 DDS 配置
verify_dds_effectiveness

# 所有组件启动完成
print_success "----------------------------------------"
print_success "所有组件已在后台成功启动！"
print_success "使用以下命令查看各组件输出："
print_success "推理模块: screen -r inference_session"
print_success "手柄控制: screen -r joy_session"
print_success "----------------------------------------"
print_info "若要退出某个screen会话，按Ctrl+A然后按D"
print_info "使用以下命令停止所有组件："
print_info "screen -S inference_session -X quit"
print_info "screen -S joy_session -X quit"
print_success "----------------------------------------"
print_info "手柄控制说明:"
print_info "X键: 使能/失能电机"
print_info "A键: 复位电机"
print_info "B键: 开始/暂停推理"
print_info "Y键: 切换手柄控制/cmd_vel指令控制"
print_info "LB键: 切换策略模式(在beyondmimic/interrupt模式下可用)"
print_info "RB键: 切换运动序列(在beyondmimic模式下可用)"
print_info "右摇杆: 控制前后左右移动"
print_info "LT/RT: 控制转向(左/右旋转)"
```


---

## FILE: raw/roboparty/src/inference_node.hpp

- bytes: 16832

```cpp
// SPDX-License-Identifier: GPL-3.0
// Copyright (C) 2025-2026 Luo1imasi

#pragma once

#include <sys/mman.h>
#include <onnxruntime_cxx_api.h>
#include <string>
#include <vector>
#include <mutex>
#include <atomic>
#include <condition_variable>
#include <algorithm>
#include <memory>
#include <stdexcept>
#include <Eigen/Geometry>
#include <cmath>
#include <chrono>
#include <filesystem>
#include <iostream>
#include <queue>
#include <sstream>
#include <thread>
#include <rclcpp/rclcpp.hpp>
#include <sensor_msgs/msg/imu.hpp>
#include <sensor_msgs/msg/joint_state.hpp>
#include <sensor_msgs/msg/joy.hpp>
#include <geometry_msgs/msg/twist.hpp>
#include <std_msgs/msg/float32_multi_array.hpp> 
#include "utils/motion_loader.hpp"
#include "utils/latent_loader.hpp"
#include <std_srvs/srv/trigger.hpp>
#include "robot_interface.hpp"

enum class ObsStackOrder {
    FrameMajor,
    ObsMajor,
};

class InferenceNode;

struct ObsSourceDefinition {
    const char* name;
    void (InferenceNode::*get)(std::vector<float>& segment);
};

struct ObsSourceSpec {
    std::string name;
    const ObsSourceDefinition* source;
    int size;
    // Empty keeps legacy contiguous stacking; otherwise values are explicit inference-tick lags.
    std::vector<int> history_taps;
};

struct ObsHistorySlice {
    size_t history_offset;
    size_t size;
};

class InferenceNode : public rclcpp::Node {
   public:
    struct ModelContext {
        std::unique_ptr<Ort::Session> session;
        std::unique_ptr<Ort::MemoryInfo> memory_info;
        std::unique_ptr<Ort::Value> input_tensor;
        std::unique_ptr<Ort::Value> output_tensor;
        std::vector<std::string> input_names;
        std::vector<std::string> output_names;
        std::vector<const char *> input_names_raw;
        std::vector<const char *> output_names_raw;
        std::vector<int64_t> input_shape;
        std::vector<int64_t> output_shape;
        std::vector<float> input_buffer;
        std::vector<float> output_buffer;
        size_t num_inputs;
        size_t num_outputs;
    };

    struct PolicyRuntime {
        std::string name;
        std::string model_path;
        std::string motion_path;
        std::vector<ObsSourceSpec> obs_layout;
        std::vector<int> obs_layout_sizes;
        std::vector<std::vector<float>> obs_segments;
        std::vector<float> obs;
        // Sparse mode only: complete frames ordered from oldest to newest.
        std::vector<float> obs_history;
        // Non-empty selects sparse mode and describes sequential copies into the model input.
        std::vector<ObsHistorySlice> history_gather_plan;
        int obs_num = 0;
        int obs_input_num = 0;
        int frame_stack = 1;
        ObsStackOrder stack_order = ObsStackOrder::FrameMajor;
        std::unique_ptr<ModelContext> ctx;
        std::shared_ptr<MotionLoader> motion_loader;
        std::unique_ptr<LatentLoader> latent_loader;
        size_t motion_frame = 0;
        bool is_first_frame = true;
    };

    InferenceNode() : Node("inference_node") {
        load_config();

        robot_ = std::make_shared<RobotInterface>(robot_config_path_);

        Ort::ThreadingOptions thread_opts;
        if (intra_threads_ > 0) {
            thread_opts.SetGlobalIntraOpNumThreads(intra_threads_);
        }
        env_ = std::make_unique<Ort::Env>(thread_opts, ORT_LOGGING_LEVEL_WARNING, "ONNXRuntimeInference");
        if (policies_.empty()) {
            throw std::runtime_error("At least one policy must be configured");
        }
        for (size_t i = 0; i < policies_.size(); i++) {
            PolicyRuntime& policy = policies_[i];
            policy.obs.resize(policy.obs_num, 0.0f);
            policy.obs_segments.resize(policy.obs_layout.size());
            for (size_t j = 0; j < policy.obs_layout.size(); j++) {
                policy.obs_segments[j].resize(policy.obs_layout[j].size, 0.0f);
            }
            if (!policy.history_gather_plan.empty()) {
                policy.obs_history.resize(
                    static_cast<size_t>(policy.obs_num) * static_cast<size_t>(policy.frame_stack),
                    0.0f);
            }
            if (!policy.motion_path.empty()) {
                policy.motion_loader = std::make_shared<MotionLoader>(policy.motion_path);
                if (policy.motion_loader->get_num_frames() == 0) {
                    throw std::runtime_error("Motion file has no frames: " + policy.motion_path);
                }
                if (policy.motion_loader->get_num_joints() != static_cast<size_t>(joint_num_)) {
                    throw std::runtime_error("Motion joint count mismatch: " + policy.motion_path);
                }
            }
            setup_model(policy.ctx, policy.model_path, policy.obs_input_num);
        }
        initialize_runtime_state();
        reset_runtime_state();

        auto data_qos = rclcpp::QoS(rclcpp::KeepLast(1)).best_effort().durability_volatile();
        joy_subscription_ = this->create_subscription<sensor_msgs::msg::Joy>(
            "/joy", data_qos, std::bind(&InferenceNode::subs_joy_callback, this, std::placeholders::_1));
        cmd_subscription_ = this->create_subscription<geometry_msgs::msg::Twist>(
            "/cmd_vel", data_qos, std::bind(&InferenceNode::subs_cmd_callback,this, std::placeholders::_1
        ));
        if (has_obs_source("perception")) {
            perception_subscription_ = this->create_subscription<std_msgs::msg::Float32MultiArray>(
                perception_obs_topic_, data_qos,
                std::bind(&InferenceNode::subs_perception_callback, this, std::placeholders::_1));
        }
        if (use_depth_) {
            clear_depth_history_client_ =
                this->create_client<std_srvs::srv::Trigger>("clear_depth_history");
        }
        joint_state_subscription_ = this->create_subscription<sensor_msgs::msg::JointState>(
            "/joint_ref_states", data_qos,
            std::bind(&InferenceNode::subs_joint_state_callback, this, std::placeholders::_1));
        action_publisher_ =
            this->create_publisher<sensor_msgs::msg::JointState>("/action", data_qos);
        imu_publisher_ =
            this->create_publisher<sensor_msgs::msg::Imu>("/imu", data_qos);
        joint_state_publisher_ =
            this->create_publisher<sensor_msgs::msg::JointState>("/joint_states", data_qos);
        inference_thread_ = std::thread(&InferenceNode::inference, this);
        control_thread_ = std::thread(&InferenceNode::control, this);

        reset_joints_service_ = this->create_service<std_srvs::srv::Trigger>(
            "reset_joints", std::bind(&InferenceNode::reset_joints_srv, this, std::placeholders::_1, std::placeholders::_2));
        set_zeros_service_ = this->create_service<std_srvs::srv::Trigger>(
            "set_zeros", std::bind(&InferenceNode::set_zeros_srv, this, std::placeholders::_1, std::placeholders::_2));
        clear_errors_service_ = this->create_service<std_srvs::srv::Trigger>(
            "clear_errors", std::bind(&InferenceNode::clear_errors_srv, this, std::placeholders::_1, std::placeholders::_2));
        refresh_joints_service_ = this->create_service<std_srvs::srv::Trigger>(
            "refresh_joints", std::bind(&InferenceNode::refresh_joints_srv, this, std::placeholders::_1, std::placeholders::_2));
        read_joints_service_ = this->create_service<std_srvs::srv::Trigger>(
            "read_joints", std::bind(&InferenceNode::read_joints_srv, this, std::placeholders::_1, std::placeholders::_2));
        read_imu_service_ = this->create_service<std_srvs::srv::Trigger>(
            "read_imu", std::bind(&InferenceNode::read_imu_srv, this, std::placeholders::_1, std::placeholders::_2));
        init_motors_service_ = this->create_service<std_srvs::srv::Trigger>(
            "init_motors", std::bind(&InferenceNode::init_motors_srv, this, std::placeholders::_1, std::placeholders::_2));
        deinit_motors_service_ = this->create_service<std_srvs::srv::Trigger>(
            "deinit_motors", std::bind(&InferenceNode::deinit_motors_srv, this, std::placeholders::_1, std::placeholders::_2));
        start_inference_service_ = this->create_service<std_srvs::srv::Trigger>(
            "start_inference", std::bind(&InferenceNode::start_inference_srv, this, std::placeholders::_1, std::placeholders::_2));
        stop_inference_service_ = this->create_service<std_srvs::srv::Trigger>(
            "stop_inference", std::bind(&InferenceNode::stop_inference_srv, this, std::placeholders::_1, std::placeholders::_2));
    }
    ~InferenceNode() {
        is_running_.store(false);
        if (reset_thread_.joinable()) {
            reset_thread_.join();
        }
        if (inference_thread_.joinable()) {
            inference_thread_.join();
        }
        if (control_thread_.joinable()) {
            control_thread_.join();
        }
        reset_runtime_state();
        if (robot_) {
            robot_.reset();
        }
    }
    bool supports_interrupt() const;
    bool has_motion_policy() const;
   private:
    std::shared_ptr<RobotInterface> robot_;
    std::atomic<bool> is_running_{false}, is_joy_control_{true}, is_interrupt_{false}, is_motion_policy_{false};
    std::string robot_config_path_;
    std::string perception_obs_topic_;
    size_t current_motion_policy_idx_ = 0;
    int active_policy_idx_ = 0;
    int perception_obs_num_, joint_num_;
    bool use_depth_ = false;
    int decimation_;
    std::unique_ptr<Ort::Env> env_;
    int intra_threads_;
    Ort::AllocatorWithDefaultOptions allocator_;
    rclcpp::Subscription<sensor_msgs::msg::Joy>::SharedPtr joy_subscription_;
    rclcpp::Subscription<geometry_msgs::msg::Twist>::SharedPtr cmd_subscription_;
    rclcpp::Subscription<std_msgs::msg::Float32MultiArray>::SharedPtr perception_subscription_;
    rclcpp::Subscription<sensor_msgs::msg::JointState>::SharedPtr joint_state_subscription_;
    rclcpp::Publisher<sensor_msgs::msg::JointState>::SharedPtr action_publisher_;
    rclcpp::Publisher<sensor_msgs::msg::Imu>::SharedPtr imu_publisher_;
    rclcpp::Publisher<sensor_msgs::msg::JointState>::SharedPtr joint_state_publisher_;
    rclcpp::Client<std_srvs::srv::Trigger>::SharedPtr clear_depth_history_client_;
    std::thread inference_thread_;
    std::thread control_thread_;
    std::thread reset_thread_;
    std::mutex reset_thread_mutex_;
    bool reset_thread_running_ = false;
    float act_alpha_;
    float dt_;
    float obs_scales_lin_vel_, obs_scales_ang_vel_, obs_scales_dof_pos_, obs_scales_dof_vel_,
        obs_scales_gravity_b_, clip_observations_;
    float clip_actions_;
    float action_rescale_ = 1.0f;
    std::vector<double> action_scale_, clip_cmd_, joint_default_angle_, joint_limits_;
    std::vector<long int> usd2urdf_;
    float gravity_z_upper_;
    int last_button0_ = 0, last_button1_ = 0, last_button2_ = 0, last_button3_ = 0, last_button4_ = 0, last_button5_ = 0;
    std::vector<PolicyRuntime> policies_;
    std::vector<int> motion_policy_indices_;
    rclcpp::Service<std_srvs::srv::Trigger>::SharedPtr reset_joints_service_, set_zeros_service_, clear_errors_service_, refresh_joints_service_, read_joints_service_, read_imu_service_, init_motors_service_, deinit_motors_service_, start_inference_service_, stop_inference_service_;

    std::mutex act_mutex_, perception_mutex_, interrupt_mutex_, cmd_mutex_, mode_mutex_, control_mutex_, lb_switch_mutex_;
    std::vector<float> act_, last_act_, cmd_vel_, interrupt_action_, perception_obs_buffer_;
    std::vector<float> joint_pos_buffer_, joint_vel_buffer_, joint_torques_buffer_, quat_buffer_, ang_vel_buffer_;
    sensor_msgs::msg::JointState joint_state_msg_, action_msg_;

    void subs_joy_callback(const std::shared_ptr<sensor_msgs::msg::Joy> msg);
    void subs_cmd_callback(const std::shared_ptr<geometry_msgs::msg::Twist> msg);
    void subs_perception_callback(const std::shared_ptr<std_msgs::msg::Float32MultiArray> msg);
    void subs_joint_state_callback(const std::shared_ptr<sensor_msgs::msg::JointState> msg);
    void inference();
    void control();
    void apply_action();
    bool start_joint_reset();
    PolicyRuntime& active_policy();

    void load_config();
    void setup_model(std::unique_ptr<ModelContext>& ctx, std::string model_path, int input_size);

    // Policy/model runtime helpers.
    void initialize_runtime_state();
    void reset_runtime_state();
    void request_depth_history_reset();
    void reset_policy_runtime(PolicyRuntime& policy);
    void step_motion_frame();

    // Observation registry and layout helpers.
    static const std::vector<ObsSourceDefinition>& obs_source_definitions();
    std::vector<ObsSourceSpec> parse_obs_layout(const std::string& layout_spec,
                                                const std::string& layout_name);
    bool has_obs_source(const std::string& source_name) const;
    ObsStackOrder parse_obs_stack_order(const std::string& stack_order_name);

    // Observation runtime helpers.
    void update_obs_segments(std::vector<std::vector<float>>& segments,
                             const std::vector<ObsSourceSpec>& layout);
    void flatten_obs_segments(const std::vector<std::vector<float>>& segments,
                              std::vector<float>::iterator output_begin);
    void update_obs_history(std::vector<float>& history, const std::vector<float>& obs,
                            int obs_num, int frame_stack, bool is_first_frame);
    void update_stacked_obs(std::vector<float>& input_buffer, const std::vector<float>& obs,
                            int obs_num, int frame_stack, ObsStackOrder stack_order,
                            const std::vector<int>& field_sizes, bool is_first_frame);
    void gather_sparse_obs_history(std::vector<float>& input_buffer,
                                   const std::vector<float>& obs_history,
                                   const std::vector<ObsHistorySlice>& gather_plan);

    // Observation getters.
    void get_cmd_vel_obs(std::vector<float>& segment);
    void get_ang_vel_obs(std::vector<float>& segment);
    void get_gravity_b_obs(std::vector<float>& segment);
    void get_dof_pos_obs(std::vector<float>& segment);
    void get_dof_vel_obs(std::vector<float>& segment);
    void get_last_action_obs(std::vector<float>& segment);
    void get_interrupt_obs(std::vector<float>& segment);
    void get_perception_obs(std::vector<float>& segment);
    void get_motion_pos_obs(std::vector<float>& segment);
    void get_motion_vel_obs(std::vector<float>& segment);
    void get_latent_obs(std::vector<float>& segment);

    void init_motors_srv(const std::shared_ptr<std_srvs::srv::Trigger::Request> request,
                         std::shared_ptr<std_srvs::srv::Trigger::Response> response);
    void deinit_motors_srv(const std::shared_ptr<std_srvs::srv::Trigger::Request> request,
                           std::shared_ptr<std_srvs::srv::Trigger::Response> response);
    void reset_joints_srv(const std::shared_ptr<std_srvs::srv::Trigger::Request> request,
                          std::shared_ptr<std_srvs::srv::Trigger::Response> response);
    void set_zeros_srv(const std::shared_ptr<std_srvs::srv::Trigger::Request> request,
                       std::shared_ptr<std_srvs::srv::Trigger::Response> response);
    void clear_errors_srv(const std::shared_ptr<std_srvs::srv::Trigger::Request> request,
                          std::shared_ptr<std_srvs::srv::Trigger::Response> response);
    void refresh_joints_srv(const std::shared_ptr<std_srvs::srv::Trigger::Request> request,
                            std::shared_ptr<std_srvs::srv::Trigger::Response> response);
    void read_joints_srv(const std::shared_ptr<std_srvs::srv::Trigger::Request> request,
                         std::shared_ptr<std_srvs::srv::Trigger::Response> response);
    void read_imu_srv(const std::shared_ptr<std_srvs::srv::Trigger::Request> request,
                      std::shared_ptr<std_srvs::srv::Trigger::Response> response);
    void start_inference_srv(const std::shared_ptr<std_srvs::srv::Trigger::Request> request,
                             std::shared_ptr<std_srvs::srv::Trigger::Response> response);
    void stop_inference_srv(const std::shared_ptr<std_srvs::srv::Trigger::Request> request,
                            std::shared_ptr<std_srvs::srv::Trigger::Response> response);
    void publish_joint_states();
    void publish_action();
    void publish_imu();
    
    template <typename T>
    void print_vector(const std::string& name, const std::vector<T>& vec) {
        std::stringstream ss;
        ss << name << ": [";
        for (size_t i = 0; i < vec.size(); ++i) {
            ss << vec[i] << (i == vec.size() - 1 ? "" : ", ");
        }
        ss << "]";
        RCLCPP_INFO(this->get_logger(), "%s", ss.str().c_str());
    }
};
```


---

## FILE: raw/roboparty/src/inference_node.cpp

- bytes: 19488

```cpp
// SPDX-License-Identifier: GPL-3.0
// Copyright (C) 2025-2026 Luo1imasi

#include "inference_node.hpp"

void InferenceNode::update_obs_history(std::vector<float>& history,
                                       const std::vector<float>& obs,
                                       int obs_num, int frame_stack,
                                       bool is_first_frame) {
    if (is_first_frame) {
        for (int frame = 0; frame < frame_stack; frame++) {
            std::copy(obs.begin(), obs.end(), history.begin() + frame * obs_num);
        }
        return;
    }
    std::move(history.begin() + obs_num,
              history.begin() + frame_stack * obs_num,
              history.begin());
    std::copy(obs.begin(), obs.end(), history.begin() + (frame_stack - 1) * obs_num);
}

ObsStackOrder InferenceNode::parse_obs_stack_order(const std::string& stack_order_name) {
    if (stack_order_name == "frame_major") {
        return ObsStackOrder::FrameMajor;
    }
    if (stack_order_name == "obs_major") {
        return ObsStackOrder::ObsMajor;
    }
    throw std::runtime_error("Unsupported obs stack order: " + stack_order_name);
}

void InferenceNode::update_stacked_obs(std::vector<float>& input_buffer, const std::vector<float>& obs,
                                       int obs_num, int frame_stack, ObsStackOrder stack_order,
                                       const std::vector<int>& field_sizes, bool is_first_frame) {
    if (stack_order == ObsStackOrder::FrameMajor) {
        update_obs_history(input_buffer, obs, obs_num, frame_stack, is_first_frame);
        return;
    }

    int input_offset = 0;
    int obs_offset = 0;

    for (const int field_size : field_sizes) {
        if (is_first_frame) {
            for (int frame = 0; frame < frame_stack; frame++) {
                std::copy(obs.begin() + obs_offset, obs.begin() + obs_offset + field_size,
                          input_buffer.begin() + input_offset + frame * field_size);
            }
        } else {
            std::move(input_buffer.begin() + input_offset + field_size,
                      input_buffer.begin() + input_offset + frame_stack * field_size,
                      input_buffer.begin() + input_offset);
            std::copy(obs.begin() + obs_offset, obs.begin() + obs_offset + field_size,
                      input_buffer.begin() + input_offset + (frame_stack - 1) * field_size);
        }
        input_offset += field_size * frame_stack;
        obs_offset += field_size;
    }
}

void InferenceNode::gather_sparse_obs_history(
    std::vector<float>& input_buffer,
    const std::vector<float>& obs_history,
    const std::vector<ObsHistorySlice>& gather_plan) {
    auto output = input_buffer.begin();
    for (const ObsHistorySlice& slice : gather_plan) {
        output = std::copy_n(
            obs_history.begin() + slice.history_offset, slice.size, output);
    }
}

void InferenceNode::setup_model(std::unique_ptr<ModelContext>& ctx, std::string model_path, int input_size) {
    if (!ctx) {
        ctx = std::make_unique<ModelContext>();
    }

    Ort::SessionOptions session_options;
    session_options.DisablePerSessionThreads();
    session_options.EnableCpuMemArena();
    session_options.EnableMemPattern();
    session_options.SetGraphOptimizationLevel(GraphOptimizationLevel::ORT_ENABLE_ALL);
    
    ctx->session = std::make_unique<Ort::Session>(*env_, model_path.c_str(), session_options);
    
    ctx->num_inputs = ctx->session->GetInputCount();
    if (ctx->num_inputs != 1) {
        throw std::runtime_error("Only single-input ONNX models are supported: " + model_path);
    }
    ctx->input_names.resize(ctx->num_inputs);

    for (size_t i = 0; i < ctx->num_inputs; i++) {
        Ort::AllocatedStringPtr input_name = ctx->session->GetInputNameAllocated(i, allocator_);
        ctx->input_names[i] = input_name.get();
        auto type_info = ctx->session->GetInputTypeInfo(i);
        ctx->input_shape = type_info.GetTensorTypeAndShapeInfo().GetShape();
        if (ctx->input_shape[0] == -1) ctx->input_shape[0] = 1;
    }

    size_t model_input_size = 1;
    for (size_t i = 0; i < ctx->input_shape.size(); i++) {
        model_input_size *= static_cast<size_t>(ctx->input_shape[i]);
    }
    if (model_input_size != static_cast<size_t>(input_size)) {
        throw std::runtime_error(
            "ONNX input size mismatch for " + model_path + ": model expects " +
            std::to_string(model_input_size) + " values, but config provides " + std::to_string(input_size));
    }
    ctx->input_buffer.resize(input_size);

    ctx->num_outputs = ctx->session->GetOutputCount();
    ctx->output_names.resize(ctx->num_outputs);
    ctx->output_buffer.resize(joint_num_);

    for (size_t i = 0; i < ctx->num_outputs; i++) {
        Ort::AllocatedStringPtr output_name = ctx->session->GetOutputNameAllocated(i, allocator_);
        ctx->output_names[i] = output_name.get();
        auto type_info = ctx->session->GetOutputTypeInfo(i);
        ctx->output_shape = type_info.GetTensorTypeAndShapeInfo().GetShape();
        if (ctx->output_shape[0] == -1) ctx->output_shape[0] = 1;
        if (ctx->output_shape[1] == -1) ctx->output_shape[1] = joint_num_;
    }

    ctx->input_names_raw = std::vector<const char *>(ctx->num_inputs, nullptr);
    ctx->output_names_raw = std::vector<const char *>(ctx->num_outputs, nullptr);
    for (size_t i = 0; i < ctx->num_inputs; i++) {
        ctx->input_names_raw[i] = ctx->input_names[i].c_str();
    }
    for (size_t i = 0; i < ctx->num_outputs; i++) {
        ctx->output_names_raw[i] = ctx->output_names[i].c_str();
    }

    ctx->memory_info = std::make_unique<Ort::MemoryInfo>(Ort::MemoryInfo::CreateCpu(OrtDeviceAllocator, OrtMemTypeCPU));
    
    ctx->input_tensor = std::make_unique<Ort::Value>(Ort::Value::CreateTensor<float>(
        *ctx->memory_info, ctx->input_buffer.data(), ctx->input_buffer.size(), ctx->input_shape.data(), ctx->input_shape.size()));
        
    ctx->output_tensor = std::make_unique<Ort::Value>(Ort::Value::CreateTensor<float>(
        *ctx->memory_info, ctx->output_buffer.data(), ctx->output_buffer.size(), ctx->output_shape.data(), ctx->output_shape.size()));
}

void InferenceNode::reset_runtime_state() {
    is_running_.store(false);
    std::unique_lock<std::mutex> mode_lock(mode_mutex_);
    std::unique_lock<std::mutex> control_lock(control_mutex_);
    is_interrupt_.store(false);
    is_motion_policy_.store(false);
    active_policy_idx_ = 0;
    {
        std::unique_lock<std::mutex> lock(cmd_mutex_);
        std::fill(cmd_vel_.begin(), cmd_vel_.end(), 0.0f);
    }
    {
        std::unique_lock<std::mutex> lock(perception_mutex_);
        std::fill(perception_obs_buffer_.begin(), perception_obs_buffer_.end(), 0.0f);
    }
    {
        std::unique_lock<std::mutex> lock(act_mutex_);
        for (int i = 0; i < joint_num_; i++) {
            act_[i] = static_cast<float>(joint_default_angle_[i]);
            last_act_[i] = static_cast<float>(joint_default_angle_[i]);
        }
    }
    if (supports_interrupt()) {
        if (joint_default_angle_.size() < interrupt_action_.size()) {
            throw std::runtime_error("joint_default_angle is smaller than interrupt_action");
        }
        std::unique_lock<std::mutex> lock(interrupt_mutex_);
        const size_t offset = joint_default_angle_.size() - interrupt_action_.size();
        for (size_t i = 0; i < interrupt_action_.size(); i++) {
            interrupt_action_[i] = static_cast<float>(joint_default_angle_[offset + i]);
        }
    }
    for (PolicyRuntime& policy : policies_) {
        reset_policy_runtime(policy);
    }
    request_depth_history_reset();
}

void InferenceNode::request_depth_history_reset() {
    if (!use_depth_ || !clear_depth_history_client_) {
        return;
    }
    if (!clear_depth_history_client_->service_is_ready()) {
        return;
    }
    auto request = std::make_shared<std_srvs::srv::Trigger::Request>();
    clear_depth_history_client_->async_send_request(request);
}

InferenceNode::PolicyRuntime& InferenceNode::active_policy() {
    return policies_[active_policy_idx_];
}

void InferenceNode::initialize_runtime_state() {
    active_policy_idx_ = 0;

    joint_state_msg_.name.resize(joint_num_);
    joint_state_msg_.position.assign(joint_num_, 0.0f);
    joint_state_msg_.velocity.assign(joint_num_, 0.0f);
    joint_state_msg_.effort.assign(joint_num_, 0.0f);
    action_msg_.name.resize(joint_num_);
    action_msg_.position.assign(joint_num_, 0.0f);
    for (int i = 0; i < joint_num_; i++) {
        joint_state_msg_.name[i] = "joint_" + std::to_string(i + 1);
        action_msg_.name[i] = "action_" + std::to_string(i + 1);
    }

    cmd_vel_.assign(3, 0.0f);
    act_.assign(joint_num_, 0.0f);
    last_act_.assign(joint_num_, 0.0f);
    joint_pos_buffer_.assign(joint_num_, 0.0f);
    joint_vel_buffer_.assign(joint_num_, 0.0f);
    joint_torques_buffer_.assign(joint_num_, 0.0f);
    quat_buffer_.assign(4, 0.0f);
    ang_vel_buffer_.assign(3, 0.0f);
    if (has_obs_source("perception")) {
        perception_obs_buffer_.assign(perception_obs_num_, 0.0f);
    } else {
        perception_obs_buffer_.clear();
    }
    if (has_obs_source("interrupt")) {
        interrupt_action_.assign(10, 0.0f);
    } else {
        interrupt_action_.clear();
    }
}

bool InferenceNode::has_motion_policy() const {
    return !motion_policy_indices_.empty();
}

bool InferenceNode::supports_interrupt() const {
    return !interrupt_action_.empty();
}

void InferenceNode::reset_policy_runtime(PolicyRuntime& policy) {
    std::fill(policy.obs.begin(), policy.obs.end(), 0.0f);
    for (auto& segment : policy.obs_segments) {
        std::fill(segment.begin(), segment.end(), 0.0f);
    }
    if (policy.ctx) {
        std::fill(policy.ctx->input_buffer.begin(), policy.ctx->input_buffer.end(), 0.0f);
        std::fill(policy.ctx->output_buffer.begin(), policy.ctx->output_buffer.end(), 0.0f);
    }
    policy.motion_frame = 0;
    if (policy.latent_loader) {
        policy.latent_loader->reset();
    }
    policy.is_first_frame = true;
}

void InferenceNode::apply_action() {
    std::unique_lock<std::mutex> control_lock(control_mutex_);
    if(!is_running_.load()){
        return;
    }
    {
        std::unique_lock<std::mutex> lock(act_mutex_);
        for (size_t i = 0; i < act_.size(); i++) {
            last_act_[i] = act_alpha_ * act_[i] + (1 - act_alpha_) * last_act_[i];
        }
    }
    robot_->apply_action(last_act_);
}

void InferenceNode::control() {
    pthread_setname_np(pthread_self(), "control");
    struct sched_param sp{}; sp.sched_priority = 45;
    if (pthread_setschedparam(pthread_self(), SCHED_FIFO, &sp) != 0) {
        RCLCPP_FATAL(this->get_logger(), "Failed to set realtime priority for control thread");
        rclcpp::shutdown();
        return;
    }
    const auto period = std::chrono::microseconds(static_cast<long long>(dt_ * 1000000));
    auto next_release = std::chrono::steady_clock::now();
    while(rclcpp::ok()){
        next_release += period;
        try {
            apply_action();
        } catch (const std::exception& e) {
            RCLCPP_FATAL(this->get_logger(), "Exception in control thread: %s", e.what());
            rclcpp::shutdown();
            return;
        }
        auto loop_end = std::chrono::steady_clock::now();
        if (loop_end > next_release) {
            const auto missed_periods = (loop_end - next_release) / period;
            next_release += period * missed_periods;
            if (next_release < loop_end) {
                next_release += period;
            }
        }
        std::this_thread::sleep_until(next_release);
    }
}

void InferenceNode::inference() {
    pthread_setname_np(pthread_self(), "inference");
    const unsigned int total_cores = std::thread::hardware_concurrency();
    const unsigned int cpu_id = total_cores > 1 ? total_cores / 2 : 0;
    cpu_set_t cpuset;
    CPU_ZERO(&cpuset);
    CPU_SET(cpu_id, &cpuset);
    if (pthread_setaffinity_np(pthread_self(), sizeof(cpu_set_t), &cpuset) != 0) {
        RCLCPP_FATAL(this->get_logger(), "Failed to bind inference thread to Core %u", cpu_id);
        rclcpp::shutdown();
        return;
    }
    struct sched_param sp{}; sp.sched_priority = 35;
    if (pthread_setschedparam(pthread_self(), SCHED_FIFO, &sp) != 0) {
        RCLCPP_FATAL(this->get_logger(), "Failed to set realtime priority for inference thread");
        rclcpp::shutdown();
        return;
    }
    const auto period = std::chrono::microseconds(static_cast<long long>(dt_ * 1000 * 1000 * decimation_));
    auto next_release = std::chrono::steady_clock::now();

    while(rclcpp::ok()){
        next_release += period;
        auto loop_start = std::chrono::steady_clock::now();
        if(!is_running_.load()){
            const auto now = std::chrono::steady_clock::now();
            if (now > next_release) {
                const auto missed_periods = (now - next_release) / period;
                next_release += period * missed_periods;
                if (next_release < now) {
                    next_release += period;
                }
            }
            std::this_thread::sleep_until(next_release);
            continue;
        }

        try {
            std::unique_lock<std::mutex> mode_lock(mode_mutex_);
            if (!is_running_.load()) {
                mode_lock.unlock();
                const auto now = std::chrono::steady_clock::now();
                if (now > next_release) {
                    const auto missed_periods = (now - next_release) / period;
                    next_release += period * missed_periods;
                    if (next_release < now) {
                        next_release += period;
                    }
                }
                std::this_thread::sleep_until(next_release);
                continue;
            }
            auto& policy = active_policy();
            robot_->read_imu();
            update_obs_segments(policy.obs_segments, policy.obs_layout);
            publish_imu();
            publish_joint_states();
            flatten_obs_segments(policy.obs_segments, policy.obs.begin());

            std::transform(policy.obs.begin(), policy.obs.end(), policy.obs.begin(), [this](float val) {
                return std::clamp(val, -clip_observations_, clip_observations_);
            });

            if (!policy.history_gather_plan.empty()) {
                if (policy.is_first_frame && policy.latent_loader) {
                    std::fill(policy.obs_history.begin(),
                              policy.obs_history.end() - policy.obs_num, 0.0f);
                    std::copy(policy.obs.begin(), policy.obs.end(),
                              policy.obs_history.end() - policy.obs_num);
                } else {
                    update_obs_history(policy.obs_history, policy.obs, policy.obs_num,
                                       policy.frame_stack, policy.is_first_frame);
                }
                gather_sparse_obs_history(policy.ctx->input_buffer, policy.obs_history,
                                          policy.history_gather_plan);
            } else {
                update_stacked_obs(policy.ctx->input_buffer, policy.obs, policy.obs_num,
                                   policy.frame_stack, policy.stack_order,
                                   policy.obs_layout_sizes, policy.is_first_frame);
            }
            if (policy.motion_loader) {
                step_motion_frame();
            }
            policy.is_first_frame = false;

            policy.ctx->session->Run(Ort::RunOptions{nullptr},
                policy.ctx->input_names_raw.data(), policy.ctx->input_tensor.get(), policy.ctx->num_inputs,
                policy.ctx->output_names_raw.data(), policy.ctx->output_tensor.get(), policy.ctx->num_outputs);

            {
                std::unique_lock<std::mutex> interrupt_lock(interrupt_mutex_, std::defer_lock);
                if (supports_interrupt() && is_interrupt_.load()) {
                    interrupt_lock.lock();
                }
                std::unique_lock<std::mutex> lock(act_mutex_);
                for (int i = 0; i < static_cast<int>(policy.ctx->output_buffer.size()); i++) {
                    policy.ctx->output_buffer[i] = action_rescale_ * std::clamp(
                        policy.ctx->output_buffer[i], -clip_actions_, clip_actions_);
                    const auto joint_idx = usd2urdf_[i];
                    act_[joint_idx] = policy.ctx->output_buffer[i] * action_scale_[joint_idx] +
                                      joint_default_angle_[joint_idx];
                }
                if (interrupt_lock.owns_lock()) {
                    for (size_t i = 0; i < interrupt_action_.size(); i++) {
                        act_[act_.size() - interrupt_action_.size() + i] = interrupt_action_[i];
                    }
                }
            }
            publish_action();
        } catch (const std::exception& e) {
            RCLCPP_FATAL(this->get_logger(), "Exception in inference thread: %s", e.what());
            rclcpp::shutdown();
            return;
        }

        auto loop_end = std::chrono::steady_clock::now();
        auto elapsed_time = std::chrono::duration_cast<std::chrono::microseconds>(loop_end - loop_start);
        if (loop_end > next_release) {
            RCLCPP_WARN(this->get_logger(), "Inference loop overran! Took %lld us, but period is %lld us.", static_cast<long long>(elapsed_time.count()), static_cast<long long>(period.count()));
            const auto missed_periods = (loop_end - next_release) / period;
            next_release += period * missed_periods;
            if (next_release < loop_end) {
                next_release += period;
            }
        }
        std::this_thread::sleep_until(next_release);
    }
}

int main(int argc, char **argv) {
    rclcpp::init(argc, argv);
    if (mlockall(MCL_CURRENT | MCL_FUTURE) == -1) {
        RCLCPP_WARN(rclcpp::get_logger("main"), "mlockall failed.");
    }
    pthread_setname_np(pthread_self(), "main");
    std::shared_ptr<InferenceNode> node;
    try {
        node = std::make_shared<InferenceNode>();
        rclcpp::executors::MultiThreadedExecutor executor(rclcpp::ExecutorOptions(), 2);
        executor.add_node(node);
        RCLCPP_INFO(node->get_logger(), "Press 'X' to initialize/deinitialize motors");
        RCLCPP_INFO(node->get_logger(), "Press 'A' to reset motors");
        RCLCPP_INFO(node->get_logger(), "Press 'B' to start/pause inference");
        RCLCPP_INFO(node->get_logger(), "Press 'Y' to switch between Gamepad Control / cmd_vel Control");
        if (node->supports_interrupt() || node->has_motion_policy()){
            RCLCPP_INFO(node->get_logger(), "Press 'LB' to switch policy mode (available in beyondmimic / interrupt modes)");
        }
        if (node->has_motion_policy()){
            RCLCPP_INFO(node->get_logger(), "Press 'RB' to switch motion sequence (available in beyondmimic mode)");
        }
        RCLCPP_INFO(node->get_logger(), "Right Stick: Control forward, backward, left and right movement");
        RCLCPP_INFO(node->get_logger(), "LT/RT: Control turning (left / right rotation)");
        executor.spin();
    } catch (const std::exception &e) {
        RCLCPP_FATAL(rclcpp::get_logger("main"), "Exception caught: %s", e.what());
    }
    rclcpp::shutdown();
    node.reset();
    return 0;
}
```


---

## FILE: raw/roboparty/src/ros_interface.cpp

- bytes: 31488

```cpp
// SPDX-License-Identifier: GPL-3.0
// Copyright (C) 2025-2026 Luo1imasi

#include "inference_node.hpp"

#include <limits>

void InferenceNode::load_config() {
    const std::string default_robot_dir = std::string(ROOT_DIR) + "robots/rpo";
    this->declare_parameter<std::string>("robot_name", "rpo");
    this->declare_parameter<std::string>("policy_name", "default");
    this->declare_parameter<std::string>("robot_config", default_robot_dir + "/robot.yaml");
    this->declare_parameter<std::string>("model_dir", default_robot_dir + "/models");
    this->declare_parameter<std::string>("motion_dir", default_robot_dir + "/motions");
    this->declare_parameter<std::string>("latent_dir", default_robot_dir + "/latents");
    this->declare_parameter<std::vector<std::string>>("model_names", std::vector<std::string>{});
    this->declare_parameter<std::vector<std::string>>("motion_names", std::vector<std::string>{});
    this->declare_parameter<std::vector<std::string>>("latent_names", std::vector<std::string>{});
    this->declare_parameter<std::vector<std::string>>("obs_layouts", std::vector<std::string>{});
    this->declare_parameter<std::vector<long int>>("frame_stacks", std::vector<long int>{});
    this->declare_parameter<std::vector<std::string>>("obs_stack_orders", std::vector<std::string>{});
    this->declare_parameter<float>("act_alpha", 0.9);
    this->declare_parameter<int>("intra_threads", -1);
    this->declare_parameter<std::string>("perception_obs_topic", "elevation_data");
    this->declare_parameter<bool>("use_depth", false);
    this->declare_parameter<int>("joint_num", 23);
    this->declare_parameter<int>("decimation", 10);
    this->declare_parameter<float>("dt", 0.001);
    this->declare_parameter<float>("obs_scales_lin_vel", 1.0);
    this->declare_parameter<float>("obs_scales_ang_vel", 1.0);
    this->declare_parameter<float>("obs_scales_dof_pos", 1.0);
    this->declare_parameter<float>("obs_scales_dof_vel", 1.0);
    this->declare_parameter<float>("obs_scales_gravity_b", 1.0);
    this->declare_parameter<float>("clip_observations", 100.0);
    this->declare_parameter<std::vector<double>>("action_scale", std::vector<double>{0.3});
    this->declare_parameter<float>("clip_actions", 18.0);
    this->declare_parameter<double>("action_rescale", 1.0);
    this->declare_parameter<std::vector<long int>>("usd2urdf", std::vector<long int>{});
    this->declare_parameter<std::vector<double>>(
        "clip_cmd", std::vector<double>{-0.4, 0.6, -0.4, 0.4, -0.8, 0.8});
    this->declare_parameter<std::vector<double>>("joint_default_angle", std::vector<double>{});
    this->declare_parameter<std::vector<double>>("joint_limits", std::vector<double>{});
    this->declare_parameter<float>("gravity_z_upper", -0.5);
    this->declare_parameter<double>("gamma", 0.8);
    this->declare_parameter<int>("window_size", 1);
    std::vector<std::string> model_names;
    std::vector<std::string> motion_names;
    std::vector<std::string> latent_names;
    std::vector<std::string> obs_layouts;
    std::vector<long int> frame_stacks;
    std::vector<std::string> obs_stack_orders;
    std::string robot_name;
    std::string policy_name;
    std::string model_dir;
    std::string motion_dir;
    std::string latent_dir;
    this->get_parameter("robot_name", robot_name);
    this->get_parameter("policy_name", policy_name);
    this->get_parameter("robot_config", robot_config_path_);
    this->get_parameter("model_dir", model_dir);
    this->get_parameter("motion_dir", motion_dir);
    this->get_parameter("latent_dir", latent_dir);
    this->get_parameter("model_names", model_names);
    this->get_parameter("motion_names", motion_names);
    this->get_parameter("latent_names", latent_names);
    this->get_parameter("obs_layouts", obs_layouts);
    this->get_parameter("frame_stacks", frame_stacks);
    this->get_parameter("obs_stack_orders", obs_stack_orders);
    this->get_parameter("act_alpha", act_alpha_);
    this->get_parameter("intra_threads", intra_threads_);
    this->get_parameter("perception_obs_topic", perception_obs_topic_);
    this->get_parameter("use_depth", use_depth_);
    this->get_parameter("joint_num", joint_num_);
    this->get_parameter("decimation", decimation_);
    this->get_parameter("dt", dt_);
    this->get_parameter("obs_scales_lin_vel", obs_scales_lin_vel_);
    this->get_parameter("obs_scales_ang_vel", obs_scales_ang_vel_);
    this->get_parameter("obs_scales_dof_pos", obs_scales_dof_pos_);
    this->get_parameter("obs_scales_dof_vel", obs_scales_dof_vel_);
    this->get_parameter("obs_scales_gravity_b", obs_scales_gravity_b_);
    this->get_parameter("clip_observations", clip_observations_);
    this->get_parameter("action_scale", action_scale_);
    double action_rescale = 1.0;
    this->get_parameter("action_rescale", action_rescale);
    action_rescale_ = static_cast<float>(action_rescale);
    if (joint_num_ <= 0) {
        throw std::runtime_error("joint_num must be greater than zero");
    }
    if (action_scale_.size() == 1) {
        action_scale_.resize(static_cast<std::size_t>(joint_num_), action_scale_.front());
    } else if (action_scale_.size() != static_cast<std::size_t>(joint_num_)) {
        throw std::runtime_error(
            "action_scale must contain either 1 value or " +
            std::to_string(joint_num_) + " values, but got " +
            std::to_string(action_scale_.size()));
    }
    this->get_parameter("clip_actions", clip_actions_);
    this->get_parameter("usd2urdf", usd2urdf_);
    this->get_parameter("clip_cmd", clip_cmd_);
    this->get_parameter("joint_default_angle", joint_default_angle_);
    this->get_parameter("joint_limits", joint_limits_);
    this->get_parameter("gravity_z_upper", gravity_z_upper_);
    double latent_gamma = 0.8;
    this->get_parameter("gamma", latent_gamma);
    int latent_window_size = 1;
    this->get_parameter("window_size", latent_window_size);

    policies_.clear();
    motion_policy_indices_.clear();
    perception_obs_num_ = 0;
    const size_t policy_count = model_names.size();
    if (policy_count == 0) {
        throw std::runtime_error("model_names must contain at least one policy");
    }
    const auto require_policy_count = [policy_count](const auto& values, const std::string& name) {
        if (values.size() != policy_count) {
            throw std::runtime_error(name + " must have the same size as model_names");
        }
    };
    const auto require_empty_or_policy_count = [policy_count](const auto& values, const std::string& name) {
        if (!values.empty() && values.size() != policy_count) {
            throw std::runtime_error(name + " must be empty or have the same size as model_names");
        }
    };
    require_policy_count(obs_layouts, "obs_layouts");
    require_policy_count(frame_stacks, "frame_stacks");
    require_policy_count(obs_stack_orders, "obs_stack_orders");
    require_empty_or_policy_count(motion_names, "motion_names");
    require_empty_or_policy_count(latent_names, "latent_names");

    const auto resolve_asset_path = [](const std::string& base_dir, const std::string& asset_name) {
        const std::filesystem::path asset_path(asset_name);
        if (asset_path.is_absolute()) {
            return asset_path.string();
        }
        return (std::filesystem::path(base_dir) / asset_path).lexically_normal().string();
    };

    for (size_t i = 0; i < policy_count; i++) {
        const std::string& policy_model_name = model_names[i];
        const std::string policy_motion_name = motion_names.empty() ? "" : motion_names[i];
        const std::string policy_latent_name = latent_names.empty() ? "" : latent_names[i];
        const long int policy_frame_stack = frame_stacks[i];
        if (policy_model_name.empty()) {
            throw std::runtime_error("model_names[" + std::to_string(i) + "] must not be empty");
        }
        if (policy_frame_stack <= 0 ||
            policy_frame_stack > static_cast<long int>(std::numeric_limits<int>::max())) {
            throw std::runtime_error(
                "frame_stacks[" + std::to_string(i) + "] must be a positive 32-bit integer");
        }
        PolicyRuntime policy;
        policy.name = policy_model_name;
        policy.model_path = resolve_asset_path(model_dir, policy_model_name);
        policy.frame_stack = static_cast<int>(policy_frame_stack);
        policy.stack_order = parse_obs_stack_order(obs_stack_orders[i]);
        if (!policy_motion_name.empty()) {
            policy.motion_path = resolve_asset_path(motion_dir, policy_motion_name);
        }
        if (!policy_latent_name.empty()) {
            policy.latent_loader = std::make_unique<LatentLoader>(
                resolve_asset_path(latent_dir, policy_latent_name),
                static_cast<float>(latent_gamma), latent_window_size);
        }
        policy.obs_layout = parse_obs_layout(obs_layouts[i], "obs_layouts[" + std::to_string(i) + "]");
        policy.obs_layout_sizes.reserve(policy.obs_layout.size());
        bool has_sparse_history = false;
        for (const ObsSourceSpec& source : policy.obs_layout) {
            if (source.size > std::numeric_limits<int>::max() - policy.obs_num) {
                throw std::runtime_error("obs_layouts[" + std::to_string(i) + "] is too large");
            }
            policy.obs_layout_sizes.push_back(source.size);
            policy.obs_num += source.size;
            if (source.name == "perception") {
                perception_obs_num_ = source.size;
            }
            if (!source.history_taps.empty()) {
                has_sparse_history = true;
                const auto invalid_tap = std::find_if(
                    source.history_taps.begin(), source.history_taps.end(),
                    [&policy](int tap) { return tap >= policy.frame_stack; });
                if (invalid_tap != source.history_taps.end()) {
                    throw std::runtime_error(
                        "obs_layouts[" + std::to_string(i) + "] history tap " +
                        std::to_string(*invalid_tap) + " for source '" +
                        source.name + "' must be smaller than frame_stacks[" +
                        std::to_string(i) + "]");
                }
                if (policy.stack_order == ObsStackOrder::FrameMajor &&
                    std::adjacent_find(
                        source.history_taps.begin(), source.history_taps.end(),
                        [](int previous, int next) { return previous <= next; }) !=
                        source.history_taps.end()) {
                    throw std::runtime_error(
                        "obs_layouts[" + std::to_string(i) +
                        "] history taps for source '" + source.name +
                        "' must be strictly descending for frame_major");
                }
            }
        }

        const long long dense_history_num =
            static_cast<long long>(policy.obs_num) * policy.frame_stack;
        if (dense_history_num > static_cast<long long>(std::numeric_limits<int>::max())) {
            throw std::runtime_error(
                "obs_layouts[" + std::to_string(i) + "] history buffer is too large");
        }
        policy.obs_input_num = static_cast<int>(dense_history_num);

        if (has_sparse_history) {
            size_t input_offset = 0;
            const auto append_history_slice =
                [&policy, &input_offset](size_t obs_offset,
                                         const ObsSourceSpec& source,
                                         int tap) {
                    const size_t frame = static_cast<size_t>(policy.frame_stack - 1 - tap);
                    policy.history_gather_plan.push_back({
                        frame * static_cast<size_t>(policy.obs_num) + obs_offset,
                        static_cast<size_t>(source.size),
                    });
                    input_offset += static_cast<size_t>(source.size);
                };

            if (policy.stack_order == ObsStackOrder::ObsMajor) {
                size_t obs_offset = 0;
                for (const ObsSourceSpec& source : policy.obs_layout) {
                    if (source.history_taps.empty()) {
                        for (int tap = policy.frame_stack - 1; tap >= 0; tap--) {
                            append_history_slice(obs_offset, source, tap);
                        }
                    } else {
                        for (const int tap : source.history_taps) {
                            append_history_slice(obs_offset, source, tap);
                        }
                    }
                    obs_offset += static_cast<size_t>(source.size);
                }
            } else {
                for (int tap = policy.frame_stack - 1; tap >= 0; tap--) {
                    size_t obs_offset = 0;
                    for (const ObsSourceSpec& source : policy.obs_layout) {
                        if (source.history_taps.empty() ||
                            std::find(source.history_taps.begin(),
                                      source.history_taps.end(), tap) !=
                                source.history_taps.end()) {
                            append_history_slice(obs_offset, source, tap);
                        }
                        obs_offset += static_cast<size_t>(source.size);
                    }
                }
            }
            policy.obs_input_num = static_cast<int>(input_offset);
        }
        if (!policy.motion_path.empty()) {
            motion_policy_indices_.push_back(static_cast<int>(policies_.size()));
        }
        policies_.push_back(std::move(policy));
    }

    RCLCPP_INFO(this->get_logger(), "robot_name: %s", robot_name.c_str());
    RCLCPP_INFO(this->get_logger(), "policy_name: %s", policy_name.c_str());
    RCLCPP_INFO(this->get_logger(), "robot_config: %s", robot_config_path_.c_str());
    RCLCPP_INFO(this->get_logger(), "model_dir: %s", model_dir.c_str());
    RCLCPP_INFO(this->get_logger(), "motion_dir: %s", motion_dir.c_str());
    RCLCPP_INFO(this->get_logger(), "latent_dir: %s", latent_dir.c_str());
    for(size_t i = 0; i < policies_.size(); i++) {
        RCLCPP_INFO(this->get_logger(), "policy %zu: %s", i, policies_[i].name.c_str());
        RCLCPP_INFO(this->get_logger(), "policy_model_path %zu: %s", i, policies_[i].model_path.c_str());
        if (!policies_[i].motion_path.empty()) {
            RCLCPP_INFO(this->get_logger(), "policy_motion_path %zu: %s", i, policies_[i].motion_path.c_str());
        }
    }
    RCLCPP_INFO(this->get_logger(), "act_alpha: %f", act_alpha_);
    RCLCPP_INFO(this->get_logger(), "intra_threads: %d", intra_threads_);
    RCLCPP_INFO(this->get_logger(), "supports_interrupt: %s", has_obs_source("interrupt") ? "true" : "false");
    RCLCPP_INFO(this->get_logger(), "has_motion_policy: %s", motion_policy_indices_.empty() ? "false" : "true");
    RCLCPP_INFO(this->get_logger(), "perception_obs_num: %d", perception_obs_num_);
    RCLCPP_INFO(this->get_logger(), "perception_obs_topic: %s", perception_obs_topic_.c_str());
    RCLCPP_INFO(this->get_logger(), "use_depth: %s", use_depth_ ? "true" : "false");
    RCLCPP_INFO(this->get_logger(), "joint_num: %d", joint_num_);
    RCLCPP_INFO(this->get_logger(), "decimation: %d", decimation_);
    RCLCPP_INFO(this->get_logger(), "dt: %f", dt_);
    RCLCPP_INFO(this->get_logger(), "obs_scales_lin_vel: %f", obs_scales_lin_vel_);
    RCLCPP_INFO(this->get_logger(), "obs_scales_ang_vel: %f", obs_scales_ang_vel_);
    RCLCPP_INFO(this->get_logger(), "obs_scales_dof_pos: %f", obs_scales_dof_pos_);
    RCLCPP_INFO(this->get_logger(), "obs_scales_dof_vel: %f", obs_scales_dof_vel_);
    RCLCPP_INFO(this->get_logger(), "obs_scales_gravity_b: %f", obs_scales_gravity_b_);
    print_vector<double>("action_scale", action_scale_);
    RCLCPP_INFO(this->get_logger(), "clip_actions: %f", clip_actions_);
    print_vector<long int>("usd2urdf", usd2urdf_);
    print_vector<double>("clip_cmd", clip_cmd_);
    print_vector<double>("joint_default_angle", joint_default_angle_);
    print_vector<double>("joint_limits", joint_limits_);
    RCLCPP_INFO(this->get_logger(), "gravity_z_upper: %f", gravity_z_upper_);
}

void InferenceNode::subs_joy_callback(const std::shared_ptr<sensor_msgs::msg::Joy> msg) {
    if (is_joy_control_){
        std::unique_lock<std::mutex> lock(cmd_mutex_);
        cmd_vel_[0] = std::clamp(msg->axes[4] * clip_cmd_[1], clip_cmd_[0], clip_cmd_[1]);
        cmd_vel_[1] = std::clamp(msg->axes[3] * clip_cmd_[3], clip_cmd_[2], clip_cmd_[3]);
            if (msg->axes[2] < 0) {
            cmd_vel_[2] = std::clamp(-msg->axes[2] * clip_cmd_[5], clip_cmd_[4], clip_cmd_[5]);
            } else if (msg->axes[5] < 0) {
            cmd_vel_[2] = std::clamp(msg->axes[5] * clip_cmd_[5], clip_cmd_[4], clip_cmd_[5]);
            } else {
            cmd_vel_[2] = 0.0;
        }
    }
    if ((msg->buttons[2] == 1 && msg->buttons[2] != last_button0_)) {
        if (is_running_.load()){
            reset_runtime_state();
            RCLCPP_INFO(this->get_logger(), "Inference paused");
        }
        try {
            if (robot_->is_init_.load()){
                robot_->deinit_motors();
                RCLCPP_INFO(this->get_logger(), "Motors deinitialized");
            } else {
                robot_->init_motors();
                RCLCPP_INFO(this->get_logger(), "Motors initialized");
            }
        } catch (const std::exception& e) {
            RCLCPP_WARN(this->get_logger(), "Failed to change motor state: %s", e.what());
        }
    }
    if (msg->buttons[0] == 1 && msg->buttons[0] != last_button1_) {
        if (is_running_.load()){
            reset_runtime_state();
            RCLCPP_INFO(this->get_logger(), "Inference paused");
        }
        try {
            if (!start_joint_reset()) {
                RCLCPP_WARN(this->get_logger(), "Motor reset is already in progress");
            }
        } catch (const std::exception& e) {
            RCLCPP_WARN(this->get_logger(), "Failed to start motor reset: %s", e.what());
        }
    }
    if (msg->buttons[1] == 1 && msg->buttons[1] != last_button2_) {
        if (is_running_.load()) {
            is_running_.store(false);
            RCLCPP_INFO(this->get_logger(), "Inference paused");
        } else if (!robot_->is_init_.load()) {
            RCLCPP_WARN(this->get_logger(), "Motors are not initialized, cannot start inference");
        } else {
            is_running_.store(true);
            RCLCPP_INFO(this->get_logger(), "Inference started");
        }
    }
    if (msg->buttons[3] == 1 && msg->buttons[3] != last_button3_) {
        is_joy_control_.store(!is_joy_control_);
        RCLCPP_INFO(this->get_logger(), "Controlled by %s", is_joy_control_.load() ? "joy" : "/cmd_vel");
    }
    if (supports_interrupt() || has_motion_policy()) {
        if (msg->buttons[4] == 1 && msg->buttons[4] != last_button4_) {
            const auto switch_while_paused = [this](auto&& switch_mode) {
                std::unique_lock<std::mutex> switch_lock(lb_switch_mutex_);
                const bool restore_running = is_running_.exchange(false);
                if (restore_running) {
                    RCLCPP_INFO(this->get_logger(), "Inference paused");
                }
                try {
                    switch_mode();
                } catch (...) {
                    if (restore_running) {
                        is_running_.store(true);
                        RCLCPP_INFO(this->get_logger(), "Inference started");
                    }
                    throw;
                }
                if (restore_running) {
                    is_running_.store(true);
                    RCLCPP_INFO(this->get_logger(), "Inference started");
                }
            };
            if (supports_interrupt()) {
                switch_while_paused([this]() {
                    std::unique_lock<std::mutex> lock(mode_mutex_);
                    is_interrupt_.store(!is_interrupt_.load());
                    RCLCPP_INFO(this->get_logger(), "Interrupt mode %s", is_interrupt_.load() ? "enabled" : "disabled");
                });
            } else if (has_motion_policy()) {
                switch_while_paused([this]() {
                    std::string policy_name;
                    std::unique_lock<std::mutex> lock(mode_mutex_);
                    is_motion_policy_.store(!is_motion_policy_.load());
                    active_policy_idx_ = is_motion_policy_.load() ? motion_policy_indices_[current_motion_policy_idx_] : 0;
                    reset_policy_runtime(active_policy());
                    policy_name = active_policy().name;
                    RCLCPP_INFO(this->get_logger(), "Policy enabled: %s", policy_name.c_str());
                });
            }
        }
        last_button4_ = msg->buttons[4];
    }
    if (has_motion_policy()) {
        if (msg->buttons[5] == 1 && msg->buttons[5] != last_button5_) {
            std::unique_lock<std::mutex> lock(mode_mutex_);
            if (is_motion_policy_.load()) {
                RCLCPP_WARN(this->get_logger(), "Cannot switch motion policy while in motion policy mode");
            } else {
                current_motion_policy_idx_ = (current_motion_policy_idx_ + 1) % motion_policy_indices_.size();
                RCLCPP_INFO(this->get_logger(), "Selected policy: %s", policies_[motion_policy_indices_[current_motion_policy_idx_]].name.c_str());
            }
        }
        last_button5_ = msg->buttons[5];
    }
    last_button0_ = msg->buttons[2];
    last_button1_ = msg->buttons[0];
    last_button2_ = msg->buttons[1];
    last_button3_ = msg->buttons[3];
}

void InferenceNode::subs_cmd_callback(const std::shared_ptr<geometry_msgs::msg::Twist> msg){
    if(!is_joy_control_){
        std::unique_lock<std::mutex> lock(cmd_mutex_);
        cmd_vel_[0] = std::clamp(msg->linear.x, clip_cmd_[0], clip_cmd_[1]);
        cmd_vel_[1] = std::clamp(msg->linear.y, clip_cmd_[2], clip_cmd_[3]);
        cmd_vel_[2] = std::clamp(msg->angular.z, clip_cmd_[4], clip_cmd_[5]);
    }
}

void InferenceNode::subs_perception_callback(const std::shared_ptr<std_msgs::msg::Float32MultiArray> msg){
    if(perception_obs_num_ > 0){
        std::unique_lock<std::mutex> lock(perception_mutex_);
        if (msg->data.size() < perception_obs_buffer_.size()) {
            RCLCPP_WARN(this->get_logger(), "Perception obs message too small: got %zu, expected %zu", msg->data.size(), perception_obs_buffer_.size());
            std::fill(perception_obs_buffer_.begin(), perception_obs_buffer_.end(), 0.0f);
            return;
        }
        std::copy(msg->data.begin(), msg->data.begin() + perception_obs_buffer_.size(), perception_obs_buffer_.begin());
    }
}

void InferenceNode::subs_joint_state_callback(const std::shared_ptr<sensor_msgs::msg::JointState> msg){
    if(supports_interrupt() && is_interrupt_.load()){
        std::unique_lock<std::mutex> lock(interrupt_mutex_);
        for(size_t i = 0; i < interrupt_action_.size(); i++){
            interrupt_action_[i] = msg->position[i];
        }
    }
}

bool InferenceNode::start_joint_reset() {
    std::unique_lock<std::mutex> lock(reset_thread_mutex_);
    if (reset_thread_running_) {
        return false;
    }
    if (!robot_->is_init_.load()) {
        throw std::runtime_error("Motors are not initialized");
    }
    if (reset_thread_.joinable()) {
        reset_thread_.join();
    }

    reset_thread_running_ = true;
    try {
        reset_thread_ = std::thread([
            this, robot = robot_, joint_default_angle = joint_default_angle_, logger = this->get_logger()
        ]() {
            try {
                robot->reset_joints(joint_default_angle);
                if (robot->is_init_.load()) {
                    RCLCPP_INFO(logger, "Motors reset");
                } else {
                    RCLCPP_INFO(logger, "Motor reset interrupted by deinitialization");
                }
            } catch (const std::exception& e) {
                if (robot->is_init_.load()) {
                    RCLCPP_WARN(logger, "Failed to reset motors: %s", e.what());
                } else {
                    RCLCPP_INFO(logger, "Motor reset interrupted by deinitialization");
                }
            } catch (...) {
                RCLCPP_ERROR(logger, "Motor reset failed with an unknown exception");
            }

            std::lock_guard<std::mutex> state_lock(reset_thread_mutex_);
            reset_thread_running_ = false;
        });
    } catch (...) {
        reset_thread_running_ = false;
        throw;
    }
    return true;
}

void InferenceNode::reset_joints_srv(const std::shared_ptr<std_srvs::srv::Trigger::Request> request,
                                     std::shared_ptr<std_srvs::srv::Trigger::Response> response) {
    try {
        if (is_running_.load()){
            reset_runtime_state();
            RCLCPP_INFO(this->get_logger(), "Inference paused");
        }
        if (!start_joint_reset()) {
            response->success = false;
            response->message = "Joint reset is already in progress";
            return;
        }
        response->success = true;
        response->message = "Joint reset started";
    } catch (const std::exception& e) {
        response->success = false;
        response->message = e.what();
    }
}

void InferenceNode::refresh_joints_srv(const std::shared_ptr<std_srvs::srv::Trigger::Request> request,
                                     std::shared_ptr<std_srvs::srv::Trigger::Response> response) {
    try {
        robot_->refresh_joints();
        response->success = true;
        response->message = "Motors refreshed successfully";
    } catch (const std::exception& e) {
        response->success = false;
        response->message = e.what();
    }
}

void InferenceNode::read_joints_srv(const std::shared_ptr<std_srvs::srv::Trigger::Request> request,
                                     std::shared_ptr<std_srvs::srv::Trigger::Response> response) {
    try {
        robot_->read_joints();
        response->success = true;
        response->message = "Joints read successfully";
        publish_joint_states();
    } catch (const std::exception& e) {
        response->success = false;
        response->message = e.what();
    }
}

void InferenceNode::read_imu_srv(const std::shared_ptr<std_srvs::srv::Trigger::Request> request,
                                 std::shared_ptr<std_srvs::srv::Trigger::Response> response) {
    try {
        robot_->read_imu();
        response->success = true;
        response->message = "IMU read successfully";
        publish_imu();
    } catch (const std::exception& e) {
        response->success = false;
        response->message = e.what();
    }
}

void InferenceNode::set_zeros_srv(const std::shared_ptr<std_srvs::srv::Trigger::Request> request,
                                  std::shared_ptr<std_srvs::srv::Trigger::Response> response) {
    if (is_running_.load()) {
        response->success = false;
        response->message = "Inference is running, cannot set zeros";
        return;
    }
    try {
        robot_->set_zeros();
        response->success = true;
        response->message = "Zeros set successfully";
    } catch (const std::exception& e) {
        response->success = false;
        response->message = e.what();
    }
}

void InferenceNode::clear_errors_srv(const std::shared_ptr<std_srvs::srv::Trigger::Request> request,
                                     std::shared_ptr<std_srvs::srv::Trigger::Response> response) {
    try {
        robot_->clear_errors();
        response->success = true;
        response->message = "Errors cleared successfully";
    } catch (const std::exception& e) {
        response->success = false;
        response->message = e.what();
    }
}

void InferenceNode::init_motors_srv(const std::shared_ptr<std_srvs::srv::Trigger::Request> request,
                                    std::shared_ptr<std_srvs::srv::Trigger::Response> response) {
    try {
        robot_->init_motors();
        response->success = true;
        response->message = "Motors initialized successfully";
    } catch (const std::exception& e) {
        response->success = false;
        response->message = e.what();
    }
}

void InferenceNode::deinit_motors_srv(const std::shared_ptr<std_srvs::srv::Trigger::Request> request,
                                      std::shared_ptr<std_srvs::srv::Trigger::Response> response) {
    try {
        if (is_running_.load()){
            reset_runtime_state();
            RCLCPP_INFO(this->get_logger(), "Inference paused");
        }
        robot_->deinit_motors();
        response->success = true;
        response->message = "Motors deinitialized successfully";
    } catch (const std::exception& e) {
        response->success = false;
        response->message = e.what();
    }
}

void InferenceNode::start_inference_srv(const std::shared_ptr<std_srvs::srv::Trigger::Request> request,
                                        std::shared_ptr<std_srvs::srv::Trigger::Response> response) {
    if (is_running_.load()) {
        response->success = false;
        response->message = "Inference is already running";
        return;
    }
    if (!robot_->is_init_.load()) {
        response->success = false;
        response->message = "Motors are not initialized, cannot start inference";
        RCLCPP_WARN(this->get_logger(), "%s", response->message.c_str());
        return;
    }
    is_running_.store(true);
    response->success = true;
    response->message = "Inference started";
}

void InferenceNode::stop_inference_srv(const std::shared_ptr<std_srvs::srv::Trigger::Request> request,
                                       std::shared_ptr<std_srvs::srv::Trigger::Response> response) {
    if (!is_running_.load()) {
        response->success = false;
        response->message = "Inference is already stopped";
        return;
    }
    is_running_.store(false);
    response->success = true;
    response->message = "Inference stopped";
}

void InferenceNode::publish_joint_states() {
    joint_pos_buffer_ = robot_->get_joint_q();
    joint_vel_buffer_ = robot_->get_joint_vel();
    joint_torques_buffer_ = robot_->get_joint_tau();
    joint_state_msg_.header.stamp = this->now();
    joint_state_msg_.effort.resize(joint_num_);
    for (int i = 0; i < joint_num_; i++) {
        joint_state_msg_.position[i] = joint_pos_buffer_[i];
        joint_state_msg_.velocity[i] = joint_vel_buffer_[i];
        joint_state_msg_.effort[i] = joint_torques_buffer_[i];
    }
    joint_state_publisher_->publish(joint_state_msg_);
}

void InferenceNode::publish_action() {
    action_msg_.header.stamp = this->now();
    {
        std::unique_lock<std::mutex> lock(act_mutex_);
        for (int i = 0; i < joint_num_; i++) {
            action_msg_.position[i] = act_[i];
        }
    }
    action_publisher_->publish(action_msg_);
}

void InferenceNode::publish_imu() {
    const auto quat = robot_->get_quat();
    const auto ang_vel = robot_->get_ang_vel();
    auto msg = sensor_msgs::msg::Imu();
    msg.header.stamp = this->now();
    msg.orientation.w = quat[0];
    msg.orientation.x = quat[1];
    msg.orientation.y = quat[2];
    msg.orientation.z = quat[3];
    msg.angular_velocity.x = ang_vel[0];
    msg.angular_velocity.y = ang_vel[1];
    msg.angular_velocity.z = ang_vel[2];
    imu_publisher_->publish(msg);
}
```


---

## FILE: raw/roboparty/src/obs_manager.cpp

- bytes: 10736

```cpp
// SPDX-License-Identifier: GPL-3.0
// Copyright (C) 2025-2026 Luo1imasi

#include "inference_node.hpp"

#include <charconv>
#include <cctype>
#include <utility>

namespace {
std::string trim_copy(const std::string& value) {
    const auto first = std::find_if_not(value.begin(), value.end(), [](unsigned char c) { return std::isspace(c) != 0; });
    const auto last = std::find_if_not(value.rbegin(), value.rend(), [](unsigned char c) { return std::isspace(c) != 0; }).base();
    if (first >= last) {
        return "";
    }
    return std::string(first, last);
}

std::vector<std::string> split_obs_layout_spec(const std::string& layout_spec) {
    std::vector<std::string> layout_specs;
    size_t start = 0;
    while (start < layout_spec.size()) {
        const size_t end = layout_spec.find(',', start);
        const std::string token = trim_copy(layout_spec.substr(start, end == std::string::npos ? std::string::npos : end - start));
        if (!token.empty()) {
            layout_specs.push_back(token);
        }
        if (end == std::string::npos) {
            break;
        }
        start = end + 1;
    }
    return layout_specs;
}

int parse_decimal_integer(const std::string& text, int minimum_value,
                          const std::string& error_message) {
    int value = 0;
    const auto result = std::from_chars(text.data(), text.data() + text.size(), value);
    if (result.ec != std::errc() || result.ptr != text.data() + text.size() ||
        value < minimum_value) {
        throw std::runtime_error(error_message);
    }
    return value;
}

std::vector<int> parse_history_taps(const std::string& taps_spec,
                                    const std::string& layout_name,
                                    const std::string& raw_spec) {
    const std::string error_message =
        layout_name + " history taps must be non-negative integers separated by '|': " + raw_spec;
    std::vector<int> taps;
    size_t start = 0;
    while (start <= taps_spec.size()) {
        const size_t end = taps_spec.find('|', start);
        const std::string tap_text = trim_copy(
            taps_spec.substr(start, end == std::string::npos ? std::string::npos : end - start));
        const int tap = parse_decimal_integer(tap_text, 0, error_message);
        if (std::find(taps.begin(), taps.end(), tap) != taps.end()) {
            throw std::runtime_error(
                layout_name + " history taps must not contain duplicates: " + raw_spec);
        }
        taps.push_back(tap);

        if (end == std::string::npos) {
            break;
        }
        start = end + 1;
    }
    return taps;
}

}

const std::vector<ObsSourceDefinition>& InferenceNode::obs_source_definitions() {
    static const std::vector<ObsSourceDefinition> definitions{
        {"motion_pos", &InferenceNode::get_motion_pos_obs},
        {"motion_vel", &InferenceNode::get_motion_vel_obs},
        {"ang_vel", &InferenceNode::get_ang_vel_obs},
        {"gravity_b", &InferenceNode::get_gravity_b_obs},
        {"cmd_vel", &InferenceNode::get_cmd_vel_obs},
        {"dof_pos", &InferenceNode::get_dof_pos_obs},
        {"dof_vel", &InferenceNode::get_dof_vel_obs},
        {"last_action", &InferenceNode::get_last_action_obs},
        {"interrupt", &InferenceNode::get_interrupt_obs},
        {"perception", &InferenceNode::get_perception_obs},
        {"latent", &InferenceNode::get_latent_obs},
    };
    return definitions;
}

std::vector<ObsSourceSpec> InferenceNode::parse_obs_layout(
    const std::string& layout_spec,
    const std::string& layout_name) {
    const std::vector<std::string> entries = split_obs_layout_spec(layout_spec);
    if (entries.empty()) {
        throw std::runtime_error(layout_name + " must be explicitly configured");
    }

    std::vector<ObsSourceSpec> layout;
    layout.reserve(entries.size());
    for (const std::string& entry : entries) {
        const size_t separator = entry.find(':');
        if (separator == std::string::npos || separator == 0 || separator == entry.size() - 1) {
            throw std::runtime_error(
                layout_name + " entry must use 'name:size' or 'name:size@tap|tap' format: " + entry);
        }

        const std::string name = trim_copy(entry.substr(0, separator));
        const std::string size_and_taps = trim_copy(entry.substr(separator + 1));
        const size_t history_separator = size_and_taps.find('@');
        const std::string size_text = trim_copy(size_and_taps.substr(0, history_separator));
        if (name.empty() || size_text.empty()) {
            throw std::runtime_error(
                layout_name + " entry must use 'name:size' or 'name:size@tap|tap' format: " + entry);
        }
        const int size = parse_decimal_integer(
            size_text, 1, layout_name + " field size must be a positive integer: " + entry);

        std::vector<int> history_taps;
        if (history_separator != std::string::npos) {
            history_taps = parse_history_taps(
                size_and_taps.substr(history_separator + 1), layout_name, entry);
        }

        const auto& definitions = obs_source_definitions();
        const auto source = std::find_if(definitions.begin(), definitions.end(), [&name](const ObsSourceDefinition& definition) {
            return name == definition.name;
        });
        if (source == definitions.end()) {
            throw std::runtime_error("Unsupported obs source: " + name);
        }

        layout.push_back({name, &*source, size, std::move(history_taps)});
    }
    return layout;
}

bool InferenceNode::has_obs_source(const std::string& source_name) const {
    return std::any_of(policies_.begin(), policies_.end(), [&source_name](const PolicyRuntime& policy) {
        return std::any_of(
            policy.obs_layout.begin(), policy.obs_layout.end(),
            [&source_name](const ObsSourceSpec& spec) { return spec.name == source_name; });
    });
}

void InferenceNode::update_obs_segments(std::vector<std::vector<float>>& segments, const std::vector<ObsSourceSpec>& layout) {
    for (size_t i = 0; i < layout.size(); i++) {
        size_t previous = 0;
        while (previous < i && (layout[previous].source != layout[i].source ||
                                layout[previous].size != layout[i].size)) {
            ++previous;
        }
        if (previous < i) {
            segments[i] = segments[previous];
        } else {
            (this->*(layout[i].source->get))(segments[i]);
        }
    }
}

void InferenceNode::flatten_obs_segments(const std::vector<std::vector<float>>& segments,
                                         std::vector<float>::iterator output_begin) {
    int offset = 0;
    for (size_t i = 0; i < segments.size(); i++) {
        std::copy(segments[i].begin(), segments[i].end(), output_begin + offset);
        offset += static_cast<int>(segments[i].size());
    }
}

void InferenceNode::step_motion_frame() {
    auto& policy = active_policy();
    if (!policy.motion_loader) {
        return;
    }
    policy.motion_frame += 1;
    if (policy.motion_frame >= policy.motion_loader->get_num_frames()) {
        policy.motion_frame = policy.motion_loader->get_num_frames() - 1;
    }
}

void InferenceNode::get_motion_pos_obs(std::vector<float>& segment) {
    auto& policy = active_policy();
    const std::vector<float>& motion_pos = policy.motion_loader->get_pos(policy.motion_frame);
    std::copy(motion_pos.begin(), motion_pos.end(), segment.begin());
}

void InferenceNode::get_motion_vel_obs(std::vector<float>& segment) {
    auto& policy = active_policy();
    const std::vector<float>& motion_vel = policy.motion_loader->get_vel(policy.motion_frame);
    std::copy(motion_vel.begin(), motion_vel.end(), segment.begin());
}

void InferenceNode::get_ang_vel_obs(std::vector<float>& segment) {
    ang_vel_buffer_ = robot_->get_ang_vel();
    for (int i = 0; i < 3; i++) {
        segment[i] = ang_vel_buffer_[i] * obs_scales_ang_vel_;
    }
}

void InferenceNode::get_gravity_b_obs(std::vector<float>& segment) {
    quat_buffer_ = robot_->get_quat();
    Eigen::Quaternionf q_b2w(quat_buffer_[0], quat_buffer_[1], quat_buffer_[2], quat_buffer_[3]);
    Eigen::Vector3f gravity_w(0.0f, 0.0f, -1.0f);
    Eigen::Quaternionf q_w2b = q_b2w.inverse();
    Eigen::Vector3f gravity_b = q_w2b * gravity_w;
    if (gravity_b.z() > gravity_z_upper_){
        RCLCPP_FATAL(this->get_logger(), "Robot fell down! Shutting down...");
        rclcpp::shutdown();
        throw std::runtime_error("Robot fell down");
    }
    segment[0] = gravity_b.x() * obs_scales_gravity_b_;
    segment[1] = gravity_b.y() * obs_scales_gravity_b_;
    segment[2] = gravity_b.z() * obs_scales_gravity_b_;
}

void InferenceNode::get_cmd_vel_obs(std::vector<float>& segment) {
    std::unique_lock<std::mutex> lock(cmd_mutex_);
    segment[0] = cmd_vel_[0] * obs_scales_lin_vel_;
    segment[1] = cmd_vel_[1] * obs_scales_lin_vel_;
    segment[2] = cmd_vel_[2] * obs_scales_ang_vel_;
}

void InferenceNode::get_dof_pos_obs(std::vector<float>& segment) {
    joint_pos_buffer_ = robot_->get_joint_q();
    for (int i = 0; i < joint_num_; i++) {
        segment[i] = (joint_pos_buffer_[usd2urdf_[i]] - joint_default_angle_[usd2urdf_[i]]) * obs_scales_dof_pos_;
    }
    for(size_t i = 0; i < joint_limits_.size() / 2; i++){
        if(joint_pos_buffer_[i] < joint_limits_[i * 2] || joint_pos_buffer_[i] > joint_limits_[i * 2 + 1]){
            RCLCPP_FATAL(this->get_logger(), "Joint %zu out of limit! Shutting down...", i+1);
            rclcpp::shutdown();
            throw std::runtime_error("Joint out of limit");
        }
    }
}

void InferenceNode::get_dof_vel_obs(std::vector<float>& segment) {
    joint_vel_buffer_ = robot_->get_joint_vel();
    for (int i = 0; i < joint_num_; i++) {
        segment[i] = joint_vel_buffer_[usd2urdf_[i]] * obs_scales_dof_vel_;
    }
}

void InferenceNode::get_last_action_obs(std::vector<float>& segment) {
    const auto& policy = active_policy();
    for (int i = 0; i < joint_num_; i++) {
        segment[i] = policy.ctx->output_buffer[i];
    }
}

void InferenceNode::get_interrupt_obs(std::vector<float>& segment) {
    segment[0] = is_interrupt_.load() ? 1.0f : 0.0f;
}

void InferenceNode::get_perception_obs(std::vector<float>& segment) {
    std::unique_lock<std::mutex> lock(perception_mutex_);
    std::copy(perception_obs_buffer_.begin(), perception_obs_buffer_.begin() + segment.size(), segment.begin());
}

void InferenceNode::get_latent_obs(std::vector<float>& segment) {
    auto& policy = active_policy();
    if (!policy.latent_loader) {
        throw std::runtime_error("latent observation requires latent_names");
    }
    policy.latent_loader->next(segment);
}
```


---

## FILE: raw/roboparty/include/robot_interface.hpp

- bytes: 4600

```cpp
#pragma once

#include <string>
#include <vector>
#include <mutex>
#include <atomic>
#include <condition_variable>
#include <algorithm>
#include <memory>
#include <Eigen/Geometry>
#include <cmath>
#include <chrono>
#include <filesystem>
#include <iostream>
#include <queue>
#include <sstream>
#include <yaml-cpp/yaml.h>
#include "utils/close_chain_mapping.hpp"
#include "utils/thread_pool.hpp"
#include "motor_driver.hpp"
#include "imu_driver.hpp"

class RobotInterface {
   public:
    RobotInterface(const std::string& config_file);
    ~RobotInterface() {
        if (is_init_.load()) {
            deinit_motors();
        }
        motors_.clear();
        imu_.reset();
    }
    struct IMUCfg{
        int imu_id_, baudrate_;
        std::string imu_type_, imu_interface_type_, imu_interface_;
    };
    struct MotorsCfg{
        int master_id_offset_;
        std::vector<std::string> motor_type_;
        std::vector<std::string> motor_interface_type_;
        std::vector<std::string> motor_interface_;
        std::vector<long int> motor_id_, motor_model_, motor_num_;
        std::vector<double> motor_zero_offset_;
    };
    struct RobotCfg{
        std::vector<long int> close_chain_motor_idx_, motor_sign_, urdf2motor_;
        std::vector<double> kp_, kd_, extrinsic_R_;
    };

    void apply_action(const std::vector<float>& p,
                      const std::vector<float>& v = {},
                      const std::vector<float>& kp = {},
                      const std::vector<float>& kd = {},
                      const std::vector<float>& tau = {});
    void init_motors();
    void deinit_motors();
    void reset_joints(std::vector<double> joint_default_angle);
    void set_zeros();
    void clear_errors();
    void read_joints();
    void read_imu();
    void refresh_joints();
    std::vector<float> get_joint_q() {
        if (!is_init_.load()) {
            throw std::runtime_error("Motors are not initialized");
        }
        std::unique_lock<std::mutex> lock(joint_mutex_);
        return joint_q_;
    }
    std::vector<float> get_joint_vel() {
        if (!is_init_.load()) {
            throw std::runtime_error("Motors are not initialized");
        }
        std::unique_lock<std::mutex> lock(joint_mutex_);
        return joint_vel_;
    }
    std::vector<float> get_joint_tau() {
        if (!is_init_.load()) {
            throw std::runtime_error("Motors are not initialized");
        }
        std::unique_lock<std::mutex> lock(joint_mutex_);
        return joint_tau_;
    }
    std::vector<float> get_quat() {
        if (!imu_) {
            throw std::runtime_error("IMU is not initialized");
        }
        std::unique_lock<std::mutex> lock(imu_mutex_);
        return quat_buf_;
    }
    std::vector<float> get_ang_vel() {
        if (!imu_) {
            throw std::runtime_error("IMU is not initialized");
        }
        std::unique_lock<std::mutex> lock(imu_mutex_);
        return ang_vel_buf_;
    }

    std::atomic<bool> is_init_{false};

   private:
    std::shared_ptr<IMUCfg> imu_cfg_;
    std::shared_ptr<MotorsCfg> motors_cfg_;
    std::shared_ptr<RobotCfg> robot_cfg_;
    int offline_threshold_ = 25;
    std::shared_ptr<IMUDriver> imu_;
    std::shared_ptr<Decouple> ankle_decouple_;
    Eigen::Matrix3f extrinsic_R_mat_ = Eigen::Matrix3f::Identity();
    Eigen::Quaternionf extrinsic_q_inv_ = Eigen::Quaternionf::Identity();
    std::vector<float> quat_buf_{0.f, 0.f, 0.f, 0.f};
    std::vector<float> ang_vel_buf_{0.f, 0.f, 0.f};
    std::vector<std::shared_ptr<MotorDriver>> motors_;
    std::unique_ptr<ThreadPool> thread_pool_;
    std::vector<size_t> motor_bus_offsets_;

    std::mutex reset_mutex_, command_mutex_, motors_mutex_, joint_mutex_, imu_mutex_;
    std::vector<float> joint_q_, joint_vel_, joint_tau_;
    std::vector<float> motor_pos_target_, motor_vel_target_, motor_kp_target_, motor_kd_target_, motor_tau_target_;
    std::vector<int> close_chain_joint_idx_, motor2urdf_;

    void setup_motors();
    void setup_imu();

    template <typename F>
    void exec_motors_parallel(F&& cmd_func) {
        std::unique_lock<std::mutex> lock(motors_mutex_);
        thread_pool_->run_parallel(motor_bus_offsets_.size() - 1,
            [this, &cmd_func](size_t bus) {
                for (size_t idx = motor_bus_offsets_[bus];
                     idx < motor_bus_offsets_[bus + 1]; ++idx) {
                    cmd_func(motors_[idx], static_cast<int>(idx));
                }
            });
    }
    void throw_if_motors_offline() const;
    void motors_mit_cmd();
    void forward_close_chain();
};
```


---

## FILE: raw/roboparty/src/robot_interface.cpp

- bytes: 19075

```cpp
// SPDX-License-Identifier: GPL-3.0
// Copyright (C) 2025-2026 Luo1imasi

#include "robot_interface.hpp"

#include <array>

RobotInterface::RobotInterface(const std::string& config_file) {
    YAML::Node config = YAML::LoadFile(config_file);

    imu_cfg_ = std::make_shared<IMUCfg>();
    if (config["imu"]) {
        YAML::Node imu_node = config["imu"];
        if (imu_node["imu_id"]) imu_cfg_->imu_id_ = imu_node["imu_id"].as<int>();
        if (imu_node["baudrate"]) imu_cfg_->baudrate_ = imu_node["baudrate"].as<int>();
        if (imu_node["imu_type"]) imu_cfg_->imu_type_ = imu_node["imu_type"].as<std::string>();
        if (imu_node["imu_interface_type"]) imu_cfg_->imu_interface_type_ = imu_node["imu_interface_type"].as<std::string>();
        if (imu_node["imu_interface"]) imu_cfg_->imu_interface_ = imu_node["imu_interface"].as<std::string>();
        setup_imu();
    }

    motors_cfg_ = std::make_shared<MotorsCfg>();
    if (config["motors"]) {
        YAML::Node motors_node = config["motors"];
        if (motors_node["motor_zero_offset"]) motors_cfg_->motor_zero_offset_ = motors_node["motor_zero_offset"].as<std::vector<double>>();
        if (motors_node["master_id_offset"]) motors_cfg_->master_id_offset_ = motors_node["master_id_offset"].as<int>();
        if (motors_node["motor_type"]) motors_cfg_->motor_type_ = motors_node["motor_type"].as<std::vector<std::string>>();
        if (motors_node["motor_interface_type"]) motors_cfg_->motor_interface_type_ = motors_node["motor_interface_type"].as<std::vector<std::string>>();
        if (motors_node["motor_interface"]) motors_cfg_->motor_interface_ = motors_node["motor_interface"].as<std::vector<std::string>>();
        if (motors_node["motor_id"]) motors_cfg_->motor_id_ = motors_node["motor_id"].as<std::vector<long int>>();
        if (motors_node["motor_model"]) motors_cfg_->motor_model_ = motors_node["motor_model"].as<std::vector<long int>>();
        if (motors_node["motor_num"]) motors_cfg_->motor_num_ = motors_node["motor_num"].as<std::vector<long int>>();
        setup_motors();
    } else {
        throw std::runtime_error("Motors configuration not found in " + config_file);
    }

    robot_cfg_ = std::make_shared<RobotCfg>();
    if (config["robot"]) {
        YAML::Node robot_node = config["robot"];
        if (robot_node["kp"]) robot_cfg_->kp_ = robot_node["kp"].as<std::vector<double>>();
        if (robot_node["kd"]) robot_cfg_->kd_ = robot_node["kd"].as<std::vector<double>>();
        if (robot_node["close_chain_motor_idx"]) robot_cfg_->close_chain_motor_idx_ = robot_node["close_chain_motor_idx"].as<std::vector<long int>>();
        if (robot_node["motor_sign"]) robot_cfg_->motor_sign_ = robot_node["motor_sign"].as<std::vector<long int>>();
        if (robot_node["urdf2motor"]) robot_cfg_->urdf2motor_ = robot_node["urdf2motor"].as<std::vector<long int>>();
        motor2urdf_ = std::vector<int>(motors_cfg_->motor_id_.size(), -1);
        for (size_t i = 0; i < robot_cfg_->urdf2motor_.size(); ++i) {
            motor2urdf_[robot_cfg_->urdf2motor_[i]] = i;
        }
        if (robot_node["extrinsic_R"]) {
            robot_cfg_->extrinsic_R_ = robot_node["extrinsic_R"].as<std::vector<double>>();
            if (robot_cfg_->extrinsic_R_.size() == 9) {
                // Row-major: [r00, r01, r02, r10, r11, r12, r20, r21, r22]
                extrinsic_R_mat_ << robot_cfg_->extrinsic_R_[0], robot_cfg_->extrinsic_R_[1], robot_cfg_->extrinsic_R_[2],
                                    robot_cfg_->extrinsic_R_[3], robot_cfg_->extrinsic_R_[4], robot_cfg_->extrinsic_R_[5],
                                    robot_cfg_->extrinsic_R_[6], robot_cfg_->extrinsic_R_[7], robot_cfg_->extrinsic_R_[8];
                Eigen::Quaternionf q_R(extrinsic_R_mat_);  // quaternion of R (Body->IMU)
                extrinsic_q_inv_ = q_R.inverse();           // we need R_inv for quaternion transform
            }
        }
        for (size_t ankle_idx = 0; ankle_idx < robot_cfg_->close_chain_motor_idx_.size(); ++ankle_idx) {
            const long int idx = robot_cfg_->close_chain_motor_idx_[ankle_idx];
            auto it = std::find(robot_cfg_->urdf2motor_.begin(), robot_cfg_->urdf2motor_.end(), idx);
            if (it != robot_cfg_->urdf2motor_.end()) {
                close_chain_joint_idx_.push_back(std::distance(robot_cfg_->urdf2motor_.begin(), it));
            }
        }
        if (robot_node["type"]) {
            ankle_decouple_ = Decouple::create(robot_node["type"].as<std::string>());
        } else {
            ankle_decouple_ = nullptr;
        }
    } else {
        throw std::runtime_error("Robot configuration not found in " + config_file);
    }

    thread_pool_ = std::make_unique<ThreadPool>(motors_cfg_->motor_interface_.size(), 46);

    joint_q_ = std::vector<float>(motors_cfg_->motor_id_.size(), 0.0);
    joint_vel_ = std::vector<float>(motors_cfg_->motor_id_.size(), 0.0);
    joint_tau_ = std::vector<float>(motors_cfg_->motor_id_.size(), 0.0);
    motor_pos_target_ = std::vector<float>(motors_cfg_->motor_id_.size(), 0.0);
    motor_vel_target_ = std::vector<float>(motors_cfg_->motor_id_.size(), 0.0);
    motor_kp_target_  = std::vector<float>(motors_cfg_->motor_id_.size(), 0.0);
    motor_kd_target_  = std::vector<float>(motors_cfg_->motor_id_.size(), 0.0);
    motor_tau_target_ = std::vector<float>(motors_cfg_->motor_id_.size(), 0.0);
}

void RobotInterface::setup_motors(){
    const size_t bus_count = motors_cfg_->motor_interface_.size();
    motor_bus_offsets_.assign(bus_count + 1, 0);
    for (size_t bus = 0; bus < bus_count; ++bus) {
        motor_bus_offsets_[bus + 1] = motor_bus_offsets_[bus] +
                                      static_cast<size_t>(motors_cfg_->motor_num_[bus]);
    }

    size_t count = 0;
    motors_.resize(motors_cfg_->motor_id_.size());
    for (size_t i = 0; i < motors_cfg_->motor_interface_.size(); ++i){
        for (size_t j = 0; j < motors_cfg_->motor_num_[i]; ++j){
            motors_[count] = MotorDriver::create_motor(motors_cfg_->motor_id_[count], motors_cfg_->motor_interface_type_[i], motors_cfg_->motor_interface_[i], motors_cfg_->motor_type_[i], motors_cfg_->motor_model_[count], motors_cfg_->master_id_offset_, motors_cfg_->motor_zero_offset_[count]);
            count += 1;
        }
    }
}

void RobotInterface::setup_imu(){
    imu_ = IMUDriver::create_imu(imu_cfg_->imu_id_, imu_cfg_->imu_interface_type_, imu_cfg_->imu_interface_, imu_cfg_->imu_type_, imu_cfg_->baudrate_);
}

void RobotInterface::forward_close_chain() {
    Eigen::Vector2d q, vel, tau;
    for (size_t pair = 0; pair < 2; ++pair) {
        const bool left = (pair == 0);
        int idx1 = close_chain_joint_idx_[pair * 2];
        int idx2 = close_chain_joint_idx_[pair * 2 + 1];
        q << joint_q_[idx1], joint_q_[idx2];
        vel << joint_vel_[idx1], joint_vel_[idx2];
        tau << joint_tau_[idx1], joint_tau_[idx2];
        ankle_decouple_->get_forwardQVT(q, vel, tau, left);
        joint_q_[idx1]   = q[0];
        joint_q_[idx2]   = q[1];
        joint_vel_[idx1] = vel[0];
        joint_vel_[idx2] = vel[1];
        joint_tau_[idx1] = tau[0];
        joint_tau_[idx2] = tau[1];
    }
}

void RobotInterface::read_joints() {
    if (!is_init_.load()) {
        throw std::runtime_error("Motors are not initialized");
    }
    std::unique_lock<std::mutex> lock(joint_mutex_);
    exec_motors_parallel([this](std::shared_ptr<MotorDriver>& motor, int idx) {
        joint_q_[motor2urdf_[idx]] = motor->get_motor_pos() * robot_cfg_->motor_sign_[idx];
        joint_vel_[motor2urdf_[idx]] = motor->get_motor_spd() * robot_cfg_->motor_sign_[idx];
        joint_tau_[motor2urdf_[idx]] = motor->get_motor_current() * robot_cfg_->motor_sign_[idx];
    });
    throw_if_motors_offline();

    if (!close_chain_joint_idx_.empty() && ankle_decouple_) {
        forward_close_chain();
    }
}

void RobotInterface::read_imu() {
    if (!imu_) {
        throw std::runtime_error("IMU is not initialized");
    }

    std::unique_lock<std::mutex> lock(imu_mutex_);
    const auto raw_quat = imu_->get_quat();          // w, x, y, z
    const auto raw_ang_vel = imu_->get_ang_vel();  // in IMU frame
    Eigen::Quaternionf q_body =
        Eigen::Quaternionf(raw_quat[0], raw_quat[1], raw_quat[2], raw_quat[3]) * extrinsic_q_inv_;
    q_body.normalize();
    Eigen::Map<const Eigen::Vector3f> omega_imu(raw_ang_vel.data());
    const Eigen::Vector3f omega_body = extrinsic_R_mat_ * omega_imu;

    quat_buf_[0] = q_body.w();
    quat_buf_[1] = q_body.x();
    quat_buf_[2] = q_body.y();
    quat_buf_[3] = q_body.z();
    Eigen::Map<Eigen::Vector3f>(ang_vel_buf_.data()) = omega_body;
}

void RobotInterface::apply_action(const std::vector<float>& p,
                                  const std::vector<float>& v,
                                  const std::vector<float>& kp,
                                  const std::vector<float>& kd,
                                  const std::vector<float>& tau) {
    std::unique_lock<std::mutex> command_lock(command_mutex_);
    if(!is_init_.load()){
        return;
    }
    const bool use_close_chain_tau = !close_chain_joint_idx_.empty() && ankle_decouple_;
    std::array<float, 4> ankle_motor_tau{};

    read_joints();

    {
        std::unique_lock<std::mutex> lock(joint_mutex_);
        if (use_close_chain_tau){
            auto kp_cc = [&](size_t i) -> double {
                return kp.empty() ? robot_cfg_->kp_[robot_cfg_->close_chain_motor_idx_[i]]
                                  : static_cast<double>(kp[close_chain_joint_idx_[i]]);
            };
            auto kd_cc = [&](size_t i) -> double {
                return kd.empty() ? robot_cfg_->kd_[robot_cfg_->close_chain_motor_idx_[i]]
                                  : static_cast<double>(kd[close_chain_joint_idx_[i]]);
            };
            auto vel_target_cc = [&](size_t i) -> double {
                return v.empty() ? 0.0 : static_cast<double>(v[close_chain_joint_idx_[i]]);
            };
            auto tau_ff_cc = [&](size_t i) -> double {
                return tau.empty() ? 0.0 : static_cast<double>(tau[close_chain_joint_idx_[i]]);
            };

            Eigen::Vector2d q, vel, tau_cc;
            for (size_t pair = 0; pair < 2; ++pair) {
                const bool left = (pair == 0);
                const size_t off = pair * 2;
                const int idx1 = close_chain_joint_idx_[off];
                const int idx2 = close_chain_joint_idx_[off + 1];
                q << joint_q_[idx1], joint_q_[idx2];
                vel << joint_vel_[idx1], joint_vel_[idx2];
                tau_cc << kp_cc(off)     * (p[idx1] - q[0]) + kd_cc(off)     * (vel_target_cc(off)     - vel[0]) + tau_ff_cc(off),
                          kp_cc(off + 1) * (p[idx2] - q[1]) + kd_cc(off + 1) * (vel_target_cc(off + 1) - vel[1]) + tau_ff_cc(off + 1);
                ankle_decouple_->get_decoupleQVT(q, vel, tau_cc, left);
                ankle_motor_tau[off] = static_cast<float>(tau_cc[0]);
                ankle_motor_tau[off + 1] = static_cast<float>(tau_cc[1]);
            }
        }
    }

    {
        std::unique_lock<std::mutex> lock(motors_mutex_);
        for (size_t i = 0; i < motor_pos_target_.size(); i++){
            const size_t ji = motor2urdf_[i];
            motor_pos_target_[i] = p[ji];
            motor_vel_target_[i] = v.empty() ? 0.0f : v[ji];
            motor_kp_target_[i]  = kp.empty() ? static_cast<float>(robot_cfg_->kp_[i]) : kp[ji];
            motor_kd_target_[i]  = kd.empty() ? static_cast<float>(robot_cfg_->kd_[i]) : kd[ji];
            motor_tau_target_[i] = tau.empty() ? 0.0f : tau[ji];
        }
        if (use_close_chain_tau) {
            for (size_t ankle_idx = 0; ankle_idx < ankle_motor_tau.size(); ++ankle_idx) {
                const size_t motor_idx = robot_cfg_->close_chain_motor_idx_[ankle_idx];
                motor_pos_target_[motor_idx] = 0.0f;
                motor_vel_target_[motor_idx] = 0.0f;
                motor_kp_target_[motor_idx] = 0.0f;
                motor_kd_target_[motor_idx] = 0.0f;
                motor_tau_target_[motor_idx] = ankle_motor_tau[ankle_idx];
            }
        }
    }

    motors_mit_cmd();
}

void RobotInterface::reset_joints(std::vector<double> joint_default_angle) {
    std::unique_lock<std::mutex> reset_lock(reset_mutex_, std::try_to_lock);
    if (!reset_lock.owns_lock()) {
        throw std::runtime_error("Joint reset is already in progress");
    }
    std::unique_lock<std::mutex> command_lock(command_mutex_);

    constexpr int reset_duration_ms = 4000;
    constexpr int reset_period_ms = 20;
    constexpr int reset_steps = reset_duration_ms / reset_period_ms;
    const auto reset_period = std::chrono::milliseconds(reset_period_ms);

    refresh_joints();
    const std::vector<float> start_joint_q = get_joint_q();
    auto next_frame = std::chrono::steady_clock::now();

    for (int step = 0; step <= reset_steps; ++step) {
        if (step > 0) {
            read_joints();
        }

        const double phase = static_cast<double>(step) / reset_steps;
        const double blend = phase * phase * (3.0 - 2.0 * phase);
        std::vector<double> joint_target(joint_default_angle.size());
        for (size_t i = 0; i < joint_target.size(); ++i) {
            joint_target[i] = start_joint_q[i] +
                              blend * (joint_default_angle[i] - start_joint_q[i]);
        }

        if (!close_chain_joint_idx_.empty() && ankle_decouple_) {
            Eigen::Vector2d q, vel = Eigen::Vector2d::Zero(), tau = Eigen::Vector2d::Zero();
            for (size_t pair = 0; pair < 2; ++pair) {
                const bool left = (pair == 0);
                int idx1 = close_chain_joint_idx_[pair * 2];
                int idx2 = close_chain_joint_idx_[pair * 2 + 1];
                q << joint_target[idx1], joint_target[idx2];
                ankle_decouple_->get_decoupleQVT(q, vel, tau, left);
                joint_target[idx1] = q[0];
                joint_target[idx2] = q[1];
            }
        }

        {
            std::unique_lock<std::mutex> lock(motors_mutex_);
            for (size_t i = 0; i < motor_pos_target_.size(); i++){
                motor_pos_target_[i] = static_cast<float>(joint_target[motor2urdf_[i]]);
                motor_vel_target_[i] = 0.0f;
                motor_kp_target_[i]  = static_cast<float>(robot_cfg_->kp_[i]) * (1.0f / 2.5f);
                motor_kd_target_[i]  = static_cast<float>(robot_cfg_->kd_[i]);
                motor_tau_target_[i] = 0.0f;
            }
        }

        motors_mit_cmd();
        if (step < reset_steps) {
            next_frame += reset_period;
            std::this_thread::sleep_until(next_frame);
        }
    }

    {
        std::unique_lock<std::mutex> lock(motors_mutex_);
        for (size_t i = 0; i < motor_kp_target_.size(); i++){
            motor_kp_target_[i] = static_cast<float>(robot_cfg_->kp_[i]);
        }
    }
    motors_mit_cmd();
}

void RobotInterface::refresh_joints() {
    if (!is_init_.load()) {
        throw std::runtime_error("Motors are not initialized");
    }
    exec_motors_parallel([](std::shared_ptr<MotorDriver>& motor, int) {
        motor->refresh_motor_status();
    });
    std::this_thread::sleep_for(std::chrono::milliseconds(1000));
    read_joints();
}

void RobotInterface::set_zeros() {
    std::unique_lock<std::mutex> command_lock(command_mutex_);
    if (!is_init_.load()) {
        throw std::runtime_error("Motors are not initialized");
    }
    exec_motors_parallel([](std::shared_ptr<MotorDriver>& motor, int) {
        motor->set_motor_zero();
    });
}

void RobotInterface::clear_errors() {
    std::unique_lock<std::mutex> command_lock(command_mutex_);
    exec_motors_parallel([](std::shared_ptr<MotorDriver>& motor, int) {
        motor->clear_motor_error();
    });
}

void RobotInterface::init_motors() {
    std::unique_lock<std::mutex> command_lock(command_mutex_);
    if (is_init_.load()) {
        throw std::runtime_error("Motors are already initialized");
    }
    exec_motors_parallel([](std::shared_ptr<MotorDriver>& motor, int) {
        motor->init_motor();
    });
    is_init_.store(true);
}

void RobotInterface::deinit_motors() {
    if (!is_init_.exchange(false)) {
        throw std::runtime_error("Motors are already deinitialized");
    }
    exec_motors_parallel([](std::shared_ptr<MotorDriver>& motor, int) {
        motor->deinit_motor();
    });
}

void RobotInterface::motors_mit_cmd() {
    std::unique_lock<std::mutex> lock(motors_mutex_);
    if (!is_init_.load()) {
        return;
    }
    thread_pool_->run_parallel(motor_bus_offsets_.size() - 1, [this](size_t bus) {
        const size_t start_count = motor_bus_offsets_[bus];
        const size_t end_count = motor_bus_offsets_[bus + 1];
        if (motors_cfg_->motor_interface_type_[bus] == "canfd") {
            float pos[8] = {}, vel[8] = {}, kp[8] = {}, kd[8] = {}, tau[8] = {};
            for (size_t idx = start_count; idx < end_count; ++idx) {
                const long int motor_id = motors_cfg_->motor_id_[idx];
                const size_t slot = (motor_id > 0 && motor_id <= 8)
                    ? static_cast<size_t>(motor_id - 1)
                    : idx - start_count;
                if (slot >= 8) continue;
                const float sign = static_cast<float>(robot_cfg_->motor_sign_[idx]);
                pos[slot] = motor_pos_target_[idx] * sign;
                vel[slot] = motor_vel_target_[idx] * sign;
                kp[slot]  = motor_kp_target_[idx];
                kd[slot]  = motor_kd_target_[idx];
                tau[slot] = motor_tau_target_[idx] * sign;
            }
            motors_[start_count]->motor_mit_cmd(pos, vel, kp, kd, tau);
        } else {
            for (size_t idx = start_count; idx < end_count; ++idx) {
                const float sign = static_cast<float>(robot_cfg_->motor_sign_[idx]);
                motors_[idx]->motor_mit_cmd(motor_pos_target_[idx] * sign,
                                             motor_vel_target_[idx] * sign,
                                             motor_kp_target_[idx],
                                             motor_kd_target_[idx],
                                             motor_tau_target_[idx] * sign);
            }
        }
    });
}

void RobotInterface::throw_if_motors_offline() const {
    std::string offline_motors;
    for (size_t idx = 0; idx < motors_.size(); ++idx) {
        const int response_count = motors_[idx]->get_response_count();
        if (response_count <= offline_threshold_) {
            continue;
        }
        if (!offline_motors.empty()) {
            offline_motors += ", ";
        }
        offline_motors += motors_[idx]->get_can_name() + "/id=" +
                          std::to_string(motors_cfg_->motor_id_[idx]) +
                          "(count=" + std::to_string(response_count) + ")";
    }
    if (!offline_motors.empty()) {
        throw std::runtime_error("Motors offline: " + offline_motors);
    }
}
```


---
