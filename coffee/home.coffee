require './utils/canvas_polyfill'

canvas = document.getElementById 'canvas'
ctx = canvas.getContext '2d'

WIDTH = canvas.clientWidth
HEIGHT = canvas.clientHeight
DENSITY = 0.2
COLOR = '#23BBD9'
OPACITY = 0.6
SPEED = 0.05

particalCount = HEIGHT * DENSITY