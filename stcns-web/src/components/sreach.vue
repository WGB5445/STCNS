<template>
  <div style="height: max-content ;">
    <Details :User.sync="User" :module.sync="module" :admin = "admin"  :domain.sync="domain" />

  </div>
</template>

<script>
import Details from "./Details";
export default {
  components: {Details},
  props: {
    module :"",
    admin :"",
    User:{
      account:"",
    },
    domain:'',
  },
  data(){
        return{

        }
    }
}
</script>

<style>

</style>