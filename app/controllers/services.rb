Armin.controllers :services do
  get :index, :map => '/services' do
    @services = Service.selected
    render 'services/index'
  end

  get :action, :provides => [:html, :js] do
    @service = Service.new(params[:name])
    @cflash = @service.exec(params[:action])
    @services = Service.selected
    partial 'services/services', :object => @services, :locals => { :cflash => @cflash}
  end

  get :settings, :map => '/services/settings' do
    @services = Service.all
    @selected = Service.selected.map(&:name)
    render 'services/settings'
  end

  post :save do
    if Service::Settings.save(params.map{|k,v| k}.to_json)
      flash[:success] = 'Service was successfully added'
    else
      flash[:error] = 'Can not save selected services'
    end

    #@services = Service.selected
    redirect url(:services, :index )
  end
end
