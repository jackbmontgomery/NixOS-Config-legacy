{config, ...}: {
  services.xserver.videoDrivers = ["amdgpu" "nvidia"];

  hardware.nvidia = {
    # Blackwell dropped proprietary kernel module support; open is mandatory.
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
