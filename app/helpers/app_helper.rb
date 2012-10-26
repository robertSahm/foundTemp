module AppHelper
  
  def t1o_json(options={})
    default_serialization_options(options)
    super(options)
  end
   
  def d1efault_serialization_options(options={})
    options[:only] = [ :user_id, :updated_at, :created_at]
  end
  
end
