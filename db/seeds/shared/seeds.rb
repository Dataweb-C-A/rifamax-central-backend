# frozen_string_literal: true

app_module = Shared::ApplicationModule
user = Shared::User

modules = ['Rifamax', 'X100', '50/50']

# Información de usuarios a crear
users_info = [
  {
    name: 'Javier Diaz',
    role: 'admin',
    dni: 'V-29543140',
    email: 'javierdiazt406@gmail.com',
    password: '12345678',
    is_active: true,
    module_assigned: [1, 2, 3],
    phone: '0412-1688466'
  },
  {
    name: 'Evanan Semprun',
    role: 'taquilla',
    dni: 'V-28488961',
    email: 'evanansemprun@gmail.com',
    password: '12345678',
    is_active: true,
    module_assigned: [1],
    phone: '0414-6317864',
    rifero_ids: [3]
  },
  {
    name: 'Briyith Portillo',
    role: 'rifero',
    dni: 'V-30355033',
    email: 'portillobriyith2@gmail.com',
    password: '12345678',
    is_active: true,
    module_assigned: [1],
    phone: '0414-6961248'
  }
]

# Crear módulos de aplicación
modules.each do |app|
  app_module.create(title: app) if app_module.where(title: app).empty?
end

# Crear usuarios usando each
users_info.each do |user_data|
  user.create(user_data) if user.where(dni: user_data[:dni]).empty?
end
