<template>
  <div class="home">
    <button type="button" @click="initialize">初始化</button>
    <button type="button" @click="test">链接</button>
    <button type="button" @click="init">init</button>
    <button type="button" @click="register">register</button>
    <button type="button" @click="call">call</button>
    <!-- <img alt="Vue logo" src="../assets/logo.png"> -->
    <!-- <HelloWorld msg="Welcome to Your Vue.js App"/> -->
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
    },
    async init(){
      try {
        const functionId = '0xb87b4d228705e6e481dd21538a819371::STCNS_script::init'
        const strTypeArgs = []
         const tyArgs = utils.tx.encodeStructTypeTags(strTypeArgs)

        const toAccount = "0x57b052EA2d156B01A2596969E7aa4044"
        if (!toAccount) {
          // eslint-disable-next-line no-alert
          window.alert('Invalid To: can not be empty!')
          return false
        }
        console.log({ toAccount })
        let n = 0.01 
        const sendAmount = parseFloat(n, 10)
        // if (!(sendAmount > 0)) {
        //   // eslint-disable-next-line no-alert
        //   window.alert('Invalid sendAmount: should be a number!')
        //   return false
        // }
        
        const BIG_NUMBER_NANO_STC_MULTIPLIER = new BigNumber('1000000000')

        const sendAmountSTC = new BigNumber(String(n), 10)
        const sendAmountNanoSTC = sendAmountSTC.times(BIG_NUMBER_NANO_STC_MULTIPLIER)
        const sendAmountHex = `0x${ sendAmountNanoSTC.toString(16) }`
        
        // // Multiple BcsSerializers should be used in different closures, otherwise, the latter will be contaminated by the former.
        const amountSCSHex = (function () {
          const se = new bcs.BcsSerializer()
          // eslint-disable-next-line no-undef
          se.serializeU128(BigInt(sendAmountNanoSTC.toString(10)))
          return hexlify(se.getBytes())
        })()
        console.log({ sendAmountHex, sendAmountNanoSTC: sendAmountNanoSTC.toString(10), amountSCSHex })

        // const args = [
        //   arrayify(toAccount),
        //   arrayify(amountSCSHex),
        // ]
        
        const scriptFunction = utils.tx.encodeScriptFunction(functionId, tyArgs, [])
        console.log(scriptFunction)

        // Multiple BcsSerializers should be used in different closures, otherwise, the latter will be contaminated by the former.
        const payloadInHex = (function () {
          const se = new bcs.BcsSerializer()
          scriptFunction.serialize(se)
          return hexlify(se.getBytes())
        })()
        console.log({ payloadInHex })

        const txParams = {
          data: payloadInHex,
        }

        const expiredSecs = parseInt(100, 10)
        console.log({ expiredSecs })
        if (expiredSecs > 0) {
          txParams.expiredSecs = expiredSecs
        }

        console.log({ txParams })
        const transactionHash = await this.starcoinProvider.getSigner().sendUncheckedTransaction(txParams)
        console.log({ transactionHash })
      } catch (error) {

        throw error
      }
    },
    async register(){
      try {
        const functionId = '0xb87b4d228705e6e481dd21538a819371::STCNS_script::register'
        const strTypeArgs = []
         const tyArgs = utils.tx.encodeStructTypeTags(strTypeArgs)

        const toAccount = "0x57b052EA2d156B01A2596969E7aa4044"
        if (!toAccount) {
          // eslint-disable-next-line no-alert
          window.alert('Invalid To: can not be empty!')
          return false
        }
        console.log({ toAccount })
        
        // let n = 0.01 
        // const sendAmount = parseFloat(n, 10)
        // if (!(sendAmount > 0)) {
        //   // eslint-disable-next-line no-alert
        //   window.alert('Invalid sendAmount: should be a number!')
        //   return false
        // }
        
        // const BIG_NUMBER_NANO_STC_MULTIPLIER = new BigNumber('1000000000')

        // const sendAmountSTC = new BigNumber(String(n), 10)
        // const sendAmountNanoSTC = sendAmountSTC.times(BIG_NUMBER_NANO_STC_MULTIPLIER)
        // const sendAmountHex = `0x${ sendAmountNanoSTC.toString(16) }`
        
        // // Multiple BcsSerializers should be used in different closures, otherwise, the latter will be contaminated by the former.
        const amountSCSHex = (function () {
          const se = new bcs.BcsSerializer()
          // eslint-disable-next-line no-undef
          se.serializeU64(BigInt("1"))
          return hexlify(se.getBytes())
        })()
        
        // console.log({ sendAmountHex, sendAmountNanoSTC: sendAmountNanoSTC.toString(10), amountSCSHex })
        let domain = "Tim"
        const args = [
          "Tim12345678911",
          "1"
        ]
        console.log("stes")
        const scriptFunction =await utils.tx.encodeScriptFunctionByResolve(functionId, tyArgs, args,'https://barnard-seed.starcoin.org')
        console.log(scriptFunction)

        // Multiple BcsSerializers should be used in different closures, otherwise, the latter will be contaminated by the former.
        const payloadInHex = (function () {
          const se = new bcs.BcsSerializer()
          scriptFunction.serialize(se)
          return hexlify(se.getBytes())
        })()
        console.log({ payloadInHex })

        const txParams = {
          data: payloadInHex,
        }



        console.log({ txParams })
        const transactionHash = await this.starcoinProvider.getSigner().sendUncheckedTransaction(txParams)
        console.log({ transactionHash })
      } catch (error) {

        throw error
      }
    },
    async call(){
       this.starcoinProvider.send(
              'contract.call_v2',
              [
                {
                  function_id: "0xb87b4d228705e6e481dd21538a819371::STCNS_script::init",
                  type_args: [],
                  args:[],
                },
              ],
            ).then((result) => {
              
                console.log(result[0])


            })
          
    }
  }
}
</script>
