import { ConnectButton } from "@rainbow-me/rainbowkit";
import styled, { keyframes } from 'styled-components';

import { useAccount } from "wagmi";

import { Account } from "./components/Account";
import { Balance } from "./components/Balance";
import { BlockNumber } from "./components/BlockNumber";
import { NetworkSwitcher } from "./components/NetworkSwitcher";
import { ReadContract } from "./components/ReadContract";
import { ReadContracts } from "./components/ReadContracts";
import { ReadContractsInfinite } from "./components/ReadContractsInfinite";
import { SendTransaction } from "./components/SendTransaction";
import { SendTransactionPrepared } from "./components/SendTransactionPrepared";
import { SignMessage } from "./components/SignMessage";
import { SignTypedData } from "./components/SignTypedData";
import { Token } from "./components/Token";
import { WatchContractEvents } from "./components/WatchContractEvents";
import { WatchPendingTransactions } from "./components/WatchPendingTransactions";
import { WriteContract } from "./components/WriteContract";
import { WriteContractPrepared } from "./components/WriteContractPrepared";
import { CadetNamePanel } from "./components/CadetNamePanel";

import backgroundImage from './assets/middle_ground.png'; // Import your image
import spaceImage from './assets/space.png';

const updown = keyframes`
  0% { transform: translateY(0); }
  50% { transform: translateY(-500px); }
  100% { transform: translateY(0); }
`;

const SpaceImage = styled.div`
  background-image: url(${spaceImage});
  background-size: cover;
  background-position: center; // Add this line
  height: 100vh;
  width: 100%;
  position: absolute;
  animation: ${updown} 25s infinite alternate;
  z-index: -1;
`;

export function App() {
  const { isConnected } = useAccount();

  return (
    <>
    <SpaceImage />
    <div className="spaceship">
      <h1 className="text-xl font-bold">Starter</h1>

      <ConnectButton />

      {isConnected && (
        <>
          <NetworkSwitcher />
          <br />
          <h2>Account</h2>
          <Account />
          <br />
          <h2>Balance</h2>
        </>
      )}
      <CadetNamePanel />
    </div>
    </>
  );
}
