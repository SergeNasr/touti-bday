<template>
    <div class="riddle-section" :class="{ 'solved-riddle': isSolved }" >
        <h2>Riddle {{ riddle.index }}</h2>
        <p>{{ riddle.question }}</p>
        <input type="text" v-model="userAnswer" placeholder="Enter your answer" @keyup.enter="checkAnswer" />
        <button v-if="!isSolved" @click="checkAnswer" class="submit-button">Submit</button>
        <p v-if="isSolved" class="location-message">{{ riddle.locationMessage }}</p>
        <p v-else-if="hasAttempted && !isSolved" class="error-message">Incorrect! Try again.</p>
        <button v-if="isSolved && currentStep == riddle.index" @click="$emit('next-riddle')" class="next-button">Next Riddle</button>
    </div>
</template>

<script>
export default {
    name: 'RiddleComponent',
    props: {
        riddle: Object,
        currentStep: Number
    },
    data() {
        return {
            isSolved: false,
            hasAttempted: false,
            userAnswer: ''
        };
    },
    methods: {
        checkAnswer() {
            this.hasAttempted = true;
            if (this.userAnswer.trim().toLowerCase() === this.riddle.answer.toLowerCase()) {
                this.isSolved = true;
            } else {
                this.isSolved = false;
            }
            this.$emit('solved', this.isSolved);
        }
    }
};
</script>