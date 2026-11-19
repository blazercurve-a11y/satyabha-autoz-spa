(() => {
 const form=document.getElementById('booking-form'), msg=document.getElementById('booking-message');
 const date=document.getElementById('appointment-date');
 const localToday=new Date(); date.min=new Date(localToday.getTime()-localToday.getTimezoneOffset()*60000).toISOString().slice(0,10);
 const ready=window.supabase && window.SATYABHA_SUPABASE_URL && !window.SATYABHA_SUPABASE_URL.startsWith('PASTE_') && window.SATYABHA_SUPABASE_ANON_KEY && !window.SATYABHA_SUPABASE_ANON_KEY.startsWith('PASTE_');
 form.addEventListener('submit',async e=>{e.preventDefault(); msg.className='form-message';
  if(form.elements.website.value) return;
  if(!ready){msg.textContent='Booking is not connected yet. The owner must finish the secure database setup first.';msg.classList.add('error');return;}
  const f=new FormData(form), payload={customer_name:String(f.get('customer_name')).trim(),mobile:String(f.get('mobile')).trim(),car_model:String(f.get('car_model')).trim(),service:String(f.get('service')),appointment_date:String(f.get('appointment_date')),preferred_time:String(f.get('preferred_time')),status:'Pending'};
  if(!/^[0-9 +()-]{10,16}$/.test(payload.mobile)){msg.textContent='Please enter a valid mobile number.';msg.classList.add('error');return;}
  if(payload.appointment_date<date.min){msg.textContent='Please choose today or a future date.';msg.classList.add('error');return;}
  const client=window.supabase.createClient(window.SATYABHA_SUPABASE_URL,window.SATYABHA_SUPABASE_ANON_KEY);
  const button=form.querySelector('button');button.disabled=true;button.textContent='Sending request…';
  const {error}=await client.from('bookings').insert(payload);button.disabled=false;button.textContent='Send booking request ↗';
  if(error){msg.textContent='We could not submit this request right now. Please call 9124382929.';msg.classList.add('error');return;}
  form.reset();msg.textContent='Request received. Our team will call you to confirm your appointment.';msg.classList.add('success');
 });
})();
