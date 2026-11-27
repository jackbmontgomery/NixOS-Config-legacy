{config, ...}: {
  # RTX 5070 (Blackwell) is compute-only here: amdgpu drives the display via
  # the Ryzen APU's integrated graphics, nvidia is never an output device.
  services.xserver.videoDrivers = ["amdgpu" "nvidia"];

  hardware.nvidia = {
    # Blackwell dropped proprietary kernel module support; open is mandatory.
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
