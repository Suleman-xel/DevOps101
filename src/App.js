import logo from './logo.svg';
import './App.css';

function App() {
  return (
    <div className="app">
      <header className="app-header">
        <img src={logo} className="app-logo" alt="logo" />
        <p>
          We Gonna Deploy this app for sure!
           
        </p>
        <a
          className="app-link"
          href="https://reactjs.org"
          target="_blank"
          rel="noopener noreferrer"
        >
          CI/CD Pipelines -- Teraform -- Ansible -- Jenkins 
        </a>
      </header>
    </div>
  );
}

export default App;
