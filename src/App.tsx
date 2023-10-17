import { ConnectButton } from "@rainbow-me/rainbowkit";
import styled, { keyframes } from 'styled-components';

import { useAccount, useEnsName } from 'wagmi'

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
import { SpaceBankCenterPanel } from './components/SpaceBankCenterPanel';
import { Notifications } from './components/Notifications';

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
  const { isConnected, address } = useAccount();
  const { data: ensName } = useEnsName({ address })

  const mockDepositAmount = 1000;
  const mockOnDeposit = () => console.log('Deposit button clicked');
  const mockOnCreateAccount = () => console.log('Create account button clicked');
  const mockOnBorrow = () => console.log('Borrow button clicked');

  return (
    <>
    <SpaceImage />
    <div className="spaceship">

      <div className="network-switcher">
        <ConnectButton />
        <Notifications />
      </div>
      <SpaceBankCenterPanel 
            depositAmount={mockDepositAmount} 
            onDeposit={mockOnDeposit} 
            onCreateAccount={mockOnCreateAccount} 
            onBorrow={mockOnBorrow} 
        />
      {isConnected && (
        <>
          <CadetNamePanel name={{address}} />
        </>
      )}
    </div>
    </>
  );
}
