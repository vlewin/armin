Armin.controllers :services do
  get :index, :map => '/services' do
    @running = Service.running_services
    @services = Service.all
    #@init_services = Service.init_services
    render 'services/index'
  end
  
  get :action, :map => '/services/action' do
    puts "*** ACTION #{params.inspect}"
    puts "*** ACTION #{params[:name].inspect}"
    @service = Service.new(params[:pid].to_i)
    puts @service.stop
    render :status => 200
  end
  
end
