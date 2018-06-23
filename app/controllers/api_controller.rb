class ApiController < ApplicationController
  def grab
    case @verb
    when 'count'
      render json: count_verb if @table
    when 'return'
      render json: return_verb
    end

    @response = 'Please try again'
  end

  private

  def api_params
    params.permit(:table, :verb, :datetime, :number)
  end

  def count_verb
      find_class

      if @when
        @response = @class.where('created_at >= ?', @when).size.to_s
      else
        @response = @class.all.size.to_s
      end
    end

    def return_verb
      find_class

      @collection = @class.limit(@number || 100)

      if @collection.any?
        @response = 'There you go'
      else
        @response = "There weren't any #{@table}"
      end
    end

    def find_class
      @class = @table.singularize.camelize.constantize

    rescue NameError
      raise TranslateException, 'Class cannot be found'
    end

    class TranslateException < StandardError; end
  end
end
