require "system"

Armin.controllers :main do
  get :index, :map => "/" do
    @partitions = SystemInfo::FileSystem.all
    @list = @partitions.map(&:partition)
    @cpu = SystemInfo::CPU.usage
    render 'main/index'
  end

  get :index, :map => "/filesystem" do
    used = SystemInfo::FileSystem.find(params[:partition])
    if used
      free = (100-used)
      return [{:data=> free, :label => "free"}, {:data=>used, :label => "used"}].to_json
    else
      return used.to_json
    end
  end

end
