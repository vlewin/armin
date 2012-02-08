require "system"

Armin.controllers :main do
  get :index, :map => "/" do
    @partitions = SystemInfo::FileSystem.all
    @list = @partitions.map(&:partition)
    @cpu = SystemInfo::CPU.usage
    render 'main/index'
  end

  get :index, :map => "/filesystem" do
    data = SystemInfo::FileSystem.find(params[:partition])
    if data
      free = (100-data)
      return [{:data=> data, :label => "free"}, {:data=>free, :label => "used"}].to_json
    else
      return data.to_json
    end
  end

end
