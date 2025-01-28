# Using OBIS API in Svelte

With the OBIS API [(api.obis.org/)](https://api.obis.org/) you can get any data into your application. Maybe most relevant are the **"Statistics"** calls.

Here is the code for an example of a Svelte application. To execute it, go to [svelte.dev/playground/hello-world](https://svelte.dev/playground/hello-world), remove the existing code and paste the code below. Then try with one species (e.g. _Leptuca thayeri_)

``` svelte
<script>
  import { writable } from 'svelte/store';

  // Store for user input
  let scientificName = '';

  // Stores for API response data
  const records = writable(null);
  const species = writable(null);
  const taxa = writable(null);
  const datasets = writable(null);
  const specieslevel = writable(null);
  const yearrange = writable([]);

  // Function to fetch data from the OBIS API
  async function fetchData() {
    if (scientificName.trim() === '') {
      alert('Please enter a valid scientific name.');
      return;
    }

    try {
      const response = await fetch(`https://api.obis.org/v3/statistics?scientificname=${encodeURIComponent(scientificName)}`);
      if (!response.ok) {
        throw new Error(`HTTP error! Status: ${response.status}`);
      }
      const data = await response.json();
      records.set(data.records);
      species.set(data.species);
      taxa.set(data.taxa);
      datasets.set(data.datasets);
      specieslevel.set(data.specieslevel);
      yearrange.set(data.yearrange);
    } catch (error) {
      console.error('Error fetching data:', error);
      alert('Failed to fetch data. Please try again later.');
    }
  }

  // Function to clear previous results
  function clearResults() {
    records.set(null);
    species.set(null);
    taxa.set(null);
    datasets.set(null);
    specieslevel.set(null);
    yearrange.set([]);
  }
</script>

<style>
  /* Add your styles here */
  .container {
    max-width: 600px;
    margin: 0 auto;
    text-align: center;
  }
  input {
    width: 80%;
    padding: 10px;
    margin-bottom: 10px;
  }
  button {
    padding: 10px 20px;
  }
  .result {
    margin-top: 20px;
    text-align: left;
  }
</style>

<div class="container">
  <h1>OBIS Species Statistics Fetcher</h1>
  <input
    type="text"
    bind:value={scientificName}
    placeholder="Enter scientific name"
    on:input={clearResults}
    on:keydown={(e) => e.key === 'Enter' && fetchData()}
  />
  <button on:click={fetchData}>Fetch Data</button>

  {#if $records !== null}
    <div class="result">
      <h2>Results for: {scientificName}</h2>
      <p><strong>Records:</strong> {$records}</p>
      <p><strong>Species:</strong> {$species}</p>
      <p><strong>Taxa:</strong> {$taxa}</p>
      <p><strong>Datasets:</strong> {$datasets}</p>
      <p><strong>Species-level Records:</strong> {$specieslevel}</p>
      <p><strong>Year Range:</strong> {$yearrange[0]} - {$yearrange[1]}</p>
    </div>
  {/if}
</div>

```