<template>
    <div id="app" class="app-container">
        <!-- Landing Page -->
        <div v-if="currentStep === 0" class="landing-page">
            <h1>Hoaiiii Touti!</h1>
            <p>
                On May 13th, 2024, you sent me the following text:
            </p>
            <br>
            <img src="@/assets/touti-screenshot.png" alt="Touti Screenshot" class="screenshot-image"
                style="width: 75%;" />
            <p>
                The context of the conversation is irrelevant.<br>
                All you need to know is that I took a screenshot of this message and been waiting for the perfect
                opportunity to use it.
            </p>
            <br>
            <p>
                It's December 5th, 2024 - a very special date.<br>
                Today is not only your birthday, but also the day we put your skills to the test!
            </p>
            <br>
            <p>
                Without further ado, here's what we're going to do.
            </p>
            <br>
            <p>
                We will be embarking on a journey, together. A scavenger hunt in London.<br>
                In order for us to know our destination, you'll have to solve a riddle.<br>
                Solve the riddle and you unlock a new step in our journey.<br>
                Fail to do so and we're stuck in London.<br>
            </p>
            <button @click="startHunt" class="start-button">Let the games begin</button>
        </div>

        <!-- Congratulatory Message -->
        <div v-else-if="huntCompleted" class="congrats-container">
            <h1>Congrats Touti, you solved all the riddles!</h1>
            <canvas id="confetti-canvas"></canvas>
            <div v-if="showMessage" class="message-container">
                <h2>Oh and one more thing - here's something I wrote for you...</h2>
            </div>
        </div>

        <!-- Riddle Steps -->
        <div v-else class="riddles-container">
            <transition-group name="fade" tag="div">
                <RiddleComponent
                    v-for="(riddle, index) in renderedRidles()"
                    :key="index"
                    :riddle="riddle"
                    :currentStep="currentStep"
                    @solved="updateSolvedState(index, $event)"
                    @next-riddle="nextRiddle"
                />
                <div v-if="currentStep === riddles.length + 1" class="riddle-section"
                    :class="{ 'solved-riddle': finalRiddleSolved }">
                    <h2>Riddle 5</h2>
                    <SudokuGrid @solved="handleSudokuSolved" />
                    <div v-if="sudokuSolved">
                        <p>
                            Well done Touti! Sudoku solved!<br>
                            You had to input the numbers: 1 2 5 9 6<br>
                            Wait.... We can combine these the following way: 12 5 96<br>
                            Oh sneaky... 12/5/96<br>
                            <br>
                            Anyway - Sudokus as we know them today were created in Japan.<br>
                            Can you guess what's the next and final destination?
                        </p>
                        <input type="text" v-model="finalRiddleAnswer" placeholder="Enter your answer"
                            @keyup.enter="checkFinalAnswer" />
                        <button v-if="!finalRiddleSolved" @click="checkFinalAnswer"
                            class="submit-button">Submit</button>
                        <p v-if="finalRiddleSolved">
                            Well done Touti, you're going to Tokii for your afternoon tea! Yey perfect way to wrap up
                            our adventure! 🍵<br>
                            Once you're there, click on the button below to complete the hunt!<br>
                        </p>
                        <button v-if="finalRiddleSolved" @click="completeHunt" class="next-button">I'm a Tokii</button>
                    </div>
                </div>
            </transition-group>
        </div>

        <!-- Add this button for testing purposes -->
        <!-- <button @click="bypassRiddles" class="bypass-button">Bypass Riddles</button> -->
    </div>
</template>

<script>
import RiddleComponent from './Riddle.vue';
import confetti from 'canvas-confetti';
import SudokuGrid from './Sudoku.vue';

export default {
    name: "ScavengerHunt",
    components: {
        SudokuGrid,
        RiddleComponent
    },
    data() {
        return {
            currentStep: 0,
            huntCompleted: false,
            showMessage: false,
            riddles: [
                {
                    index: 1,
                    question: "🌟 Let's start with something simple! Practice your Arabic: What does \"chajrit 3id\" mean? 🎄",
                    answer: "christmas tree",
                    locationMessage: "🎄 Let's kick things off at Covent Garden with a dazzling Christmas Tree!"
                },
                {
                    index: 2,
                    question: "🏛️ Time to test your architecture vocabulary! What do we call a corridor formed by a line of arches? 🤔",
                    answer: "arcades",
                    userAnswer: "",
                    locationMessage: "✨ Time to wander through the cool arcades on Piccadilly and Burlington!"
                },
                {
                    index: 3,
                    question: "🎉 You're doing great, Touti! Our next stop is a seasonal village you only see at year's end. Where are we going? 🎄",
                    answer: "christmas market",
                    locationMessage: "🎪 Hyde Park Winter Wonderland is calling! Let's dive into the festive fun!"
                },
                {
                    index: 4,
                    question: "🎂 I love traditions! I usually celebrate birthdays 3 days later, but this year, I'm keeping another tradition. What are we doing next? 🧁",
                    answer: "cupcakes",
                    locationMessage: "🧁 Sweet tooth alert! Let's grab some cupcakes at Lola's in Selfridges!"
                }
            ],
            solvedRiddles: new Set(),
            sudokuSolved: false,
            finalRiddleAnswer: "",
            finalRiddleSolved: false,
        };
    },
    methods: {
        startHunt() {
            this.currentStep = 1;
        },
        nextRiddle() {
            this.currentStep++;
        },
        completeHunt() {
            this.huntCompleted = true;
            this.launchConfetti();
        },
        updateSolvedState(index, isSolved) {
            if (isSolved) {
                this.solvedRiddles.add(index);
            } else {
                this.solvedRiddles.delete(index);
            }
        },
        renderedRidles() {
            return this.riddles.filter((riddle, index) => this.solvedRiddles.has(index) || this.currentStep > index);
        },
        launchConfetti() {
            const duration = 5 * 1000;
            const animationEnd = Date.now() + duration;
            const defaults = { startVelocity: 30, spread: 360, ticks: 60, zIndex: 0 };

            function randomInRange(min, max) {
                return Math.random() * (max - min) + min;
            }

            const interval = setInterval(() => {
                const timeLeft = animationEnd - Date.now();

                if (timeLeft <= 0) {
                    clearInterval(interval);
                    this.showMessage = true;
                }

                const particleCount = 50 * (timeLeft / duration);
                confetti(Object.assign({}, defaults, { particleCount, origin: { x: randomInRange(0.1, 0.3), y: Math.random() - 0.2 } }));
                confetti(Object.assign({}, defaults, { particleCount, origin: { x: randomInRange(0.7, 0.9), y: Math.random() - 0.2 } }));
            }, 250);
        },
        bypassRiddles() {
            this.riddles.forEach((riddle, index) => {
                this.solvedRiddles.add(index);
            });
            this.currentStep = this.riddles.length;
        },
        handleSudokuSolved() {
            this.sudokuSolved = true;
        },
        checkFinalAnswer() {
            if (this.finalRiddleAnswer.trim().toLowerCase() === "tokii") {
                this.finalRiddleSolved = true;
            }
        },
    },
};
</script>

<style>
.app-container {
    max-width: 600px;
    margin: 0 auto;
    padding: 20px;
    text-align: center;
    font-family: 'Arial, sans-serif';
}

.landing-page {
    margin-top: 50px;
    transition: opacity 0.5s ease-in-out;
}

.start-button {
    padding: 10px 20px;
    font-size: 1.2em;
    background-color: #3498db;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    transition: background-color 0.3s;
}

.start-button:hover {
    background-color: #2980b9;
}

.riddles-container {
    margin-top: 20px;
}

.riddle-section {
    margin-bottom: 40px;
    padding: 20px;
    border: 1px solid #ccc;
    border-radius: 8px;
    background-color: #f0f8ff;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    transition: transform 0.5s ease-in-out;
}

.riddle-section:hover {
    transform: scale(1.05);
}

input[type="text"] {
    padding: 10px;
    margin-top: 10px;
    font-size: 1em;
    width: 80%;
    border: 1px solid #ccc;
    border-radius: 4px;
    transition: border-color 0.3s;
}

input[type="text"]:focus {
    border-color: #3498db;
    outline: none;
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

.success-message {
    color: #27ae60;
    margin-top: 10px;
    font-weight: bold;
    transition: opacity 0.5s;
}

.error-message {
    color: #e74c3c;
    margin-top: 10px;
    font-weight: bold;
    transition: opacity 0.5s;
}

.fade-enter-active,
.fade-leave-active {
    transition: opacity 0.5s;
}

.fade-enter,
.fade-leave-to {
    opacity: 0;
}

.next-button {
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

.next-button:hover {
    background-color: #27ae60;
}

.congrats-container {
    margin-top: 50px;
    text-align: center;
}

#confetti-canvas {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    pointer-events: none;
    z-index: 1000;
}

.location-message {
    color: #3498db;
    margin-top: 10px;
    font-weight: bold;
    transition: opacity 0.5s;
}

.message-container {
    margin-top: 20px;
    padding: 20px;
    border: 1px solid #ccc;
    border-radius: 8px;
    background-color: #f0f8ff;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.solved-riddle {
    background-color: #d4edda;
    border-color: #c3e6cb;
}
</style>