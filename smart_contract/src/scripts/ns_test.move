script {
    
    use 0x1::Debug;
    // use 0x1::Signer;
    use 0x1::Math;
    // use 0x413c244e089787d792f76cf8a756c13c::STCNS;
    fun main(_account : signer){
        let _hello_world = b"12345.test.ed";
        let _test_world = x"68656c6c6f20776f726c63";
        let num = Math::pow(10,9);
        Debug::print( &num );
        // stcns::register_nft(&_account);
        // stcns::mint_nft(&_account);
        

        // let num = stcns::IsRegister(&_hello_world); 
        // Debug::print( &num );
        // stcns::Register(&_account,&_hello_world,1);  
        // let num = stcns::IsRegister(&_hello_world); 
        // Debug::print( &num );
    }
}