const defaultTheme = require("tailwindcss/defaultTheme");
const { default: typographyStyles } = require("../config/tailwind.typography");

function rem(num, base = 16) {
  let parsedNum = num;

  // remove mesurment unit
  if (typeof num === "string") {
    parsedNum = Number(num.replace(/(\d.)(.*)/, "$1"));
  }

  parsedNum = `${parsedNum / base}rem`;

  return parsedNum;
}

module.exports = {
  content: [
    "./app/assets/images/*.svg",
    "./app/assets/images/**/*.svg",
    "./app/views/**/*.rb",
    "./app/views/**/**/*.rb",
    "./public/*.html",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
    "./app/views/**/*.erb",
    "./assets/images/icons/*.svg",
  ],
  darkMode: "selector",
  theme: {
    fontSize: {
      "2xs": ["0.75rem", { lineHeight: "1.25rem" }],
      xs: ["0.8125rem", { lineHeight: "1.5rem" }],
      sm: ["0.875rem", { lineHeight: "1.5rem" }],
      base: ["1rem", { lineHeight: "1.75rem" }],
      lg: ["1.125rem", { lineHeight: "1.75rem" }],
      xl: ["1.25rem", { lineHeight: "1.75rem" }],
      "2xl": ["1.5rem", { lineHeight: "2rem" }],
      "3xl": ["1.875rem", { lineHeight: "2.25rem" }],
      "4xl": ["2.25rem", { lineHeight: "2.5rem" }],
      "5xl": ["3rem", { lineHeight: "1" }],
      "6xl": ["3.75rem", { lineHeight: "1" }],
      "7xl": ["4.5rem", { lineHeight: "1" }],
      "8xl": ["6rem", { lineHeight: "1" }],
      "9xl": ["8rem", { lineHeight: "1" }],
    },
    typography: typographyStyles,
    extend: {
      colors: {
        navy: {
          50: "#e9f9ff",
          100: "#cef0ff",
          200: "#a7e6ff",
          300: "#6bdbff",
          400: "#26c2ff",
          500: "#009aff",
          600: "#0070ff",
          700: "#0055ff",
          800: "#0048e6",
          900: "#0043b3",
          950: "#001d4a", // base
        },
        mauve: {
          50: "#faf5ff",
          100: "#f3e8ff",
          200: "#ead6fe",
          300: "#d9b5fd",
          400: "#cc9dfb", // base
          500: "#a658f4",
          600: "#8e36e7",
          700: "#7825cb",
          800: "#6423a6",
          900: "#511e85",
          950: "#350962",
        },
        lilac: {
          50: "#fdf5fe",
          100: "#fbebfc",
          200: "#f7d6f8",
          300: "#f3b9f3", // base
          400: "#ea88e8",
          500: "#db5ad9",
          600: "#be3bb9",
          700: "#9d2e97",
          800: "#81277b",
          900: "#6a2564",
          950: "#450d40",
        },
        lace: {
          50: "#fef5fe",
          100: "#fbebfc",
          200: "#f9dcf9", // base
          300: "#f1b6ed",
          400: "#e88ae2",
          500: "#d95cd1",
          600: "#bc3db1",
          700: "#9c2f91",
          800: "#802876",
          900: "#692660",
          950: "#440e3c",
        },
        energy: {
          50: "#fefce8",
          100: "#fffac2",
          200: "#fff089",
          300: "#ffe45c", // base
          400: "#fdcd12",
          500: "#ecb306",
          600: "#cc8a02",
          700: "#a36105",
          800: "#864c0d",
          900: "#723e11",
          950: "#432005",
        },
      },
      boxShadow: {
        glow: "0 0 4px rgb(0 0 0 / 0.1)",
      },
      maxWidth: {
        lg: "33rem",
        "2xl": "40rem",
        "3xl": "50rem",
        "5xl": "66rem",
      },
      opacity: {
        1: "0.01",
        2.5: "0.025",
        7.5: "0.075",
        15: "0.15",
      },
    },
  },
  extend: {
    spacing: {
      px: rem(1), // 1px,
      "-0.5": rem(-2),
      0: rem(0),
      2.5: rem(10), // 0.625rem
      4.5: rem(18), // 1.125rem
      7.5: rem(30), // 1.875rem
      13: rem(52), // 3.25rem
      15: rem(60), // 3.75rem
      18: rem(72), // 4.5rem
      38: rem(152), // 9.5 rem
      ...defaultTheme.spacing,
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    require("@tailwindcss/typography"),
    require("@tailwindcss/container-queries"),
  ],
};
