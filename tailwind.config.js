module.exports = {
  plugins: [
    // ...
    require('@tailwindcss/forms'),
    require('daisyui')
  ],
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ]
}
