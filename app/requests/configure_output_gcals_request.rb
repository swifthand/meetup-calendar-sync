class ConfigureOutputGcalsRequest

  attr_reader :selected_calendars

  def initialize(gcal_params)
    @selected_calendars = gcals_from_params(gcal_params)
  end


  def gcals_from_params(params)
    params.values.select do |gcal|
      ['true', true, '1', 't'].include?(gcal[:selected].downcase)
    end.map do |gcal|
      { name: gcal[:name],
        id:   gcal[:id],
        tags: split_tags(gcal[:tags]),
        service: 'google',
        access_params: { id: gcal[:id] }
      }
    end
  end


  def split_tags(tag_string)
    tag_string.strip.split(/\s*,\s*/).map do |tag|
      if tag[0] == "\"" and tag[-1] == "\""
        tag.gsub(/"/, '')
      else
        tag.gsub(/"/, '').split(/\s+/)
      end
    end.flatten
  end

end
