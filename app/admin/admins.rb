ActiveAdmin.register Admin do

  permit_params :name, :image, :id

   # image download krne ke liy ae code 
  action_item :download_media, only: :show do
    if params[:id].present?
      admin = Admin.find(params[:id])
      if admin.image.present?
        link_to 'Download Media', rails_blob_path(admin.image, disposition: 'attachment')
      end
    end
  end

  index do
    column :id
    column :name
    # column :created_at
    # column :updated_at
    column "Media" do |admin|
      if admin.image.present?
        admin.image.filename.to_s.truncate(18)
      else
        "No Media Found"
      end
    end
    actions
  end

  # external edit and create form
  form do |f|
      f.inputs do
        f.semantic_errors *f.object.errors.keys
        f.input :name
        f.input :image, as: :file
      end
      f.actions
  end

  # external show page
  #ae image show krne ke liye code/video
  show do
    attributes_table do
      row :name
      row  "Media Detail" do |ad|
        if ad.image.present?
            ad.image.blob.filename
        else
          "No Media found!"
        end
      end
      row  "Media" do |ad|
        if ad.image.present?
          case ad.image.blob.content_type 
  
          when "image/jpeg"
            image_tag ad.image, :width=>250

          when "video/mp4"
            video(width: 480, height: 320, controls: true) do
              source(src: polymorphic_url(admin.image))
            end
          when "audio/mpeg"
            audio(controls: true) do
              source(src: polymorphic_url(admin.image))
            end
          else  
            "Media format is not supported in the admin yet, please download the media file to view"
          end 
        end
      end
    end
    # active_admin_comments
  end
end