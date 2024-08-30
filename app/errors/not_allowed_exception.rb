class NotAllowedException < StandardError
  def initialize(msg="You don't be able to perform this action", exception_type="unauhtorized", exception_code=11)
    @exception_type = exception_type
    @exception_code = exception_code
    super({ 
      message: msg,
      exception_type: @exception_type,
      exception_code: @exception_code
    })
  end
end