module JsonResponsedMacros
  def json_success_hash
    { status: true, message: 'Success' }
  end
end
