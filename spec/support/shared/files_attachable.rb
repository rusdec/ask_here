# These lets files_attachable must be declared
#   @let files_attachable [Hash]
#     @param resource [String] the any resource name
#     @param resources [String] the any plural (or not) name 
#     @param new_resource_uri [String] the path for create new resource page
#     @param edit_resource_uri [String] the path for edit new resource page
#     @param bad_author_uri [String] the path for edit new resource page with user
#       who is not author of resource
shared_examples_for 'files attachable' do
  let(:resource) { files_attachable[:resource] }
  let(:resources) { files_attachable[:resources] }

  context 'Authenticated user' do
    given(:files) do
      [{ name: 'restart.txt', path: "#{Rails.root}/tmp/restart.txt" },
       { name: 'LICENSE', path: "#{Rails.root}/LICENSE" }]
    end

    before { sign_in(files_attachable[:user]) }

    context 'when create new resource' do
      before { visit files_attachable[:new_resource_uri] }
      given(:resource_attributes) { attributes_for(files_attachable[:resource].to_sym) }

      scenario 'can attach one or more files', js: true do
        send("create_#{resource}", resource_attributes) do
          attach_files({ context: ".attachements", files: files})
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
          within ".#{resources}" do
            click_on 'Edit'
            attach_files({ context: ".#{resource}_editable_attachements", files: files })
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
        within ".#{resources}" do
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
end
