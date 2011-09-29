f=File.open("data/simple_to_dannet.txt", "r:binary")
f.read().split("\r").drop(1).each do |line|
  head, id, desc, dannet_id = line.split("\t")
  if dannet_id
    ws = DanNet::WordSense.where(:id => dannet_id).first
    puts [head, id, ws.syn_set.id / 1000 ]*"\t" if ws
  end
end
