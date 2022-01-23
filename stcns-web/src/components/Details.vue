<template>
  <n-space vertical size="large">
  <n-layout >
    <n-layout-header  >
      <n-grid  :cols="2">
        <n-gi span="1">
          <h2 style="float: left;">
          {{domain}}.stc
          </h2>
        </n-gi>
        <n-gi span="1">
          <n-button-group style="float: right;">
            <n-button ghost @click="Com = 'register'">

              注册
            </n-button>
            <n-button ghost  @click="Com = 'Details'">

              详情
            </n-button>
            <n-button ghost  @click="Com = 'subdomain'">
              子域名
            </n-button>
          </n-button-group>

        </n-gi>
      </n-grid>
    </n-layout-header>
    <n-layout-content >



      <div v-if="Com == 'Details'">
        <n-space vertical>
          <n-grid :x-gap="5" :y-gap="8" :cols="5">
            <n-grid-item span="1">
              <div style="float:left">
                父域名:
              </div>
            </n-grid-item>
            <n-grid-item span="3">
              <div style="float: left">
                stc
              </div>
            </n-grid-item>
            <n-grid-item span="1">

            </n-grid-item>
            <n-grid-item span="1">
              <div style="float:left">
                所有人:
              </div>
            </n-grid-item>
            <n-grid-item span="3">
              <div style="float: left;">
                {{domain_info.Owner}}
              </div>
            </n-grid-item>
            <n-grid-item span="1">
              <n-button ghost v-if="domain_info.Owner == User.account" @click="Send_to">
                转让
              </n-button>
            </n-grid-item>
            <n-grid-item span="1">
              <div v-if="Is_register == false" style="float:left">
                状态：
              </div>
              <div v-else style="float:left">
                到期时间:
              </div>
            </n-grid-item>
            <n-grid-item span="3">
              <div style="float: left;" v-if="Is_register == false">
                未注册
              </div>
              <div v-else style="float:left">
                {{getLocalTime(domain_info.Meta.Expiration_time)}}
              </div>
            </n-grid-item>
            <n-grid-item span="1">

            </n-grid-item>
          </n-grid>
        </n-space>
        <p></p>
        <n-grid :x-gap="5" :y-gap="8" :cols="5">
          <n-grid-item span="1">
            <div style="float: left;">
              解析记录：
            </div>
          </n-grid-item>
          <n-grid-item span="4">
            <div style="float: right;">
              <n-button v-if="domain_info.Owner == User.account" ghost @click="click_change">
                <template v-if="Is_change">
                  保存
                </template>
                <template v-else>
                  修改解析地址
                </template>

              </n-button>
            </div>
          </n-grid-item>
        </n-grid>
          <div  v-if="Is_register">
            <n-grid :x-gap="5" :y-gap="8" :cols="5">
              <n-grid-item span="1">

              </n-grid-item>
              <n-grid-item span="4">
                <div style="float:left">
                  地址：
                </div>
              </n-grid-item>
              <n-grid-item span="1">

              </n-grid-item>
              <n-grid-item span="1">
                STC：
              </n-grid-item>
              <n-grid-item span="3" v-if="Is_change">
                <n-input-group>
                  <n-input v-model:value="new_Main.STC_address" type="text"   />
                </n-input-group>
              </n-grid-item>
              <n-grid-item span="3" v-else>
                {{new_Main.STC_address}}
              </n-grid-item>

            </n-grid>
            </div>
            <div v-else>
              <p></p>
              地址：
              <p></p>
              STC：{{domain_info.Body.Main.STC_address}}

              <p></p>
              ETH: {{domain_info.Body.Main.ETH_address}}
            </div>
          </div>




      <div v-if="Com == 'register'">
        <div v-if="Is_register">
          该域名被已经注册
        </div>
        <div v-else-if="Is_register">
          注册
        </div>
      </div>
      <div v-if="Com == 'subdomain'">
        子域名暂时未开放
      </div>

    </n-layout-content>

  </n-layout>
  </n-space>
<!--  <p></p>-->
<!--  主域名：{{domain}}.stc-->
<!--  <p></p>-->
<!--  创建时间：{{domain_info.Meta.Create_time}}-->
<!--  <p></p>-->
<!--  过期时间：{{domain_info.Meta.Expiration_time}}-->
<!--  <p></p>-->
<!--  stc地址：{{domain_info.Body.Main.STC_address}}-->


</template>

<script>
import {call, send_transaction_arg} from "../utils/starcoin";
import {utils} from "@starcoin/starcoin";

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
        Owner:'0x0',
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

      },
      new_Main:{
        STC_address: String,
        ETH_address: String,
      },
      Is_change:false,
      Is_register:Boolean,
      Is_loaded:Boolean,
      Com:'Details',
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
          this.Is_register = false
        this.Is_loaded = true
        return
      });
      this.domain_info = result[0];
      this.Is_loaded = true
      this.Is_register = true
      this.new_Main =JSON.parse(JSON.stringify(this.domain_info.Body.Main))

    },
    getLocalTime(nS) {
      return new Date(parseInt(nS) * 1000).toLocaleString().replace(/:\d{1,2}$/,' ');
    },
    click_change(){
      if(this.Is_change ){
        //保存
        if (this.new_Main.STC_address != this.domain_info.Body.Main.STC_address){
          //有修改
          {
            //发送修改
            try {
              const functionId = this.admin + '::STCNS_script::change_Resolver_stcaddress'
              const strTypeArgs = []
              const tyArgs = utils.tx.encodeStructTypeTags(strTypeArgs)


              const args = [
                this.domain,
                this.new_Main.STC_address
              ]
              let hash = send_transaction_arg(functionId, tyArgs, args);
              console.log(hash)
            } catch (error) {

              throw error
            }
          }
          console.log('有修改')
        }else {
          //没有修改
          console.log('没有修改')
        }
      }
      else{
        //修改
      }
      this.Is_change = !this.Is_change
    },
    Send_to(){
      const functionId = this.admin + '::STCNS_script::send'
      const strTypeArgs = []
      const tyArgs = utils.tx.encodeStructTypeTags(strTypeArgs)
      const args = [
        this.domain,

      ]
      let hash = send_transaction_arg(functionId, tyArgs, args);
      console.log(hash)
    }
  },

}
</script>

<style scoped>

</style>