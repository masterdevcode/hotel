module.exports = {
    content: [
      "./resources/**/*.blade.php",
      "./resources/**/*.js",
      "./resources/**/*.vue",
    ],
    theme: {
        screens: {
            sm: '600px',
            md: '960px',
            lg: '1280px',
            'xxs': '540px',
          },
      extend: {},
    },
    plugins: [
        require('@tailwindcss/aspect-ratio'),
    ],
  }
