<template>
  <div class="home">
    <!-- <Sreach msg="Welcome to Your Vue.js App"/> -->
    <Myaccount :User.sync="User" :module.sync="module" :admin = "admin" />
    
    <n-button type="tertiary" @click="Get_account">链接</n-button>
    <!-- <n-button type="tertiary" @click="init">init</n-button> -->
    <n-button type="tertiary" @click="register">register</n-button>
    <n-button type="tertiary" @click="call">解析</n-button>
    <n-button type="tertiary" @click="call1">解析全部</n-button>
    <n-button type="tertiary" @click="change">修改解析地址</n-button>
    <n-button type="tertiary" @click="send">发送</n-button>
    <n-button type="tertiary" @click="renewal">续费</n-button> 
    
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
          
        }
      } catch (error) {
        console.error(error)
        this.have_starmask = false
      }

      this.Get_account()
  },
  data(){
    return {
        
        admin:"0xc17e245c8ce8dcfe56661fa2796c98cf",
        module:'0xc17e245c8ce8dcfe56661fa2796c98cf::STCNS_script',
        name: "Tim",
        private_key:'0x197f57cce853c9cb2616235afbeb4e92588e3f921bb894300c905d11e01806e2',
        starcoinProvider:null,
        starcoin:null,
        have_starmask:Boolean,
        User:{
          account:"",
        }
      }
  },
  
  methods:{
    async Get_account(){
      
      this.User.account = await get_account()
      console.log(this.User.account)
    }
    ,
    async init(){
      try {
        const functionId = this.admin+'::STCNS_script::init'
        const strTypeArgs = []
         const tyArgs = utils.tx.encodeStructTypeTags(strTypeArgs)
         console.log (await send_transaction(functionId,tyArgs))
        

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
        // const transactionHash = await this.starcoinProvider.getSigner().sendUncheckedTransaction(txParams)
        // console.log({ transactionHash })
      } catch (error) {

        throw error
      }
    },
    async register(){
      try {
        const functionId = this.admin+'::STCNS_script::register'
        const strTypeArgs = []
         const tyArgs = utils.tx.encodeStructTypeTags(strTypeArgs)


        const args = [
          this.name,
          "1"
        ]
        let hash = send_transaction_arg(functionId,tyArgs,args);
        
      } catch (error) {

        throw error
      }
    },
    async call(){

       this.starcoinProvider.send(
              'contract.call_v2',
              [
                {
                  function_id: this.admin+'::STCNS_script::resolution_stcaddress',
                  type_args: [],
                  args:["x\"54696d3132333435363738393130\""],
                },
              ],
            ).then((result) => {
              
                console.log(result)


            })
          
    },
    async call1(){
           const args = [
            "b\""+this.name+"\"",
         
        ]
       this.starcoinProvider.send(
              'contract.call_v2',
              [
                {
                  function_id: this.admin+'::STCNS_script::get_domain_info',
                  type_args: [],
                  args:["x\"54696d3132333435363738393130\""],
                },
              ],
            ).then((result) => {
              
                console.log(result)


            })
          
    },
    async send(){
      try {
        const functionId = this.admin+'::STCNS_script::send'
        const strTypeArgs = []
         const tyArgs = utils.tx.encodeStructTypeTags(strTypeArgs)

        const amountSCSHex = (function () {
          const se = new bcs.BcsSerializer()
          // eslint-disable-next-line no-undef
          se.serializeU64(BigInt("1"))
          return hexlify(se.getBytes())
        })()
        
        // console.log({ sendAmountHex, sendAmountNanoSTC: sendAmountNanoSTC.toString(10), amountSCSHex })

        const args = [
          this.name,
          "0x57b052EA2d156B01A2596969E7aa4044"
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
    async change(){
      try {
        const functionId = this.admin+'::STCNS_script::change_Resolver_stcaddress'
        const strTypeArgs = []
         const tyArgs = utils.tx.encodeStructTypeTags(strTypeArgs)

        const amountSCSHex = (function () {
          const se = new bcs.BcsSerializer()
          // eslint-disable-next-line no-undef
          se.serializeU64(BigInt("1"))
          return hexlify(se.getBytes())
        })()
        
        // console.log({ sendAmountHex, sendAmountNanoSTC: sendAmountNanoSTC.toString(10), amountSCSHex })

        const args = [
          this.name,
          "0x57b052EA2d156B01A2596969E7aa4044"
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
    async renewal(){
      try {
        const functionId = this.admin+'::STCNS_script::renewal_domain'
        const strTypeArgs = []
         const tyArgs = utils.tx.encodeStructTypeTags(strTypeArgs)

        const amountSCSHex = (function () {
          const se = new bcs.BcsSerializer()
          // eslint-disable-next-line no-undef
          se.serializeU64(BigInt("1"))
          return hexlify(se.getBytes())
        })()
        
        // console.log({ sendAmountHex, sendAmountNanoSTC: sendAmountNanoSTC.toString(10), amountSCSHex })

        const args = [
          this.name,
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
  }
}
</script>
