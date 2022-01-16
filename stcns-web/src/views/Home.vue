<template>
  <div class="home">
    <!-- <Sreach msg="Welcome to Your Vue.js App"/> -->
    <!--    <Myaccount :User.sync="User" :module.sync="module" :admin = "admin" />-->
    <HelloWorld :msg="have_starmask"/>

    
    <!-- <img alt="Vue logo" src="../assets/logo.png"> -->
    <!-- <Sreach msg="Welcome to Your Vue.js App"/> -->
  </div>
</template>

<script>
// @ is an alias to /src
import { arrayify, hexlify } from '@ethersproject/bytes'
import BigNumber from 'bignumber.js'

import { providers, utils, bcs, encoding, version as starcoinVersion } from '@starcoin/starcoin'
import { encrypt } from 'eth-sig-util'
import { compare } from 'compare-versions';
import HelloWorld from '@/components/HelloWorld.vue'
import Sreach from '@/components/sreach.vue'
import Myaccount from '@/components/Myaccount.vue'
import {get_account,send_transaction,send_transaction_arg,call} from '../utils/starcoin.js'
export default {
  name: 'Home',
  components: {
    HelloWorld,
    Sreach,
    Myaccount
  },
  
  created(){
      try {
        if (window.starcoin) {
          // We must specify the network as 'any' for starcoin to allow network changes
          this.starcoinProvider = new providers.Web3Provider(window.starcoin, 'any')
          this.starcoin = window.starcoin
          this.have_starmask = true
        }
      } catch (error) {
        console.error(error)
        this.have_starmask = false
      }


  },
  data(){
    return {
       have_starmask : false,
       starcoinProvider : null,
      starcoin : null


    }

  }


}
</script>
