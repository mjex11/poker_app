module.exports = {
    root: true,
    env: {
        browser: true,
        es2021: true,
        node: true,
        jquery: true,
    },
    extends: ['eslint:recommended', 'prettier'],
    parserOptions: {
        ecmaVersion: 'latest',
        sourceType: 'module',
    },
    ignorePatterns: [
        '**/app/assets/builds/application.js',
        '**/vendor/**',
        '**/node_modules/**',
    ],
}
