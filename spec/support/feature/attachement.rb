module Feature
  module Attachement
    def remove_attached_files(context)
      within context do
        all('.attachement').each do |attachement|
          within attachement do
            click_on 'Remove file'
          end
        end
      end
    end

    def remove_attached_files_when_edit(context)
      within context do
        all('.editable_attachement').each do |attachement|
          within attachement do
            check 'Remove file'
          end
        end
      end
    end

    def attach_files(params)
      within params[:context] do
        params[:files].each do |file|
          click_on 'Add file'
          attach_it(file[:path])
        end
      end
    end

    def attach_files_when_edit(params)
      within params[:context] do
        params[:files].each do |file|
          click_on 'Add file'
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
