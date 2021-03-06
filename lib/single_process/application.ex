defmodule SingleProcess.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  import Supervisor.Spec
  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the endpoint when the application starts
      SingleProcessWeb.Endpoint,
      # Starts a worker by calling: SingleProcess.Worker.start_link(arg)
      # {SingleProcess.Worker, arg},
      worker(SingleProcess.MyProcess, [[name: :my_process]])
    ]

    # See https://hexdocs.pm/elixiSr/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SingleProcess.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    SingleProcessWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
