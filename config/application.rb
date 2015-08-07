class OrigenDebuggersApplication < Origen::Application

  # See http://origen.freescale.net/origen/latest/api/Origen/Application/Configuration.html
  # for a full list of the configuration options available

  # This information is used in headers and email templates, set it specific
  # to your application
  config.name     = "Origen Debuggers"
  config.initials = "OrigenDebuggers"
  config.rc_url   = "git@github.com:Origen-SDK/origen_debuggers.git"
  config.release_externally = true

  config.web_directory = "git@github.com:Origen-SDK/Origen-SDK.github.io.git/debuggers"
  config.web_domain = "http://origen-sdk.org/debuggers"

  # When false Origen will be less strict about checking for some common coding errors,
  # it is recommended that you leave this to true for better feedback and easier debug.
  # This will be the default setting in Origen v3.
  config.strict_errors = true

  config.semantically_version = true

  # By default all generated output will end up in ./output.
  # Here you can specify an alternative directory entirely, or make it dynamic such that
  # the output ends up in a setup specific directory. 
  #config.output_directory do
  #  "#{Origen.root}/output/#{$dut.class}"
  #end

  # Similary for the reference files, generally you want to setup the reference directory
  # structure to mirror that of your output directory structure.
  #config.reference_directory do
  #  "#{Origen.root}/.ref/#{$dut.class}"
  #end
  
  config.lint_test = {
    # Require the lint tests to pass before allowing a release to proceed
    run_on_tag: true,
    # Auto correct violations where possible whenever 'origen lint' is run
    auto_correct: true, 
    # Limit the testing for large legacy applications
    #level: :easy,
    # Run on these directories/files by default
    #files: ["lib", "config/application.rb"],
  }

  # Ensure that all tests pass before allowing a release to continue
  def validate_release
    if !system("origen examples")
      puts "Sorry but you can't release with failing tests, please fix them and try again."
      exit 1
    else
      puts "All tests passing, proceeding with release process!"
    end
  end

  # Run the tests before deploying to generate test coverage numbers
  def before_deploy_site
    Dir.chdir Origen.root do
      system "origen examples -c"
      #system "origen specs -c"
      dir = "#{Origen.root}/web/output/coverage"       
      FileUtils.remove_dir(dir, true) if File.exists?(dir) 
      system "mv #{Origen.root}/coverage #{dir}"
    end
  end
 
  # This will automatically deploy your documentation after every tag
  def after_release_email(tag, note, type, selector, options)
    command = "origen web compile --remote --api"
    Dir.chdir Origen.root do
      system command
    end
  end
end
