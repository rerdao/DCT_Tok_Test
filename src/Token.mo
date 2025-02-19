import Buffer "mo:base/Buffer";
import D "mo:base/Debug";
import ExperimentalCycles "mo:base/ExperimentalCycles";

import Principal "mo:base/Principal";
// import Time "mo:base/Time";

// import CertifiedData "mo:base/CertifiedData";
import CertTree "mo:cert/CertTree";

import ICRC1 "mo:icrc1-mo/ICRC1";
import ICRC2 "mo:icrc2-mo/ICRC2";
import ICRC3 "mo:icrc3-mo/";
import ICRC4 "mo:icrc4-mo/ICRC4";

shared ({ caller = _owner }) actor class Token  (args: ?{
    icrc1 : ?ICRC1.InitArgs;
    icrc2 : ?ICRC2.InitArgs;
    icrc3 : ICRC3.InitArgs; //already typed nullable
    icrc4 : ?ICRC4.InitArgs;
  }
) = this{

    let default_icrc1_args : ICRC1.InitArgs = {
      name = ?"DCitizen Token";
      symbol = ?"DCT";
      logo = ?"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAACXBIWXMAAA7EAAAOxAGVKw4bAAAEqmlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPD94cGFja2V0IGJlZ2luPSfvu78nIGlkPSdXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQnPz4KPHg6eG1wbWV0YSB4bWxuczp4PSdhZG9iZTpuczptZXRhLyc+CjxyZGY6UkRGIHhtbG5zOnJkZj0naHR0cDovL3d3dy53My5vcmcvMTk5OS8wMi8yMi1yZGYtc3ludGF4LW5zIyc+CgogPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9JycKICB4bWxuczpBdHRyaWI9J2h0dHA6Ly9ucy5hdHRyaWJ1dGlvbi5jb20vYWRzLzEuMC8nPgogIDxBdHRyaWI6QWRzPgogICA8cmRmOlNlcT4KICAgIDxyZGY6bGkgcmRmOnBhcnNlVHlwZT0nUmVzb3VyY2UnPgogICAgIDxBdHRyaWI6Q3JlYXRlZD4yMDI1LTAyLTE5PC9BdHRyaWI6Q3JlYXRlZD4KICAgICA8QXR0cmliOkV4dElkPjIxNmMzNmY4LTM1ODEtNDhjNS04ZWU5LTdmN2ZkNzFiMzUxNDwvQXR0cmliOkV4dElkPgogICAgIDxBdHRyaWI6RmJJZD41MjUyNjU5MTQxNzk1ODA8L0F0dHJpYjpGYklkPgogICAgIDxBdHRyaWI6VG91Y2hUeXBlPjI8L0F0dHJpYjpUb3VjaFR5cGU+CiAgICA8L3JkZjpsaT4KICAgPC9yZGY6U2VxPgogIDwvQXR0cmliOkFkcz4KIDwvcmRmOkRlc2NyaXB0aW9uPgoKIDxyZGY6RGVzY3JpcHRpb24gcmRmOmFib3V0PScnCiAgeG1sbnM6ZGM9J2h0dHA6Ly9wdXJsLm9yZy9kYy9lbGVtZW50cy8xLjEvJz4KICA8ZGM6dGl0bGU+CiAgIDxyZGY6QWx0PgogICAgPHJkZjpsaSB4bWw6bGFuZz0neC1kZWZhdWx0Jz5EQ1QgLSAxPC9yZGY6bGk+CiAgIDwvcmRmOkFsdD4KICA8L2RjOnRpdGxlPgogPC9yZGY6RGVzY3JpcHRpb24+CgogPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9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";
      decimals = 8;
      fee = ?#Fixed(10000);
      minting_account = ?{
        owner = _owner;
        subaccount = null;
      };
      max_supply = null;
      min_burn_amount = ?10000;
      max_memo = ?64;
      advanced_settings = null;
      metadata = null;
      fee_collector = null;
      transaction_window = null;
      permitted_drift = null;
      max_accounts = ?1000000000;
      settle_to_accounts = ?99999000;
    };

    let default_icrc2_args : ICRC2.InitArgs = {
      max_approvals_per_account = ?10000;
      max_allowance = ?#TotalSupply;
      fee = ?#ICRC1;
      advanced_settings = null;
      max_approvals = ?10000000;
      settle_to_approvals = ?9990000;
    };

    let default_icrc3_args : ICRC3.InitArgs = ?{
      maxActiveRecords = 3000;
      settleToRecords = 2000;
      maxRecordsInArchiveInstance = 100000000;
      maxArchivePages = 62500;
      archiveIndexType = #Stable;
      maxRecordsToArchive = 8000;
      archiveCycles = 6_000_000_000_000;
      archiveControllers = null;//??[put cycle ops prinicpal here];
      supportedBlocks = [
        {
          block_type = "1xfer"; 
          url="https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3";
        },
        {
          block_type = "2xfer"; 
          url="https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3";
        },
        {
          block_type = "2approve"; 
          url="https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3";
        },
        {
          block_type = "1mint"; 
          url="https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3";
        },
        {
          block_type = "1burn"; 
          url="https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3";
        }
      ];
    };

    let default_icrc4_args : ICRC4.InitArgs = {
      max_balances = ?200;
      max_transfers = ?200;
      fee = ?#ICRC1;
    };

    let icrc1_args : ICRC1.InitArgs = switch(args){
      case(null) default_icrc1_args;
      case(?args){
        switch(args.icrc1){
          case(null) default_icrc1_args;
          case(?val){
            {
              val with minting_account = switch(
                val.minting_account){
                  case(?val) ?val;
                  case(null) {?{
                    owner = _owner;
                    subaccount = null;
                  }};
                };
            };
          };
        };
      };
    };

    let icrc2_args : ICRC2.InitArgs = switch(args){
      case(null) default_icrc2_args;
      case(?args){
        switch(args.icrc2){
          case(null) default_icrc2_args;
          case(?val) val;
        };
      };
    };


    let icrc3_args : ICRC3.InitArgs = switch(args){
      case(null) default_icrc3_args;
      case(?args){
        switch(args.icrc3){
          case(null) default_icrc3_args;
          case(?val) ?val;
        };
      };
    };

    let icrc4_args : ICRC4.InitArgs = switch(args){
      case(null) default_icrc4_args;
      case(?args){
        switch(args.icrc4){
          case(null) default_icrc4_args;
          case(?val) val;
        };
      };
    };

    stable let icrc1_migration_state = ICRC1.init(ICRC1.initialState(), #v0_1_0(#id),?icrc1_args, _owner);
    stable let icrc2_migration_state = ICRC2.init(ICRC2.initialState(), #v0_1_0(#id),?icrc2_args, _owner);
    stable let icrc4_migration_state = ICRC4.init(ICRC4.initialState(), #v0_1_0(#id),?icrc4_args, _owner);
    stable let icrc3_migration_state = ICRC3.init(ICRC3.initialState(), #v0_1_0(#id), icrc3_args, _owner);
    stable let cert_store : CertTree.Store = CertTree.newStore();
    let ct = CertTree.Ops(cert_store);


    stable var owner = _owner;

    let #v0_1_0(#data(icrc1_state_current)) = icrc1_migration_state;

    private var _icrc1 : ?ICRC1.ICRC1 = null;

    private func get_icrc1_state() : ICRC1.CurrentState {
      return icrc1_state_current;
    };

    private func get_icrc1_environment() : ICRC1.Environment {
    {
      get_time = null;
      get_fee = null;
      add_ledger_transaction = ?icrc3().add_record;
      can_transfer = null; //set to a function to intercept and add validation logic for transfers
    };
  };

    func icrc1() : ICRC1.ICRC1 {
    switch(_icrc1){
      case(null){
        let initclass : ICRC1.ICRC1 = ICRC1.ICRC1(?icrc1_migration_state, Principal.fromActor(this), get_icrc1_environment());
        ignore initclass.register_supported_standards({
          name = "ICRC-3";
          url = "https://github.com/dfinity/ICRC/ICRCs/icrc-3/"
        });
        ignore initclass.register_supported_standards({
          name = "ICRC-10";
          url = "https://github.com/dfinity/ICRC/ICRCs/icrc-10/"
        });
        _icrc1 := ?initclass;
        initclass;
      };
      case(?val) val;
    };
  };

  let #v0_1_0(#data(icrc2_state_current)) = icrc2_migration_state;

  private var _icrc2 : ?ICRC2.ICRC2 = null;

  private func get_icrc2_state() : ICRC2.CurrentState {
    return icrc2_state_current;
  };

  private func get_icrc2_environment() : ICRC2.Environment {
    {
      icrc1 = icrc1();
      get_fee = null;
      can_approve = null; //set to a function to intercept and add validation logic for approvals
      can_transfer_from = null; //set to a function to intercept and add validation logic for transfer froms
    };
  };

  func icrc2() : ICRC2.ICRC2 {
    switch(_icrc2){
      case(null){
        let initclass : ICRC2.ICRC2 = ICRC2.ICRC2(?icrc2_migration_state, Principal.fromActor(this), get_icrc2_environment());
        _icrc2 := ?initclass;
        initclass;
      };
      case(?val) val;
    };
  };

  let #v0_1_0(#data(icrc4_state_current)) = icrc4_migration_state;

  private var _icrc4 : ?ICRC4.ICRC4 = null;

  private func get_icrc4_state() : ICRC4.CurrentState {
    return icrc4_state_current;
  };

  private func get_icrc4_environment() : ICRC4.Environment {
    {
      icrc1 = icrc1();
      get_fee = null;
      can_approve = null; //set to a function to intercept and add validation logic for approvals
      can_transfer_from = null; //set to a function to intercept and add validation logic for transfer froms
    };
  };

  func icrc4() : ICRC4.ICRC4 {
    switch(_icrc4){
      case(null){
        let initclass : ICRC4.ICRC4 = ICRC4.ICRC4(?icrc4_migration_state, Principal.fromActor(this), get_icrc4_environment());
        _icrc4 := ?initclass;
        initclass;
      };
      case(?val) val;
    };
  };

  let #v0_1_0(#data(icrc3_state_current)) = icrc3_migration_state;

  private var _icrc3 : ?ICRC3.ICRC3 = null;

  private func get_icrc3_state() : ICRC3.CurrentState {
    return icrc3_state_current;
  };

  func get_state() : ICRC3.CurrentState{
    return icrc3_state_current;
  };

  private func get_icrc3_environment() : ICRC3.Environment {
    ?{
      updated_certification = ?updated_certification;
      get_certificate_store = ?get_certificate_store;
    };
  };

  func ensure_block_types(icrc3Class: ICRC3.ICRC3) : () {
    let supportedBlocks = Buffer.fromIter<ICRC3.BlockType>(icrc3Class.supported_block_types().vals());

    let blockequal = func(a : {block_type: Text}, b : {block_type: Text}) : Bool {
      a.block_type == b.block_type;
    };

    if(Buffer.indexOf<ICRC3.BlockType>({block_type = "1xfer"; url="";}, supportedBlocks, blockequal) == null){
      supportedBlocks.add({
            block_type = "1xfer"; 
            url="https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3";
          });
    };

    if(Buffer.indexOf<ICRC3.BlockType>({block_type = "2xfer"; url="";}, supportedBlocks, blockequal) == null){
      supportedBlocks.add({
            block_type = "2xfer"; 
            url="https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3";
          });
    };

    if(Buffer.indexOf<ICRC3.BlockType>({block_type = "2approve";url="";}, supportedBlocks, blockequal) == null){
      supportedBlocks.add({
            block_type = "2approve"; 
            url="https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3";
          });
    };

    if(Buffer.indexOf<ICRC3.BlockType>({block_type = "1mint";url="";}, supportedBlocks, blockequal) == null){
      supportedBlocks.add({
            block_type = "1mint"; 
            url="https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3";
          });
    };

    if(Buffer.indexOf<ICRC3.BlockType>({block_type = "1burn";url="";}, supportedBlocks, blockequal) == null){
      supportedBlocks.add({
            block_type = "1burn"; 
            url="https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3";
          });
    };

    icrc3Class.update_supported_blocks(Buffer.toArray(supportedBlocks));
  };

  func icrc3() : ICRC3.ICRC3 {
    switch(_icrc3){
      case(null){
        let initclass : ICRC3.ICRC3 = ICRC3.ICRC3(?icrc3_migration_state, Principal.fromActor(this), get_icrc3_environment());
        _icrc3 := ?initclass;
        ensure_block_types(initclass);

        initclass;
      };
      case(?val) val;
    };
  };

  private func updated_certification(cert: Blob, lastIndex: Nat) : Bool{

    // D.print("updating the certification " # debug_show(CertifiedData.getCertificate(), ct.treeHash()));
    ct.setCertifiedData();
    // D.print("did the certification " # debug_show(CertifiedData.getCertificate()));
    return true;
  };

  private func get_certificate_store() : CertTree.Store {
    // D.print("returning cert store " # debug_show(cert_store));
    return cert_store;
  };

  /// Functions for the ICRC1 token standard
  public shared query func icrc1_name() : async Text {
      icrc1().name();
  };

  public shared query func icrc1_symbol() : async Text {
      icrc1().symbol();
  };

  public shared query func icrc1_decimals() : async Nat8 {
      icrc1().decimals();
  };

  public shared query func icrc1_fee() : async ICRC1.Balance {
      icrc1().fee();
  };

  public shared query func icrc1_metadata() : async [ICRC1.MetaDatum] {
      icrc1().metadata()
  };

  public shared query func icrc1_total_supply() : async ICRC1.Balance {
      icrc1().total_supply();
  };

  public shared query func icrc1_minting_account() : async ?ICRC1.Account {
      ?icrc1().minting_account();
  };

  public shared query func icrc1_balance_of(args : ICRC1.Account) : async ICRC1.Balance {
      icrc1().balance_of(args);
  };

  public shared query func icrc1_supported_standards() : async [ICRC1.SupportedStandard] {
      icrc1().supported_standards();
  };

  public shared query func icrc10_supported_standards() : async [ICRC1.SupportedStandard] {
      icrc1().supported_standards();
  };

  public shared ({ caller }) func icrc1_transfer(args : ICRC1.TransferArgs) : async ICRC1.TransferResult {
      switch(await* icrc1().transfer_tokens(caller, args, false, null)){
        case(#trappable(val)) val;
        case(#awaited(val)) val;
        case(#err(#trappable(err))) D.trap(err);
        case(#err(#awaited(err))) D.trap(err);
      };
  };

  public shared ({ caller }) func mint(args : ICRC1.Mint) : async ICRC1.TransferResult {
      if(caller != owner){ D.trap("Unauthorized")};

      switch( await* icrc1().mint_tokens(caller, args)){
        case(#trappable(val)) val;
        case(#awaited(val)) val;
        case(#err(#trappable(err))) D.trap(err);
        case(#err(#awaited(err))) D.trap(err);
      };
  };

  public shared ({ caller }) func burn(args : ICRC1.BurnArgs) : async ICRC1.TransferResult {
      switch( await*  icrc1().burn_tokens(caller, args, false)){
        case(#trappable(val)) val;
        case(#awaited(val)) val;
        case(#err(#trappable(err))) D.trap(err);
        case(#err(#awaited(err))) D.trap(err);
      };
  };

   public query ({ caller }) func icrc2_allowance(args: ICRC2.AllowanceArgs) : async ICRC2.Allowance {
      return icrc2().allowance(args.spender, args.account, false);
    };

  public shared ({ caller }) func icrc2_approve(args : ICRC2.ApproveArgs) : async ICRC2.ApproveResponse {
      switch(await*  icrc2().approve_transfers(caller, args, false, null)){
        case(#trappable(val)) val;
        case(#awaited(val)) val;
        case(#err(#trappable(err))) D.trap(err);
        case(#err(#awaited(err))) D.trap(err);
      };
  };

  public shared ({ caller }) func icrc2_transfer_from(args : ICRC2.TransferFromArgs) : async ICRC2.TransferFromResponse {
      switch(await* icrc2().transfer_tokens_from(caller, args, null)){
        case(#trappable(val)) val;
        case(#awaited(val)) val;
        case(#err(#trappable(err))) D.trap(err);
        case(#err(#awaited(err))) D.trap(err);
      };
  };

  public query func icrc3_get_blocks(args: ICRC3.GetBlocksArgs) : async ICRC3.GetBlocksResult{
    return icrc3().get_blocks(args);
  };

  public query func icrc3_get_archives(args: ICRC3.GetArchivesArgs) : async ICRC3.GetArchivesResult{
    return icrc3().get_archives(args);
  };

  public query func icrc3_get_tip_certificate() : async ?ICRC3.DataCertificate {
    return icrc3().get_tip_certificate();
  };

  public query func icrc3_supported_block_types() : async [ICRC3.BlockType] {
    return icrc3().supported_block_types();
  };

  public query func get_tip() : async ICRC3.Tip {
    return icrc3().get_tip();
  };

  public shared ({ caller }) func icrc4_transfer_batch(args: ICRC4.TransferBatchArgs) : async ICRC4.TransferBatchResults {
      switch(await* icrc4().transfer_batch_tokens(caller, args, null, null)){
        case(#trappable(val)) val;
        case(#awaited(val)) val;
        case(#err(#trappable(err))) err;
        case(#err(#awaited(err))) err;
      };
  };

  public shared query func icrc4_balance_of_batch(request : ICRC4.BalanceQueryArgs) : async ICRC4.BalanceQueryResult {
      icrc4().balance_of_batch(request);
  };

  public shared query func icrc4_maximum_update_batch_size() : async ?Nat {
      ?icrc4().get_state().ledger_info.max_transfers;
  };

  public shared query func icrc4_maximum_query_batch_size() : async ?Nat {
      ?icrc4().get_state().ledger_info.max_balances;
  };

  public shared ({ caller }) func admin_update_owner(new_owner : Principal) : async Bool {
    if(caller != owner){ D.trap("Unauthorized")};
    owner := new_owner;
    return true;
  };

  public shared ({ caller }) func admin_update_icrc1(requests : [ICRC1.UpdateLedgerInfoRequest]) : async [Bool] {
    if(caller != owner){ D.trap("Unauthorized")};
    return icrc1().update_ledger_info(requests);
  };

  public shared ({ caller }) func admin_update_icrc2(requests : [ICRC2.UpdateLedgerInfoRequest]) : async [Bool] {
    if(caller != owner){ D.trap("Unauthorized")};
    return icrc2().update_ledger_info(requests);
  };

  public shared ({ caller }) func admin_update_icrc4(requests : [ICRC4.UpdateLedgerInfoRequest]) : async [Bool] {
    if(caller != owner){ D.trap("Unauthorized")};
    return icrc4().update_ledger_info(requests);
  };

  /* /// Uncomment this code to establish have icrc1 notify you when a transaction has occured.
  private func transfer_listener(trx: ICRC1.Transaction, trxid: Nat) : () {

  };

  /// Uncomment this code to establish have icrc1 notify you when a transaction has occured.
  private func approval_listener(trx: ICRC2.TokenApprovalNotification, trxid: Nat) : () {

  };

  /// Uncomment this code to establish have icrc1 notify you when a transaction has occured.
  private func transfer_from_listener(trx: ICRC2.TransferFromNotification, trxid: Nat) : () {

  }; */

  private stable var _init = false;
  public shared(msg) func admin_init() : async () {
    //can only be called once


    if(_init == false){
      //ensure metadata has been registered
      let test1 = icrc1().metadata();
      let test2 = icrc2().metadata();
      let test4 = icrc4().metadata();
      let test3 = icrc3().stats();

      //uncomment the following line to register the transfer_listener
      //icrc1().register_token_transferred_listener<system>("my_namespace", transfer_listener);

      //uncomment the following line to register the transfer_listener
      //icrc2().register_token_approved_listener<system>("my_namespace", approval_listener);

      //uncomment the following line to register the transfer_listener
      //icrc2().register_transfer_from_listener<system>("my_namespace", transfer_from_listener);
    };
    _init := true;
  };


  // Deposit cycles into this canister.
  public shared func deposit_cycles() : async () {
      let amount = ExperimentalCycles.available();
      let accepted = ExperimentalCycles.accept<system>(amount);
      assert (accepted == amount);
  };

  system func postupgrade() {
    //re wire up the listener after upgrade
    //uncomment the following line to register the transfer_listener
      //icrc1().register_token_transferred_listener("my_namespace", transfer_listener);

      //uncomment the following line to register the transfer_listener
      //icrc2().register_token_approved_listener("my_namespace", approval_listener);

      //uncomment the following line to register the transfer_listener
      //icrc2().register_transfer_from_listener("my_namespace", transfer_from_listener);
  };

};
