// const colors = require('tailwindcss/colors')

module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/views/**/*',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.{js, jsx, vue}',
    './public/*.html',
  ],
  darkMode: "class", // or 'media' or 'class'
  theme: {
    screens: {
      xs: "614px",
      sm: "1002px",
      md: "1022px",
      lg: "1092px",
      xl: "1280px",
    },
    extend: {
      keyframes: {
        'fade-in-up': {
          '0%': {
            opacity: '0',
            transform: 'translateY(10px)'
          },
          '100%': {
            opacity: '1',
            transform: 'translateY(0)'
          },
        },
      },
      animation: {
        'spin-fast': 'spin 0.7s linear infinite',
        'fade-in-up': 'fade-in-up 0.3s ease-in-out'
      },
      colors: {
        vividSkyBlue: "#1CCEED",
        "citrine": "#EDD71C",
        "cerise-pink": "#ED1C7A",
        "twilight-lavender": "#98456A",
        "cadet": {
          800: "#3F6066",
          900: "#44676E",
        },
        dim: {
          50: "#5F99F7",
          100: "#5F99F7",
          200: "#38444d",
          300: "#202e3a",
          400: "#253341",
          500: "#5F99F7",
          600: "#5F99F7",
          700: "#192734",
          800: "#162d40",
          900: "#15202b",
        },
      },
      width: {
        68: "68px",
        88: "88px",
        275: "275px",
        290: "290px",
        350: "350px",
        600: "600px",
      },
      backgroundImage: {
        'tos-image': "url('/images/steve-johnson-abstract.jpg')",
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/line-clamp'),
  ]
}
