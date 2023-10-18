import { useAccount, useEnsName } from 'wagmi'

export function Account() {
  const { address } = useAccount()
  const { data: ensName } = useEnsName({ address })

  return (
    <div style={{
      width: '300px',
      padding: '20px',
      backgroundColor: '#1a1a1a',
      border: '3px solid #4a4a4a',
      borderRadius: '15px',
      boxShadow: '0 5px 10px rgba(0, 0, 0, 0.5)',
      margin: '50px auto'
    }}>
      <div className="panel">
        <div style={{
          color: '#ffffff',
          fontSize: '24px',
          marginBottom: '20px',
          textAlign: 'center',
          borderBottom: '2px solid #4a4a4a',
          paddingBottom: '10px'
        }} className="cadet-name">{ensName ?? address}</div>
        {ensName ? ` (${address})` : null}
      </div>
    </div>
  )
}

