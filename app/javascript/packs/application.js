// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs";
import Turbolinks from "turbolinks";

document.addEventListener("DOMContentLoaded", () => {
  console.log("DOMContentLoaded");
  const form = document.querySelector("form");
  
  form.addEventListener("submit", async (event) => {
    event.preventDefault();
    // const cards = event.target.elements.namedItem('cards').value;
    const submitButton = form.querySelector('[type="submit"]');

    // ボタンを非活性化
    submitButton.disabled = true;

    const response = await fetch(form.action, {
      method: form.getAttribute('method'),
      headers: { "Content-Type": "application/x-www-form-urlencoded", "Accept": "application/json",},
      body: new URLSearchParams(new FormData(form)),
    });

    const resultDiv = document.querySelector("#result");
    
    const data = await response.json();
    if (response.ok) {
      resultDiv.textContent = data.hand;
    } else {
      const errorList = data.errors.map((error) => `${error}<br>`).join("");
      resultDiv.innerHTML = `<p>エラー</p>${errorList}`;
    }

    // // ボタンを活性化
    submitButton.disabled = false;
  });
});

Rails.start();
Turbolinks.start();
