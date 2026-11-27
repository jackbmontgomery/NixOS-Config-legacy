{
  lib,
  pkgs,
  ...
}: {
  home = {
    sessionVariables = {
      JULIA_EDITOR = "nvim";
      JULIA_PKG_PRESERVE_TIERED_INSTALLED = "true";
      JULIA_STACKTRACE_ABBREVIATED = "true";
      PYTHON_JULIAPKG_EXE = "${pkgs.julia-bin}/bin/julia";
    };

    file.".julia/config/startup.jl".text = ''
      try
          using Pkg

          STARTUP_PKGS = ["Revise", "OhMyREPL", "AbbreviatedStackTraces"]

          missing_pkgs = [pkg for pkg in STARTUP_PKGS if Base.identify_package(pkg) === nothing]

          if !isempty(missing_pkgs)
              @info "Installing missing startup packages to default environment: $(missing_pkgs)..."
              saved_active_project = Base.ACTIVE_PROJECT[]
              try
                  Base.ACTIVE_PROJECT[] = first(Base.load_path())
                  Pkg.add(missing_pkgs)
              finally
                  Base.ACTIVE_PROJECT[] = saved_active_project
              end
          end

          using Revise
          using OhMyREPL

          saved_stderr = stderr
          redirect_stderr(devnull)
          try
              using AbbreviatedStackTraces
          finally
              redirect_stderr(saved_stderr)
          end

      catch e
          @warn "Failed to load startup packages" exception=(e, catch_backtrace())
      end
    '';
  };
}
