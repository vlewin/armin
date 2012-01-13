Armin.controllers :services do
  get :index, :map => '/services' do
    @services = Service.get_process_list 
    render 'services/index'
  end
end
