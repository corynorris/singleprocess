defmodule SingleProcessWeb.PageController do
  use SingleProcessWeb, :controller
  alias SingleProcess.MyProcess

  def index(conn, _params) do
    render(conn, "index.html")
  end

  @spec start(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def start(conn, _params) do
    if MyProcess.running?() do
      redirect(conn, to: "/")
    else
      MyProcess.start()
      MyProcess.set_running_flag()
      redirect(conn, to: "/")
    end
  end
end
