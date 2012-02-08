require "system"

Armin.controllers :main do
  get :index, :map => "/" do
    @partitions = System::FileSystem.usage
    @cpu = System::CPU.usage
    render 'main/index'
  end

  get :index, :map => "/filesystem" do
    puts params.inspect
    used = System::FileSystem.find(params[:name])
    free = (100-used)
    return [{:data=> used, :label => "free"}, {:data=>free, :label => "used"}].to_json
  end
end
