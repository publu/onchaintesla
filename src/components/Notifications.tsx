import React, { useState } from 'react';

export function Notifications() {
  const [showPanel, setShowPanel] = useState(false);

  return (
    <>
      <button className="notifications" onClick={() => setShowPanel(!showPanel)}>🔔</button>
      {showPanel && (
        <div className="panel">
          {/* Insert your notification content here */}
        </div>
      )}
    </>
  );
}
