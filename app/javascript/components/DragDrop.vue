<template>
  <div>
    <div
      class="dropzone has-text-centered"
      :class="{ 'is-dragging' : dragging }"
      @ondrop="$swal('dropped')">
      <p v-if="!dragging" class="dropzone-message p-0 m-0 text-grey-dark font-bold is-5 text-center has-text-grey">Arrastra y suelta la imagen aquí.</p>
      <p v-else
        @dragover="dragging = true"
        class="dropzone-message p-0 m-0 text-grey-dark font-bold is-5 text-center">Suelta la imagen.</p>
      <input
        class="drop-reciever pointer"
        type="file"
        id="items"
        name="items[]" 
        required
        :multiple="multiple"
        @dragenter="dragging = true"
        @dragend="dragging = false"
        @dragleave="dragging = false"
        @change="checkFiles">
    </div>
  </div>
</template>

<script>
import * as ActiveStorage from 'activestorage'

export default {
  name: 'drag-drop',
  data: () => ({
    dragging: false,
    images: [],
  }),
  props: ['url', 'multiple'],
  methods: {
    // handleUpload: function () {
    //   const that = this
    //   console.log(this.images.length)
    //   this.images.map(image => {
    //     const upload = new ActiveStorage.DirectUpload(image.raw, '/rails/active_storage/direct_uploads')
    //     upload.create((error, blob) => {
    //       if (error) {
    //         console.log(error)
    //       } else {
    //         that.images[that.images.indexOf(image)].blob = blob

    //         if (that.images.indexOf(image) === that.images.length -1) {
    //           const publication = {
    //             'images': that.images
    //           }
    //           that.$axios.put(that.url, { publication })
    //             .then(result => {
    //               that.$emit('uploaded')
    //               that.images = []
    //               console.log(document.getElementById('items').value = '')
    //               that.$swal.close()
    //             })
    //             .catch(err => {
    //               that.$swal({
    //                 type: 'error',
    //                 title: 'Error',
    //                 text: err
    //               })
    //               that.images = []
    //               console.log(document.getElementById('items').value = '')
    //             })
    //         }
    //       }
    //     })
    //   })
    // },
    checkFiles: function (e) {
      const that = this
      const files = e.target.files
      
      this.dragging = false

      if (files.length > 0) this.$swal.showLoading()

      if (files && files[0]) {
        for (const key in files) {
          if (files.hasOwnProperty(key)) {
            const element = files[key]
            const reader = new FileReader()
            reader.onload = function (e) {
              const image = {
                lastModified: element.lastModified,
                lastModifiedDate: element.lastModifiedDate,
                name: element.name,
                size: element.size,
                type: element.type,
                webkitRelativePath: element.webkitRelativePath,
                url: e.target.result,
                raw: element
              }
              if (image.type == 'image/png' || image.type == 'image/jpeg'){
                if (!that.multiple) {
                  that.images = []
                  that.$swal.close()
                } else {
                  if (key == that.images.length -1) that.$swal.close()
                }
                that.images.push(image)
              } else {
                that.$swal({
                  type: 'error',
                  title: 'Tipo de archivo no admitido',
                  text: `${image.name} es inválido, los correctos son 'image/png' o 'image/jpeg', tú intentas subir ${image.type}`
                })
                that.images = []
              }
            };
            reader.readAsDataURL(files[key])
          }
        }
      }
    }
  },
  watch: {
    images: function () { this.$emit('images', this.images) }
  }
}
</script>
