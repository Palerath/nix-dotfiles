{pkgs, lib, ... }:
{
   home.sessionVariables = {
      XMODIFIERS = "@im=fcitx";
      GTK_IM_MODULE = "fcitx";
      QT_IM_MODULE = "fcitx";

      # NVIDIA and Vulkan specific variables for better gaming performance
      __GL_SHADER_DISK_CACHE = "1";
      __GL_SHADER_DISK_CACHE_PATH = "$HOME/.cache/nvidia";
      __GL_THREADED_OPTIMIZATIONS = "1";
      __GL_SYNC_TO_VBLANK = "0";  # Disable vsync for competitive games

      # Gamescope variables (Valve's micro-compositor for games)
      GAMESCOPE_FORCE_FSR = "1";
      GAMESCOPE_FSR_SHARPNESS = "5";  # 0-20, higher is sharper

      # Proton and Wine variables
      PROTON_ENABLE_NVAPI = "1";  # For DLSS support
      PROTON_HIDE_NVIDIA_GPU = "0";
      DXVK_ASYNC = "1";  # Improve shader compilation stutter

      # Steam variables
      STEAM_RUNTIME_HEAVY = "1";
      STEAM_RUNTIME_PREFER_HOST_LIBRARIES = "0";

      # Audio-related variables
      PULSE_LATENCY_MSEC = "60";  # Lower latency for audio

      # For games using Unreal Engine
      ENABLE_VKBASALT = "1";
   };
}
