require 'rails_helper'

RSpec.describe FilesController, type: :controller do
  let(:file_blob) do
    ActiveStorage::Blob.create_and_upload! io: file_fixture("test.jpg").open,
                                           filename: "test.jpg",
                                           content_type: "image/jpeg",
                                           metadata: nil
  end
  let(:users) { create_list(:user, 2) }
  let(:question) { create(:question, user: users.first) }

  describe 'DELETE #destroy' do
    let!(:question) { create(:question) }
    before do
      question.files.attach(file_blob)
      login(question.user)
    end

    it 'delete the file' do
      expect { delete :destroy, params: { id: question.files[0] }, format: :js }.to change(question.files, :count).by(-1)
    end

    it 'render delete_attachment' do
      delete :destroy, params: { id: question.files[0] }, format: :js
      expect(response).to render_template :destroy
    end

    context 'user is not author of the question' do
      before { login(users.last) }
      it "can't delete file" do
        expect { delete :destroy, params: { id: question.files[0] }, format: :js }.to change(question.files, :count).by(0)
      end
    end
  end
end
