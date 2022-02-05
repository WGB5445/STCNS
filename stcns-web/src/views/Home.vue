<template>
  <div class="home">
    <!-- <Sreach msg="Welcome to Your Vue.js App"/> -->
    <!--    <Myaccount :User.sync="User" :module.sync="module" :admin = "admin" />-->
<!--    <HelloWorld :msg="have_starmask"/>-->
    <n-layout position="absolute">
      <n-layout-header position="absolute" style="height: 150px; padding: 24px; background-color: white  "  >
        <n-grid  :cols="12">
          <n-gi span="3">

          </n-gi>
          <n-gi span="9">
            <n-input-group style="height: 100px;">
              <n-divider vertical />
              <input  v-model="click_domainn" placeholder="输入域名或地址" style="height: 100px; width: inherit ; font-size:30px;background-color:transparent;border:0; outline: none"/>
              <n-button color="#8a2be2"  style="height: 100px;width: 150px ; font-size: 30px" @click="Com = 'Sreach'" >搜索</n-button>
            </n-input-group>
          </n-gi>
        </n-grid>
      </n-layout-header>

      <n-layout has-sider position="absolute" style="top: 150px; bottom: 64px;  ">

        <n-layout-sider bordered content-style="padding: 12px;">
          <n-anchor :show-rail="showRail" :show-background="showBackground">
            <n-card  hoverable>
              <template #header >
                <n-ellipsis style="max-width: 100px;">
                  {{User.account}}
                </n-ellipsis>

              </template>

                {{User.network_info.name}}网络


              <template #action >
                <n-button round   @click="Get_account"  >
                  {{ User.connect? "断开":"链接" }}
                </n-button>
              </template>

            </n-card>
            <n-anchor-link style="font-size: 25px" title="我的账户"  @click="Com = 'Myaccount'"/>
<!--            <n-anchor-link  style="font-size: 25px"  title="搜索" @click="Com = 'Sreach'" />-->
            <n-anchor-link  style="font-size: 25px"  title="转账" @click="Com = 'Payfor'" />
            <n-anchor-link  style="font-size: 25px"  title="关于" @click="Com = 'about'" />

          </n-anchor>
        </n-layout-sider>

        <n-layout content-style="padding: 24px;">
          <Myaccount v-if="Com == 'Myaccount'" :User.sync="User" :module.sync="module" :admin = "admin" @click_domain="click_domain" />
          <Sreach v-if="Com == 'Sreach'" :User.sync="User" :module.sync="module" :admin = "admin" :domain.sync="click_domainn"/>
          <Pay_for v-if="Com == 'Payfor'" :User.sync="User" :module.sync="module" :admin = "admin" />
          <Register v-if="Com == 'Register'" :User.sync="User" :module.sync="module" :admin = "admin" />
          <Details v-if="Com == 'Details'" :User.sync="User" :module.sync="module" :admin = "admin"  :domain.sync="click_domainn" />
        </n-layout>
      </n-layout>

    </n-layout>
    
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
import Pay_for from '@/components/Pay_for.vue'
import Register from '@/components/Register.vue'
import Details from '@/components/Details.vue'
import {get_account,get_id, send_transaction,send_transaction_arg,call} from '../utils/starcoin.js'
export default {
  name: 'Home',
  components: {
    HelloWorld,
    Sreach,
    Myaccount,
    Pay_for,
    Register,
    Details
  },

  async created() {
    //记录当前的网络信息
    let info = await get_id()
    this.User.network_info = info
    //注册钩子
    window.starcoin.on('chainChanged', async (id)=>{
      let info = await get_id()
      this.User.network_info = info

    })

  },
  data(){
    return {
       have_starmask : false,

      Com:'' ,

          admin:"0xc17e245c8ce8dcfe56661fa2796c98cf",
          module:'0xc17e245c8ce8dcfe56661fa2796c98cf::STCNS_script',
          name: "Tim",
          private_key:'0x197f57cce853c9cb2616235afbeb4e92588e3f921bb894300c905d11e01806e2',
          starcoinProvider:null,
          starcoin:null,

          User:{
            account:"",
            connect:false,
            network_info: {
              name: String,
              id: Number,
            }
        },
      click_domainn:"",


    }

  },
  methods:{
    currentTabComponent(){
      return
    },
    async Get_account() {
      if (this.User.connect) {
        this.User.connect = false
      } else {
        this.User.account = await get_account()
        this.User.connect = true
        console.log(this.User.connect)
      }
    },
    click_domain(domain){
        this.click_domainn = domain
      this.Com = "Details"
    }

  }


}
</script>
