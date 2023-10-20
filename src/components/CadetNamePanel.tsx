import React, { useEffect, useState } from 'react';

import {fetchUniversalProfile} from 'web3card/src/apiFunctions.js';

export function CadetNamePanel({ name }: { name: { address: string } }) {
  const [profile, setProfile] = useState<{ avatar: string, identity: string, platform: string } | null>(null);
  const [showPanel, setShowPanel] = useState(false);

  useEffect(() => {
    const fetchProfile = async () => {
      const profileData = await fetchUniversalProfile(name.address);
      console.log(profileData)
      setProfile(profileData[0]);
    };
    fetchProfile();
  }, [name]);
  
  return (
    <>
      <button className="cadet" onClick={() => setShowPanel(!showPanel)}>🧑‍🚀</button>
      {showPanel && profile && (
        <div className="panel panel-bottom-left">
          <div className="cadet-name">WELCOME CADET</div>
          {profile.avatar && (
            <div className="row">
              <span className="label">Avatar</span>
              <img src={profile.avatar} alt="Avatar" style={{objectFit: 'cover', borderRadius: '50%', maxWidth: '25px'}} />
            </div>
          )}
          <div className="row">
            <span className="label">Identifier</span>
            <span className="value">{profile.identity}</span>
          </div>
          <div className="row">
            <span className="label">Platform</span>
            <span className="value">{profile.platform}</span>
          </div>
          <div className="row">
            <span className="label">Powered By</span>
            <span className="value">RelationService</span>
          </div>
        </div>
      )}
    </>
  );
};

