import { Routes, Route } from 'react-router-dom'
import './App.css'
import mortgageRatesMeta from './data/mortgage-rates-meta.json'

const PROJECTS = [
  {
    id: 4,
    title: 'Mortgage Rate Dispersion',
    description: 'Interactive beeswarm chart showing the distribution of 30-year fixed mortgage rates by year.',
    href: '/projects/mortgage-rates',
    thumb: '/mortgage-rates-thumb.png',
  },
]

function Navbar() {
  return (
    <nav className="navbar">
      <div className="nav-inner">
        <a href="/" className="nav-brand">
          <img src="/logo.svg" alt="GV" className="nav-logo" />
        </a>
        <ul className="nav-links">
          <li><a href="/">Home</a></li>
          <li><a href="#projects">Projects</a></li>
        </ul>
      </div>
    </nav>
  )
}

function Hero() {
  return (
    <section className="hero">
      <div className="hero-inner">
        <div className="hero-content">
          <p className="hero-tagline">
            Hi, I'm Genaro — a housing economist by trade and a data storyteller
            by passion. Here you'll find projects spanning topics I find
            fascinating. I hope they inspire you to see data differently.
          </p>
        </div>
        <div className="hero-photo">
          <img src="/profile.jpg" alt="Genaro" />
        </div>
      </div>
    </section>
  )
}

function ProjectCard({ title, description, href, thumb, thumbBg }) {
  return (
    <div className="card">
      {thumb
        ? <img className="card-thumb" src={thumb} alt={title} />
        : <div className="card-thumb" style={{ backgroundColor: thumbBg }} />
      }
      <div className="card-body">
        <h3 className="card-title">{title}</h3>
        <p className="card-desc">{description}</p>
        <a href={href} className="card-link">View Project →</a>
      </div>
    </div>
  )
}

function Projects() {
  return (
    <section id="projects" className="projects">
      <div className="projects-inner">
        <h2 className="projects-heading">Projects</h2>
        <div className="projects-grid">
          {PROJECTS.map(p => (
            <ProjectCard key={p.id} {...p} />
          ))}
        </div>
      </div>
    </section>
  )
}

const MORTGAGE_RATES_TAGS = ['R', 'ggplot2', 'ggiraph', 'Beeswarm', 'Housing', 'Economics', 'Data Visualization']

function MortgageRatesPage() {
  return (
    <div className="project-page-bg">
      <Navbar />
      <main>
        <article className="project-detail">
          <div className="project-detail-inner">
            <p className="project-date">Updated: {mortgageRatesMeta.updated}</p>
            <h1 className="project-detail-title">Mortgage Rate Dispersion</h1>
            <p className="project-detail-body">
              My wife called me one afternoon to tell me our five-year-old had been stung by a bee —
              nothing serious, thankfully, but it inspired me to create this beeswarm chart.
            </p>
            <p className="project-detail-body">
              A beeswarm plot arranges individual data points so they don't overlap, letting you see
              the full distribution at a glance. In this chart, I used Freddie Mac's weekly Primary Mortgage
              Market Survey (PMMS) average rates for 30-year fixed-rate mortgages distributed by
              year. Some years like 2022 had a wide range of rates while other years like 2021 and
              2025 had a much narrower range of rates. I originally created this chart using ggplot2
              but then used ggiraph to make it interactive — hover over the points to see each
              week's average rate.
            </p>
          </div>
          <iframe
            src="/widgets/mortgage-rates-beeswarm.html"
            title="Mortgage Rate Dispersion"
            className="project-iframe"
            scrolling="no"
          />
          <div className="project-detail-inner">
            <div className="project-tags">
              {MORTGAGE_RATES_TAGS.map(tag => (
                <span key={tag} className="project-tag">{tag}</span>
              ))}
            </div>
          </div>
        </article>
      </main>
    </div>
  )
}

function App() {
  return (
    <Routes>
      <Route path="/" element={
        <>
          <Navbar />
          <main>
            <Hero />
            <Projects />
          </main>
        </>
      } />
      <Route path="/projects/mortgage-rates" element={<MortgageRatesPage />} />
    </Routes>
  )
}

export default App
