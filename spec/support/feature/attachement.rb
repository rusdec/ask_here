module Feature
  module Attachement
    def attach_files(params)
      within params[:context] do
        params[:files].each_with_index do |file, index|
          attach_it(file[:path])
          click_on 'More file' if (index + 1) < params[:files].count
        end
      end
    end

    def attach_files_when_edit(params)
      within params[:context] do
        params[:files].each do |file|
          click_on 'More file'
          attach_it(file[:path])
        end
      end
    end

    def attach_it(path)
      within all('.attachement').last do
        attach_file 'File', path
      end
    end
  end
end
