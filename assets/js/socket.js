// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket,
// and connect at the socket path in "lib/web/endpoint.ex".
//
// Pass the token on params as below. Or remove it
// from the params if you are not using authentication.
import {
  Socket
} from "phoenix"

let socket = new Socket("/socket", {
  params: {
    token: window.userToken
  }
})

// Finally, connect to the socket:
socket.connect()

let channel = socket.channel("room:notification", {})
let start = document.querySelector("#start-button")
let messagesContainer = document.querySelector("#messages")

start.onclick = function (e) {
  e.preventDefault();
  const Http = new XMLHttpRequest();
  const url = "/start";
  Http.open("GET", url);
  Http.send();
}

channel.on("new_msg", payload => {
  let messageItem = document.createElement("li")
  messageItem.innerText = `[${Date()}] ${payload.body}`
  messagesContainer.appendChild(messageItem)
})
channel.join()
  .receive("ok", resp => {
    console.log("Joined successfully", resp)
  })
  .receive("error", resp => {
    console.log("Unable to join", resp)
  })

export default socket