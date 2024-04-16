_: {
  job.storage_controller = {
    datacenters = [ "dc1" ];

    group.controller.task.plugin = {
      driver = "docker";

      config = {
        image = "docker.io/democraticcsi/democratic-csi:latest";

        args = [
          "--csi-version=1.5.0"
          "--csi-name=org.democratic-csi.nfs"
          "--driver-config-file=\${NOMAD_TASK_DIR}/driver-config-file.yaml"
          "--log-level=info"
          "--csi-mode=controller"
          "--server-socket=/csi/csi.sock"
        ];
      };

      templates = [
        {
          destination = "\${NOMAD_TASK_DIR}/driver-config-file.yaml";
          data = ''
            driver: node-manual
          '';
        }
      ];

      csiPlugin = {
        id = "org.democratic-csi.nfs";
        type = "controller";
        mountDir = "/csi";
      };

      resources = {
        cpu = 500;
        memory = 256;
      };
    };
  };

  job.storage_node = {
    datacenters = [ "dc1" ];

    type = "system";

    group.nodes.task.plugin = {
      driver = "docker";

      env = {
        CSI_NODE_ID = "\${attr.unique.hostname}";
      };

      config = {
        image = "docker.io/democraticcsi/democratic-csi:latest";

        args = [
          "--csi-version=1.5.0"
          "--csi-name=org.democratic-csi.nfs"
          "--driver-config-file=\${NOMAD_TASK_DIR}/driver-config-file.yaml"
          "--log-level=info"
          "--csi-mode=node"
          "--server-socket=/csi/csi.sock"
        ];

        privileged = true;
        ipc_mode = "host";
        network_mode = "host";
      };

      templates = [
        {
          destination = "\${NOMAD_TASK_DIR}/driver-config-file.yaml";

          data = ''
            driver: node-manual
          '';
        }
      ];

      csiPlugin = {
        id = "org.democratic-csi.nfs";
        type = "node";
        mountDir = "/csi";
      };

      resources = {
        cpu = 500;
        memory = 256;
      };
    };
  };
}
