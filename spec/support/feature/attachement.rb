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
          within all('.attachement').last do
            attach_file 'File', file[:path]
          end
        end
      end
    end
  end
end
