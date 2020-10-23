pragma solidity ^0.6.12;

contract NotTwitter {
  event NewTweet(address indexed user, string content, string ipfsHash, uint256 timestamp);
  event NewMessage(address indexed sender, address indexed recipient, string content, string ipfsHash, uint256 timestamp);

  struct Tweet {
    address user;
    string content;
    string ipfsHash;
    uint256 timestamp;
  }

  // struct for private message between two users
  struct Message {
    address from;
    address to;
    string content;
    string ipfsHash;
    uint256 timestamp;
  }

  mapping(uint256 => Tweet) public tweets;
  mapping(address => uint[]) private tweetsOf;
  uint256 public tweetIndex;

  mapping(address => address[]) public followings;


  //mapping for private conversations
  mapping(uint => Message[]) private conversations;
  uint256 public messageIndex;

  function tweet(string calldata _content, string calldata _ipfsHash) external {
    require(_content.length > 0);
    Tweet memory _tweet = Tweet(msg.sender, _content, _ipfsHash, block.timestamp);
    tweets[tweetIndex] = _tweet;
    tweetIndex++;
    tweetsOf[msg.sender].push(tweetIndex);

    emit NewTweet(msg.sender, _content, _ipfsHash, block.timestamp);
  }

  function sendMessage(address _to, string calldata _content, string calldata _ipfsHash) {
    require(_content.length > 0);
    conversations[messageIndex].push(Message(msg.sender, _to, _content, _ipfsHash, block.timestamp));
    messageIndex++;

    emit NewMessage(msg.sender, _to, _content, _ipfsHash, block.timestamp);
  }

  // commands for followings
  function follow(address _followed) external {
    followings[msg.sender].push(_followed);
  }

  //retrival

  function getLatestTweet(uint count) view external returns(Tweet[] memory) {
    require(count > 0, "must have at least 1 tweet to return");
    Tweet[] memory _tweets = new Tweet[](count);
    uint a;

    for(uint i = tweetIndex - count; i < tweetIndex; i++) {
      Tweet storage _tweet = tweets[i];
      _tweets[a] = Tweet(
        _tweet.user,
        _tweet.content,
        _tweet.ipfsHash,
        _tweet.timestamp
      )
      a++
    }
    return _tweets;
  }

  function getTweetsOf(address _user, uint count) view exteranl returns(Tweet[] memory) {
    uint[] storage tweetIds = tweetsOf[_user];
    require(count > 0 && count <= tweetIds.length, "Too few or too many tweets to return");
    Tweet[] memory _tweets = new Tweet[](count);
    uint a;

    for(uint i = tweetIds.length - count; i < tweetIds.length; i++) {
      Tweet storage _tweet = tweets[i];
      _tweet[a] = Tweet(
        _tweet.user,
        _tweet.content,
        _tweet.ipfsHash,
        _tweet.timestamp
      )
      a++
    }
    return _tweets;
  }

}