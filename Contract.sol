pragma solidity ^0.7.6;

contract Ownable {
    address public owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
     **/
   constructor() public {
      owner = msg.sender;
    }
    
    /**
     * @dev Throws if called by any account other than the owner.
     **/
    modifier onlyOwner() {
      require(msg.sender == owner);
      _;
    }
    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     **/
    function transferOwnership(address newOwner) public onlyOwner {
      require(newOwner != address(0));
      emit OwnershipTransferred(owner, newOwner);
      owner = newOwner;
    }
}


library data {
    /**
     * @dev Include all the details required for every phase in Emerald making lifecycle
     **/
    struct mining_status {
        
        string id;
        string origin;
        string mine;
        string color_grade;
        string weight;
        uint datetime;
        bytes32 image;
    }
    
    struct sorting_status {
        
        string id;
        string weight;
        string gemology;
        string color_grade;
        uint datetime;
        address sorted_by;
    }
    
    struct cuting_status {
        
        string id;
        string weight;
        string color_grade;
        string cut;
        uint datetime;
        address cut_by;
        bytes32 image;
        bytes32 video;
    }
    
    struct polishing_status {
        
        string id;
        string weight;
        string color_grade;
        string cut;
        string clarity;
        uint datetime;
        address polished_by;
        bytes32 image;
        bytes32 video;
    }
    
    /**
     * @dev Includes Certificate details issued by verifying authorities 
     **/
    
    struct certify {
        
        string id;
        string certificate_no;
        string gemology;
        bytes32 image;
    }
    
    struct store_details {
        
        string name;
        string[] stones;
        bytes32 image;
    }
    
    struct goldSmith_status {
        
        string id;
        string gold_carat;
        string gold_gram;
        string style;
        string diomands;
        string gems;
        string emerald;
    }
}

contract miner is Ownable {
    
    uint256 total_stones;
    
    /**
     * @dev Assign a unique id to stones and keep track of them 
     **/
    mapping ( uint256 => string ) public stone_id;
    
    /**
     * @dev Keep track of every details about stone in mining phase
     **/
    mapping ( string => data.mining_status) public mining_history;
    
    event Mined(string _id,string _origin,string _mine,string _weight,uint _datetime,bytes32 _image);
    
    event MinerAdded(address _eth_address,string _name,uint _age,uint _experience,bytes32 _image);
    
    /**
     * @dev Details for employees in the mining facility
     **/
    struct miner_detail {
        
        address eth_address;
        string name;
        uint age;
        uint experience;
        bytes32 image;
    }
    
    /**
     * @dev Keep track of details about employees in mining phase
     **/
    mapping ( address => miner_detail) public miners;
    
    /**
     * @dev set record of the stone mined
     **/
    function assetMined(string memory _id,string memory _weight,string memory _origin,string memory _mine,bytes32 _image) public returns (bool) {
        
        require(keccak256(abi.encodePacked(_id)) != keccak256(abi.encodePacked("")));
        require(keccak256(abi.encodePacked(_weight)) != keccak256(abi.encodePacked("")));
        require(keccak256(abi.encodePacked(_origin)) != keccak256(abi.encodePacked("")));
        require(keccak256(abi.encodePacked(_mine)) != keccak256(abi.encodePacked("")));
        require(keccak256(abi.encodePacked(_image)) != keccak256(abi.encodePacked("")));
        
        data.mining_status memory emerald;
        emerald.id = _id;
        emerald.origin = _origin;
        emerald.mine = _mine;
        emerald.weight = _weight;
        emerald.datetime = now;
        emerald.image = _image;
        
        stone_id[++total_stones] = _id;
        mining_history[_id] = emerald;
        
        emit Mined(emerald.id,emerald.origin,emerald.mine,emerald.weight,emerald.datetime,emerald.image);
        return true;
    }
    
    
    /**
     * @dev set record of employee in the mining phase 
     **/
    function minerAdded(address _eth_address,string memory _name,uint _age,uint _experience,bytes32 _image) public onlyOwner returns (bool) {
        
        miner_detail memory employee;
        
        employee.eth_address = _eth_address;
        employee.name = _name;
        employee.age = _age;
        employee.experience = _experience;
        employee.image = _image;
        
        miners[_eth_address] = employee;
        
        emit MinerAdded(employee.eth_address,employee.name,employee.age,employee.experience,employee.image);
        return true;
    }
    
}

contract sorter is Ownable {
    
    miner m;
    
    /**
     * @dev The sorter constructor sets an instance of excisting mining contract
     * @param _minerContract The address of deployed contract
     **/
    constructor(address _minerContract) public {
        
        m = miner(_minerContract);    
    }
    
    /**
     * @dev Keep track of every details about stone in sorting phase
     **/
    mapping ( string => data.sorting_status ) public sorting_history;
    
    event Sorted(string _id,string _weight,string _gemology,string _color_grade,uint _datetime,address _sorted_by);
    
    event SorterAdded(address _eth_address,string _name,uint _age,uint _experience,bytes32 _image);
    
    /**
     * @dev Details for employees in the sorting facility
     **/
    struct sorter_detail {
        
        address eth_address;
        string name;
        uint age;
        uint experience;
        bytes32 image;
    }
    
    /**
     * @dev Keep track of details about employees in sorting phase
     **/
    mapping ( address => sorter_detail) public sorters; 
    
    /**
     * @dev set record of the stone sorted
     **/
    function assetSorted(string memory _id,string memory _weight,string memory _gemology,string memory _color_grade) public returns (bool) {
        
        (string memory a,,,,,,) = m.mining_history(_id);
        
        require(keccak256(abi.encodePacked(_id)) != keccak256(abi.encodePacked("")));
        require(keccak256(abi.encodePacked(_weight)) != keccak256(abi.encodePacked("")));
        require(keccak256(abi.encodePacked(_gemology)) != keccak256(abi.encodePacked("")));
        require(keccak256(abi.encodePacked(_color_grade)) != keccak256(abi.encodePacked("")));
        require(msg.sender == sorters[msg.sender].eth_address || msg.sender == owner);
        require(keccak256(abi.encodePacked(a)) != keccak256(abi.encodePacked("")));
        
        data.sorting_status memory emerald;
        emerald.id = _id;
        emerald.weight = _weight;
        emerald.gemology = _gemology;
        emerald.color_grade = _color_grade;
        emerald.datetime = now;
        emerald.sorted_by = msg.sender;
        
        sorting_history[_id] = emerald;
        
        emit Sorted(emerald.id,emerald.weight,emerald.gemology,emerald.color_grade,emerald.datetime,emerald.sorted_by);
        return true;
    }
    
    /**
     * @dev set record of the employee in the sorting phase
     **/
    function addSorter(address _eth_address,string memory _name,uint _age,uint _experience,bytes32 _image) public onlyOwner {
        
        sorter_detail memory employee;
        
        employee.eth_address = _eth_address;
        employee.name = _name;
        employee.age = _age;
        employee.experience = _experience;
        employee.image = _image;
        
        sorters[_eth_address] = employee;
        
        emit SorterAdded(employee.eth_address,employee.name,employee.age,employee.experience,employee.image);
    }
}

contract cuter is Ownable {
    
    sorter s;
    
    /**
     * @dev The cuter constructor sets an instance of excisting sorter contract
     * @param _sorterContract The address of deployed contract
     **/
    constructor(address _sorterContract) public {
        
        s=sorter(_sorterContract);
    }
    
    /**
     * @dev Keep track of every details about stone in cuting phase
     **/
    mapping ( string => data.cuting_status ) public cutting_history;
    
    event Cut(string _id,string _weight,string _color_grade,string _cut,uint _datetime,address _cut_by,bytes32 _image,bytes32 _video);
    
    event CuterAdded(address _eth_address,string _name,uint _age,uint _experience,bytes32 _image);
    
    /**
     * @dev Details for employees in the cuting facility
     **/
    struct cuter_detail {
        
        address eth_address;
        string name;
        uint age;
        uint experience;
        bytes32 image;
    }
    
    /**
     * @dev Keep track of details about employees in cuting phase
     **/
    mapping ( address => cuter_detail) public cuters; 
    
    /**
     * @dev set record of the stone cut
     **/
    function assetCut(string memory _id,string memory _weight,string memory _color_grade,string memory _cut,bytes32 _image,bytes32 _video) public returns (bool) {
        
        (string memory a,,,,,)=s.sorting_history(_id);
        
        require(keccak256(abi.encodePacked(_id)) != keccak256(abi.encodePacked("")));
        require(keccak256(abi.encodePacked(_weight)) != keccak256(abi.encodePacked("")));
        require(keccak256(abi.encodePacked(_color_grade)) != keccak256(abi.encodePacked("")));
        require(keccak256(abi.encodePacked(_cut)) != keccak256(abi.encodePacked("")));
        require(keccak256(abi.encodePacked(_image)) != keccak256(abi.encodePacked("")));
        require(keccak256(abi.encodePacked(_video)) != keccak256(abi.encodePacked("")));
        require(msg.sender == cuters[msg.sender].eth_address || msg.sender == owner);
        require(keccak256(abi.encodePacked(a)) != keccak256(abi.encodePacked("")));
        
        data.cuting_status memory emerald;
        emerald.id = _id;
        emerald.weight = _weight;
        emerald.color_grade = _color_grade;
        emerald.cut = _cut;
        emerald.datetime = now;
        emerald.cut_by = msg.sender;
        emerald.image = _image;
        emerald.video = _video;
        
        cutting_history[_id] = emerald;
        
        emit Cut(emerald.id,emerald.weight,emerald.color_grade,emerald.cut,emerald.datetime,emerald.cut_by,emerald.image,emerald.video);
        return true;
    }
    
    /**
     * @dev set record of the employee in the cuting phase
     **/
    function addCuter(address _eth_address,string memory _name,uint _age,uint _experience,bytes32 _image) public onlyOwner {
        
        cuter_detail memory employee;
        
        employee.eth_address = _eth_address;
        employee.name = _name;
        employee.age = _age;
        employee.experience = _experience;
        employee.image = _image;
        
        cuters[_eth_address] = employee;
        
        emit CuterAdded(employee.eth_address,employee.name,employee.age,employee.experience,employee.image);
    }
}

contract polisher is Ownable {
    
    cuter c;
    
    /**
     * @dev The polisher constructor sets an instance of excisting cuter contract
     * @param _cuterContract The address of deployed contract
     **/
    constructor(address _cuterContract) public {
        
        c = cuter(_cuterContract);
    }
    
    /**
     * @dev Keep track of every details about stone in polishing phase
     **/
    mapping ( string => data.polishing_status ) public polishing_history;
    
    event Polished(string _id,string _weight,string _color_grade,string _cut,string _clarity,uint _datetime,address _cut_by,bytes32 _image,bytes32 _video);
    
    event PolisherAdded(address _eth_address,string _name,uint _age,uint _experience,bytes32 _image);
    
    /**
     * @dev Details for employees in the polishing facility
     **/
    struct polisher_detail {
        
        address eth_address;
        string name;
        uint age;
        uint experience;
        bytes32 image;
    }
    
    /**
     * @dev Keep track of details about employees in polishing phase
     **/
    mapping ( address => polisher_detail) public polishers;
    
    /**
     * @dev set record of the stone polished
     **/
    function assetPolished(string memory _id,string memory _weight,string memory _color_grade,string memory _cut,string memory _clarity,bytes32 _image,bytes32 _video) public returns (bool) {
        
        (string memory a,,,,,,,) = c.cutting_history(_id);
        
        require(keccak256(abi.encodePacked(_id)) != keccak256(abi.encodePacked("")));
        require(keccak256(abi.encodePacked(_weight)) != keccak256(abi.encodePacked("")));
        require(keccak256(abi.encodePacked(_color_grade)) != keccak256(abi.encodePacked("")));
        require(keccak256(abi.encodePacked(_cut)) != keccak256(abi.encodePacked("")));
        require(keccak256(abi.encodePacked(_clarity)) != keccak256(abi.encodePacked("")));
        require(msg.sender == polishers[msg.sender].eth_address || msg.sender == owner);
        require(keccak256(abi.encodePacked(a)) != keccak256(abi.encodePacked("")));
        
        data.polishing_status memory emerald;
        emerald.id = _id;
        emerald.weight = _weight;
        emerald.color_grade = _color_grade;
        emerald.cut = _cut;
        emerald.clarity = _clarity;
        emerald.datetime = now;
        emerald.polished_by = msg.sender;
        emerald.image = _image;
        emerald.video = _video;
        
        polishing_history[_id] = emerald;
        
        emit Polished(emerald.id,emerald.weight,emerald.color_grade,emerald.cut,emerald.color_grade,emerald.datetime,emerald.polished_by,emerald.image,emerald.video);
        return true;
    }
    
    /**
     * @dev set record of the employee in the polishing phase
     **/
    function addPolisher(address _eth_address,string memory _name,uint _age,uint _experience,bytes32 _image) public onlyOwner {
        
        polisher_detail memory employee;
        
        employee.eth_address = _eth_address;
        employee.name = _name;
        employee.age = _age;
        employee.experience = _experience;
        employee.image = _image;
        
        polishers[_eth_address] = employee;
        
        emit PolisherAdded(employee.eth_address,employee.name,employee.age,employee.experience,employee.image);
    }
}

contract certificate is Ownable {
    
    polisher p;
    
    /**
     * @dev The certificate constructor sets an instance of excisting polisher contract
     * @param _polisherContract The address of deployed contract
     **/
    constructor(address _polisherContract) public {
        
        p = polisher(_polisherContract);
    }
    
    /**
     * @dev Keep track of every details about certificate of the stone
     **/
    mapping ( string => data.certify ) public certificate_detail;
    
    event Certified(string _id,string _certificate_no,string _gemology,bytes32 _image);
    
    /**
     * @dev set record of the stone certificate
     **/
    function assetCertified(string memory _id,string memory _certificate_no,string memory _gemology,bytes32 _image) public returns (bool) {
        
        (string memory a,,,,,,,,) = p.polishing_history(_id);
        
        require(keccak256(abi.encodePacked(_id)) != keccak256(abi.encodePacked("")));
        require(keccak256(abi.encodePacked(_certificate_no)) != keccak256(abi.encodePacked("")));
        require(keccak256(abi.encodePacked(_gemology)) != keccak256(abi.encodePacked("")));
        require(keccak256(abi.encodePacked(_image)) != keccak256(abi.encodePacked("")));
        require(keccak256(abi.encodePacked(a)) != keccak256(abi.encodePacked("")));
        require(msg.sender == owner);
        
        data.certify memory emerald;
        emerald.id = _id;
        emerald.certificate_no = _certificate_no;
        emerald.gemology = _gemology;
        emerald.image = _image;
        
        certificate_detail[_id] = emerald;
        
        emit Certified(emerald.id,emerald.certificate_no,emerald.gemology,emerald.image);
        return true;
    }
    
}

contract supply is Ownable {
    
    certificate c;
    
    /**
     * @dev The supply constructor sets an instance of excisting certificate contract
     * @param _certificateContract The address of deployed contract
     **/
    constructor(address _certificateContract) public {
        
        c = certificate(_certificateContract);
    }
    
    mapping ( address => string[] ) public stone_owner;
    
    mapping ( string => address ) public inherited_owner;
    
    mapping ( address => data.store_details) public stores;
    
    mapping ( string => data.goldSmith_status) public to_gold_smith;
    
    event DirectClient(address _to,string _id);
    
    event Inherit(address _to,string _id);
    
    event ToStore(address _eth_address,string _name,string _id);
    
    event StoreAdded(address _eth_address,string _name,bytes32 _image);
    
    event ToGoldSmith(string _id);
    
    function directClient(address _to,string memory _id) public onlyOwner {
        
        (string memory a,,,) = c.certificate_detail(_id);
        
        require(keccak256(abi.encodePacked(a)) != keccak256(abi.encodePacked("")));
        stone_owner[_to].push(_id);
        
        emit DirectClient(_to,_id);
    }
    
    function inheritStone(address _to,string memory _id) public {
        
        uint no = stone_owner[msg.sender].length;
        
        for(uint i=0;i<no;i++) {
            
            if(keccak256(abi.encodePacked(stone_owner[msg.sender][i])) == keccak256(abi.encodePacked(_id))) {
                
                inherited_owner[_id] = _to;
                
                emit Inherit(_to,_id);
            }
            else {
                
                revert();
            }
        }
        
    }
    
    function addStore(address _to,string memory _name,bytes32 _image) public onlyOwner {
        
        data.store_details memory s;
        s.name = _name;
        s.image = _image;
        
        stores[_to] = s;
        
        emit StoreAdded(_to,s.name,s.image);
    }
    
    function toStores(address _to,string memory _id) public onlyOwner {
        
        (string memory a,,,) = c.certificate_detail(_id);
        
        require(keccak256(abi.encodePacked(a)) != keccak256(abi.encodePacked("")));

        stores[_to].stones.push(_id);
        
        emit ToStore(_to,stores[_to].name,_id);
    }
    
    function goldSmith(string memory _id,string memory _gold_carat,string memory _gold_gram,string memory _style,string memory _diamonds,string memory _gems,string memory _emerald) public onlyOwner {
        
        data.goldSmith_status memory emerald;
        emerald.id = _id;
        emerald.gold_carat = _gold_carat;
        emerald.gold_gram = _gold_gram;
        emerald.style = _style;
        emerald.diomands = _diamonds;
        emerald.gems = _gems;
        emerald.emerald = _emerald;
        
        to_gold_smith[_id] = emerald;
        
        emit ToGoldSmith(emerald.id);
    }
}