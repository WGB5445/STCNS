<template>
            <n-grid  cols="1  m:2" responsive="screen">
                <n-gi>
                    <h2>
                        {{User.account}}
                    </h2> 
                </n-gi>
                <n-gi class="align-center">
                    <n-button class="button" text v-if="User.account != ''" @click="call">
                        在Stcscan上查看
                    </n-button>
                </n-gi>
            </n-grid>
    
            <n-divider />
            <n-button class="button" text v-if="User.account != ''" @click="get_domain">
                查看
            </n-button>
            <div style="text-align:left">
               <n-list bordered>
                    <template #header> 已注册 </template>
                    
                    <n-list-item v-for="(item,i) in domains">
                        
                       <n-thing>
                            <template #avatar v-if="avatar">
                            <n-avatar>
                            
                            </n-avatar>
                        </template>
                        <template #header > 
                             <n-button  text  @click="call">
                                {{hexCharCodeToStr(item.Name)}}
                            </n-button>
                        </template>
                        <template #header-extra >
                                   {{"过期时间："+getLocalTime(item.Expiration_time)}}
                        </template>

                        <template #action ></template>
                       </n-thing>
                    </n-list-item>

                </n-list>
            </div>
        
        
        
</template>

<script>
import {get_account,send_transaction,send_transaction_arg,call} from '../utils/starcoin.js'
export default {
    name:'myaccount',
    props: {
        module :"",
        admin :"",
        User:{
          account:"",
        }
    },
    mounted(){
    //  this.timer = setInterval(this.get_domain, 1000);
    this.get_domain()
  },
    data(){
        return {
            domains:[]
        }
    },
    methods:{
        async get_domain(){
            if(this.User.account == "")
                return
            let result = await call(this.module + "::get_Owner_all_domain",[],[this.User.account]).catch(error=>{
                return
            });
            this.domains = result[0].Domains
            console.log(JSON.parse(JSON.stringify(this.domains)))
        },
        hexCharCodeToStr(hexCharCodeStr) {
            var trimedStr = hexCharCodeStr.trim();
            var rawStr = 
            trimedStr.substr(0,2).toLowerCase() === "0x"
            ? 
            trimedStr.substr(2) 
            : 
            trimedStr;
            var len = rawStr.length;
            if(len % 2 !== 0) {
            alert("Illegal Format ASCII Code!");
                return "";
            }
            var curCharCode;
            var resultStr = [];
            for(var i = 0; i < len;i = i + 2) {
            curCharCode = parseInt(rawStr.substr(i, 2), 16); // ASCII Code Value
            resultStr.push(String.fromCharCode(curCharCode));
            }
            return resultStr.join("");
        },
        getLocalTime(nS) {     
            return new Date(parseInt(nS) * 1000).toLocaleString().replace(/:\d{1,2}$/,' ');     
        }
    },
}
</script>

<style>
.align-center{text-align:center}
.button{
    padding:24px;
    font-size:17px
}
</style>