require 'sinatra'
require 'zk'


get // do
  zk = ZK.new hosts
  @path = request.path_info

  @children= zk.children @path
  @data, stat = zk.get @path

  @links = links @path

  @stats = stats stat

  erb :index
end

helpers do

  def hosts
   File.open('./config/zookeeper.conf').read.gsub("\n",',')
  end

  def links(path)
    cpath = ""
    path.split('/').drop(1).reduce({'root' => '/'}){|res,name|
      res[name] = (cpath += "/#{name}")
      res
    }
  end

  def stats stat
    labels = [:version, :exists, :czxid, :mzxid, :ctime, :mtime, :cversion, :aversion, :ephemeralOwner, :dataLength, :numChildren, :pzxid]
    labels.reduce({}){|res,k|
      res[k] = stat.send k
      res
    }
  end
end





