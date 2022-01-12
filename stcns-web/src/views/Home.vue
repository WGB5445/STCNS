<template>
  <div class="home">
    <button type="button" @click="initialize">初始化</button>
    <button type="button" @click="test">链接</button>
    <!-- <img alt="Vue logo" src="../assets/logo.png"> -->
    <!-- <HelloWorld msg="Welcome to Your Vue.js App"/> -->
  </div>
</template>

<script>
// @ is an alias to /src
import { providers, utils, bcs, encoding, version as starcoinVersion } from '@starcoin/starcoin'
import HelloWorld from '@/components/HelloWorld.vue'

export default {
  name: 'Home',
  components: {
    HelloWorld
  },
  data(){
    return {
        starcoinProvider:null
      }
  }
  ,
  methods:{
    async test (){
      const newAccounts = await window.starcoin.request({
        method: 'stc_requestAccounts',
      })
    }
    ,
    initialize: function (){
      console.log('initialize')
      try {
        if (window.starcoin) {
          // We must specify the network as 'any' for starcoin to allow network changes
          this.starcoinProvider = new providers.Web3Provider(window.starcoin, 'any')
          
        }
      } catch (error) {
        console.error(error)
      }
    }
  }
}
</script>
