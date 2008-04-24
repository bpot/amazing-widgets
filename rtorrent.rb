class Rtorrent < Widget
  description "Rtorrent"
  dependency "xmlrpc/client", "Ruby standard library"
  option :path, "Path", "localhost"
  field :upload_rate, "Upload Rate"
  field :download_rate, "Download Rate"
  field :incomplete_count, "Number Incomplete"
  field :seeding_count, "Number Seeding"
  default { "S: " + @seeding_count.to_s + "|" + "D: " + @incomplete_count.to_s + " (" + @upload_rate + "Kb/" + @download_rate + "Kb)" }


  init do
    server = XMLRPC::Client.new2(@path)
    torrents = server.call("download_list")
    @seeding_count = server.call("download_list","seeding").size
    @incomplete_count = server.call("download_list","incomplete").size
    @upload_rate = 0.0
    @download_rate = 0.0
    torrents.each do |t|
      @upload_rate += server.call("d.get_up_rate",t)
      @download_rate += server.call("d.get_down_rate",t)
    end
    @upload_rate = "%.1f" % (@upload_rate/1024.0)
    @download_rate = "%.1f" % (@download_rate/1024.0)
  end
end
