address 0x413c244e089787d792f76cf8a756c13c {
    module stcns3{

        
        use 0x1::Vector;
        use 0x1::Signer;

        use 0x1::NFT;
        use 0x1::Errors;
        use 0x1::Option;
        use 0x1::Timestamp;


       const ADMAIN_ADDRESS : address = @0x413c244e089787d792f76cf8a756c13c;
       const ERR_ADMIN_NOT_INIT:u64 = 1000;
        const ERR_DOMAIN_TOO_LANG :u64 = 2000;
        const ERR_DOMAIN_HAVE_DOT : u64 = 2001;
        const ERR_DOMAIN_IS_REGISTERED : u64 = 2002;
        const ERR_NOT_CapAddress : u64 = 1001;
        struct STCns_List has store,key{
            ns : vector<NFT::NFT<STCns_Meta,STCns_Body>>
        }
        struct STCns_Meta has copy ,store ,drop ,key{
            Name                :   vector<u8>,
            
            Domain_name         :   vector<u8>,

            Registrant          :   address     ,
            Controller          :   address     ,
            
            Create_time         :   u64,
            Expiration_time     :   u64,


        }
        
        struct STCns_Body has copy ,store ,drop ,key{
            Resolver            :   STCns_Resolver
        }
       
        struct STCns_Resolver has copy,store, drop,key{
            Domain           :   STCns_Domains,
            Subdomains       :   vector<STCns_Subdomains>
        }
       
        struct Owner_Domains has copy ,store , drop,key{
            Domains             :   vector<Owner_Data>,
        }

        
        struct Owner_Data has copy,store ,drop,key{
            Domain_name         :   vector<u8>,
            Owner               :   address,
        }


       
        struct STCns_Domains has copy,store ,drop ,key{
            Domains_name                :   vector<u8>  ,
            Record                      :   STCns_Dommains_Record,
        }
        
       
        struct STCns_Dommains_Record has copy,store,drop,key{
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
        
        struct STCns_Subdomains has copy,store,drop,key{
            Subdomains_name             :   vector<u8>  ,
            Record                      :   STCns_Subdomains_Record,
        }
        
        struct STCns_Subdomains_Record has copy,store,drop,key{
            STC_address         :   address     ,
            ETH_address         :   vector<u8>    ,
            BTC_address         :   vector<u8>  ,
            LTC_address         :   vector<u8>  ,

            Email               :   vector<u8>  ,
            Website             :   vector<u8>  ,
            com_twitter         :   vector<u8>  ,
            com_discord         :   vector<u8>  ,
            com_github          :   vector<u8>  , 
        }

        struct ShardCap has key, store{
            mint_cap: NFT::MintCapability<STCns_Meta>,

        }
        
        fun register (_account:&signer, _domain: &vector<u8> ,   _year:  u64 )acquires  Owner_Domains , ShardCap ,STCns_List{
               let owner_domains =  borrow_global_mut<Owner_Domains>(ADMAIN_ADDRESS);
               let domains = &mut owner_domains.Domains;
               Vector::push_back<Owner_Data>(domains,Owner_Data{
                   Domain_name:*_domain,
                   Owner:Signer::address_of(_account)
               });
              if(! exists<STCns_List>(Signer::address_of(_account))){
                  let list = STCns_List{
                      ns: Vector::empty<NFT::NFT<STCns_Meta,STCns_Body>>()
                  };
                  move_to<STCns_List>(_account, list);
              };
               mint(_account,_domain,_year);
            

       }
       
       public fun   Register (_account:&signer,domain:&vector<u8>,_year:u64) acquires Owner_Domains , ShardCap ,STCns_List{
               if( IsRegister(domain)){
                    abort(1001)
               }
               else{
                    register(_account,domain,_year);
               }
       }
      
       public fun IsRegister  (domain:&vector<u8>):bool acquires Owner_Domains{
           

           let owner_domains = borrow_global<Owner_Domains>(ADMAIN_ADDRESS);
           let domains = *&owner_domains.Domains;
           let length = Vector::length<Owner_Data>(&domains);
           let i:u64 = 0; 
           while(i < length){
               let _domain = Vector::borrow<Owner_Data>(&domains,i);
               if(Utils_vector_comp(&_domain.Domain_name,domain)){
                   return true
               };
               i = i + 1;
           };
            false
       }

        fun Utils_vector_comp(a:&vector<u8>,b:&vector<u8>):bool{
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


        fun is_gotime(addr:&address,domain:&vector<u8>):bool acquires STCns_List{
            let index = find_address_nft_index(addr,domain);
            if(Option::is_none<u64>(&index)){
                return true
            }else{
                let list = borrow_global<STCns_List>(*addr);
                let nft = Vector::borrow<NFT::NFT<STCns_Meta,STCns_Body>>(&list.ns, *Option::borrow<u64>(&index));
                let expiration_time = Timestamp::now_seconds();
                let meta = NFT::get_type_meta<STCns_Meta,STCns_Body>(nft);
                if(*&meta.Expiration_time < expiration_time){
                    return false
                }
                
            };
            return true
        }

        fun find_address_nft_index(addr:&address,domain:&vector<u8>):Option::Option<u64>  acquires STCns_List{ 
            let list = borrow_global<STCns_List>(*addr);
            let length = Vector::length<NFT::NFT<STCns_Meta,STCns_Body>>(&list.ns);
            let i = 0;

            while(i < length){
                let nft = Vector::borrow<NFT::NFT<STCns_Meta,STCns_Body>>(&list.ns,i);
                let _domain = &NFT::get_type_meta<STCns_Meta,STCns_Body>(nft).Domain_name;
                if(Utils_vector_comp(_domain,domain)){
                   return Option::some<u64>(i)
               };
                
                i = i + 1;
            };
            return Option::none<u64>()
        }
        fun change_owner(account:&signer,domain:&vector<u8>) acquires STCns_List ,Owner_Domains{
            let addr = Signer::address_of(account);
            if(is_gotime(&addr,domain)){
               abort(1020)
            };
            let owner_domains =  borrow_global_mut<Owner_Domains>(ADMAIN_ADDRESS);
            let domains = *&mut owner_domains.Domains;
            let length = Vector::length<Owner_Data>(&domains);
            let i:u64 = 0; 
            while(i < length){
                let _domain = Vector::borrow<Owner_Data>(&domains,i);
                if(Utils_vector_comp(&_domain.Domain_name,domain)){
                    let d = Vector::borrow_mut<Owner_Data>(&mut domains, i);
                    d.Owner = addr;
                    break
                };
                i = i + 1;
            };

            // let meta = Get_domain_nftMeta(&addr,domain);

        }
       
        fun change_rsolver_stcaddress(record:&mut STCns_Dommains_Record,addr:&address) {
            record.STC_address = *addr;
        }

        fun change_rsolver_ethaddress(record:&mut STCns_Dommains_Record,addr:&vector<u8>) {
            let length = Vector::length<u8>(&record.ETH_address);
            let i = 0;
            while(i < length){
                Vector::pop_back<u8>(&mut record.ETH_address);
                i = i + 1;
            };
            Vector::append<u8>(&mut record.ETH_address, *addr);
        }
        fun change_rsolver_btcaddress(record:&mut STCns_Dommains_Record,addr:&vector<u8>) {
            let length = Vector::length<u8>(&record.BTC_address);
            let i = 0;
            while(i < length){
                Vector::pop_back<u8>(&mut record.BTC_address);
                i = i + 1;
            };
            Vector::append<u8>(&mut record.BTC_address, *addr);
        }
        fun change_rsolver_ltcaddress(record:&mut STCns_Dommains_Record,addr:&vector<u8>) {
            let length = Vector::length<u8>(&record.LTC_address);
            let i = 0;
            while(i < length){
                Vector::pop_back<u8>(&mut record.LTC_address);
                i = i + 1;
            };
            Vector::append<u8>(&mut record.LTC_address, *addr);
        }
        fun change_rsolver_email(record:&mut STCns_Dommains_Record,addr:&vector<u8>) {
            let length = Vector::length<u8>(&record.Email);
            let i = 0;
            while(i < length){
                Vector::pop_back<u8>(&mut record.Email);
                i = i + 1;
            };
            Vector::append<u8>(&mut record.Email, *addr);
        }
        fun change_rsolver_website(record:&mut STCns_Dommains_Record,addr:&vector<u8>) {
            let length = Vector::length<u8>(&record.Website);
            let i = 0;
            while(i < length){
                Vector::pop_back<u8>(&mut record.Website);
                i = i + 1;
            };
            Vector::append<u8>(&mut record.Website, *addr);
        }

        fun change_rsolver_twitter(record:&mut STCns_Dommains_Record,addr:&vector<u8>) {
            let length = Vector::length<u8>(&record.com_twitter);
            let i = 0;
            while(i < length){
                Vector::pop_back<u8>(&mut record.com_twitter);
                i = i + 1;
            };
            Vector::append<u8>(&mut record.com_twitter, *addr);
        }
        fun change_rsolver_discord(record:&mut STCns_Dommains_Record,addr:&vector<u8>) {
            let length = Vector::length<u8>(&record.com_discord);
            let i = 0;
            while(i < length){
                Vector::pop_back<u8>(&mut record.com_discord);
                i = i + 1;
            };
            Vector::append<u8>(&mut record.com_discord, *addr);
        }

        fun change_rsolver_github(record:&mut STCns_Dommains_Record,addr:&vector<u8>) {
            let length = Vector::length<u8>(&record.com_github);
            let i = 0;
            while(i < length){
                Vector::pop_back<u8>(&mut record.com_github);
                i = i + 1;
            };
            Vector::append<u8>(&mut record.com_github, *addr);
        }
        
        fun mint(account:&signer,domain:&vector<u8>,year:u64) acquires ShardCap ,STCns_List{
            let account_address =  Signer::address_of(account);

            let meta = STCns_Meta {
                Name:   x"7374636e73",
                Domain_name: *domain,
                Registrant: account_address,
                Controller: account_address,
                Create_time: Timestamp::now_seconds(),
                Expiration_time: Timestamp::now_seconds() + 31536000 * year
            };
            let body = STCns_Body{
                Resolver:   STCns_Resolver{
                    Domain: STCns_Domains{
                        Domains_name: Vector::empty<u8>(),
                        Record:     STCns_Dommains_Record{
                            STC_address:    account_address,
                            ETH_address:    Vector::empty<u8>(),
                            BTC_address         :   Vector::empty<u8>()  ,
                            LTC_address         :   Vector::empty<u8>()  ,

                            Email               :  Vector::empty<u8>() ,
                            Website             :   Vector::empty<u8>()  ,
                            com_twitter         :  Vector::empty<u8>()  ,
                            com_discord         :  Vector::empty<u8>()  ,
                            com_github          :  Vector::empty<u8>()  , 

                        }
                    },
                    Subdomains        :Vector::empty<STCns_Subdomains>()
                }
            };
            let cap = borrow_global_mut<ShardCap>(ADMAIN_ADDRESS);
            let nft = NFT::mint_with_cap_v2<STCns_Meta,STCns_Body>(account_address,&mut cap.mint_cap,NFT::new_meta(x"7374636e73",x"7374636e73"),meta,body);
            let list = borrow_global_mut<STCns_List>(account_address);
            Vector::push_back<NFT::NFT<STCns_Meta,STCns_Body>>(&mut list.ns, nft);
        }

        public fun rsolver_subdomain(domain:&vector<u8>):vector<vector<u8>>{
                let length = Vector::length<u8>(domain);
                let i = 0;
                let j = 0;
                let subdomains = Vector::empty<u8>();
                let domains_tree = Vector::empty<vector<u8>>();
                Vector::push_back<vector<u8>>(&mut domains_tree, subdomains);
                while(i < length){
                    let t = Vector::borrow<u8>(domain, i);
                    if(*t == 46u8){
                        j = j + 1;
                        i = i + 1;
                        Vector::push_back<vector<u8>>(&mut domains_tree, Vector::empty<u8>());
                        continue
                    };
                    let subdomains_name =  Vector::borrow_mut<vector<u8>>(&mut domains_tree, j);
                    Vector::push_back<u8>( subdomains_name, *t);
                    i= i + 1;
                };
                return domains_tree
        }

        public fun Get_domain_owner(domain:&vector<u8>):address acquires Owner_Domains{
             let owner_domains = borrow_global<Owner_Domains>(ADMAIN_ADDRESS);
           let domains = *&owner_domains.Domains;
           let length = Vector::length<Owner_Data>(&domains);
           let i:u64 = 0; 
           while(i < length){
               let _domain = Vector::borrow<Owner_Data>(&domains,i);
               if(Utils_vector_comp(&_domain.Domain_name,domain)){
                   return _domain.Owner
               };
               i = i + 1;
           };
           @0x0
        }
        public fun Get_domain_nftBody(addr:&address, domain:&vector<u8>):Option::Option<STCns_Body> acquires STCns_List{
            let list = borrow_global<STCns_List>(*addr);
            let length = Vector::length<NFT::NFT<STCns_Meta,STCns_Body>>(&list.ns);
            let i = 0;

            while(i < length){
                let nft = Vector::borrow<NFT::NFT<STCns_Meta,STCns_Body>>(&list.ns,i);
                let _domain = &NFT::get_type_meta<STCns_Meta,STCns_Body>(nft).Domain_name;
                if(Utils_vector_comp(_domain,domain)){
                   return Option::some(*NFT::borrow_body<STCns_Meta,STCns_Body>(nft))
               };
                
                i = i + 1;
            };
            return Option::none<STCns_Body>()
        }
        public fun Get_domain_nftMeta(addr:&address, domain:&vector<u8>):Option::Option<STCns_Meta> acquires STCns_List{
            let list = borrow_global<STCns_List>(*addr);
            let length = Vector::length<NFT::NFT<STCns_Meta,STCns_Body>>(&list.ns);
            let i = 0;

            while(i < length){
                let nft = Vector::borrow<NFT::NFT<STCns_Meta,STCns_Body>>(&list.ns,i);
                let _domain = &NFT::get_type_meta<STCns_Meta,STCns_Body>(nft).Domain_name;
                if(Utils_vector_comp(_domain,domain)){
                   return Option::some(*NFT::get_type_meta<STCns_Meta,STCns_Body>(nft))
               };
                
                i = i + 1;
            };
            return Option::none<STCns_Meta>()
        }
        
        public (script) fun init(account:signer){
            let account_address =  Signer::address_of(&account);
            assert(ADMAIN_ADDRESS == account_address,  Errors::invalid_argument(ERR_NOT_CapAddress));
            if(! exists<Owner_Domains>(ADMAIN_ADDRESS)){
                let owner_domains = Owner_Domains{
                    Domains         : Vector::empty<Owner_Data>()
                };
                move_to<Owner_Domains>(&account, owner_domains);
            };
            NFT::register_v2<STCns_Meta>(&account,NFT::new_meta(x"68656c6c6f20776f726c64",x"68656c6c6f20776f726c64"));
            let nft_mint_cap = NFT::remove_mint_capability<STCns_Meta>(&account);
            move_to(&account, ShardCap {mint_cap:nft_mint_cap});
        }
        public fun check_admin_is_init():bool  {
           return exists<Owner_Domains>(ADMAIN_ADDRESS)
        }
        public fun check_address_is_init(addr:&address):bool {
            return exists<Owner_Domains>(*addr)
        }

        public fun check_register_domain(domain:&vector<u8>):bool{
            let length = Vector::length<u8>(domain);
            assert(length <= 50u64, ERR_DOMAIN_TOO_LANG);
            let i = 0;
            while(i < length){
                assert(*Vector::borrow<u8>(domain, i) != 46u8, ERR_DOMAIN_HAVE_DOT);
                i = i + 1;
            };
            true
        }

        public fun check_domain_is_registered(domain:&vector<u8>):bool acquires Owner_Domains{
            assert(check_admin_is_init(), ERR_ADMIN_NOT_INIT);
            let owner_domains = borrow_global<Owner_Domains>(ADMAIN_ADDRESS);
            let owner_datas = *&owner_domains.Domains;
            let length = Vector::length<Owner_Data>(&owner_datas);
            let i = 0; 
            while(i < length){
                let owner_data = Vector::borrow<Owner_Data>(&owner_datas,i);
                if(Utils_vector_comp(&owner_data.Domain_name,domain)){
                    return true
                };
                i = i + 1;
            };
            return false
        }

        public (script) fun register_domain(account:signer,domain:vector<u8>,year:u64) acquires Owner_Domains {//, ShardCap ,STCns_List{
                assert(check_admin_is_init(), ERR_ADMIN_NOT_INIT);
                check_register_domain(&domain);
                assert(!check_domain_is_registered(&domain), ERR_DOMAIN_IS_REGISTERED);
                // Register(&_account,&_domain,_year);
        }
        public (script) fun Resolution_stcaddress(domain:vector<u8>):address acquires Owner_Domains ,STCns_List{
            let owner = Get_domain_owner(&domain);
            assert(owner != @0x0, 2000);
            let op_stcns_Body = Get_domain_nftBody(&owner,&domain);
            if(Option::is_some<STCns_Body>(&op_stcns_Body)){
            let stcn_body = Option::borrow<STCns_Body>(&op_stcns_Body);
                let resolver = *&stcn_body.Resolver;
                let domains_tree = rsolver_subdomain(&domain);
                let length = Vector::length<vector<u8>>(&domains_tree);
                if(length == 1){
                    let addr = *&(*&(*&resolver.Domain).Record).STC_address;
                    return addr
                }else{
                        
                }
            };
           abort(2001)
        }
        public (script) fun Resolution_ethaddress(domain:vector<u8>):vector<u8> acquires Owner_Domains ,STCns_List{
            let owner = Get_domain_owner(&domain);
            assert(owner != @0x0, 2000);
            let op_stcns_Body = Get_domain_nftBody(&owner,&domain);
            if(Option::is_some<STCns_Body>(&op_stcns_Body)){
            let stcn_body = Option::borrow<STCns_Body>(&op_stcns_Body);
                let resolver = *&stcn_body.Resolver;
                let domains_tree = rsolver_subdomain(&domain);
                let length = Vector::length<vector<u8>>(&domains_tree);
                if(length == 1){
                    let addr = *&(*&(*&resolver.Domain).Record).ETH_address;
                    return addr
                }else{
                        
                }
            };
           abort(2001)
        }
    }
}