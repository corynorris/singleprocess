defmodule SingleProcessWeb.PageController do
  use SingleProcessWeb, :controller
  alias SingleProcess.MyProcess

  def index(conn, _params) do
    render(conn, "index.html")
  end

  @spec start(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def start(conn, _params) do
    MyProcess.start()
    redirect(conn, to: "/")
  end
end
