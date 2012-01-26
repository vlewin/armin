Armin.controllers :services do
  get :index, :map => '/services' do
    @services = Service.saved
    render 'services/index'
  end

  get :action, :provides => [:html, :js] do
    @service = Service.new(params[:name])
    response = @service.exec(params[:action])
    @services = Service.saved

    if response[:status] == "success"
      @flash = "Success: #{response[:message]}"
    elsif response[:status] == "warning"
      @flash = "Warning: #{response[:error]}"
    else
      @flash = "Error: #{response[:error]}"
    end

    partial 'services/services', :object => @services, :locals => { :flash => @flash}
  end

  get :settings, :map => '/services/settings' do
    @services = Service.all
    @checked = Service.saved.map(&:name)
    render 'services/settings'
  end

  post :save do
    puts params.inspect
    if Service::Settings.save(params.map{|k,v| k}.to_json)
      flash[:notice] = 'Post was successfully created.'
    else
      flash[:notice] = 'ERROR: Can not save selected services!'
    end

    @services = Service.saved
    redirect url(:services, :index)

  end
end
