class Date
  def self.parse_de(str, sg=ITALY)
    parse "#{str.gsub(/\./, '-')}" rescue nil
  end
end

class Time
  def de_date
    strftime '%d.%m.%Y'
  end

end
