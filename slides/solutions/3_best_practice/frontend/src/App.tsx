import { useState } from 'react'
import reactLogo from './assets/react.svg'
import viteLogo from '/vite.svg'
import './App.css'

function App() {
  const [message, setMessage] = useState("")

  return (
    <>
      <div>
        <a href="https://vite.dev" target="_blank">
          <img src={viteLogo} className="logo" alt="Vite logo" />
        </a>
        <a href="https://react.dev" target="_blank">
          <img src={reactLogo} className="logo react" alt="React logo" />
        </a>
      </div>
      <h1>Docker IKT Level 2</h1>
      <div className="card">
        <button onClick={() => {
          fetch("http://localhost:3000/api")
          .then((response) => response.json())
          .then((data) => {
            setMessage(data.message)
          });
        }}>
          Get Message
        </button>
      </div>
      <div>{message}</div>
    </>
  )
}

export default App
