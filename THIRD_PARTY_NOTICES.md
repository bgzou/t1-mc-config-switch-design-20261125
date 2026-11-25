# Third-party notices

This repository is a **review input bundle**, not a product release. It contains text copied from several sources.

## 1. `roboparty_deploy` (RoboParty)

- Source: <https://github.com/Roboparty/roboto_origin/tree/main/modules/roboparty_deploy>
- License: **GNU General Public License v3.0 only (GPL-3.0-only)**, unless a file says otherwise.
- Included here: `README_CN.md`, `robot.yaml`, policy configs, inference source (`inference_node.*`, `ros_interface.cpp`, `obs_manager.cpp`, `robot_interface.*`), `motion_player.py`, launch/start scripts, and utility sources — copied for architecture review and interoperability analysis.
- The full GPL text is at `raw/roboparty/LICENSE`.
- The upstream project also contains third-party submodules and binaries under their own licenses; those are **not** included here. See upstream `LICENSES.md`.

If you redistribute or modify the GPL-covered code, comply with GPL-3.0-only. The rest of this bundle (Collie design notes and T1 evidence) is not relicensed by this notice.

## 2. T1 Pro deployment dumps (vendor evidence)

- Source: T1 Pro (`qd1_t2d0`) deployment files, copied from the robot's RK board for evidence and interoperability review.
- Included here: YAML configs, device/process/system-mode configs, task-engine configs, interface `.msg/.srv`, model/action lists, transition recordings, selected motion CSVs.
- These are **vendor configuration data**, not open source. No license is granted beyond review use. Do not use them as Collie calibration values or redistribute them commercially without permission.

## 3. ONNX / binaries

- Not included. See `raw/NOT_INCLUDED.md`.

## 4. Redactions

- The upstream default AP password in `README_CN.md` is replaced with `<REDACTED_DEFAULT_AP_PASSWORD>`; see `raw/REDACTIONS.md`.
- Internal lab IPs remain in the evidence documents; they are not credentials.
