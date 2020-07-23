require 'open3'
require 'pathname'
require 'securerandom'

def get_env_variable(key)
	return (ENV[key] == nil || ENV[key] == "") ? nil : ENV[key]
end

project_id = get_env_variable("AC_FIREBASE_PROJECT_ID") || abort('Missing project id property.')
key_file = get_env_variable("AC_FIREBASE_KEY_FILE") || abort('Missing firebase key file.')
output_folder = get_env_variable("AC_OUTPUT_DIR") || abort('Missing AC_OUTPUT_DIR variable.')
bucket_name = get_env_variable("AC_FIREBASE_BUCKET_NAME")
apk_path = get_env_variable("AC_APK_PATH")
test_apk_path = get_env_variable("AC_TEST_APK_PATH")
test_type = get_env_variable("AC_FIREBASE_TEST_TYPE") || "robo"

def run_command(command)
    puts "@@[command] #{command}"
    status = nil
    stdout_str = nil
    stderr_str = nil

    Open3.popen3(command) do |stdin, stdout, stderr, wait_thr|
        stdout.each_line do |line|
            puts line
        end
        stdout_str = stdout.read
        stderr_str = stderr.read
        status = wait_thr.value
    end

    unless status.success?
        puts stderr_str
        raise stderr_str
    end
    return stdout_str
end

test_params = "--type=#{test_type}"
result_dir = SecureRandom.hex

unless apk_path.nil?
    test_params += " --app=\"#{apk_path}\""
end

unless test_apk_path.nil?
    test_params += " --test=\"#{test_apk_path}\""
end

unless bucket_name.nil?
    test_params += " --results-bucket=\"#{bucket_name}\" --results-dir=#{result_dir}"
end

run_command("gcloud auth activate-service-account --project=\"#{project_id}\" --key-file=\"#{key_file}\"")
run_command("gcloud firebase test android run #{test_params}")

unless bucket_name.nil?
    run_command("gsutil -m cp -r #{bucket_name}/#{result_dir} #{output_folder}/firebase-test-results")
end

exit 0