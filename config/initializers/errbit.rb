Airbrake.configure do |config|
  config.api_key = '3bc7c8c85f033233dcb5100b616a6f65'
  config.host    = 'errbit.reradio.ch'
  config.port    = 80
  config.secure  = config.port == 443
end