<template>
    <div id="app" class="app-container">
        <!-- Landing Page -->
        <div v-if="currentStep === 0" class="landing-page">
            <h1>Welcome Touti!</h1>
            <button @click="startHunt" class="start-button">Get Started</button>
        </div>

        <!-- Congratulatory Message -->
        <div v-else-if="huntCompleted" class="congrats-container">
            <h1>Congrats Touti! Enjoy your tea!</h1>
            <canvas id="confetti-canvas"></canvas>
            <div v-if="showMessage" class="message-container">
                <h2>Oh and one more thing - here's something I wrote for you:</h2>
                <p>{{ personalMessage }}</p>
            </div>
        </div>

        <!-- Riddle Steps -->
        <div v-else class="riddles-container">
            <transition-group name="fade" tag="div">
                <div v-for="(riddle, index) in riddles" :key="index" class="riddle-section"
                    :class="{ 'solved-riddle': riddle.isSolved }" v-show="currentStep > index">
                    <h2>Riddle {{ index + 1 }}</h2>
                    <p>{{ riddle.question }}</p>
                    <input type="text" v-model="riddle.userAnswer" placeholder="Enter your answer"
                        @keyup.enter="checkAnswer(index)" />
                    <button v-if="!riddle.isSolved" @click="checkAnswer(index)" class="submit-button">Submit</button>
                    <p v-if="riddle.isSolved" class="location-message">{{ riddle.locationMessage }}</p>
                    <p v-else-if="riddle.hasAttempted && !riddle.isSolved" class="error-message">Incorrect! Try again.
                    </p>
                    <button v-if="riddle.isSolved && currentStep === index + 1 && index < riddles.length - 1"
                        @click="nextRiddle" class="next-button">Next Riddle</button>
                    <button v-if="riddle.isSolved && index === riddles.length - 1" @click="completeHunt"
                        class="next-button">I'm a Tokii</button>
                </div>
            </transition-group>
        </div>

        <!-- Add this button for testing purposes -->
        <!-- <button @click="bypassRiddles" class="bypass-button">Bypass Riddles</button> -->
    </div>
</template>

<script>
import confetti from 'canvas-confetti';

export default {
    name: "ScavengerHunt",
    data() {
        return {
            currentStep: 0,
            huntCompleted: false,
            showMessage: false,
            personalMessage: "This is a placeholder for a cute message you want to write.",
            riddles: [
                {
                    question: "🌟 Let's start with something simple! Practice your Arabic: What does \"chajrit 3id\" mean? 🎄",
                    answer: "christmas tree",
                    userAnswer: "",
                    isSolved: false,
                    hasAttempted: false,
                    locationMessage: "🎄 Let's kick things off at Covent Garden with a dazzling Christmas Tree!"
                },
                {
                    question: "🏛️ Time to test your architecture vocabulary! What do we call a corridor formed by a line of arches? 🤔",
                    answer: "arcades",
                    userAnswer: "",
                    isSolved: false,
                    hasAttempted: false,
                    locationMessage: "✨ Time to wander through the cool arcades on Piccadilly and Burlington!"
                },
                {
                    question: "🎉 You're doing great, Touti! Our next stop is a seasonal village you only see at year's end. Where are we going? 🎄",
                    answer: "christmas market",
                    userAnswer: "",
                    isSolved: false,
                    hasAttempted: false,
                    locationMessage: "🎪 Hyde Park Winter Wonderland is calling! Let's dive into the festive fun!"
                },
                {
                    question: "🎂 I love traditions! I usually celebrate birthdays 3 days later, but this year, I'm keeping another tradition. What are we doing next? 🧁",
                    answer: "cupcakes",
                    userAnswer: "",
                    isSolved: false,
                    hasAttempted: false,
                    locationMessage: "🧁 Sweet tooth alert! Let's grab some cupcakes at Lola's in Selfridges!"
                },
                {
                    question: "🍵 Last riddle, Touti! After a long day, let's relax with a warm drink. Imagine your favorite morning drink and \"Drops of God\" had a kid... where are we heading? 🇯🇵",
                    answer: "japanese tea",
                    userAnswer: "",
                    isSolved: false,
                    hasAttempted: false,
                    locationMessage: "🍵 Chill out with some Japanese tea at TOKii. Perfect way to wrap up our adventure!"
                },
            ],
        };
    },
    methods: {
        startHunt() {
            this.currentStep = 1;
        },
        checkAnswer(index) {
            const riddle = this.riddles[index];
            riddle.hasAttempted = true;
            if (riddle.userAnswer.trim().toLowerCase() === riddle.answer.toLowerCase()) {
                riddle.isSolved = true;
            } else {
                riddle.isSolved = false;
            }
        },
        nextRiddle() {
            this.currentStep++;
        },
        completeHunt() {
            this.huntCompleted = true;
            this.launchConfetti();
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
            this.riddles.forEach(riddle => {
                riddle.isSolved = true;
                riddle.hasAttempted = true;
            });
            this.currentStep = this.riddles.length;
        }
    },
};
</script>

<style scoped>
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