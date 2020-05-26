+function(){
    let csrfToken = document.querySelector('meta[name=csrf-token]').content

    Dropzone.autoDiscover = false;
    const myDropzone = new Dropzone("#image-dropzone", {
        url: "/upload",
        autoProcessQueue: false,
        uploadMultiple: false,
        addRemoveLinks: true,
        params: {
            'authenticity_token': csrfToken
        },
        success: function (data, response) {
            console.log('Files response', response);

            const messages = document.querySelector('#upload-messages');

            const message = document.createElement("span");
            message.innerHTML = response.message;
            message.classList.add("alert", "alert-success")
            messages.appendChild(message);

            const imageUrl = document.querySelector('#image_url');
            const imageContentType = document.querySelector('#image_content_type');
            imageUrl.value = response.url;
            imageContentType.value = data.type;

            document.querySelector('form').submit();
        }
    });

    document.querySelector('form')
        .addEventListener('submit', (e) => {
            if (myDropzone.getQueuedFiles().length > 0) {
                e.preventDefault();
                myDropzone.processQueue();
            }
        })
}()
