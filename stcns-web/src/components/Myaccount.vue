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

            <div style="text-align:left">
               <n-list bordered>
                    <template #header> 已注册 </template>
                    
                    <n-list-item>
                    
                        <n-thing title="Thing" title-extra="extra" description="description">
                            Biu<br />
                            Biu<br />
                            Biu<br />
                        </n-thing>
                    </n-list-item>
                    <n-list-item>
                        <n-thing title="Thing" title-extra="extra" description="description" />
                    </n-list-item>
                </n-list>
            </div>
        
        
        
</template>

<script>
export default {
    props: {
        
        User:{
          account:"",
        }
    },
    data(){
        return {
            
        }
    }
}
</script>

<style>
.align-center{text-align:center}
.button{
    padding:24px;
    font-size:17px
}
</style>