pragma solidity ^0.6.12;

contract NotTwitter {
  event NewTweet(address indexed user, string content, string ipfsHash, uint256 timestamp);

  struct Tweet {
    address user;
    string content;
    string ipfsHash;
    uint256 timestamp;
  }

  mapping(uint256 => Tweet) public tweets;
  uint256 public tweetIndex;

  function tweet(string calldata _content, string calldata _ipfsHash) external {
    require(_content.length > 0);
    Tweet memory _tweet = Tweet(msg.sender, _content, _ipfsHash, block.timestamp);
    tweets[tweetIndex] = _tweet;
    tweetIndex++;

    emit NewTweet(msg.sender, _content, _ipfsHash, block.timestamp);
  }
}