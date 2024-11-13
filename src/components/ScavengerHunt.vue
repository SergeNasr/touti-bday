<template>
    <div id="app" class="app-container">
        <!-- Landing Page -->
        <div v-if="currentStep === 0" class="landing-page">
            <h1>Welcome to the Scavenger Hunt</h1>
            <button @click="startHunt">Get Started</button>
        </div>

        <!-- Riddle Steps -->
        <div v-else class="riddles-container">
            <div v-for="(riddle, index) in riddles" :key="index" class="riddle-section" v-show="currentStep > index">
                <h2>Riddle {{ index + 1 }}</h2>
                <p>{{ riddle.question }}</p>
                <input type="text" v-model="riddle.userAnswer" placeholder="Enter your answer"
                    @keyup.enter="checkAnswer(index)" />
                <button @click="checkAnswer(index)">Submit</button>
                <p v-if="riddle.isSolved" class="success-message">Correct! Scroll down for the next riddle.</p>
            </div>
        </div>
    </div>
</template>

<script>
export default {
    name: "ScavengerHunt",
    data() {
        return {
            currentStep: 0, // Keeps track of the current step the user is on
            riddles: [
                {
                    question: "I speak without a mouth and hear without ears. I have nobody, but I come alive with the wind. What am I?",
                    answer: "echo",
                    userAnswer: "",
                    isSolved: false,
                },
                {
                    question: "The more of this there is, the less you see. What is it?",
                    answer: "darkness",
                    userAnswer: "",
                    isSolved: false,
                },
                {
                    question: "I’m light as a feather, yet the strongest person can’t hold me for five minutes. What am I?",
                    answer: "breath",
                    userAnswer: "",
                    isSolved: false,
                },
                {
                    question: "What has keys but can't open locks?",
                    answer: "piano",
                    userAnswer: "",
                    isSolved: false,
                },
            ],
        };
    },
    methods: {
        startHunt() {
            this.currentStep = 1; // Move to the first riddle
        },
        checkAnswer(index) {
            const riddle = this.riddles[index];
            if (riddle.userAnswer.trim().toLowerCase() === riddle.answer.toLowerCase()) {
                riddle.isSolved = true;
                // Allow the next riddle to show
                if (this.currentStep === index + 1) {
                    this.currentStep++;
                }
            } else {
                riddle.isSolved = false;
            }
        },
    },
};
</script>

<style scoped>
.app-container {
    max-width: 600px;
    margin: 0 auto;
    padding: 20px;
    text-align: center;
}

.landing-page {
    margin-top: 50px;
}

.riddles-container {
    margin-top: 20px;
}

.riddle-section {
    margin-bottom: 40px;
    padding: 20px;
    border: 1px solid #ccc;
    border-radius: 8px;
}

.success-message {
    color: green;
    margin-top: 10px;
}
</style>