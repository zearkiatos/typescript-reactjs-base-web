import { createRoot } from 'react-dom/client'

const App = () => {
    return <p>Hello World!</p>
}

const container = document.createElement('div')
const root = createRoot(container)

root.render(<App/>)

document.body.appendChild(container)