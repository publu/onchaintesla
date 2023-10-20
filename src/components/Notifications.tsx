import React, { useState, FunctionComponent } from 'react';
import Iframe from 'react-iframe'

interface PushChatProps {
  walletClient: any; // replace 'any' with the actual type of walletClient
}

export const PushChat: FunctionComponent<PushChatProps> = ({ walletClient }) => {
  const [showPanel, setShowPanel] = useState(false);

  return (
    <>
      <button className="notifications" onClick={() => setShowPanel(!showPanel)}>🔔</button>
      <div className="television blueish">
        <Iframe url="https://app.push.org/chat/0x85B8173C483c10CC8aefbB83437cF65Bf86E6A57"
          width="640px"
          height="640px"
          id=""
          className="middle"
          display={showPanel ? "block" : "none"}
          position="absolute"/>
        {showPanel && <div className="mask"></div>}
      </div>
    </>
  );
}
