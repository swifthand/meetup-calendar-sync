namespace :watch do

  task :meetup_group, [:path] => :environment do |task, args|
    group_names = []
    if ENV['GROUP_NAMES'] || ENV['GROUP_NAME']
      group_names += from_env_var
    end
    if args[:path].present?
      group_names += from_path(args[:path])
    end

    group_names = group_names.uniq

    if group_names.empty?
      abort(
        "No meetup group urlnames provided. "\
        "Please use either the GROUP_NAMES environment variable "\
        "or a path to a list of groups as an argument to this task.")
    end

    WatchMeetupGroups.new(group_names).apply
  end


  def from_env_var
    comma_space = /\s*,\s*|\s+/
    (ENV['GROUP_NAME'] || "").split(comma_space) +
    (ENV['GROUP_NAMES'] || "").split(comma_space)
  end


  def from_path(path)
    case path
    when /\.yml$|\.yaml$/
      load_yaml(path)
    when /\.json$/
      load_json(path)
    else
      load_plaintext(path)
    end
  rescue Errno::ENOENT
    []
  end


  def load_yaml(path)
    YAML.load_file(path).to_a.select { |val| String === val }
  end


  def load_json(path)
    JSON.load(File.read(path)).to_a.select { |val| String === val }
  end


  def load_plaintext(path)
    File.read(path).split("\n").map(&:strip).reject(&:empty?)
  end

end
