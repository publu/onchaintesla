import React, { useState } from 'react';

export function XmtpChat() {
  const [showPanel, setShowPanel] = useState(false);

  const openPopup = () => {
    window.open("https://xmtp-inbox-web-with-privy-git-dev-theqidaoteam.vercel.app/", "popupWindow", "width=640,height=640");
    setShowPanel(false);
  }

  return (
    <>
      <button className="notifications2" onClick={openPopup}>💬</button>
      {showPanel && <div className="mask"></div>}
    </>
  );
}
