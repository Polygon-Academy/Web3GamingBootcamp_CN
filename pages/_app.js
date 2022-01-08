import '../styles/globals.css'
import Link from 'next/link'

function Marketplace({ Component, pageProps }) {
  return (
    <div>
      <nav className="border-b p-6">
        <p className="text-4xl font-bold" style={{textAlign:'center'}}>Five Elemental Dragon</p>
        <div className="flex mt-4" style={{justifyContent:'center'}}>
          <Link href="/">
            <a className="mr-16 text-purple-500">
              My Dragon
            </a>
          </Link>
          <Link href="/hatch-dragon">
            <a className="mr-16 text-purple-500">
              Hatch Dragon
            </a>
          </Link>
          {/* <Link href="/my-assets">
            <a className="mr-16 text-purple-500">
              My Dragon
            </a>
          </Link> */}
          <Link href="/all-dragon">
            <a className="mr-16 text-purple-500">
              All Dragon
            </a>
          </Link>
          <Link href="/mall">
            <a className="mr-16 text-purple-500">
              Mall
            </a>
          </Link>
        </div>
      </nav>
      <Component {...pageProps} />
    </div>
  )
}

export default Marketplace