address 0x413c244e089787d792f76cf8a756c13c {
    module STCNS{
        use 0x1::Vector;
        use 0x1::Signer;
        use 0x1::Timestamp;
        use 0x1::NFT;
        use 0x1::Option;
        const ERR_IS_NOT_ADMIN :u64 = 10000;
        const ERR_ADMIN_IS_NOT_INIT:u64 = 100011;
        const ERR_ADMIN_IS_INIT:u64 = 10012;
        const ERR_USER_IS_INIT:u64 = 10013;
        const ERR_DOMAIN_TOO_LANG:u64 = 10100;
        const ERR_DOMAIN_HAVE_DOT:u64 = 10101;
        const ERR_DOMAIN_IS_REGISTERED :u64 = 10102;
        const ERR_DOMAIN_IS_EXP:u64 = 10103;

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
        const ADMAIN_ADDRESS : address = @0x413c244e089787d792f76cf8a756c13c;

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
        
        public fun get_STCNS_Admin_index(stcns_admin:&STCNS_Admin,domain:&vector<u8>):Option::Option<u64>{
            let domains = get_STCNS_Admin_Domains(stcns_admin);
            let length = Vector::length<STCNS_Admin_Domain>(domains);
            let i = 0;
            while(i < length){
                let stcns_admin_doamin = Vector::borrow<STCNS_Admin_Domain>(domains ,i);
                let name = get_STCNS_Admin_Domain_Name(stcns_admin_doamin);
                if(Utils_vector_cmp(name,domain)){
                    return Option::some<u64>(i)
                };
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


        public fun get_STCNS_List_index(stcns_list:&STCNS_List,domain:&vector<u8>):Option::Option<u64> {
            let list = get_STCNS_List_List(stcns_list);
            let length = Vector::length<NFT::NFT<STCNS_Meta,STCNS_Body>>(list);
            let i = 0;
            while(i < length){
                let nft = Vector::borrow<NFT::NFT<STCNS_Meta,STCNS_Body>>(list, i);
                let meta = NFT::get_type_meta(nft);
                let domain_name = get_STCNS_Meta_Domain_name(meta);
                if(Utils_vector_cmp(domain_name,domain)){
                    return Option::some<u64>(i)
                };
                i = i + 1;
            };
            Option::none<u64>()
        }

        public fun get_STCNS_Body_Main(body:&STCNS_Body):&Domain{
            &body.Main
        }
        public fun get_mut_STCNS_Body_Main(body:&mut STCNS_Body):&mut Domain{
            &mut body.Main
        }

        public fun get_Domain_STC_address(domain:&Domain):&address{
            &domain.STC_address
        }

        public fun get_mut_Domain_STC_address(domain:&mut Domain):&mut address{
            &mut domain.STC_address    
        }


        public fun Find_domain_owner(domains:&vector<STCNS_Admin_Domain>,domain:&vector<u8>):&address{
            let length = Vector::length<STCNS_Admin_Domain>(domains);
            let i = 0;
            while(i < length){
                let j = Vector::borrow<STCNS_Admin_Domain>(domains, i);
                let _domain = get_STCNS_Admin_Domain_Name(j);
                if(Utils_vector_cmp(_domain,domain)){
                    return get_STCNS_Admin_Domain_Owner(j)
                };
                i = i + 1;
            };
            abort(10010)
        }
        public fun Find_mut_domain_owner(domains:&mut vector<STCNS_Admin_Domain>,domain:&vector<u8>):&mut address{
            let length = Vector::length<STCNS_Admin_Domain>(domains);
            let i = 0;
            while(i < length){
                let j = Vector::borrow_mut<STCNS_Admin_Domain>(domains, i);
                let _domain = get_mut_STCNS_Admin_Domain_Name(j);
                if(Utils_vector_cmp(_domain,domain)){
                    return get_mut_STCNS_Admin_Domain_Owner(j)
                };
                i = i + 1;
            };
            abort(10010)
        }

        public fun Find_List_nft(list:&vector<NFT::NFT<STCNS_Meta,STCNS_Body>>,domain:&vector<u8>):&NFT::NFT<STCNS_Meta,STCNS_Body>{
            let length = Vector::length<NFT::NFT<STCNS_Meta,STCNS_Body>>(list);
            let i = 0;
            while(i < length){
                let nft = Vector::borrow<NFT::NFT<STCNS_Meta,STCNS_Body>>(list, i);
                let meta = NFT::get_type_meta(nft);
                let domain_name = get_STCNS_Meta_Domain_name(meta);
                if(Utils_vector_cmp(domain_name,domain)){
                    return nft
                };
                i = i + 1;
            };
            abort(10011)
        }

        public fun Find_mut_List_nft(list:&mut vector<NFT::NFT<STCNS_Meta,STCNS_Body>>,domain:&vector<u8>):&mut NFT::NFT<STCNS_Meta,STCNS_Body>{
            let length = Vector::length<NFT::NFT<STCNS_Meta,STCNS_Body>>(list);
            let i = 0;
            while(i < length){
                let nft = Vector::borrow_mut<NFT::NFT<STCNS_Meta,STCNS_Body>>(list, i);
                let meta = NFT::get_type_meta(nft);
                let domain_name = get_STCNS_Meta_Domain_name(meta);
                if(Utils_vector_cmp(domain_name,domain)){
                    return nft
                };
                i = i + 1;
            };
            abort(10011)
        }

        public fun Is_Admin_Init():bool{
            return exists<STCNS_Admin>(ADMAIN_ADDRESS)
        }
        public fun Is_User_Init(addr:&address):bool{
            return exists<STCNS_List>(*addr)
        }

        public fun Is_Good_Domain(domain:&vector<u8>):bool{
            let length = Vector::length<u8>(domain);
            assert(length <= 50u64, ERR_DOMAIN_TOO_LANG);
            let i = 0;
            while(i < length){
                assert(*Vector::borrow<u8>(domain, i) != 46u8, ERR_DOMAIN_HAVE_DOT);
                i = i + 1;
            };
            true
        }

        public fun Is_Doamin_registered(domains:&vector<STCNS_Admin_Domain>,domain:&vector<u8>){
            let length = Vector::length<STCNS_Admin_Domain>(domains);
            let i = 0;
            while(i < length){
                let j = Vector::borrow<STCNS_Admin_Domain>(domains, i);
                let _domain = get_STCNS_Admin_Domain_Name(j);
                assert(Utils_vector_cmp(_domain,domain),ERR_DOMAIN_IS_REGISTERED);
                i = i + 1;
            };
        }

        public fun Is_Domain_Expired(domain:&vector<u8>,addr:address):bool acquires STCNS_List{
            let stcns_list  = borrow_global<STCNS_List>(addr);
            let op_index    = get_STCNS_List_index(stcns_list,domain);
            if(Option::is_some<u64>(&op_index)){
                let list = get_STCNS_List_List(stcns_list);
                let nft =  Vector::borrow<NFT::NFT<STCNS_Meta,STCNS_Body>>(list, *Option::borrow<u64>(&op_index));
                let meta = NFT::get_type_meta(nft);
                let expiration_time = get_STCNS_Meta_Expiration_time(meta);
                if(Timestamp::now_seconds() > *expiration_time){
                    false
                }
                else{
                    true
                };
            };
            false
        }

        public fun Is_Domain_index_Expired(list:&vector<NFT::NFT<STCNS_Meta,STCNS_Body>>,i:u64):bool{
            let nft = Vector::borrow<NFT::NFT<STCNS_Meta,STCNS_Body>>(list, i);
            Is_Domain_NFT_Expired(nft)
        }

        public fun Is_Domain_NFT_Expired(nft:&NFT::NFT<STCNS_Meta,STCNS_Body>):bool{
            let meta = NFT::get_type_meta(nft);
            let expiration_time = get_STCNS_Meta_Expiration_time(meta);
            if(Timestamp::now_seconds() > *expiration_time){
               return  false
            };
            true
        }

        public fun Admin_init(account :&signer){
            assert(!Is_Admin_Init(),ERR_ADMIN_IS_INIT);
            let account_address =  Signer::address_of(account);
            assert(ADMAIN_ADDRESS == account_address,  ERR_IS_NOT_ADMIN);
            if(! exists<STCNS_Admin>(ADMAIN_ADDRESS)){
                let stcns_admin = STCNS_Admin{
                    Domains         : Vector::empty<STCNS_Admin_Domain>()
                };
                move_to<STCNS_Admin>(account, stcns_admin);
            };
            NFT::register_v2<STCNS_Meta>(account,NFT::new_meta(x"68656c6c6f20776f726c64",x"68656c6c6f20776f726c64"));
            let nft_mint_cap = NFT::remove_mint_capability<STCNS_Meta>(account);
            let nft_burn_cap = NFT::remove_burn_capability<STCNS_Meta>(account);
            let nft_updata_cap = NFT::remove_update_capability<STCNS_Meta>(account);
            move_to(account, ShardCap {mint_cap:nft_mint_cap,burn_cap:nft_burn_cap,updata_cap:nft_updata_cap});
        }


        public fun User_init(account :&signer){
            assert(!Is_User_Init(&Signer::address_of(account)),ERR_USER_IS_INIT);
            let list = STCNS_List{
                List: Vector::empty<NFT::NFT<STCNS_Meta,STCNS_Body>>()
            };
            move_to<STCNS_List>(account, list);
        }

        public fun register_domain(account :&signer,domain:&vector<u8>,year:u64) acquires STCNS_Admin ,STCNS_List,ShardCap{
            assert(Is_Admin_Init(), ERR_ADMIN_IS_NOT_INIT);
            Is_Good_Domain(domain);
            if(!Is_User_Init(&Signer::address_of(account))){
                User_init(account);
            };
            register(account,domain,year);
        }

        
        fun register(account :&signer,domain:&vector<u8>,year:u64) acquires STCNS_Admin ,STCNS_List,ShardCap{
            let stcns_admin = borrow_global_mut<STCNS_Admin>(ADMAIN_ADDRESS);
            let domains = get_mut_STCNS_Admin_Domains(stcns_admin);
            Vector::push_back<STCNS_Admin_Domain>(domains, STCNS_Admin_Domain{
                                                    Name                : *domain,
                                                    Owner               : Signer::address_of(account)
                                                });
        
            let nft = mint(account,domain,year);
            let stcns_list = borrow_global_mut<STCNS_List>(Signer::address_of(account));
            let list = get_mut_STCNS_List_List(stcns_list);
            Vector::push_back<NFT::NFT<STCNS_Meta,STCNS_Body>>(list, nft);
        }

        fun mint(account :&signer,domain:&vector<u8>,year:u64):NFT::NFT<STCNS_Meta,STCNS_Body> acquires ShardCap{
            let meta = STCNS_Meta {

                        Domain_name         :   *domain,
                        Controller          :   Signer::address_of(account)     ,
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
                    Sub         :  Vector::empty<Subdomain>()
                    };

            let cap = borrow_global_mut<ShardCap>(ADMAIN_ADDRESS);
            let nft = NFT::mint_with_cap_v2<STCNS_Meta,STCNS_Body>(Signer::address_of(account),&mut cap.mint_cap,NFT::new_meta(x"5354434e53",x"5354434e53"),meta,body);
            return nft
        }
        


        public fun Resolution_main (domain:&vector<u8>):u64 acquires STCNS_Admin,STCNS_List{
            let stcns_admin = borrow_global<STCNS_Admin>(ADMAIN_ADDRESS);
            let op_stcns_admin_index = get_STCNS_Admin_index(stcns_admin,domain);
            if(Option::is_some<u64>(&op_stcns_admin_index)){
                let domains = get_STCNS_Admin_Domains(stcns_admin);
                let stcns_admin_doamin = Vector::borrow<STCNS_Admin_Domain>(domains ,*Option::borrow<u64>(&op_stcns_admin_index));
                let owner =  get_STCNS_Admin_Domain_Owner(stcns_admin_doamin);
                let stcns_list = borrow_global<STCNS_List>(*owner);
                let op_stcns_list_index = get_STCNS_List_index(stcns_list,domain);
                if(Option::is_some<u64>(&op_stcns_list_index)){
                    let list = get_STCNS_List_List(stcns_list);
                    let nft  = Vector::borrow<NFT::NFT<STCNS_Meta,STCNS_Body>>(list,*Option::borrow<u64>(&op_stcns_list_index));
                    if(Is_Domain_NFT_Expired(nft)){
                        abort(ERR_DOMAIN_IS_EXP)
                    }else{
                        return *Option::borrow<u64>(&op_stcns_list_index)
                    }
                }

            };
            abort(ERR_DOMAIN_IS_EXP)
        }
        public fun Resolution_stcaddress(domain:&vector<u8>):address acquires STCNS_Admin,STCNS_List{
            let stcns_admin = borrow_global<STCNS_Admin>(ADMAIN_ADDRESS);
            let op_stcns_admin_index = get_STCNS_Admin_index(stcns_admin,domain);
            if(Option::is_some<u64>(&op_stcns_admin_index)){
                let domains = get_STCNS_Admin_Domains(stcns_admin);
                let stcns_admin_doamin = Vector::borrow<STCNS_Admin_Domain>(domains ,*Option::borrow<u64>(&op_stcns_admin_index));
                let owner =  get_STCNS_Admin_Domain_Owner(stcns_admin_doamin);
                let stcns_list = borrow_global<STCNS_List>(*owner);
                let op_stcns_list_index = get_STCNS_List_index(stcns_list,domain);
                if(Option::is_some<u64>(&op_stcns_list_index)){
                    let list = get_STCNS_List_List(stcns_list);
                    let nft  = Vector::borrow<NFT::NFT<STCNS_Meta,STCNS_Body>>(list,*Option::borrow<u64>(&op_stcns_list_index));
                    if(Is_Domain_NFT_Expired(nft)){
                        abort(ERR_DOMAIN_IS_EXP)
                    }else{
                        let body = NFT::borrow_body(nft);
                        let main = get_STCNS_Body_Main(body);
                        let addr = get_Domain_STC_address(main);
                        return *addr
                    }
                }

            };
            abort(ERR_DOMAIN_IS_EXP)
            
        }
        
        public fun change_Resolver_main_stcaddress(body:&mut STCNS_Body,addr:address){
            let main = get_mut_STCNS_Body_Main(body);
            let stc_address = get_mut_Domain_STC_address(main);
            *stc_address = addr;
        }
        public fun change_Resolver_stcaddress(account:&signer,domain:&vector<u8>,addr:address)acquires STCNS_List ,ShardCap{
            let addr = Signer::address_of(account);
            let stcns_list = borrow_global_mut<STCNS_List>(addr);
            let list = get_mut_STCNS_List_List(stcns_list);
            let nft = Find_mut_List_nft(list,domain);
            let cap = borrow_global_mut<ShardCap>(ADMAIN_ADDRESS);
            let body = NFT::borrow_body_mut_with_cap<STCNS_Meta,STCNS_Body>(&mut cap.updata_cap,nft);
            change_Resolver_main_stcaddress(body,addr);
        }
        public fun send(account:&signer, domain:&vector<u8>,owner:address)acquires STCNS_List,STCNS_Admin{
            assert(!Is_User_Init(&owner),ERR_USER_IS_INIT);
            let addr = Signer::address_of(account);
            let stcns_list = borrow_global_mut<STCNS_List>(addr);
            let op_stcns_list_index = get_STCNS_List_index(stcns_list,domain);
            let list = get_mut_STCNS_List_List(stcns_list);
            
            if(Option::is_some<u64>(&op_stcns_list_index)){
                let nft = Vector::remove<NFT::NFT<STCNS_Meta,STCNS_Body>>(list,  *Option::borrow<u64>(&op_stcns_list_index));
                let to_stcns_list = borrow_global_mut<STCNS_List>(owner);
                let to_list = get_mut_STCNS_List_List(to_stcns_list);
                Vector::push_back<NFT::NFT<STCNS_Meta,STCNS_Body>>(to_list, nft);
                let stcns_admin = borrow_global_mut<STCNS_Admin>(ADMAIN_ADDRESS);
                let op_stcns_admin_index = get_STCNS_Admin_index(stcns_admin,domain);
                if(Option::is_some<u64>(&op_stcns_admin_index)){
                    let domains = get_mut_STCNS_Admin_Domains(stcns_admin);
                    let stcns_admin_doamin = Vector::borrow_mut<STCNS_Admin_Domain>(domains ,*Option::borrow<u64>(&op_stcns_admin_index));
                    let old_owner =  get_mut_STCNS_Admin_Domain_Owner(stcns_admin_doamin);
                    *old_owner  = owner;
                };
            };
             
        }
    }
    
    module STCNS_script{

        use 0x413c244e089787d792f76cf8a756c13c::STCNS;
        public (script) fun init(account:signer){
            STCNS::Admin_init(&account);
        }

        public (script) fun user_init(account:signer){
            STCNS::User_init(&account);
        }
        
        public (script) fun register_domain(account:signer,domain:vector<u8>,year:u64)  {
            STCNS::register_domain(&account,&domain,year);
        }
        public (script) fun change_Resolver_stcaddress(account:signer,domain:vector<u8>,addr:address){
            STCNS::change_Resolver_stcaddress(&account,&domain,addr);
        }
        public (script) fun Resolution_stcaddress(domain:vector<u8>):address{
            return  STCNS::Resolution_stcaddress(&domain)
        }

        public (script) fun send(account:signer, domain:vector<u8>,owner:address){
            STCNS::send(&account ,&domain,owner);
        }
        /*
        public (script) fun change_domain_owner(account:signer, domain:vector<u8>,owner:address) acquires Owner_Domains, STCns_List{
            assert(check_domain_at_address(&domain,&Signer::address_of(&account)), ERR_ADDRESS_IS_NOT_HAVE_DOMAIN);
            let owner_domains = borrow_global_mut<Owner_Domains>(Signer::address_of(&account));
            let addr = find_mut_Owner_IN_Owner_Domains( owner_domains,&domain);
            *addr = owner;
        }
        public (script) fun send(account :signer,domain:vector<u8>,addr:address){
            assert( check_address_is_init(&addr),ERR_ADDRESS_NOT_INIT);
            
        }
        public (script) fun change_Resolver_stcaddress(domain:vector<u8>,addr:address){
            
        }
        public (script) fun Resolution_stcaddress(domain:vector<u8>):address acquires Owner_Domains ,STCns_List{
            
            let owner = Get_domain_owner(&domain);
            assert(owner != @0x0, 2000);
            let op_stcns_Body = Get_domain_nftBody(&owner,&domain);
            let op_stcns_meta = Get_domain_nftMeta(&owner,&domain);
            if(Option::is_some<STCns_Body>(&op_stcns_Body)){
                let stcn_body = Option::borrow<STCns_Body>(&op_stcns_Body);
                let stcn_meta = Option::borrow<STCns_Meta>(&op_stcns_meta);
                assert( check_time_is_expired(*get_STCns_Meta_Expiration_time(stcn_meta)),ERR_DOMAIN_IS_EXP);
                let resolver = get_STCns_Body_Resolver(stcn_body);
                let domains_tree = rsolver_subdomain(&domain);
                let length = Vector::length<vector<u8>>(&domains_tree);
                if(length == 1){
                    let domain  = get_STCns_Resolver_Domain(resolver);
                    let record  = get_STCns_Domains_Record(domain);
                    let addr    = get_STCns_Dommains_Record_STC_address(record);
                    return *addr
                }else{
                        
                }
            };
           abort(2001)
        }
        public (script) fun Resolution_ethaddress(domain:vector<u8>):vector<u8> acquires Owner_Domains ,STCns_List{
            let owner = Get_domain_owner(&domain);
            assert(owner != @0x0, 2000);
            let op_stcns_Body = Get_domain_nftBody(&owner,&domain);
            let op_stcns_meta = Get_domain_nftMeta(&owner,&domain);
            if(Option::is_some<STCns_Body>(&op_stcns_Body)){
                let stcn_body = Option::borrow<STCns_Body>(&op_stcns_Body);
                let stcn_meta = Option::borrow<STCns_Meta>(&op_stcns_meta);
                assert( check_time_is_expired(*get_STCns_Meta_Expiration_time(stcn_meta)),ERR_DOMAIN_IS_EXP);
                let resolver = get_STCns_Body_Resolver(stcn_body);
                let domains_tree = rsolver_subdomain(&domain);
                let length = Vector::length<vector<u8>>(&domains_tree);
                if(length == 1){
                    let domain  = get_STCns_Resolver_Domain(resolver);
                    let record  = get_STCns_Domains_Record(domain);
                    let addr    = get_STCns_Dommains_Record_ETH_address(record);
                    return *addr
                }else{
                        
                }
            };
           abort(2001)
        }
        */
    }
    
}