Armin.controllers :services do
  get :index, :map => '/services' do
    @services = Service.all
    render 'services/index'
  end
  
  get :action, :map => '/services/action' do
    @service = Service.new(params[:pid].to_i)
    @service.stop
    render :status => 200
  end
  
end
