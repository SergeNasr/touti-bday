<template>
  <div>
    <div v-if="!isAuthenticated">
      <span>What's our password, Pumpsky? 🐟</span>
      <form @submit.prevent="checkPassword">
        <input type="password" v-model="passwordInput" placeholder="Enter password" />
        <button type="submit">Submit</button>
      </form>
    </div>
    <div v-else>
      <p>I know you need space, but I thought if you visited this page, I could allow myself to speak to you.</p>
      <p>As much as I hate the current circumstances, I can’t help but think they were necessary—at least for me. I messed up, Touti. Not just last week, but over the last few weeks. I was too focused on myself and didn’t realize how much I was hurting you. I wasn’t a good partner. Hearing you say you haven’t been able to sleep, you’re stressed, and you’ve lost your spark—it hit me hard. It was the wake-up call I needed. I was selfish. I created uncertainty in this relationship, and that drained you. I wasn’t invested the way you were, and that hurt you. Who would want to stay with someone who doesn’t see a future with them?</p>
      <p>But the fact that you reconsidered gives me hope. It makes me believe you still see a future for us. And if we’re going to make this work, I know you need to feel that this relationship is stable, secure, and consistent. You need to know your needs will be met. You need to feel that we can grow in ways that matter to you.</p>
      <p>From my side, I’m committed—fully. That’s it. I’ve decided to stop being stuck in my head, creating problems that don’t exist. The past is behind me. I’m only looking forward. Honestly, I was worried at first that this was just fear or anxiety talking. But the sadness I’ve felt over the last three days—real sadness, like something was dying inside me—wiped out all those doubts. This isn’t some overnight change of heart. It’s something that’s been 6 months in the making. I can tell you more about how I got here if you want, but what matters is that things are different now.</p>
      <p>What changed? I realized I’ve been too passive—thinking therapy alone or just waiting would fix everything. That was wrong. What was going to fix this was not just therapy, or reading books. It was a decision. A life-long commitment. That choice has shifted everything for me. Yesterday, when those old thoughts started creeping in, I completely obliterated them. I didn't even let them bother for more than a sec. I'm in the driver’s seat now. I want to be the partner you deserve, if you’re willing to give me another chance.</p>
      <p>I see it all, baby. I want the whole thing with you. Let’s not stop this story now, just as things are about to get better. It’s within reach.</p>
    <p>Forever, Sousou 🌹</p>

    </div>
  </div>
</template>

<script>
export default {
  name: "ApologyComponent",
  data() {
    return {
      passwordInput: '',
      isAuthenticated: false,
    };
  },
  methods: {
    async checkPassword() {
      const correctPasswordHash = '6bfe62b61291148d023c528b899c426e95ab719a6349e1869eeb3fc8fe93eacc'; 
      
      const encoder = new TextEncoder();
      const data = encoder.encode(this.passwordInput.toLowerCase());
      const hashBuffer = await crypto.subtle.digest('SHA-256', data);
      const hashArray = Array.from(new Uint8Array(hashBuffer));
      const hashHex = hashArray.map(b => b.toString(16).padStart(2, '0')).join('');

      if (hashHex === correctPasswordHash) {
        this.isAuthenticated = true;
      } else {
        alert('Incorrect password');
      }
    },
  },
};
</script>

<style scoped>
/* Add any styles you need here */
</style>
