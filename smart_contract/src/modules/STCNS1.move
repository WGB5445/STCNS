address 0x413c244e089787d792f76cf8a756c13c {
    module STCNS1{

        use 0x1::Vector;
        use 0x1::Signer;
        use 0x1::Timestamp;
        use 0x1::NFT;
        use 0x1::Option;
        use 0x1::Account;
        const ADMAIN_ADDRESS : address = @0x413c244e089787d792f76cf8a756c13c;
        
        
        const ERR_IS_NOT_ADMIN:u64 = 10000;
        const CAN_NOT_FINDED:u64 = 10001;
         // init 
        const ERR_ADMIN_IS_NOT_INIT:u64 = 100010;
        const ERR_USER_IS_NOT_INIT:u64 = 100011;
        const ERR_ADMIN_IS_INITED:u64 = 10012;
        const ERR_USER_IS_INITED:u64 = 10013;

        const ERR_DOMAIN_TOO_LANG:u64 = 10100;
        const ERR_DOMAIN_HAVE_DOT:u64 = 10101;
        const ERR_DOMAIN_IS_REGISTERED :u64 = 10102;
        const ERR_DOMAIN_IS_EXP:u64 = 10103;
        const ERR_DOMAIN_IS_NOT_YOUR:u64 = 10104;

        const ERR_DONT_HAVE_STC:u64    = 10200;
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
//   STCNS_admin
        // public fun get_Domain_NFT(domain:&vector<u8>):&NFT::NFT<STCNS_Meta,STCNS_Body>{
            
        // }
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
            let nft = Vector::borrow<NFT::NFT<STCNS_Meta,STCNS_Body>>(list, i);
            return Is_Domain_NFT_Expired(nft)
        }

        public fun Is_Domain_Expired_STCNS_List(stcns_list:&STCNS_List,domain:&vector<u8>):bool{
            let list = get_STCNS_List_List(stcns_list);
            let op_list_index = Index_of_List(list,domain);
            if(Option::is_some<u64>(&op_list_index)){
                return Is_Domain_Index_Expired(list,*Option::borrow<u64>(&op_list_index))
            };
            abort(CAN_NOT_FINDED)

        }
        public fun Is_Domain_Expired_STCNS_Admin(domain:&vector<u8>):bool acquires STCNS_Admin, STCNS_List{
            let stcns_admin = borrow_global<STCNS_Admin>(ADMAIN_ADDRESS);
            let domains =  get_STCNS_Admin_Domains(stcns_admin);
            let op_index_domains =  Index_of_Domains(domains,domain);
            if(Option::is_some<u64>(&op_index_domains)){
                let stcns_admin_doamin = Vector::borrow<STCNS_Admin_Domain>(domains ,*Option::borrow<u64>(&op_index_domains));
                let owner =  get_STCNS_Admin_Domain_Owner(stcns_admin_doamin);
                let stcns_list = borrow_global<STCNS_List>(*owner);
                return Is_Domain_Expired_STCNS_List(stcns_list,domain)
            };
            abort(ERR_DOMAIN_HAVE_DOT)
        }
//     NFT send
        public fun Send_NFT_to_list (list:&mut vector<NFT::NFT<STCNS_Meta,STCNS_Body>>,nft:NFT::NFT<STCNS_Meta,STCNS_Body>){
            Vector::push_back<NFT::NFT<STCNS_Meta,STCNS_Body>>(list,nft);
        }

        public fun Send_NFT_to_address (addr:&address,nft:NFT::NFT<STCNS_Meta,STCNS_Body>) acquires  STCNS_List{
            assert(!Is_User_init(addr),ERR_USER_IS_INITED);
            let stcns_list = borrow_global_mut<STCNS_List>(*addr);
            let list = get_mut_STCNS_List_List(stcns_list);
            Send_NFT_to_list(list,nft);
        }

//      init 
        public fun Is_User_init(addr:&address):bool{
            return exists<STCNS_List>(*addr)
        }
        public fun User_init(account :&signer){
            assert(!Is_User_init(&Signer::address_of(account)),ERR_USER_IS_INITED);
            let list = STCNS_List{
                List: Vector::empty<NFT::NFT<STCNS_Meta,STCNS_Body>>()
            };
            move_to<STCNS_List>(account, list);
        }

        public fun Is_Admin_init():bool{
            return exists<STCNS_Admin>(ADMAIN_ADDRESS)
        }
        public fun Admin_init(account :&signer){
            assert(!Is_Admin_init(),ERR_ADMIN_IS_INITED);
            let account_address =  Signer::address_of(account);
            assert(ADMAIN_ADDRESS == account_address,  ERR_IS_NOT_ADMIN);
            if(! Is_Admin_init()){
                let stcns_admin = STCNS_Admin{
                    Domains         : Vector::empty<STCNS_Admin_Domain>()
                };
                move_to<STCNS_Admin>(account, stcns_admin);
            };
            if(!exists<Admin_Control>(ADMAIN_ADDRESS)){
                let admin_control = Admin_Control{
                                Can_Send        : true,
                                Can_Resolver    : true,
                                Can_Change_Resolver: true,
                                Can_Register    : true,

                                Pricerange_1      :4,
                                Pricerange_2      :9,
                                Pricerange_3      :100,
                                
                                Word_upper_limit  : 100,

                                Price_1         : 50,
                                Price_2         : 20,
                                Price_3         : 5
                };
                move_to<Admin_Control>(account, admin_control);
            };

            NFT::register_v2<STCNS_Meta>(account,NFT::new_meta(x"68656c6c6f20776f726c64",x"68656c6c6f20776f726c64"));

            let nft_mint_cap = NFT::remove_mint_capability<STCNS_Meta>(account);
            let nft_burn_cap = NFT::remove_burn_capability<STCNS_Meta>(account);
            let nft_updata_cap = NFT::remove_update_capability<STCNS_Meta>(account);

            move_to(account, ShardCap {mint_cap:nft_mint_cap,burn_cap:nft_burn_cap,updata_cap:nft_updata_cap});
        }
//      Much
        public fun get_much_Doamin(domain:&vector<u8>):u128 acquires Admin_Control{
            let admin_control = borrow_global<Admin_Control>(ADMAIN_ADDRESS);
            let price1 = get_Admin_Control_Price_1(admin_control);
            let price2 = get_Admin_Control_Price_2(admin_control);
            let price3 = get_Admin_Control_Price_3(admin_control);

            let range1 = get_Admin_Control_Pricerange_1(admin_control);
            let range2 = get_Admin_Control_Pricerange_2(admin_control);
            let range3 = get_Admin_Control_Pricerange_3(admin_control);

            let length = Vector::length<u8>(domain);
            
            let n = 9;
            let u_stc = 12;

            if(length <= *range1){
                return ( n as u128) * (u_stc as u128) * (*price1 as u128)
            }else if(length > *range2 && length <= *range3){
                return ( n as u128) * (u_stc as u128) * (*price2 as u128)
            }else {
                return( n as u128) * (u_stc as u128) * (*price3 as u128)
            }
        }
//      domain
        public fun Is_Good_Domain(domain:&vector<u8>):bool  acquires Admin_Control{
            let admin_control = borrow_global<Admin_Control>(ADMAIN_ADDRESS);
            let word_upper_limit = get_Admin_Control_Word_upper_limit(admin_control);
            let length = Vector::length<u8>(domain);
            assert(length <= *word_upper_limit, ERR_DOMAIN_TOO_LANG);
            let i = 0;
            while(i < length){
                assert(*Vector::borrow<u8>(domain, i) != 46u8, ERR_DOMAIN_HAVE_DOT);
                i = i + 1;
            };
            true
        }
        public fun Is_Root_Domain(domain:&vector<u8>):bool{
            let length = Vector::length<u8>(domain);
            let i = 0;
            while(i < length){
                if(*Vector::borrow<u8>(domain, i) == 46u8){
                    return false
                };
                i = i + 1;
            };
            true
        }
        public fun Split_Domain(domain:&vector<u8>):vector<vector<u8>>{
            if(Is_Root_Domain(domain)){
               return Vector::singleton<vector<u8>>(*domain)
            };
            let length = Vector::length<u8>(domain);
            let domains = Vector::empty<vector<u8>>();
            let i = 0;
            let l = 0;

            while(i < length){
                if(*Vector::borrow<u8>(domain, i) == 46u8){
                    let v = Vector::empty<u8>();
                    while(l < i){
                        Vector::push_back<u8>(&mut v,*Vector::borrow<u8>(domain,l));
                        l = l + 1;
                    };
                    l = l + 1;
                    Vector::push_back<vector<u8>>(&mut domains, v);
                };
                i = i + 1;
            };
            let v = Vector::empty<u8>();
                    while(l < i){
                        Vector::push_back<u8>(&mut v,*Vector::borrow<u8>(domain,l));
                        l = l + 1;
                    };
            Vector::push_back<vector<u8>>(&mut domains, v);
            return domains

        }
        public fun Is_Doamin_registered(domain:&vector<u8>):bool acquires  STCNS_Admin{
            let stcns_admin = borrow_global<STCNS_Admin>(ADMAIN_ADDRESS);
            let domains =  get_STCNS_Admin_Domains(stcns_admin);
            let op_index_domains =  Index_of_Domains(domains,domain);
            if(Option::is_some<u64>(&op_index_domains)){
                return true
            };
            return false
        }
//      register
        public fun register(account:&signer,domain:&vector<u8>,year:u64)acquires Admin_Control ,STCNS_Admin ,STCNS_List,ShardCap{
            assert(Is_Admin_init(), ERR_ADMIN_IS_NOT_INIT);
            Is_Good_Domain(domain);
            let addr = Signer::address_of(account);
            if(!Is_User_init(&addr)){
                User_init(account);
            };
            let is_register = Is_Doamin_registered(domain);
            
            if(is_register){
                let is_expired = Is_Domain_Expired_STCNS_Admin(domain);
                assert(is_expired, ERR_DOMAIN_IS_REGISTERED);
            };
            let balance = Account::balance<0x1::STC::STC>(addr);
            
            let much = get_much_Doamin(domain);
            assert(balance < (much * (year as u128) ), ERR_DONT_HAVE_STC);
            // 

            if(is_register){
                let stcns_admin = borrow_global_mut<STCNS_Admin>(ADMAIN_ADDRESS);
                let stcns_admin_domains = get_STCNS_Admin_Domains(stcns_admin);
                let op_stcns_admin_index = Index_of_Domains(stcns_admin_domains,domain);
                let domains = get_mut_STCNS_Admin_Domains(stcns_admin);
                let stcns_admin_doamin = Vector::borrow_mut<STCNS_Admin_Domain>(domains ,*Option::borrow<u64>(&op_stcns_admin_index));
                let owner =  get_STCNS_Admin_Domain_Owner(stcns_admin_doamin);
                let stcns_list = borrow_global_mut<STCNS_List>(*owner);
                let list = get_mut_STCNS_List_List(stcns_list);
                let op_stcns_list_index = Index_of_List(list,domain);
                if(Option::is_some<u64>(&op_stcns_list_index)){
                    //
                    let nft = Vector::remove<NFT::NFT<STCNS_Meta,STCNS_Body>>(list,  *Option::borrow<u64>(&op_stcns_list_index));
                    let to_stcns_list = borrow_global_mut<STCNS_List>(addr);
                    let to_list = get_mut_STCNS_List_List(to_stcns_list);
                    Vector::push_back<NFT::NFT<STCNS_Meta,STCNS_Body>>(to_list, nft);
                    
                    let old_owner =  get_mut_STCNS_Admin_Domain_Owner(stcns_admin_doamin);
                    *old_owner  = addr;
                };
            }
            else{
                //mint
                let meta = STCNS_Meta {

                        Domain_name         :   *domain,
                        Controller          :   ADMAIN_ADDRESS  ,
                        Create_time         :   Timestamp::now_seconds(),
                        Expiration_time     :   Timestamp::now_seconds() + 31536000 * year

                    };
                let body = STCNS_Body{
                            Main        :  Domain{  
                                        STC_address         :    Signer::address_of(account) ,
                                        ETH_address         :    Vector::empty<u8>(),
                                        BTC_address         :   Vector::empty<u8>()  ,
                                        LTC_address         :   Vector::empty<u8>()  ,

                                        Email               :  Vector::empty<u8>() ,
                                        Website             :   Vector::empty<u8>()  ,
                                        com_twitter         :  Vector::empty<u8>()  ,
                                        com_discord         :  Vector::empty<u8>()  ,
                                        com_github          :  Vector::empty<u8>()  , 
                                    },
                            Sub   :  Vector::empty<Subdomain>()
                        };

                let cap = borrow_global_mut<ShardCap>(ADMAIN_ADDRESS);
                let nft = NFT::mint_with_cap_v2<STCNS_Meta,STCNS_Body>(Signer::address_of(account),&mut cap.mint_cap,NFT::new_meta(x"5354434e53",x"5354434e53"),meta,body);
                let stcns_admin = borrow_global_mut<STCNS_Admin>(ADMAIN_ADDRESS);
                let domains = get_mut_STCNS_Admin_Domains(stcns_admin);
                Vector::push_back<STCNS_Admin_Domain>(domains, STCNS_Admin_Domain{
                                                        Name                : *domain,
                                                        Owner               : addr
                                                    });
                let stcns_list = borrow_global_mut<STCNS_List>(addr);
                let list = get_mut_STCNS_List_List(stcns_list);
                Vector::push_back<NFT::NFT<STCNS_Meta,STCNS_Body>>(list, nft);
            }
        }
//
    }
}
