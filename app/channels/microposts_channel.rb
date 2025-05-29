class MicropostsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "microposts_channel"
  end

  def unsubscribed
  end
end
