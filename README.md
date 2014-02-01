lefthandSAN
===========

Development Ruby wrapper for interacting with CLIQ command line interface

Currently only supports getClusterInfo and getPerformanceStats because we needed them for our internal dashboard. We will add more of the cliq's functionality over time.

### Usage

* copy config-dist.yml to config.yml
* example configuation:

        credentials:
          password: your_cmc_admin_password
          server: lefthand_node_to_connect_to

* example usage:

        require 'lefthand'
        lh = LefthandSAN.new
        # Get cluster information
        lh.get_cluster_info
        # Get performance Statistics
        lh.get_performance_stats

### Dependencies

* requires crack xml parsing gem
