module ActionController
  class Base
  
    cattr_accessor :rescue_from_templates_exceptions
    self.rescue_from_templates_exceptions = false
    
    rescue_from ActionView::TemplateError, :with => :reraise_original_exception

  protected

    def reraise_original_exception(template_error)
      original_exception = template_error.original_exception
      available_handlers = rescue_handlers.collect(&:first)
      
      if self.class.rescue_from_templates_exceptions && available_handlers.include?(original_exception.class.to_s)
        # raise original exception instead of obscure TemplateError
        # so that we can recover correctly
        raise original_exception
      else
        # Re-raise TemplateError back
        # since we don't have a custom handler
        # for the original exception anyway
        rescue_action_without_handler(template_error)
      end
    end
  
  end
end