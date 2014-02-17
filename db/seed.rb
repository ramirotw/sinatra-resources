Resource.create(id: 1, name: 'Sala de reuniones', description: 'Sala de reuniones con máquinas y proyector')
Resource.create(id: 2, name: 'Monitor', description: 'Monitor de 24 pulgadas SAMSUNG')
Resource.create(id: 3, name: 'Computadora', description: 'Notebook con 4GB de RAM y 256 GB de espacio en disco con Linux')

Booking.create(id: 1,
               start_date: Time.new(2013, 12, 07, 13, 0, 0),
               end_date: Time.new(2013, 12, 07, 14, 0, 0), 
               status: 'approved', 
               user: 'test@gmail.com',
               resource_id: 1)
Booking.create(id: 2,
               start_date: Time.new(2013, 12, 8, 16, 0, 0),
               end_date: Time.new(2013, 12, 8, 17, 30, 0), 
               status: 'approved', 
               user: 'test@gmail.com',
               resource_id: 1)
Booking.create(id: 3,
               start_date: Time.new(2013, 12, 8, 18, 0, 0),
               end_date: Time.new(2013, 12, 7, 19, 0, 0), 
               status: 'approved', 
               user: 'test@gmail.com',
               resource_id: 2)