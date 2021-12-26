class Copy
  def refresh
    client = Airtable::Client.new(ENV['AIRTABLE_API_KEY'])
    table = client.table(ENV['AIRTABLE_APP_ID'], "Copy")

    records = table.records

    file = File.read('./copy.json')
    file_data = JSON.parse(file).with_indifferent_access

    data_hash = parse_row file_data, records, ActiveSupport::HashWithIndifferentAccess.new

    while records.offset.present?
      records = table.records(:offset => records.offset)
      data_hash = parse_row file_data, records, data_hash
    end

    File.write('./copy.json', JSON.dump(data_hash))

    $file_data = data_hash
  end

  def format_value(params)
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
    value
  end

  def get_data(params)
    data = get_file_data
    data = data.select{|k, v| v[:updated_at] >= params[:since].to_i } if params[:since].present?
    data
  end

  private

  def get_file_data
    if $file_data.present?
      puts "---IN"
      $file_data
    else
      puts "---IN 2"
      file = File.read('./copy.json')
      JSON.parse(file).with_indifferent_access
    end
  end

  def parse_row(file_data, records, data_hash)
    records.each do |row|
      if !file_data[row[:key]].present? || (file_data[row[:key]].present? && row[:copy] != file_data[row[:key]][:copy])
        updated_at = DateTime.now.to_i
      else
        updated_at = file_data[row[:key]][:updated_at]
      end
      data_hash[row[:key]] = { copy: row[:copy], updated_at: updated_at }
    end

    data_hash
  end
end
