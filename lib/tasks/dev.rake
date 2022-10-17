namespace :dev do
  DEFAULT_PASSWORD = 123456
  DEFAULT_FILES_PATH = File.join(Rails.root, 'lib', 'tmp')

  desc 'Configura o ambiente de desenvolvimento'
  task setup: :environment do
    if Rails.env.development?
      show_spinner('Deletando DB...') { `rails db:drop` }
      show_spinner('Criando DB...') { `rails db:create` }
      show_spinner('Aplicando migrações...') { `rails db:migrate` }
      show_spinner('Criando administrador default...') { `rails dev:add_default_admin` }
      show_spinner('Criando administradores extras...') { `rails dev:add_extra_admins` }
      show_spinner('Criando usuário default...') { `rails dev:add_default_user` }
      show_spinner('Cadastrando assuntos padrões...') { `rails dev:add_subjects` }
      show_spinner('Cadastrando perguntas e respostas...') { `rails dev:answers_and_questions` }
    else
      puts 'Você não está em ambiente de desenvolvimento.'
    end
  end

  desc 'Adiciona o administrador padrão'
  task add_default_admin: :environment do
    Admin.create!(
      email: 'admin@admin.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  desc 'Adiciona o administradores extras'
  task add_extra_admins: :environment do
    10.times do |_i|
      Admin.create!(
        email: Faker::Internet.email,
        password: DEFAULT_PASSWORD,
        password_confirmation: DEFAULT_PASSWORD
      )
    end
  end

  desc 'Adiciona o usuário padrão'
  task add_default_user: :environment do
    User.create!(
      email: 'user@user.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  desc 'Cadastra assuntos padrões'
  task add_subjects: :environment do
    file_name = 'subjects.txt'
    file_path = File.join(DEFAULT_FILES_PATH, file_name)

    File.open(file_path, 'r').each do |line|
      Subject.create!(description: line.strip)
    end
  end

  desc 'Cadastra de perguntas e respostas'
  task answers_and_questions: :environment do
    Subject.all.each do |subject|
      rand(5..10).times do |_i|
        params = create_question_params(subject)
        answers_array = params[:question][:answers_attributes]

        add_answers(answers_array)
        elect_true_answer(answers_array)

        Question.create!(params[:question])
      end
    end
  end

  private
  def create_question_params(subject = Subject.all.sample)
    { question: {
      description: "#{Faker::Lorem.paragraph} #{Faker::Lorem.question}",
      subject: subject,
      answers_attributes: []
    } }
  end

  def create_answers_params(correct = false)
    { description: Faker::Lorem.sentence, correct: correct }
  end

  def add_answers(answers_array = [])
    rand(2..5).times do |_j|
      answers_array.push(
        create_answers_params
      )
    end
  end

  def elect_true_answer(answers_array = [])
    selected_index = rand(answers_array.size)
    answers_array[selected_index] = create_answers_params(true)
  end

  def show_spinner(msg_start, msg_end = 'Concluido')
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}", format: :dots_2)
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")
  end
end
