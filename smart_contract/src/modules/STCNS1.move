address 0x413c244e089787d792f76cf8a756c13c {
    module STCNS1{

        use 0x1::Vector;
        use 0x1::Signer;
        use 0x1::Timestamp;
        use 0x1::NFT;
        use 0x1::Option;
         const ADMAIN_ADDRESS : address = @0x413c244e089787d792f76cf8a756c13c;
        struct Admin_Control has key,copy,drop,store{
            Can_Send        : bool,
            Can_Resolver    : bool,
            Can_Change_Resolver: bool,
            Can_Register    : bool,

            Pricerange_1      :u64,
            Pricerange_2     :u64,
            Pricerange_3     :u64,


            Word_upper_limit:u64,

            Price_1         : u64,
            Price_2         : u64,
            Price_3         : u64,

        }
        struct Subdomain has key,copy,drop,store{ 
            Name                :   vector<u8>,
            STC_address         :   address     ,
            ETH_address         :   vector<u8>  ,
            BTC_address         :   vector<u8>  ,
            LTC_address         :   vector<u8>  ,

            Email               :   vector<u8>  ,
            Website             :   vector<u8>  ,
            com_twitter         :   vector<u8>  ,
            com_discord         :   vector<u8>  ,
            com_github          :   vector<u8>  ,    
        }
        struct Domain has key,copy,drop,store{

            STC_address         :   address     ,
            ETH_address         :   vector<u8>  ,
            BTC_address         :   vector<u8>  ,
            LTC_address         :   vector<u8>  ,

            Email               :   vector<u8>  ,
            Website             :   vector<u8>  ,
            com_twitter         :   vector<u8>  ,
            com_discord         :   vector<u8>  ,
            com_github          :   vector<u8>  ,    
        }
        struct STCNS_Body has key,copy,drop,store{
            Main        :  Domain,
            Sub         :  vector<Subdomain>
        }
        struct STCNS_Meta has key,copy,drop,store{
            Domain_name         :   vector<u8>,
            Controller          :   address     ,
            Create_time         :   u64,
            Expiration_time     :   u64,
        }
        struct ShardCap has key, store{
            mint_cap: NFT::MintCapability<STCNS_Meta>,
            burn_cap: NFT::BurnCapability<STCNS_Meta>,
            updata_cap:NFT::UpdateCapability<STCNS_Meta>
        }
        struct STCNS_List has key,store{
            List        :   vector<NFT::NFT<STCNS_Meta,STCNS_Body>>
        }
        
        struct STCNS_Admin has key,copy,drop,store{
            Domains      :      vector<STCNS_Admin_Domain>
        }
        struct STCNS_Admin_Domain has key,copy,drop,store{
            Name            :vector<u8>,
            Owner             :address
        }
       public fun get_STCNS_Admin_Domains (stcns_admin:&STCNS_Admin):&vector<STCNS_Admin_Domain>{
            &stcns_admin.Domains
        }
        public fun get_mut_STCNS_Admin_Domains (stcns_admin:&mut STCNS_Admin):&mut vector<STCNS_Admin_Domain>{
            &mut stcns_admin.Domains
        }

        public fun get_STCNS_Admin_Domain_Name (stcns_admin_domain:&STCNS_Admin_Domain):&vector<u8>{
            &stcns_admin_domain.Name
        }
        public fun get_mut_STCNS_Admin_Domain_Name (stcns_admin_domain:&mut STCNS_Admin_Domain):&mut vector<u8>{
            &mut stcns_admin_domain.Name
        }

        public fun get_STCNS_Admin_Domain_Owner (stcns_admin_domain:&STCNS_Admin_Domain):&address{
            &stcns_admin_domain.Owner
        }
        public fun get_mut_STCNS_Admin_Domain_Owner (stcns_admin_domain:&mut STCNS_Admin_Domain):&mut address{
            &mut stcns_admin_domain.Owner
        }

        fun Utils_vector_cmp(a:&vector<u8>,b:&vector<u8>):bool{
            let length_a = Vector::length<u8>(a);
            let length_b = Vector::length<u8>(b);
            if(length_a != length_b){
                return false
            };
            let i:u64 = 0;
            while( i < length_a ){
                if(Vector::borrow<u8>(a,i) != Vector::borrow<u8>(b,i)){
                    return false
                };
                i = i + 1;
            };
            true
        }

        public fun Index_of_Domains(domains:&vector<STCNS_Admin_Domain>,domain:&vector<u8>):Option::Option<u64>{
            let length = Vector::length<STCNS_Admin_Domain>(domains);
            let i = 0;
            while(i < length){
                let stcns_admin_doamin =Vector::borrow<STCNS_Admin_Domain>(domains,i);
                let name = get_STCNS_Admin_Domain_Name(stcns_admin_doamin);
                if(Utils_vector_cmp(name,domain)){
                    return Option::some<u64>(i)
                };
                i = i + 1;
            };
            Option::none<u64>()
        }
        

        public fun get_STCNS_Meta_Domain_name(meta:&STCNS_Meta):&vector<u8>{
            &meta.Domain_name
        }

        public fun get_STCNS_Meta_Controller(meta:&STCNS_Meta):&address{
            &meta.Controller
        }
        public fun get_STCNS_Meta_Create_time(meta:&STCNS_Meta):&u64{
            &meta.Create_time
        }
        public fun get_STCNS_Meta_Expiration_time(meta:&STCNS_Meta):&u64{
            &meta.Expiration_time
        }

        public fun get_STCNS_List_List(stcns_list:&STCNS_List):&vector<NFT::NFT<STCNS_Meta,STCNS_Body>>{
            &stcns_list.List
        }

        public fun get_mut_STCNS_List_List(stcns_list:&mut STCNS_List):&mut vector<NFT::NFT<STCNS_Meta,STCNS_Body>>{
            &mut stcns_list.List
        }
        public fun Index_of_List(list:&vector<NFT::NFT<STCNS_Meta,STCNS_Body>>,domain:&vector<u8>):Option::Option<u64>{
            let length = Vector::length<NFT::NFT<STCNS_Meta,STCNS_Body>>(list);
            let i = 0;
            while(i < length){
                let nft =Vector::borrow<NFT::NFT<STCNS_Meta,STCNS_Body>>(list,i);
                let meta = NFT::get_type_meta(nft);
                let domain_name = get_STCNS_Meta_Domain_name(meta);
                if(Utils_vector_cmp(domain_name,domain)){
                    return Option::some<u64>(i)
                };
                i = i + 1;
            };
            Option::none<u64>()
        }
  
        public fun get_Subdomain_Name(subdomain:&Subdomain):&vector<u8>{
            &subdomain.Name
        }
        public fun get_mut_Subdomain_Name(subdomain:&mut Subdomain):&mut vector<u8>{
            &mut subdomain.Name
        }

        public fun get_Subdomain_STC_address(subdomain:&Subdomain):&address{
            &subdomain.STC_address
        }
        public fun get_mut_Subdomain_STC_address(subdomain:&mut Subdomain):&mut address{
            &mut subdomain.STC_address
        }

        public fun get_Subdomain_ETH_address(subdomain:&Subdomain):&vector<u8>{
            &subdomain.ETH_address
        }
        public fun get_mut_Subdomain_ETH_address(subdomain:&mut Subdomain):&mut vector<u8>{
            &mut subdomain.ETH_address
        }

        public fun get_Subdomain_BTC_address(subdomain:&Subdomain):&vector<u8>{
            &subdomain.BTC_address
        }
        public fun get_mut_Subdomain_BTC_address(subdomain:&mut Subdomain):&mut vector<u8>{
            &mut subdomain.BTC_address
        }

        public fun get_Subdomain_LTC_address(subdomain:&Subdomain):&vector<u8>{
            &subdomain.LTC_address
        }
        public fun get_mut_Subdomain_LTC_address(subdomain:&mut Subdomain):&mut vector<u8>{
            &mut subdomain.LTC_address
        }

        public fun get_Subdomain_Email(subdomain:&Subdomain):&vector<u8>{
            &subdomain.Email
        }
        public fun get_mut_Subdomain_Email(subdomain:&mut Subdomain):&mut vector<u8>{
            &mut subdomain.Email
        }

        public fun get_Subdomain_Website(subdomain:&Subdomain):&vector<u8>{
            &subdomain.Website
        }
        public fun get_mut_Subdomain_Website(subdomain:&mut Subdomain):&mut vector<u8>{
            &mut subdomain.Website
        }

        public fun get_Subdomain_com_twitter(subdomain:&Subdomain):&vector<u8>{
            &subdomain.com_twitter
        }
        public fun get_mut_Subdomain_com_twitter(subdomain:&mut Subdomain):&mut vector<u8>{
            &mut subdomain.com_twitter
        }

        public fun get_Subdomain_com_discord(subdomain:&Subdomain):&vector<u8>{
            &subdomain.com_discord
        }
        public fun get_mut_Subdomain_com_discord(subdomain:&mut Subdomain):&mut vector<u8>{
            &mut subdomain.com_discord
        }

        public fun get_Subdomain_com_github(subdomain:&Subdomain):&vector<u8>{
            &subdomain.com_github
        }
        public fun get_mut_Subdomain_com_github(subdomain:&mut Subdomain):&mut vector<u8>{
            &mut subdomain.com_github
        }



        public fun get_Domain_STC_address(domain:&Domain):&address{
            &domain.STC_address
        }
        public fun get_mut_Domain_STC_address(domain:&mut Domain):&mut address{
            &mut domain.STC_address
        }

        public fun get_Domain_ETH_address(domain:&Domain):&vector<u8>{
            &domain.ETH_address
        }
        public fun get_mut_Domain_ETH_address(domain:&mut Domain):&mut vector<u8>{
            &mut domain.ETH_address
        }

        public fun get_Domain_BTC_address(domain:&Domain):&vector<u8>{
            &domain.BTC_address
        }
        public fun get_mut_Domain_BTC_address(domain:&mut Domain):&mut vector<u8>{
            &mut domain.BTC_address
        }

        public fun get_Domain_LTC_address(domain:&Domain):&vector<u8>{
            &domain.LTC_address
        }
        public fun get_mut_Domain_LTC_address(domain:&mut Domain):&mut vector<u8>{
            &mut domain.LTC_address
        }

        public fun get_Domain_Email(domain:&Domain):&vector<u8>{
            &domain.Email
        }
        public fun get_mut_Domain_Email(domain:&mut Domain):&mut vector<u8>{
            &mut domain.Email
        }

        public fun get_Domain_Website(domain:&Domain):&vector<u8>{
            &domain.Website
        }
        public fun get_mut_Domain_Website(domain:&mut Domain):&mut vector<u8>{
            &mut domain.Website
        }

        public fun get_Domain_com_twitter(domain:&Domain):&vector<u8>{
            &domain.com_twitter
        }
        public fun get_mut_Domain_com_twitter(domain:&mut Domain):&mut vector<u8>{
            &mut domain.com_twitter
        }

        public fun get_Domain_com_discord(domain:&Domain):&vector<u8>{
            &domain.com_discord
        }
        public fun get_mut_Domain_com_discord(domain:&mut Domain):&mut vector<u8>{
            &mut domain.com_discord
        }

        public fun get_Domain_com_github(domain:&Domain):&vector<u8>{
            &domain.com_github
        }
        public fun get_mut_Domain_com_github(domain:&mut Domain):&mut vector<u8>{
            &mut domain.com_github
        }

        public fun get_STCNS_Body_Main(body:&STCNS_Body):&Domain{
            &body.Main
        }
        public fun get_mut_STCNS_Body_Main(body:&mut STCNS_Body):&mut Domain{
            &mut body.Main
        }

        public fun get_STCNS_Body_Sub(body:&STCNS_Body):&vector<Subdomain>{
            &body.Sub
        }
        public fun get_mut_STCNS_Body_Sub(body:&mut STCNS_Body):&mut vector<Subdomain>{
            &mut body.Sub
        }
        

        public fun get_mut_ShardCap_mint_cap(shardcap:&mut ShardCap):&mut NFT::MintCapability<STCNS_Meta>{
            &mut shardcap.mint_cap
        }
        public fun get_mut_ShardCap_burn_cap(shardcap:&mut ShardCap):&mut NFT::BurnCapability<STCNS_Meta>{
            &mut shardcap.burn_cap
        }
        public fun get_mut_ShardCap_updata_cap(shardcap:&mut ShardCap):&mut NFT::UpdateCapability<STCNS_Meta>{
            &mut shardcap.updata_cap
        }





        public fun get_Admin_Control_Can_Send(admin_control:&Admin_Control):&bool{
            &admin_control.Can_Send
        }
        public fun get_mut_Admin_Control_Can_Send(admin_control:&mut Admin_Control):&mut bool{
            &mut admin_control.Can_Send
        }

        public fun get_Admin_Control_Can_Resolver(admin_control:&Admin_Control):&bool{
            &admin_control.Can_Resolver
        }
        public fun get_mut_Admin_Control_Can_Resolver(admin_control:&mut Admin_Control):&mut bool{
            &mut admin_control.Can_Resolver
        }

        public fun get_Admin_Control_Can_Change_Resolver(admin_control:&Admin_Control):&bool{
            &admin_control.Can_Change_Resolver
        }
        public fun get_mut_Admin_Control_Can_Change_Resolver(admin_control:&mut Admin_Control):&mut bool{
            &mut admin_control.Can_Change_Resolver
        }

        public fun get_Admin_Control_Can_Register(admin_control:&Admin_Control):&bool{
            &admin_control.Can_Register
        }
        public fun get_mut_Admin_Control_Can_Register(admin_control:&mut Admin_Control):&mut bool{
            &mut admin_control.Can_Register
        }

        public fun get_Admin_Control_Pricerange_1(admin_control:&Admin_Control):&u64{
            &admin_control.Pricerange_1
        }
        public fun get_mut_Admin_Control_Pricerange_1(admin_control:&mut Admin_Control):&mut u64{
            &mut admin_control.Pricerange_1
        }

        public fun get_Admin_Control_Pricerange_2(admin_control:&Admin_Control):&u64{
            &admin_control.Pricerange_2
        }
        public fun get_mut_Admin_Control_Pricerange_2(admin_control:&mut Admin_Control):&mut u64{
            &mut admin_control.Pricerange_2
        }

        public fun get_Admin_Control_Pricerange_3(admin_control:&Admin_Control):&u64{
            &admin_control.Pricerange_3
        }
        public fun get_mut_Admin_Control_Pricerange_3(admin_control:&mut Admin_Control):&mut u64{
            &mut admin_control.Pricerange_3
        }

        public fun get_Admin_Control_Word_upper_limit(admin_control:&Admin_Control):&u64{
            &admin_control.Word_upper_limit
        }
        public fun get_mut_Admin_Control_Word_upper_limit(admin_control:&mut Admin_Control):&mut u64{
            &mut admin_control.Word_upper_limit
        }

        public fun get_Admin_Control_Price_1(admin_control:&Admin_Control):&u64{
            &admin_control.Price_1
        }
        public fun get_mut_Admin_Control_Price_1(admin_control:&mut Admin_Control):&mut u64{
            &mut admin_control.Price_1
        }

        public fun get_Admin_Control_Price_2(admin_control:&Admin_Control):&u64{
            &admin_control.Price_2
        }
        public fun get_mut_Admin_Control_Price_2(admin_control:&mut Admin_Control):&mut u64{
            &mut admin_control.Price_2
        }
        
        public fun get_Admin_Control_Price_3(admin_control:&Admin_Control):&u64{
            &admin_control.Price_3
        }
        public fun get_mut_Admin_Control_Price_3(admin_control:&mut Admin_Control):&mut u64{
            &mut admin_control.Price_3
        }

//   Expired
        public fun Is_Domain_NFT_Expired(nft:&NFT::NFT<STCNS_Meta,STCNS_Body>):bool{
            let meta = NFT::get_type_meta(nft);
            let expiration_time = get_STCNS_Meta_Expiration_time(meta);
            if(Timestamp::now_seconds() > *expiration_time){
               return  true
            };
            false
        }

        public fun Is_Domain_Index_Expired(list:&vector<NFT::NFT<STCNS_Meta,STCNS_Body>>,i:u64):bool{

        }


    }
}