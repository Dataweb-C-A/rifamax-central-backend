# frozen_string_literal: true

file_path = Rails.root.join('public', 'venezuela.json')
json_data = File.read(file_path)
data = JSON.parse(json_data, symbolize_names: true)

data.each do |state_data|
  state = Fifty::Location.create!(
    iso_31662: state_data[:iso_31662],
    estado: state_data[:estado],
    capital: state_data[:capital],
    id_estado: state_data[:id_estado]
  )

  state_data[:municipios].each do |municipio_data|
    municipio = state.fifty_towns.create!(
      municipio: municipio_data[:municipio],
      capital: municipio_data[:capital]
    )

    municipio_data[:parroquias].each do |parroquia_name|
      municipio.fifty_churches.create!(parroquia: parroquia_name)
    end
  end

  state_data[:ciudades].each do |ciudad_name|
    state.fifty_cities.create!(ciudad: ciudad_name)
  end
end
