"""Block Blast del taller: Python 3 + Tkinter, sin paquetes externos.

Ejecute: python block_blast_tkinter.py
Pruebe la logica sin abrir ventanas: python block_blast_tkinter.py --self-test
Coordenadas de 1 a 5, las mismas que en el taller de Prolog.
"""

import sys

SIZE = 5
PIECES = {
    "single": ((0, 0),),
    "horizontal2": ((0, 0), (0, 1)),
    "vertical2": ((0, 0), (1, 0)),
    "square2": ((0, 0), (0, 1), (1, 0), (1, 1)),
    "corner3": ((0, 0), (1, 0), (1, 1)),
    "horizontal3": ((0, 0), (0, 1), (0, 2)),
    "t4": ((0, 0), (0, 1), (0, 2), (1, 1)),
    "z4": ((0, 0), (0, 1), (1, 1), (1, 2)),
}
NAMES = {
    "single": "Una celda", "horizontal2": "Domino horizontal",
    "vertical2": "Domino vertical", "square2": "Cuadrado 2 x 2",
    "corner3": "Esquina", "horizontal3": "Tres horizontales",
    "t4": "Pieza T", "z4": "Pieza Z",
}
PRESETS = {
    "Vacio": set(),
    "Centro ocupado": {(3, 3)},
    "Casi completo": {(1, 1), (1, 2), (1, 3), (2, 5), (3, 5), (4, 5), (5, 5)},
    "Lleno": {(r, c) for r in range(1, SIZE + 1) for c in range(1, SIZE + 1)},
}


class Game:
    def __init__(self, preset="Casi completo"):
        self.reset(preset)

    def reset(self, preset):
        self.board = set(PRESETS[preset])
        self.history = []

    def cells(self, name, origin):
        r, c = origin
        return {(r + dr, c + dc) for dr, dc in PIECES[name]}

    def fits(self, name, origin):
        cells = self.cells(name, origin)
        return (all(1 <= r <= SIZE and 1 <= c <= SIZE for r, c in cells)
                and not cells.intersection(self.board))

    def origins(self, name):
        return [(r, c) for r in range(1, SIZE + 1) for c in range(1, SIZE + 1)
                if self.fits(name, (r, c))]

    def place(self, name, origin):
        if not self.fits(name, origin):
            return False
        self.history.append(set(self.board))
        self.board.update(self.cells(name, origin))
        return True

    def lines(self):
        rows = [r for r in range(1, SIZE + 1)
                if all((r, c) in self.board for c in range(1, SIZE + 1))]
        cols = [c for c in range(1, SIZE + 1)
                if all((r, c) in self.board for r in range(1, SIZE + 1))]
        return rows, cols

    def clear_lines(self):
        rows, cols = self.lines()
        if not rows and not cols:
            return False
        self.history.append(set(self.board))
        self.board = {(r, c) for r, c in self.board if r not in rows and c not in cols}
        return True

    def undo(self):
        if not self.history:
            return False
        self.board = self.history.pop()
        return True

    def prolog(self):
        cells = ",".join(f"cell({r},{c})" for r, c in sorted(self.board))
        return f"board(demo_board, [{cells}])."


class App:
    CELL = 72
    MARGIN = 40

    def __init__(self, root):
        import tkinter as tk
        from tkinter import ttk
        self.tk, self.ttk = tk, ttk
        self.root = root
        self.game = Game()
        self.selected = "horizontal2"
        self.hover = None
        root.title("Block Blast | Taller de Prolog")
        root.geometry("1040x900")
        root.minsize(1000, 860)
        root.configure(bg="#f3f5f9")
        style = ttk.Style(root)
        if "clam" in style.theme_names():
            style.theme_use("clam")
        style.configure("TFrame", background="#f3f5f9")
        style.configure("TLabel", background="#f3f5f9", font=("Arial", 11))
        style.configure("TButton", font=("Arial", 10), padding=7)
        container = ttk.Frame(root, padding=20)
        container.pack(fill="both", expand=True)
        ttk.Label(container, text="Block Blast", font=("Arial", 24, "bold")).pack(anchor="w")
        ttk.Label(container, text="Seleccione una pieza y haga clic en su origen. Coordenadas de 1 a 5.").pack(anchor="w", pady=(4, 14))

        toolbar = ttk.Frame(container)
        toolbar.pack(fill="x", pady=(0, 12))
        ttk.Label(toolbar, text="Tablero:").pack(side="left", padx=(0, 8))
        self.preset = tk.StringVar(value="Casi completo")
        ttk.Combobox(toolbar, textvariable=self.preset, values=list(PRESETS),
                     state="readonly", width=20).pack(side="left")
        ttk.Button(toolbar, text="Cargar / reiniciar", command=self.reset).pack(side="left", padx=8)
        self.undo_button = ttk.Button(toolbar, text="Deshacer", command=self.undo)
        self.undo_button.pack(side="left")
        ttk.Button(toolbar, text="Copiar tablero para Prolog", command=self.copy_prolog).pack(side="right")

        body = ttk.Frame(container)
        body.pack(fill="both", expand=True)
        side = self.MARGIN * 2 + SIZE * self.CELL
        self.canvas = tk.Canvas(body, width=side, height=side, bg="white", highlightthickness=0)
        self.canvas.pack(side="left", anchor="n")
        panel = ttk.Frame(body, padding=(20, 0, 0, 0))
        panel.pack(side="left", fill="both", expand=True)
        ttk.Label(panel, text="Catalogo de piezas", font=("Arial", 14, "bold")).pack(anchor="w")
        grid = ttk.Frame(panel)
        grid.pack(anchor="w", pady=8)
        self.buttons = {}
        for i, name in enumerate(PIECES):
            card = tk.Frame(grid, bg="white", bd=1, relief="solid")
            card.grid(row=i // 3, column=i % 3, padx=(0, 8), pady=(0, 8), sticky="nsew")
            icon = tk.Canvas(card, width=105, height=48, bg="white", highlightthickness=0)
            icon.pack()
            for dr, dc in PIECES[name]:
                x, y = 10 + dc * 18, 7 + dr * 18
                icon.create_rectangle(x, y, x + 15, y + 15, fill="#3976dc", outline="")
            icon.bind("<Button-1>", lambda event, n=name: self.select(n))
            button = tk.Button(card, text=NAMES[name], width=13, wraplength=100, font=("Arial", 9),
                               relief="flat", command=lambda n=name: self.select(n))
            button.pack(fill="x")
            self.buttons[name] = button

        self.hints = tk.BooleanVar(value=True)
        ttk.Checkbutton(panel, text="Mostrar origenes validos", variable=self.hints,
                        command=self.render).pack(anchor="w", pady=(4, 8))
        self.summary = tk.StringVar()
        ttk.Label(panel, textvariable=self.summary, wraplength=300, justify="left").pack(anchor="w", pady=8)
        self.line_text = tk.StringVar()
        ttk.Label(panel, textvariable=self.line_text, wraplength=300, justify="left").pack(anchor="w", pady=4)
        self.clear_button = ttk.Button(panel, text="Eliminar lineas completas", command=self.clear_lines)
        self.clear_button.pack(anchor="w", pady=(8, 12))
        ttk.Label(panel, text="Verde: colocacion valida. Rojo: no cabe.\n"
                  "Puntos naranjas: origenes posibles.\n"
                  "Borde azul: linea completa.\n\n"
                  "Sin rotaciones. Las lineas se conservan hasta que usted pulse el boton de eliminacion.",
                  wraplength=300, justify="left").pack(anchor="w")
        self.message = tk.StringVar(value="Pruebe el domino horizontal en fila 1, columna 4.")
        ttk.Label(container, textvariable=self.message, wraplength=860,
                  font=("Arial", 11, "bold")).pack(anchor="w", pady=(10, 0))

        self.canvas.bind("<Motion>", self.motion)
        self.canvas.bind("<Leave>", self.leave)
        self.canvas.bind("<Button-1>", self.click)
        root.bind("<Control-z>", lambda event: self.undo())
        root.bind("<Command-z>", lambda event: self.undo())
        self.refresh()

    def origin_at(self, event):
        col = (event.x - self.MARGIN) // self.CELL + 1
        row = (event.y - self.MARGIN) // self.CELL + 1
        return (row, col) if 1 <= row <= SIZE and 1 <= col <= SIZE else None

    def motion(self, event):
        origin = self.origin_at(event)
        if origin != self.hover:
            self.hover = origin
            self.render()

    def leave(self, event):
        self.hover = None
        self.render()

    def click(self, event):
        origin = self.origin_at(event)
        if origin is None:
            return
        if self.game.place(self.selected, origin):
            self.message.set(f"Colocada {self.selected} en cell({origin[0]},{origin[1]}).")
            self.refresh()
        else:
            self.message.set("Jugada invalida: la pieza se superpone o sale del tablero.")

    def select(self, name):
        self.selected = name
        self.message.set(f"Seleccionada {name}. Haga clic en el origen de la pieza.")
        self.refresh()

    def reset(self):
        self.game.reset(self.preset.get())
        self.hover = None
        self.message.set("Tablero reiniciado.")
        self.refresh()

    def undo(self):
        self.message.set("Accion deshecha." if self.game.undo() else "No hay acciones para deshacer.")
        self.refresh()

    def clear_lines(self):
        self.message.set("Lineas eliminadas." if self.game.clear_lines() else "No hay lineas completas.")
        self.refresh()

    def copy_prolog(self):
        self.root.clipboard_clear()
        self.root.clipboard_append(self.game.prolog())
        self.message.set("Copiado: board(demo_board, [...]). Pegue el hecho en su programa Prolog.")

    def refresh(self):
        origins = self.game.origins(self.selected)
        total = sum(len(self.game.origins(name)) for name in PIECES)
        self.summary.set(f"Pieza: {self.selected}\nPosiciones validas: {len(origins)}\n"
                         f"Jugadas del catalogo: {total}\nCeldas ocupadas: {len(self.game.board)} / 25")
        rows, cols = self.game.lines()
        self.line_text.set(f"Filas completas: {', '.join(map(str, rows)) or 'ninguna'}\n"
                           f"Columnas completas: {', '.join(map(str, cols)) or 'ninguna'}")
        self.clear_button.configure(state="normal" if rows or cols else "disabled")
        self.undo_button.configure(state="normal" if self.game.history else "disabled")
        for name, button in self.buttons.items():
            button.configure(bg="#3976dc" if name == self.selected else "#edf1f7",
                             fg="white" if name == self.selected else "#202b40")
        self.render()

    def render(self):
        cv = self.canvas
        cv.delete("all")
        rows, cols = self.game.lines()
        preview = self.game.cells(self.selected, self.hover) if self.hover else set()
        valid = self.game.fits(self.selected, self.hover) if self.hover else False
        for index in range(1, SIZE + 1):
            center = self.MARGIN + (index - 0.5) * self.CELL
            cv.create_text(center, 20, text=str(index), fill="#65718a", font=("Arial", 12))
            cv.create_text(20, center, text=str(index), fill="#65718a", font=("Arial", 12))
        for r in range(1, SIZE + 1):
            for c in range(1, SIZE + 1):
                x = self.MARGIN + (c - 1) * self.CELL
                y = self.MARGIN + (r - 1) * self.CELL
                occupied = (r, c) in self.game.board
                fill = "#344a72" if occupied else "#edf1f7"
                if (r, c) in preview:
                    fill = "#6ccca3" if valid else "#ef8b88"
                line = r in rows or c in cols
                cv.create_rectangle(x + 3, y + 3, x + self.CELL - 3, y + self.CELL - 3,
                                    fill=fill, outline="#2878ed" if line else "#d7deeb",
                                    width=3 if line else 1)
        if self.hints.get():
            for r, c in self.game.origins(self.selected):
                x = self.MARGIN + (c - 0.5) * self.CELL
                y = self.MARGIN + (r - 0.5) * self.CELL
                cv.create_oval(x - 4, y - 4, x + 4, y + 4, fill="#d18716", outline="")


def self_test():
    game = Game("Vacio")
    assert len(game.origins("horizontal2")) == 20
    assert len(game.origins("t4")) == 12
    assert len(game.origins("z4")) == 12
    assert game.cells("t4", (1, 1)) == {(1, 1), (1, 2), (1, 3), (2, 2)}
    assert game.cells("z4", (1, 1)) == {(1, 1), (1, 2), (2, 2), (2, 3)}
    assert not game.fits("t4", (5, 1))
    assert not game.fits("z4", (1, 4))
    assert sum(len(game.origins(name)) for name in PIECES) == 136
    assert not game.fits("horizontal2", (1, 5))
    game.reset("Centro ocupado")
    assert not game.fits("square2", (2, 2))
    before = set(game.board)
    assert not game.place("single", (3, 3)) and game.board == before
    assert not game.history
    game.reset("Casi completo")
    assert game.lines() == ([], [])
    initial = set(game.board)
    assert game.place("horizontal2", (1, 4))
    assert game.lines() == ([1], [5])
    placed = set(game.board)
    assert game.clear_lines() and not game.board
    assert game.undo() and game.board == placed
    assert game.undo() and game.board == initial
    assert not game.undo()
    assert game.prolog() == "board(demo_board, [cell(1,1),cell(1,2),cell(1,3),cell(2,5),cell(3,5),cell(4,5),cell(5,5)])."
    game.reset("Lleno")
    assert sum(len(game.origins(name)) for name in PIECES) == 0
    assert game.lines() == ([1, 2, 3, 4, 5], [1, 2, 3, 4, 5])
    assert game.clear_lines() and not game.board
    assert not game.clear_lines()
    print("OK: jugadas, limites, superposicion, lineas, deshacer y exportacion Prolog.")


def main():
    if "--self-test" in sys.argv:
        self_test()
        return
    try:
        import tkinter as tk
    except ImportError:
        print("Tkinter no esta instalado. Use una instalacion de Python con Tcl/Tk.")
        raise SystemExit(1)
    root = tk.Tk()
    App(root)
    root.mainloop()


if __name__ == "__main__":
    main()
