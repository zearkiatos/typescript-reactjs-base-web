import { createRoot } from 'react-dom/client';
import "./index.css";

const App = () => {
    return <h1>Hello World!</h1>
}

const container = document.createElement('div')
const root = createRoot(container)

root.render(<App/>)

document.body.appendChild(container)