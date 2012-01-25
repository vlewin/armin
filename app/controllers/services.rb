Armin.controllers :services do
  get :index, :map => '/services' do
    @services = Service.saved
    render 'services/index'
  end

  get :action, :map => '/services/action' do
    @service = Service.new(params[:name])
    @service.exec(params[:action])
    @services = Service.all
    render 'services/settings'
  end

  get :settings, :map => '/services/settings' do
    @services = Service.all
    render 'services/settings'
  end

  post :save do
    if Service::Settings.save(params.map{|k,v| k}.to_json)
      flash[:notice] = 'Post was successfully created.'
      @services = Service.saved
      redirect url(:services, :index)
    else
      @services = Service.all
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
