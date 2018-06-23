class ApiController < ApplicationController
  def grab
    return unless api_params[:table]

    case api_params['verb']
    when 'count'
      render json: count_verb
    when 'return'
      render json: return_verb
    else
      render json: return_params('Please try again')
    end
  end

  private

  def api_params
    params.permit(:table, :verb, :when, :number)
  end

  def return_params(message, *value)
    hash = { message: message }
    hash.merge!(value: value) if value
    hash
  end

  def count_verb
    find_class

    if api_params['when']
      @result = @class.where('created_at >= ?', api_params['when']).size.to_s
    else
      @result = @class.all.size.to_s
    end

    return_params("The count of requested #{api_params} is", @result)
  end

  def return_verb
    find_class

    if api_params['when']
      @collection = @class.where('created_at >= ?', api_params['when']).size.to_s
    else
      @collection = @class.limit(api_params['number'] || 100)
    end

    if @collection.any?
      return_params('There you go', @collection)
    else
      return_params("There weren't any #{api_params['table']}")
    end
  end

  def find_class
    @class = api_params['table'].singularize.camelize.constantize

  rescue NameError
    raise TranslateException, 'Class cannot be found'
  end

  class TranslateException < StandardError; end
end
