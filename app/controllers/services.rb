Armin.controllers :services do
  get :index, :map => '/services' do
    @services = Service.all
    @settings = JSON(Service::Settings.load)
    render 'services/index'
  end

  get :action, :map => '/services/action' do
    @service = Service.new(params[:pid], params[:name])
    @service.exec(params[:action])
    render :status => 200
  end

  get :settings, :map => '/services/settings' do
    @services = Service.all
    render 'services/settings'
  end

  post :save do
    puts "save settings"
    puts params.inspect

    if Service::Settings.save(params.to_json)
      flash[:notice] = 'Post was successfully created.'
      @services = Service.all
      redirect url(:services, :index)
    else
      flash[:notice] = 'ERROR'
    end
#    if @post.save
#      flash[:notice] = 'Post was successfully created.'
#      redirect url(:posts, :edit, :id => @post.id)
#    else
#      render 'posts/new'
#    end
#    @services = Service.all
#    render 'services/index'
  end

end
