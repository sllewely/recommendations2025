const colors = require('tailwindcss/colors')

module.exports = {
    theme: {
        extend: {
            colors: {
                //just add this below and your all other tailwind colors willwork
                ...colors
            }
        }
    }
}