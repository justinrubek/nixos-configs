{ nomadJobs, pkgs, ... }:
{
  # TODO: determine how to handle workspace/config name in address
  backend.http = {
    address = "http://localhost:4646/tf/state/test";
    lock_address = "http://localhost:4646/tf/lock/test";
    lock_method = "PUT";
    unlock_address = "http://localhost:4646/tf/lock/test";
    unlock_method = "DELETE";
  };

  provider = {
    null = { };
  };

  resource = {
    null_resource = {
      "foo" = { };
    };
  };
}
