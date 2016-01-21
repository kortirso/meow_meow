class ImageUploader < CarrierWave::Uploader::Base
    include CarrierWave::RMagick

    storage :file

    def store_dir
        "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end

    process :resize_to_fill => [618, 414]
    version :thumb do
        process :resize_to_fill => [150, 100]
    end

    def extension_white_list
        %w(jpg jpeg png)
    end
end
