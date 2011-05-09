class DateTimeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.blank?
      begin
        temp = Time.parse(value)
      rescue ArgumentError
        record.errors[attribute] << 'must be a valid date and time'
      end
    end
  end
end
