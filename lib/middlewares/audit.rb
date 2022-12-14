class AuditMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    began_at = Time.now
    status, headers, response = @app.call env
    p "\n \n",headers.to_h,env['REMOTE_ADDR'],"\n \n"
    results = Geocoder.search(env['REMOTE_ADDR'].to_i)
    country = results&.first.country.to_s
    city = results&.first.city.to_s
    browser = env['HTTP_USER_AGENT']
    logger = Rails.logger
    logger.info "*********** Find me in lib/middleware/audit.rb********** \nbegan at:\t\t[#{began_at}] \nrequest ip:\t\t[#{env['REMOTE_ADDR']}] \nlocation:\t\t[country:#{country}/city:#{city}] \nbrowser:\t\t[#{browser}] \nend at:\t\t\t[#{Time.now}]\n************************************************************** \n\n\n"
    @app.call(env)
  end
end
