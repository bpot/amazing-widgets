class Rtorrent < Widget
  description "Rtorrent"
  dependency "xmlrpc/client", "Ruby standard library"
  option :path, "Path", "localhost"
  field :upload_rate, "Upload Rate"
  field :download_rate, "Download Rate"
  field :incomplete_count, "Number Incomplete"
  field :seeding_count, "Number Seeding"
  default { @upload_rate.to_i.to_s + " / " + @download_rate.to_i.to_s  }

  init do
    server = XMLRPC::Client.new2(@path)

    @seeding_count = server.call("download_list","seeding").size
    @incomplete_count = server.call("download_list","incomplete").size
    
    data = server.call("d.multicall","started","d.get_up_rate=","d.get_down_rate=")
    @upload_rate, @download_rate = data.inject([0,0]) {|sum,v| [sum[0] + v[0], sum[1] + v[1]] }

    # Convert to KB/s 
    @upload_rate  /= 1024.0
    @download_rate  /= 1024.0
  end
end
