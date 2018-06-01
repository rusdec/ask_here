# These lets files_attachable must be declared
#   @let files_attachable [Hash]
#     @param resource_name [String] the any resource name
#     @param resources_name_plural [String] the any plural (or not) name 
#     @param new_resource_uri [String] the path for create new resource page
#     @param edit_resource_uri [String] the path for edit new resource page
#     @param bad_author_uri [String] the path for edit new resource page with user
#                                    who is not author of resource
#     @param user [Object] instance of User

shared_examples_for 'files attachable' do
  given(:resource_name) { files_attachable[:resource_name] }
  given(:resource_name_plural) { files_attachable[:resource_name_plural] }
  given(:files) do
    [{ name: 'restart.txt', path: "#{Rails.root}/tmp/restart.txt" },
     { name: 'LICENSE', path: "#{Rails.root}/LICENSE" }]
  end

  describe 'Attach files' do
    context 'when authenticated user' do

      before { sign_in(files_attachable[:user]) }

      context 'when create new resource' do
        before { visit files_attachable[:new_resource_uri] }
        given(:resource_attributes) { attributes_for(resource_name.to_sym) }

        scenario 'can attach one or more files', js: true do
          send("create_#{resource_name}", resource_attributes) do
            attach_files(context: ".attachements", files: files)
          end

          files.each do |file|
            expect(page).to have_content(file[:name])
          end
        end
      end

      context "when author of resource" do
        before { visit files_attachable[:edit_resource_uri] }
        context "and edit created resource" do
          scenario 'can attach one or more files', js: true do
            within ".#{resource_name_plural}" do
              click_on 'Edit'
              attach_files(context: ".#{resource_name}_editable_attachements", files: files)
              click_on 'Save'
            end

            files.each do |file|
              expect(page).to have_content(file[:name])
            end
          end
        end
      end

      context "when not author of resource" do
        before do
          visit files_attachable[:bad_author_uri]
        end

        scenario 'no see add file option' do
          within ".#{resource_name_plural}" do
            expect(page).to have_no_content('Add file')
          end
        end
      end
    end

    context 'Unauthenticated user' do
      before { visit files_attachable[:uri] }

      scenario 'no see add file option' do
        expect(page).to have_no_content('Add file')
      end
    end
  end # describe 'Attach files'

  describe 'Deattach files' do
    context 'when authenticated user' do
      before do
        sign_in(user)
      end

      context 'when create new resource' do
        before { visit files_attachable[:new_resource_uri] }
        given(:resource_attributes) { attributes_for(resource_name.to_sym) }

        scenario 'can delete attach one or more files', js: true do
          within "#new_#{resource_name}" do
            fill_in 'Body', with: resource_attributes[:body]
            attach_files({ context: '.attachements', files: files })
            
            remove_attached_files('.attachements')
            click_on "Create #{resource_name.capitalize}"
          end
          
          files.each do |file|
            expect(page).to have_no_content(file[:name])
          end
        end
      end

      context 'when author of resource' do
        context 'and edit created resource' do
          before { visit files_attachable[:edit_resource_uri] }

          scenario 'can delete one or more files', js: true do
            within ".#{resource_name_plural}" do
              #attach files
              click_on 'Edit'
              attach_files(context: ".#{resource_name}_editable_attachements", files: files)
              click_on 'Save'

              #remove attached files
              click_on 'Edit'
              remove_attached_files_when_edit(".#{resource_name}_editable_attachements")
              click_on 'Save'
            end

            files.each do |file|
              expect(page).to have_no_content(file[:name])
            end
          end
        end
      end

      context 'when not author of resource' do
        before do
          visit files_attachable[:bad_author_uri]
        end

        scenario 'no see remove attach option' do
          within ".#{resource_name_plural}" do
            expect(page).to have_no_content('Remove file')
          end
        end
      end
    end # context 'when authenticated user'

    context 'when unauthenticated user' do
      before { visit files_attachable[:edit_resource_uri] }

      scenario 'no see remove attach option' do
        expect(page).to have_no_content('Remove file')
      end
    end
  end # describe 'Deattach files'
end
