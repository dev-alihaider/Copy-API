class CopyController < ApplicationController

  def index
    data = get_file_data
    data = data.select{|k, v| v[:updated_at] >= params[:since].to_i } if params[:since].present?

    render json: data
  end

  def show
    file_data = get_file_data
    value = ''
    if file_data[params[:key]].present?
      value = file_data[params[:key]][:copy]
      params.each do |k, v|
        if "{#{k}}".in? value
          value.gsub!("{#{k}}", v)
        elsif "{#{k}, datetime}".in? value
          # we need to make this kind of checks for custom formatting as per requirements
          t = Time.at(v.to_i)
          # it may show different time than written in doc due to timezone difference
          value.gsub!("{#{k}, datetime}", t.strftime("%a %b %d %I:%M:%S%p"))
        end
      end
    end
    render json: {value: value}
  end

  def refresh
    Rake::Task.clear
    CopyApi::Application.load_tasks
    Rake::Task['refresh_data:copy'].invoke
    render json: {status: 'SUCCESS'}
  end

  private

  def get_file_data
    if $file_data.present?
      $file_data
    else
      file = File.read('./copy.json')
      JSON.parse(file).with_indifferent_access
    end
  end
end
