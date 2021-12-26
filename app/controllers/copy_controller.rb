class CopyController < ApplicationController

  def index
    copy = Copy.new
    render json: copy.get_data(params)
  end

  def show
    copy = Copy.new
    render json: {value: copy.format_value(params)}
  end

  def refresh
    Copy.new.refresh
    render json: {status: 'SUCCESS'}
  end
end
