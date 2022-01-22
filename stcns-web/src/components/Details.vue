<template>

  <p></p>
  主域名：{{domain}}.stc
  <p></p>
  创建时间：{{domain_info.Meta.Create_time}}
  <p></p>
  过期时间：{{domain_info.Meta.Expiration_time}}
  <p></p>
  stc地址：{{domain_info.Body.Main.STC_address}}


</template>

<script>
import {call} from "../utils/starcoin";

export default {
  name: "Details",
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

      domain_info:{
        Meta:{
          Create_time:Number,
          Expiration_time:Number
        },
        Body:{
          Main: {
            STC_address: String,
            ETH_address: String,

          },
          Sub:[
            {

            }
          ]
        }

      }
    }
  },
  mounted(){
    //  this.timer = setInterval(this.get_domain, 1000);
    this.get_domain_info()
  },
  methods:{
    async get_domain_info(){
      if(this.User.account == "" && domain == "")
        return
      let result = await call(this.module + "::get_domain_info",[],['b\"'+this.domain+"\""]).catch(error=>{
        return
      });
      this.domain_info = result[0];
      console.log(JSON.parse(JSON.stringify(result[0])))
    }

  },

}
</script>

<style scoped>

</style>