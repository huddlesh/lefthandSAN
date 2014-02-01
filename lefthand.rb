require 'open3'
require 'crack'

# Executes commands on a HP/Lefthand ISCSI SAN

class LefthandSAN

  def initialize

    # Load our configuration file and retrieve our credentials for
    # the lefthand cli api
    @config = YAML::load_file(File.open('config.yml'))['credentials']

  end

  # get_cluster_info: This command returns information about a cluster.
  #
  # params:
  #
  #   searchDepth: Which objects to inspect 1 - Clusters only, 2 - Clusters and volumes,
  #                3 - Clusters, volumes and snapshots, 4 - Clusters, volumes, snapshots
  #                and remote snapshots (default). The greater the search depth number,
  #                the longer the call can take.
  #
  #       verbose: How much information to return 0 - Get summary information only
  #                (better performance), 1 - Get all information (better information -
  #                default). The greater the verbose number, the longer the call can take.
  #
  def get_cluster_info searchDepth = 1, verbose = 0

    cliq_run "getClusterInfo searchDepth=#{searchDepth} verbose=#{verbose}"

  end

  # get_performance_stats: This command returns performance monitoring statistics.
  #
  # params:
  #
  #   interval: The interval in between counter sampling in milliseconds. Defaults to 6000.
  #             Note: Because the internal sampling frequency is 6 seconds, it's not
  #             recommended to set this value less than 6000
  #
  def get_performance_stats interval = 6000

    cliq_run "getPerformanceStats interval=#{interval}"

  end


  private

  # cliq_run: This command returns a ruby hash when given a valid lefthand api command
  #
  # params:
  #
  #   command: A valid lefthand api command.
  #
  def cliq_run command

    # Build shell command to run
    cmd = "/usr/bin/sshpass -p #{@config['password']} /usr/bin/ssh -p 16022 Admin@#{@config['server']} '#{command} output=xml'"

    # Open a process and run our command TODO: handle err etc as we blindly assume success right here
    Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
      Crack::XML.parse(stdout.read)['gauche']['response']
    end

  end

end