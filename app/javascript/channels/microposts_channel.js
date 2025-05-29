import consumer from "./consumer";

var array = ["/users/"]

if ( window.location.pathname === "/" || array.some(path => window.location.pathname.startsWith(path))) {
  consumer.subscriptions.create("MicropostsChannel", {
    connected() {
      console.log("Connected to MicropostsChannel");
    },

    disconnected() {
      console.log("Disconnected from MicropostsChannel");
    },

    received(data) {
      console.log("Received data:", data);
      if (data.action === "destroy") {
        const micropostElement = document.getElementById(`micropost-${data.micropost_id}`);
        if (micropostElement) {
          micropostElement.remove();
        }
      }else{
        // if (data.user_id == currentUserId) return
        const micropostsContainer = document.getElementById("microposts");
        if (micropostsContainer) {
          micropostsContainer.insertAdjacentHTML("afterbegin", data.html);
        }
      } 
    },
  });
}

