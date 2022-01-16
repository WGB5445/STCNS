<template>
  <div class="hello">
    <n-space vertical size="large">
      <n-layout>
        <n-layout-header>
          <n-grid cols="2 400:4 600:6">
            <n-grid-item>
              <div class="light-green">
                <n-thing>
                  <template #avatar v-if="avatar">
                    <n-avatar>
                      <n-icon>
                        <cash-icon />
                      </n-icon>
                    </n-avatar>
                  </template>
                  <template #header >

                  </template>

                  <template #description >
                    {{User.network_info.name}}网络
                  </template>

                  <template #action >
                    <n-button round   @click="Get_account"  >
                      {{ User.connect? "断开":"链接" }}
                    </n-button>
                  </template>
                </n-thing>

              </div>
            </n-grid-item>
            <n-grid-item>

            </n-grid-item>
            <n-grid-item>

            </n-grid-item>
            <n-grid-item>

            </n-grid-item>
            <n-grid-item>

            </n-grid-item>
            <n-grid-item>
              <n-space>
                <n-button text v-if="User.connect">
                  我的账户
                </n-button>
                <n-button text>
                  关于
                </n-button>
              </n-space>
            </n-grid-item>
          </n-grid>

        </n-layout-header>
        <n-layout-content content-style="padding: 24px;">平山道</n-layout-content>
        <n-layout-footer>成府路</n-layout-footer>
      </n-layout>
    </n-space>

    <!-- <n-button type="tertiary" @click="init">init</n-button> -->
    <n-button type="tertiary" @click="register">register</n-button>
    <n-button type="tertiary" @click="call">解析</n-button>
    <n-button type="tertiary" @click="call1">解析全部</n-button>
    <n-button type="tertiary" @click="change">修改解析地址</n-button>
    <n-button type="tertiary" @click="send">发送</n-button>
    <n-button type="tertiary" @click="renewal">续费</n-button>
  </div>
</template>

<script>
import {get_account,get_id, send_transaction, send_transaction_arg} from "../utils/starcoin";
import {bcs, utils} from "@starcoin/starcoin";
import BigNumber from "bignumber.js";
import {hexlify} from "@ethersproject/bytes";

export default {
  name: 'HelloWorld',
  props: {
    msg: Boolean
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
        connect:false,
        network_info: {
          name:String,
          id:Number,
        }
      },


    }
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
  methods: {
    async Get_account() {
      if (this.User.connect) {
        this.User.connect = false
      } else {
        this.User.account = await get_account()
        this.User.connect = true
        console.log(this.User.account)
      }
    }
    ,
    async init() {
      try {
        const functionId = this.admin + '::STCNS_script::init'
        const strTypeArgs = []
        const tyArgs = utils.tx.encodeStructTypeTags(strTypeArgs)
        console.log(await send_transaction(functionId, tyArgs))


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
        const sendAmountHex = `0x${sendAmountNanoSTC.toString(16)}`

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
        console.log({payloadInHex})

        const txParams = {
          data: payloadInHex,
        }

        const expiredSecs = parseInt(100, 10)
        console.log({expiredSecs})
        if (expiredSecs > 0) {
          txParams.expiredSecs = expiredSecs
        }

        console.log({txParams})
        // const transactionHash = await this.starcoinProvider.getSigner().sendUncheckedTransaction(txParams)
        // console.log({ transactionHash })
      } catch (error) {

        throw error
      }
    },
    async register() {
      try {
        const functionId = this.admin + '::STCNS_script::register'
        const strTypeArgs = []
        const tyArgs = utils.tx.encodeStructTypeTags(strTypeArgs)


        const args = [
          this.name,
          "1"
        ]
        let hash = send_transaction_arg(functionId, tyArgs, args);

      } catch (error) {

        throw error
      }
    },
    async call() {

      this.starcoinProvider.send(
          'contract.call_v2',
          [
            {
              function_id: this.admin + '::STCNS_script::resolution_stcaddress',
              type_args: [],
              args: ["x\"54696d3132333435363738393130\""],
            },
          ],
      ).then((result) => {

        console.log(result)


      })

    },
    async call1() {
      const args = [
        "b\"" + this.name + "\"",

      ]
      this.starcoinProvider.send(
          'contract.call_v2',
          [
            {
              function_id: this.admin + '::STCNS_script::get_domain_info',
              type_args: [],
              args: ["x\"54696d3132333435363738393130\""],
            },
          ],
      ).then((result) => {

        console.log(result)


      })

    },
    async send() {
      try {
        const functionId = this.admin + '::STCNS_script::send'
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
        const scriptFunction = await utils.tx.encodeScriptFunctionByResolve(functionId, tyArgs, args, 'https://barnard-seed.starcoin.org')
        console.log(scriptFunction)

        // Multiple BcsSerializers should be used in different closures, otherwise, the latter will be contaminated by the former.
        const payloadInHex = (function () {
          const se = new bcs.BcsSerializer()
          scriptFunction.serialize(se)
          return hexlify(se.getBytes())
        })()
        console.log({payloadInHex})

        const txParams = {
          data: payloadInHex,
        }


        console.log({txParams})
        const transactionHash = await this.starcoinProvider.getSigner().sendUncheckedTransaction(txParams)
        console.log({transactionHash})
      } catch (error) {

        throw error
      }
    },
    async change() {
      try {
        const functionId = this.admin + '::STCNS_script::change_Resolver_stcaddress'
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
        const scriptFunction = await utils.tx.encodeScriptFunctionByResolve(functionId, tyArgs, args, 'https://barnard-seed.starcoin.org')
        console.log(scriptFunction)

        // Multiple BcsSerializers should be used in different closures, otherwise, the latter will be contaminated by the former.
        const payloadInHex = (function () {
          const se = new bcs.BcsSerializer()
          scriptFunction.serialize(se)
          return hexlify(se.getBytes())
        })()
        console.log({payloadInHex})

        const txParams = {
          data: payloadInHex,
        }


        console.log({txParams})
        const transactionHash = await this.starcoinProvider.getSigner().sendUncheckedTransaction(txParams)
        console.log({transactionHash})
      } catch (error) {

        throw error
      }
    },
    async renewal() {
      try {
        const functionId = this.admin + '::STCNS_script::renewal_domain'
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
        const scriptFunction = await utils.tx.encodeScriptFunctionByResolve(functionId, tyArgs, args, 'https://barnard-seed.starcoin.org')
        console.log(scriptFunction)

        // Multiple BcsSerializers should be used in different closures, otherwise, the latter will be contaminated by the former.
        const payloadInHex = (function () {
          const se = new bcs.BcsSerializer()
          scriptFunction.serialize(se)
          return hexlify(se.getBytes())
        })()
        console.log({payloadInHex})

        const txParams = {
          data: payloadInHex,
        }


        console.log({txParams})
        const transactionHash = await this.starcoinProvider.getSigner().sendUncheckedTransaction(txParams)
        console.log({transactionHash})
      } catch (error) {

        throw error
      }
    },
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h3 {
  margin: 40px 0 0;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}
</style>
