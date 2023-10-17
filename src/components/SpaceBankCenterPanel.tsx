import React from 'react';

export function SpaceBankCenterPanel({ depositAmount, onDeposit, onCreateAccount, onBorrow }) {
    return (
        <div className="spacebank-center-panel">
            <div className="deposit-display">
                <span className="label">DEPOSIT</span>
                <span className="value">{depositAmount}</span>
            </div>
            <div className="actions">
                <button className="create-account-btn" onClick={onCreateAccount}>CREATE ACCOUNT</button>
                <button className="deposit-btn" onClick={onDeposit}>DEPOSIT FUNDS</button>
                <button className="borrow-btn" onClick={onBorrow}>BORROW MAI</button>
            </div>
        </div>
    );
}