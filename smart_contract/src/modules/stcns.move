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
       const ERR_ADDRESS_NOT_INIT:u64 = 1001;
       const ERR_ADDRESS_IS_INIT:u64 = 1002;
        const ERR_ADDRESS_IS_NOT_HAVE_DOMAIN:u64= 1003;

        const ERR_DOMAIN_TOO_LANG :u64 = 2000;
        const ERR_DOMAIN_HAVE_DOT : u64 = 2001;
        const ERR_DOMAIN_IS_REGISTERED : u64 = 2002;
        const ERR_DOMAIN_IS_EXP     :u64 = 2003;
        
        const ERR_NOT_CapAddress : u64 = 1001;

    // In admin struct 
        struct Owner_Domains has copy ,store , drop,key{
            Domains             :   vector<Owner_Data>,
        }

        
        struct Owner_Data has copy,store ,drop,key{
            Domain_name         :   vector<u8>,
            Owner               :   address,
        }
    // In admin struct end

    // In user struct
        struct STCns_List has store,key{
            ns : vector<NFT::NFT<STCns_Meta,STCns_Body>>
        }

    // In user struct end
    // NFT struct 

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
    struct STCns_Domains has copy,store ,drop ,key{
        Domains_name                :   vector<u8>  ,
        Record                      :   STCns_Dommains_Record,
    }
    struct STCns_Subdomains has copy,store,drop,key{
        Subdomains_name             :   vector<u8>  ,
        Record                      :   STCns_Subdomains_Record,
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
    // NFT struct end
        
    // NFT cap struct 
    struct ShardCap has key, store{
        mint_cap: NFT::MintCapability<STCns_Meta>,

    }
    // NFT cap struct end


       
       
        
       
        
        
        
        
        

        
        
        
//                        NFT fun
    public fun get_STCns_List_ns(list:&STCns_List):&vector<NFT::NFT<STCns_Meta,STCns_Body>>{
        &list.ns
    }
    public fun get_mut_STCns_List_ns(list:&mut STCns_List):&mut vector<NFT::NFT<STCns_Meta,STCns_Body>>{
        &mut list.ns
    }
//                        NFT fun end 

//                         STCns_Meta fun
/*
        struct STCns_Meta has copy ,store ,drop ,key{
            Name                :   vector<u8>,
            
            Domain_name         :   vector<u8>,

            Registrant          :   address     ,
            Controller          :   address     ,
            
            Create_time         :   u64,
            Expiration_time     :   u64,


        }
*/
    public fun get_STCns_Meta_Name(meta:&STCns_Meta):&vector<u8>{
        &meta.Name
    }
    public fun get_mut_STCns_Meta_Name(meta:&mut STCns_Meta):&mut vector<u8>{
        &mut meta.Name
    }

    public fun get_STCns_Meta_Domain_name(meta:&STCns_Meta):&vector<u8>{
        &meta.Domain_name
    }
    public fun get_mut_STCns_Meta_Domain_name(meta:&mut STCns_Meta):&mut vector<u8>{
        &mut meta.Domain_name
    }

    public fun get_STCns_Meta_Registrant(meta:&STCns_Meta):&address{
        &meta.Registrant
    }
    public fun get_mut_STCns_Meta_Registrant(meta:&mut STCns_Meta):&mut address{
        &mut meta.Registrant
    }

    public fun get_STCns_Meta_Controller(meta:&STCns_Meta):&address{
        &meta.Controller
    }
    public fun get_mut_STCns_Meta_Controller(meta:&mut STCns_Meta):&mut address{
        &mut meta.Controller
    }

    public fun get_STCns_Meta_Create_time(meta:&STCns_Meta):&u64{
        &meta.Create_time
    }
    public fun get_mut_STCns_Meta_Create_time(meta:&mut STCns_Meta):&mut u64{
        &mut meta.Create_time
    }
    
    public fun get_STCns_Meta_Expiration_time(meta:&STCns_Meta):&u64{
        &meta.Expiration_time
    }
    public fun get_mut_STCns_Meta_Expiration_time(meta:&mut STCns_Meta):&mut u64{
        &mut meta.Expiration_time
    }
//
//                      STCns_Body fun
/*
    struct STCns_Body has copy ,store ,drop ,key{
            Resolver            :   STCns_Resolver
        }
*/ 
    public fun get_STCns_Body_Resolver(body:&STCns_Body):&STCns_Resolver{
        &body.Resolver
    }
    public fun get_mut_STCns_Body_Resolver(body:&mut STCns_Body):&mut STCns_Resolver{
        &mut body.Resolver
    }
//                      STCns_Body fun end

//                      STCns_Resolver fun 
/*              
        struct STCns_Resolver has copy,store, drop,key{
            Domain           :   STCns_Domains,
            Subdomains       :   vector<STCns_Subdomains>
        }
*/
    public fun get_STCns_Resolver_Domain(resolver:&STCns_Resolver):&STCns_Domains{
        &resolver.Domain
    }
    public fun get_mut_STCns_Resolver_Domain(resolver:&mut STCns_Resolver):&mut STCns_Domains{
        &mut resolver.Domain
    }

    public fun get_STCns_Resolver_Subdomains(resolver:&STCns_Resolver):&vector<STCns_Subdomains>{
        &resolver.Subdomains
    }
    public fun get_mut_STCns_Resolver_Subdomains(resolver:&mut STCns_Resolver):&mut vector<STCns_Subdomains>{
        &mut resolver.Subdomains
    }

//                      STCns_Resolver fun end


//                      STCns_Domains  fun         
/*      

    struct STCns_Domains has copy,store ,drop ,key{
        Domains_name                :   vector<u8>  ,
        Record                      :   STCns_Dommains_Record,
    }
*/
    public fun get_STCns_Domains_Domains_name(resolver:&STCns_Domains):&vector<u8>{
        &resolver.Domains_name
    }
    public fun get_mut_STCns_Domains_Domains_name(resolver:&mut STCns_Domains):&mut vector<u8>{
        &mut resolver.Domains_name
    }

    public fun get_STCns_Domains_Record(resolver:&STCns_Domains):&STCns_Dommains_Record{
        &resolver.Record
    }
    public fun get_mut_STCns_Domains_Record(resolver:&mut STCns_Domains):&mut STCns_Dommains_Record{
        &mut resolver.Record
    }

//                      STCns_Domains fun end

//                      STCns_Subdomains fun 
/*
    struct STCns_Subdomains has copy,store,drop,key{
        Subdomains_name             :   vector<u8>  ,
        Record                      :   STCns_Subdomains_Record,
    }
*/
    public fun get_STCns_Subdomains_Subdomains_name(resolver:&STCns_Subdomains):&vector<u8>{
        &resolver.Subdomains_name
    }
    public fun get_mut_STCns_Subdomains_Subdomains_name(resolver:&mut STCns_Subdomains):&mut vector<u8>{
        &mut resolver.Subdomains_name
    }

    public fun get_STCns_Subdomains_Record(resolver:&STCns_Subdomains):&STCns_Subdomains_Record{
        &resolver.Record
    }
    public fun get_mut_STCns_Subdomains_Record(resolver:&mut STCns_Subdomains):&mut STCns_Subdomains_Record{
        &mut resolver.Record
    }

//                      STCns_Subdomains fun end

//                  STCns_Dommains_Record fun 
/*
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
*/

    public fun get_STCns_Dommains_Record_STC_address(record:&STCns_Dommains_Record):&address{
        &record.STC_address
    }
    public fun get_mut_STCns_Dommains_Record_STC_address(record:&mut STCns_Dommains_Record):&mut address{
        &mut record.STC_address
    }

    public fun get_STCns_Dommains_Record_ETH_address(record:&STCns_Dommains_Record):&vector<u8>{
        &record.ETH_address
    }
    public fun get_mut_STCns_Dommains_Record_ETH_address(record:&mut STCns_Dommains_Record):&mut vector<u8>{
        &mut record.ETH_address
    }

    public fun get_STCns_Dommains_Record_BTC_address(record:&STCns_Dommains_Record):&vector<u8>{
        &record.BTC_address
    }
    public fun get_mut_STCns_Dommains_Record_BTC_address(record:&mut STCns_Dommains_Record):&mut vector<u8>{
        &mut record.BTC_address
    }


    public fun get_STCns_Dommains_Record_LTC_address(record:&STCns_Dommains_Record):&vector<u8>{
        &record.LTC_address
    }
    public fun get_mut_STCns_Dommains_Record_LTC_address(record:&mut STCns_Dommains_Record):&mut vector<u8>{
        &mut record.LTC_address
    }

    public fun get_STCns_Dommains_Record_Email(record:&STCns_Dommains_Record):&vector<u8>{
        &record.Email
    }
    public fun get_mut_STCns_Dommains_Record_Email(record:&mut STCns_Dommains_Record):&mut vector<u8>{
        &mut record.Email
    }

    public fun get_STCns_Dommains_Record_Website(record:&STCns_Dommains_Record):&vector<u8>{
        &record.Website
    }
    public fun get_mut_STCns_Dommains_Record_Website(record:&mut STCns_Dommains_Record):&mut vector<u8>{
        &mut record.Website
    }

    public fun get_STCns_Dommains_Record_com_twitter(record:&STCns_Dommains_Record):&vector<u8>{
        &record.com_twitter
    }
    public fun get_mut_STCns_Dommains_Record_com_twitter(record:&mut STCns_Dommains_Record):&mut vector<u8>{
        &mut record.com_twitter
    }

    public fun get_STCns_Dommains_Record_com_discord(record:&STCns_Dommains_Record):&vector<u8>{
        &record.com_discord
    }
    public fun get_mut_STCns_Dommains_Record_com_discord(record:&mut STCns_Dommains_Record):&mut vector<u8>{
        &mut record.com_discord
    }

    public fun get_STCns_Dommains_Record_com_github(record:&STCns_Dommains_Record):&vector<u8>{
        &record.com_github
    }
    public fun get_mut_STCns_Dommains_Record_com_github(record:&mut STCns_Dommains_Record):&mut vector<u8>{
        &mut record.com_github
    }
    
//                  STCns_Dommains_Record fun end

//                      STCns_Subdomains fun end

//                  STCns_Subdomains_Record fun 
/*
    struct STCns_Subdomains_Record has copy,store,drop,key{
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
*/

    public fun get_STCns_Subdomains_Record_STC_address(record:&STCns_Subdomains_Record):&address{
        &record.STC_address
    }
    public fun get_mut_STCns_Subdomains_Record_STC_address(record:&mut STCns_Subdomains_Record):&mut address{
        &mut record.STC_address
    }

    public fun get_STCns_Subdomains_Record_ETH_address(record:&STCns_Subdomains_Record):&vector<u8>{
        &record.ETH_address
    }
    public fun get_mut_STCns_Subdomains_Record_ETH_address(record:&mut STCns_Subdomains_Record):&mut vector<u8>{
        &mut record.ETH_address
    }

    public fun get_STCns_Subdomains_Record_BTC_address(record:&STCns_Subdomains_Record):&vector<u8>{
        &record.BTC_address
    }
    public fun get_mut_STCns_Subdomains_Record_BTC_address(record:&mut STCns_Subdomains_Record):&mut vector<u8>{
        &mut record.BTC_address
    }


    public fun get_STCns_Subdomains_Record_LTC_address(record:&STCns_Subdomains_Record):&vector<u8>{
        &record.LTC_address
    }
    public fun get_mut_STCns_Subdomains_Record_LTC_address(record:&mut STCns_Subdomains_Record):&mut vector<u8>{
        &mut record.LTC_address
    }

    public fun get_STCns_Subdomains_Record_Email(record:&STCns_Subdomains_Record):&vector<u8>{
        &record.Email
    }
    public fun get_mut_STCns_Subdomains_Record_Email(record:&mut STCns_Subdomains_Record):&mut vector<u8>{
        &mut record.Email
    }

    public fun get_STCns_Subdomains_Record_Website(record:&STCns_Subdomains_Record):&vector<u8>{
        &record.Website
    }
    public fun get_mut_STCns_Subdomains_Record_Website(record:&mut STCns_Subdomains_Record):&mut vector<u8>{
        &mut record.Website
    }

    public fun get_STCns_Subdomains_Record_com_twitter(record:&STCns_Subdomains_Record):&vector<u8>{
        &record.com_twitter
    }
    public fun get_mut_STCns_Subdomains_Record_com_twitter(record:&mut STCns_Subdomains_Record):&mut vector<u8>{
        &mut record.com_twitter
    }

    public fun get_STCns_Subdomains_Record_com_discord(record:&STCns_Subdomains_Record):&vector<u8>{
        &record.com_discord
    }
    public fun get_mut_STCns_Subdomains_Record_com_discord(record:&mut STCns_Subdomains_Record):&mut vector<u8>{
        &mut record.com_discord
    }

    public fun get_STCns_Subdomains_Record_com_github(record:&STCns_Subdomains_Record):&vector<u8>{
        &record.com_github
    }
    public fun get_mut_STCns_Subdomains_Record_com_github(record:&mut STCns_Subdomains_Record):&mut vector<u8>{
        &mut record.com_github
    }
    
//                  STCns_Subdomains_Record fun end

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



        //                                   domain
        fun register (account:&signer, domain: &vector<u8> , year:  u64 )acquires  Owner_Domains , ShardCap ,STCns_List{
            let owner_domains =  borrow_global_mut<Owner_Domains>(ADMAIN_ADDRESS);
            let domains = &mut owner_domains.Domains;
            Vector::push_back<Owner_Data>(domains,Owner_Data{
                Domain_name:*domain,
                Owner:Signer::address_of(account)
            });
            if(!check_address_is_init(&Signer::address_of(account))){
                address_init(account);
            };

            mint(account,domain,year);
            

        }

        fun address_init(account:&signer){
            if(!check_address_is_init(&Signer::address_of(account))){
                let list = STCns_List{
                    ns: Vector::empty<NFT::NFT<STCns_Meta,STCns_Body>>()
                };
                move_to<STCns_List>(account, list);
            }else{
                abort(ERR_ADDRESS_IS_INIT)
            };
            
        }

        //                                   domain end



        //                                  check
        public fun check_admin_is_init():bool  {
           return exists<Owner_Domains>(ADMAIN_ADDRESS)
        }
        public fun check_address_is_init(addr:&address):bool {
            return exists<Owner_Domains>(*addr)
        }
        public fun check_time_is_expired(time:u64):bool{
            return Timestamp::now_seconds() > time 
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
        public fun check_domain_is_expired(domain:&vector<u8>,addr:&address):bool acquires STCns_List{
            if(check_domain_at_address(domain,addr)){
                let list = borrow_global<STCns_List>(*addr);
                let nfts = get_STCns_List_ns(list);
                let length = Vector::length<NFT::NFT<STCns_Meta,STCns_Body>>(nfts);
                let i = 0;

                while(i < length){
                    let nft = Vector::borrow<NFT::NFT<STCns_Meta,STCns_Body>>(nfts,i);
                    let _domain = &NFT::get_type_meta<STCns_Meta,STCns_Body>(nft).Domain_name;
                    if(Utils_vector_comp(_domain,domain)){
                        let meta = NFT::get_type_meta<STCns_Meta,STCns_Body>(nft);
                        let expiration_time = get_STCns_Meta_Expiration_time(meta);
                        if(Timestamp::now_seconds() > *expiration_time){
                            return true
                        }
                        else{
                            return false
                        }
                        
                    };
                    
                    i = i + 1;
                };
            }else{
                return false
            };
            return false
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
        public fun check_domain_at_address(domain:&vector<u8>,addr:&address):bool acquires STCns_List{
            if(check_address_is_init(addr)){
                let list = borrow_global<STCns_List>(*addr);
                let length = Vector::length<NFT::NFT<STCns_Meta,STCns_Body>>(&list.ns);
                let i = 0;
                while(i < length){
                    let nft = Vector::borrow<NFT::NFT<STCns_Meta,STCns_Body>>(&list.ns,i);
                    let _domain = &NFT::get_type_meta<STCns_Meta,STCns_Body>(nft).Domain_name;
                    if(Utils_vector_comp(_domain,domain)){
                        return true
                    };
                    i = i + 1;
                };
            }
            else{
                return false
            };
            return false
        }
        //                                  check end


        //                                   script
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
        
        public (script) fun register_domain(account:signer,domain:vector<u8>,year:u64) acquires Owner_Domains {//, ShardCap ,STCns_List{
                assert(check_admin_is_init(), ERR_ADMIN_NOT_INIT);
                check_register_domain(&domain);
                assert(!check_domain_is_registered(&domain), ERR_DOMAIN_IS_REGISTERED);
                // Register(&_account,&_domain,_year);
        }
        public (script) fun register_init(account:signer){
            address_init(&account);
        }
        public (script) fun change_domain_owner(account:signer, domain:vector<u8>,owner:address) acquires  STCns_List{
            assert(check_domain_at_address(&domain,&Signer::address_of(&account)), ERR_ADDRESS_IS_NOT_HAVE_DOMAIN);

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
    }
}