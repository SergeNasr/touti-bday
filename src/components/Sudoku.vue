<template>
    <div class="sudoku-container">
        <table>
            <tr v-for="(row, rowIndex) in grid" :key="'row-' + rowIndex">
                <td v-for="(cell, cellIndex) in row" :key="'cell-' + rowIndex + '-' + cellIndex">
                    <input v-if="cell === null" type="number" v-model.number="tempGrid[rowIndex][cellIndex]"
                        maxlength="1" style="width: 100%; height: 100%; text-align: center; border: none;"
                        @input="validateInput($event, rowIndex, cellIndex)" />
                    <span v-else>{{ cell }}</span>
                </td>
            </tr>
        </table>
        <button v-if="!isSolved" @click="validate" class="submit-button">Check Sudoku</button>
    </div>
</template>

<script>
export default {
    name: "SudokuGrid",
    data() {
        return {
            grid: [
                [null, 6, 5, 9, 8, 4, 3, 7, 2],
                [3, 8, 2, 1, 5, 7, 6, 9, 4],
                [7, 9, 4, 6, null, 3, 8, 1, 5],
                [8, 2, 1, 3, 4, 9, 5, 6, 7],
                [4, 3, 7, null, 6, 1, 9, 2, 8],
                [6, 5, 9, 8, 7, 2, 4, 3, 1],
                [2, 7, 8, 4, null, 6, 1, 5, 3],
                [9, 4, 3, 2, 1, 5, 7, 8, null],
                [5, 1, 6, 7, 3, 8, 2, 4, 9],
            ],
            tempGrid: [
                [null, 6, 5, 9, 8, 4, 3, 7, 2],
                [3, 8, 2, 1, 5, 7, 6, 9, 4],
                [7, 9, 4, 6, null, 3, 8, 1, 5],
                [8, 2, 1, 3, 4, 9, 5, 6, 7],
                [4, 3, 7, null, 6, 1, 9, 2, 8],
                [6, 5, 9, 8, 7, 2, 4, 3, 1],
                [2, 7, 8, 4, null, 6, 1, 5, 3],
                [9, 4, 3, 2, 1, 5, 7, 8, null],
                [5, 1, 6, 7, 3, 8, 2, 4, 9],
            ],
            isSolved: false,
        };
    },
    methods: {
        validateInput(event, rowIndex, cellIndex) {
            const value = event.target.value;
            if (!/^[1-9]?$/.test(value)) {
                this.tempGrid[rowIndex][cellIndex] = null;
            }
        },
        validate() {
            this.isSolved = this.checkRows() && this.checkColumns() && this.checkBoxes();
            if (this.isSolved) {
                this.$emit('solved');
            }
        },
        checkRows() {
            return this.tempGrid.every(row => new Set(row.filter(cell => cell !== null)).size === 9);
        },
        checkColumns() {
            for (let i = 0; i < 9; i++) {
                const column = this.tempGrid.map(row => row[i]).filter(cell => cell !== null);
                if (new Set(column).size !== 9) return false;
            }
            return true;
        },
        checkBoxes() {
            for (let boxRow = 0; boxRow < 3; boxRow++) {
                for (let boxCol = 0; boxCol < 3; boxCol++) {
                    const box = [];
                    for (let i = 0; i < 3; i++) {
                        for (let j = 0; j < 3; j++) {
                            box.push(this.tempGrid[boxRow * 3 + i][boxCol * 3 + j]);
                        }
                    }
                    if (new Set(box.filter(cell => cell !== null)).size !== 9) return false;
                }
            }
            return true;
        }
    }
};
</script>

<style scoped>
table {
    border-collapse: collapse;
    margin: 20px auto;
}

td {
    width: 40px;
    height: 40px;
    text-align: center;
    font-size: 20px;
    border: 1px solid #000;
    position: relative;
}

input {
    font-size: 20px;
    text-align: center;
    border: 1px solid #000;
    outline: none;
    background-color: transparent;
    width: 100%;
    height: 100%;
    box-sizing: border-box;
    font-weight: bold;
    color: blue;
}

/* Add bold borders for 3x3 regions */
td:nth-child(3n+1) {
    border-left: 3px solid black;
}

td:nth-child(3n) {
    border-right: 3px solid black;
}

tr:nth-child(3n+1) td {
    border-top: 3px solid black;
}

tr:nth-child(3n) td {
    border-bottom: 3px solid black;
}

.submit-button {
    margin-top: 10px;
    padding: 10px 15px;
    font-size: 1em;
    background-color: #2ecc71;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    transition: background-color 0.3s;
}

.submit-button:hover {
    background-color: #27ae60;
}
</style>