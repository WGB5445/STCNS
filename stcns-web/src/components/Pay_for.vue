<template>
  <n-input-group>
    <n-input-group-label>输入转账  地址 </n-input-group-label>
    <n-input  v-model:value="Receive_address" :style="{ width: '33%' }" />
  </n-input-group>
  <n-input-group>
    <n-input-group-label>Amount of STC</n-input-group-label>
    <n-input v-model:value="Amount" :style="{ width: '33%' }" />
  </n-input-group>
<!--  <n-input-group>-->
<!--    <n-input-group-label>超时时间(秒数)</n-input-group-label>-->
<!--    <n-input v-model:value="Time" :style="{ width: '33%' }" />-->
<!--  </n-input-group>-->
  <n-input-group>

      <n-button @click="Send_to">
        发送
      </n-button>

  </n-input-group>
</template>

<script>
import { providers, utils, bcs, encoding, version as starcoinVersion } from '@starcoin/starcoin'
import { encrypt } from 'eth-sig-util'
import { compare } from 'compare-versions';
import {call, send_transaction_arg} from "../utils/starcoin";
import BigNumber from "bignumber.js";
import { arrayify, hexlify } from '@ethersproject/bytes'
export default {
  props: {
    module :"",
    admin :"",
    User:{
      account:"",
    },

  },
    data(){
        return {
          Receive_address:'',
          Amount:'',
          Time:'',
        }
    },
    methods:{
     async Send_to(){
        const functionId = '0x1::TransferScripts::peer_to_peer_v2'
        const strTypeArgs = ['0x1::STC::STC']
        const tyArgs = utils.tx.encodeStructTypeTags(strTypeArgs)
        let address = '0x0'
       address = this.Receive_address
        if(this.Receive_address.length > 4 && this.Receive_address.substring(this.Receive_address.length - 4) == ".stc"){
         let get_address = await call(this.module + "::resolution_stcaddress",[],['b\"'+this.Receive_address.substring(0,this.Receive_address.length - 4)+"\""]).catch(error=>{
            console.log("未找到"+this.Receive_address.substring(0,this.Receive_address.length - 5))
          });
          address = get_address[0]
        }
       const sendAmount = parseFloat(this.Amount)
       if(!( sendAmount > 0)){
         window.alert('Invalid sendAmount: should be a number!')
         return
       }
       const BIG_NUMBER_NANO_STC_MULTIPLIER = new BigNumber('1000000000')
       const sendAmountSTC = new BigNumber(String(this.Amount), 10)
       const sendAmountNanoSTC = sendAmountSTC.times(BIG_NUMBER_NANO_STC_MULTIPLIER)
       console.log("0x57b052EA2d156B01A2596969E7aa4044")
       console.log(address)

       let hash = await send_transaction_arg('0x1::TransferScripts::peer_to_peer_v2', strTypeArgs, [address,BigInt(sendAmountNanoSTC.toString(10))]);
       console.log(hash)

      }

    }
}
</script>
    
<style>

</style>