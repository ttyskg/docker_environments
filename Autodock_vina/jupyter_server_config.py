# Configuration file for Jupyter Lab/Notebook
c = get_config()

# Set bash as the default shell for terminals
c.ServerApp.terminado_settings = {
    'shell_command': ['/bin/bash']
}

# Allow root to run Jupyter
c.ServerApp.allow_root = True

# Disable CSRF checks (for Docker environment)
c.ServerApp.disable_check_xsrf = True

# Allow connections from any origin (for Docker port forwarding)
c.ServerApp.allow_origin = '*'

# Set notebook directory
c.ServerApp.notebook_dir = '/workspace'

# Enable widgets
c.ServerApp.iopub_data_rate_limit = 1e10
c.ServerApp.rate_limit_window = 3.0
