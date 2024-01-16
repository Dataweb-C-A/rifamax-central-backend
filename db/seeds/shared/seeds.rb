# frozen_string_literal: true

app_module = Shared::ApplicationModule
user = Shared::User
old_users = JSON.parse(File.open('./old/users.json').read).sort_by { |hash| hash['id'].to_i }

modules = ['Rifamax', 'X100', '50/50']

# Crear módulos de aplicación
modules.each do |app|
  app_module.create(title: app) if app_module.where(title: app).empty?
end

# Crear usuarios usando each
old_users.each do |user_data|
  user.create(user_data)
end
