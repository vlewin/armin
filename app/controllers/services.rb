Armin.controllers :services do
  get :index, :map => '/services' do
    @services = Service.selected
    render 'services/index'
  end

  get :action, :provides => [:html, :js] do
    @service = Service.new(params[:name])
    @flash = @service.exec(params[:action])
    @services = Service.selected
    partial 'services/services', :object => @services, :locals => { :flash => @flash}
  end

  get :settings, :map => '/services/settings' do
    @services = Service.all
    @selected = Service.selected.map(&:name)
    render 'services/settings'
  end

  post :save do
    puts params.inspect
    if Service::Settings.save(params.map{|k,v| k}.to_json)
      flash[:notice] = 'Post was successfully created.'
    else
      flash[:notice] = 'ERROR: Can not save selected services!'
    end

    @services = Service.selected
    redirect url(:services, :index)

  end
end
