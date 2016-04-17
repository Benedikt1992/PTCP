module Configuration
  CONFIG_FILE = 'config.yaml'

  def self.load
    # Load configuration file
    #
    # Informations in the config file:
    #  - cygwin_installation_path: The path to the cygwin-shell (e.g. mintty)
    #  - ssh_client: The path to the openssh like ssh Client programm (default: '/usr/bin/ssh')
    #  - detach_childprocesses: Yes|No, Default: No, Determine if child processes schould be detached from this programm or if the programm should wait for the child processes.
    raise IOError ,"Config file not found. Please place the file \"#{CONFIG_FILE}\" into #{Dir.pwd}".red if not(File.exists?(CONFIG_FILE))
    config = YAML.load_file(CONFIG_FILE)

    # Defaults
    config["ssh_client"] = '/usr/bin/ssh' if not config["ssh_client"]

    return config
  end
end
