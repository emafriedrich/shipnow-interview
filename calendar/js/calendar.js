// Cargamos meses en un array, para tenerlos facilmente a mano

const months = new Array(12).fill(0).map((_, i) => {
  return new Date(`2018/${i + 1}/1`).toLocaleDateString(undefined, {month: 'long'})
});

// Obtenemos todos los dias de un mes/anio. Lo saque de https://stackoverflow.com/questions/25588473/how-to-get-list-of-days-in-a-month-with-moment-js

var getDaysArray = function(year, month) {
  var names = [ 'sun', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat' ];
  var date = new Date(year, month - 1, 1);
  var result = [];
  while (date.getMonth() == month - 1) {
    result.push(date.getDate() + "-" + names[date.getDay()]);
    date.setDate(date.getDate() + 1);
  }
  return result;
}

const weeks = ['first', 'second', 'third', 'fourth', 'fift', 'six'];

let actualMonth = new Date().getMonth();
let actualYear = new Date().getYear() + 1900;

document.querySelector('.actual-month').innerText = months[actualMonth];
document.querySelector('.actual-year').innerText = actualYear;

document.querySelector('.prev').addEventListener('click', function() {
  let actualMonthName = months[actualMonth - 1];
  //Si no hay mes anterior, significa que es un cambio de anio para atras
  if (!actualMonthName) {
    actualYear--;
    document.querySelector('.actual-year').innerText = actualYear;
    actualMonth = 12;
  }
  actualMonth--;
  cleanDates();
  fillMonth();
});

document.querySelector('.next').addEventListener('click', function() {
  let actualMonthName = months[actualMonth + 1];
  //Si no hay mes anterior, significa que es un cambio de anio para adelante
  if (!actualMonthName) {
    actualYear++;
    document.querySelector('.actual-year').innerText = actualYear;
    actualMonth = -1;
  }
  actualMonth++;
  cleanDates();
  fillMonth();
});

function fillMonth() {
  let actualMonthName = months[actualMonth];
  document.querySelector('.actual-month').innerText = actualMonthName;
  let daysArray = getDaysArray(actualYear, actualMonth + 1);
  let week = 0;
  for (dayArray of daysArray) {
    let firstWeekDay = dayArray.split('-')[1];
    day = dayArray.split('-')[0];
    if (new Date().toDateString() === new Date(`${actualYear}-${actualMonth + 1}-${day}`).toDateString()) {
      // Dia de hoy
      day = `<u><strong>${day}</strong></u>`;
      document.querySelector(`.${weeks[week]}-week .${firstWeekDay}-day`).insertAdjacentHTML('beforeend', day);
    } else {
      document.querySelector(`.${weeks[week]}-week .${firstWeekDay}-day`).innerText = day;
    }
    if (firstWeekDay === 'sun') {
      week++;
    }
  }
  showHolidays();
}

//Siendo sinceros, es mi primera vez con fetch. Esta muy bueno
function showHolidays() {
  document.querySelector('.holidays').innerText = 'Cargando feriados...';
  fetch('http://nolaborables.com.ar/api/v2/feriados/' + actualYear, {method: 'get'}) 
  .then(function(data) {
      data.json().then((holidays) => {
        let monthHolidays = [];
        for (holiday of holidays) {
          if (holiday.mes === actualMonth + 1) {
            monthHolidays.push(`${holiday.dia}: ${holiday.motivo}`)
          }
        }
        if (monthHolidays.length === 0) {
          document.querySelector('.holidays').innerText = 'No hay feriados :(';
        } else {
          document.querySelector('.holidays').innerText = monthHolidays.join('\n');
        }
        clearInterval(interval);
      });
  })
  .catch(function() {
      document.querySelector('.holidays').innerText = 'Error cargando feriados';
  });
}

fillMonth();

function cleanDates() {
  let dates = document.querySelectorAll('.calendar li');
  for (li of dates) {
    li.innerText = '';
  }
}