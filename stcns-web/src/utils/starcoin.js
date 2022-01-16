import { arrayify, hexlify } from '@ethersproject/bytes'
import BigNumber from 'bignumber.js'

import { providers, utils, bcs, encoding, version as starcoinVersion } from '@starcoin/starcoin'
import { encrypt } from 'eth-sig-util'
import { compare } from 'compare-versions';

const  get_account = async  (  )=>{
   
    const newAccounts = await window.starcoin.request({
        method: 'stc_requestAccounts',
      })
    let account = newAccounts[0]
      
    return account
}
const  get_id = async  (  )=>{

    const chainInfo = await window.starcoin.request({
        method: 'chain.id',
    })
    let id = chainInfo

    return id
}

//发送无参数交易
const send_transaction = async (functionId,typearg)=>{
    let starcoinProvider =   new providers.Web3Provider(window.starcoin, 'any')
    let  tyArgs = utils.tx.encodeStructTypeTags(typearg)
    let scriptFunction = utils.tx.encodeScriptFunction(functionId, tyArgs, [])
    let payloadInHex = (function () {
        const se = new bcs.BcsSerializer()
        scriptFunction.serialize(se)
        return hexlify(se.getBytes())
      })()
    const txParams = {
    data: payloadInHex,
    }
    const transactionHash = await starcoinProvider.getSigner().sendUncheckedTransaction(txParams)
    console.log({ transactionHash })
}
//发送有参数交易
const send_transaction_arg = async (functionId,typearg,args)=>{
    let starcoinProvider =   new providers.Web3Provider(window.starcoin, 'any')
    const scriptFunction =await utils.tx.encodeScriptFunctionByResolve(functionId, typearg, args,'https://barnard-seed.starcoin.org')
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

        const transactionHash = await starcoinProvider.getSigner().sendUncheckedTransaction(txParams)
        return transactionHash
}

const call = async(functionId,typearg,args) => {
  let starcoinProvider =   new providers.Web3Provider(window.starcoin, 'any')
  
  return new  Promise((resolver,reject)=>{ starcoinProvider.send(
       'contract.call_v2',
       [
         {
           function_id: functionId,
           type_args: typearg,
           args:args,
         },
       ],
     ).then((result) => {

          resolver(result)

     })
    })
   
}

export  {
    get_account,
    get_id,
    send_transaction,
    send_transaction_arg,
    call
};