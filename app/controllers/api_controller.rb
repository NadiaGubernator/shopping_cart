class ApiController < ApplicationController
  ERRORS    = 'Some errors occured:'
  NO_OBJECT = 'Please specify the object'
  NO_VERB   = 'Please, tell me what to do'
  NO_CLASS  = 'This class cannot be found'
  SUCCESS   = 'Here you go:'
  UNKNOWN   = "I don't know how to do this.\n Would you like to ask anything else?"

  def grab
    return render json: return_params(NO_OBJECT) unless api_params[:table]

    return render json: execute_verb if api_params[:verb]
    render json: return_params(NO_VERB)
  end

  private

  def api_params
    params.permit(:table, :verb, :date, :number, :id, parameters: {})
  end

  def return_params(message, value = [])
    hash = { message: message }
    hash.merge!(value: value) if value
    hash
  end

  def execute_verb
    find_class

    object = @class
    return return_params(NO_CLASS) unless object
    object = object.where('created_at >= ?', api_params[:date]) if api_params[:date]
    object = object.last(api_params[:number])                   if api_params[:number]
    object = action_sender(object) unless api_params[:number]

    return return_params(ERRORS, object.errors.full_messages ) if object.try(:errors)
    return return_params(SUCCESS, object) if object
    return_params(UNKNOWN)
  end

  def action_sender(object)
    object = object.find(api_params[:id]) if api_params[:id]
    return object.public_send(api_params[:verb].to_sym) unless api_params[:parameters]
    object.public_send(api_params[:verb].to_sym, api_params[:parameters])
  rescue
  end

  def find_class
    @class = api_params[:table].singularize.camelize.constantize
  rescue NameError
  end
end
