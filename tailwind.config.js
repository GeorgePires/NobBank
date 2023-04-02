module.exports = {
  plugins: [
    // ...
    require('@tailwindcss/forms'),
    require('daisyui'),
    require('flowbite/plugin')
  ],
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js',
    './node_modules/flowbite/**/*.js'
  ]
}
