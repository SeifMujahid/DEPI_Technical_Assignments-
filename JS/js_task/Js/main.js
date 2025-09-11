const url = "https://api.adviceslip.com/advice";
const main_box = document.getElementById("main-box");

async function getAdvice() {
  const response = await fetch(url);
  const data = await response.json();
  main_box.innerHTML = `
        <span class="advive-id">ADVICE # ${data.slip.id}</span>
        <p class="advice my-3">
          ${data.slip.advice}
        </p>
        <div class="image my-0">
          <img
            src="./images/pattern-divider-desktop.svg"
            alt="divider"
            class="w-100"
          />
        </div>
        <div
          class="random rounded-circle d-flex justify-content-center align-items-center my-0"
        >
          <div class="image-btn" id="random">
            <img src="./images/icon-dice.svg" alt="dice" class="w-100" />
          </div>
        </div>
  `;
  const btn = document.getElementById("random");
  btn.addEventListener("click", getAdvice);
}

window.onload = getAdvice;
