<template>
  域名：{{domain}} .stc
  <p>

  </p>
  价格：{{price}} $STC

    <n-input-number
        v-model:value="year"
        placeholder="输入注册年份"
        :min="1"
        :max="10"
        :on-update:value="get_domain_price"
    />
    <p></p>

  <n-button @click="register">
    注册
  </n-button>
</template>

<script>
import {call, send_transaction_arg} from "../utils/starcoin";
import BigNumber from "bignumber.js";
import {utils} from "@starcoin/starcoin";

export default {
  props: {
    module :"",
    admin :"",
    User:{
      account:"",
    },
    domain:"",

  },

  data(){
      return{
          year:'1',
          price:'',
      }
  },
  mounted(){
    //  this.timer = setInterval(this.get_domain, 1000);
    this.get_domain_price(1);
  },
  methods:{
    async get_domain_price(value){
      console.log(value)
      this.year = value.toString()
          let price = await call(this.module + "::get_domain_price",[],['b\"'+this.domain+"\"",this.year]).catch(error=>{
            console.log("出错")
            return
          });
      console.log(price  )
      this.price = price[0]
      const BIG_NUMBER_NANO_STC_MULTIPLIER = new BigNumber('1000000000')

      const sendAmountSTC = new BigNumber(String(price[0]), 10)
      this.price = sendAmountSTC.div(BIG_NUMBER_NANO_STC_MULTIPLIER).toString(10)
      console.log(this.price  )
      },
    async register() {
      try {
        const functionId = this.admin + '::STCNS_script::register'
        const strTypeArgs = []
        const tyArgs = utils.tx.encodeStructTypeTags(strTypeArgs)


        const args = [
          this.domain,
          this.year
        ]
        let hash = send_transaction_arg(functionId, tyArgs, args);

      } catch (error) {

        throw error
      }
    },
  },

}
</script>

<style>

</style>