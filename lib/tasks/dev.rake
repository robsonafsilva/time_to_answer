namespace :dev do

  DEFAULT_PASSWORD = 123456

  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
  
      if Rails.env.development?
        show_spinner("Deletando DB...") {%x(rails db:drop)}
        show_spinner("Criando DB...") {%x(rails db:create)}
        show_spinner("Aplicando migrações...") {%x(rails db:migrate)} 
        show_spinner("Criando administrador default...") {%x(rails dev:add_default_admin)}
        show_spinner("Criando administradores extras...") {%x(rails dev:add_extra_admins)}
        show_spinner("Criando usuário default...") {%x(rails dev:add_default_user)}
      else
        puts "Você não está em ambiente de desenvolvimento." 
      end
  end

  desc "Adiciona o administrador padrão"
  task add_default_admin: :environment do
    Admin.create!(
      email: 'admin@admin.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )  
  end

  desc "Adiciona o administradores extras"
  task add_extra_admins: :environment do
    10.times do |i|
      Admin.create!(
        email: Faker::Internet.email,
        password: DEFAULT_PASSWORD,
        password_confirmation: DEFAULT_PASSWORD
      )
    end
  end
  
  desc "Adiciona o usuário padrão"
  task add_default_user: :environment do
    User.create!(
      email: 'user@user.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )  
  end 

  private
    def show_spinner(msg_start, msg_end = "Concluido")
      spinner = TTY::Spinner.new("[:spinner] #{msg_start}", format: :dots_2)
      spinner.auto_spin
      yield
      spinner.success("(#{msg_end})")    
    end

end