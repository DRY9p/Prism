namespace :export do
  desc "Export data from MSSQL VPaymentInfo for given user and date"
  task payment_info: :environment do
    # === Параметры ===
    user_id   = ENV.fetch('USER_ID', '76').to_i
    date_from = Date.parse(ENV.fetch('DATE_FROM', '27-05-2026'))

    # === Прямое подключение к MSSQL ===
    client = TinyTds::Client.new(
      host:     ENV.fetch('MSSQL_HOST', ''),
      port:     ENV.fetch('MSSQL_PORT', '').to_i,
      database: ENV.fetch('MSSQL_DATABASE', ''),
      username: ENV.fetch('MSSQL_USER', ''),
      password: ENV.fetch('MSSQL_PASSWORD', ''),
      timeout: 30    
    )

    sql = <<-SQL
      SELECT
        v.ServiceItemId,
        v.MedicalRecordId,
        v.AppointmentId,
        v.PrescriptionId,
        v.TreatmentActionId,
        v.AppointmentExternalId,
        v.DateComplete,
        v.AppointmentItemCost,
        v.PaymentMethodId,
        v.IsPaid,
        v.PrescriptionOriginalPricePerOne,
        v.PrescriptionPricePerOne,
        v.TreatmentActionOriginalPricePerOne,
        v.TreatmentActionPricePerOne,
        v.BillId,
        v.BillItemId,
        v.BillStatus,
        v.BillPaidDate,
        v.BillItemName,
        v.BillItemOriginalPricePerOne,
        v.BillItemPricePerOne,
        v.Quantity,
        v.PaymentInstrumentId,
        v.MedicalRecordTreatmentProgramId,
        v.UserIdInitiator,
        v.ScheduleItemId,
        v.UserIdComplete,
        u.FirstName,
        u.LastName,
        u.MiddleName,
        v.BillItemOriginalPricePerOneMRTP,
        v.BillItemPricePerOneMRTP,
        v.DateCompleteMRTP
      FROM [dbo].[VPaymentInfo] v
      JOIN [dbo].[User] u ON v.UserIdComplete = u.UserId
      WHERE v.DateComplete >= ? AND v.UserIdComplete = ?
    SQL

    # Выполняем параметризированный запрос
    result = client.execute(sql, date_from, user_id)

    count = 0
    result.each do |row|
      PaymentExport.find_or_initialize_by(
        service_item_id:    row['ServiceItemId'],
        medical_record_id:  row['MedicalRecordId']
        # При необходимости добавьте другие поля в ключ уникальности
      ).update!(
        appointment_id:                     row['AppointmentId'],
        prescription_id:                    row['PrescriptionId'],
        treatment_action_id:                row['TreatmentActionId'],
        appointment_external_id:            row['AppointmentExternalId'],
        date_complete:                      row['DateComplete'],
        appointment_item_cost:              row['AppointmentItemCost'],
        payment_method_id:                  row['PaymentMethodId'],
        is_paid:                            row['IsPaid'],
        prescription_original_price_per_one: row['PrescriptionOriginalPricePerOne'],
        prescription_price_per_one:         row['PrescriptionPricePerOne'],
        treatment_action_original_price_per_one: row['TreatmentActionOriginalPricePerOne'],
        treatment_action_price_per_one:     row['TreatmentActionPricePerOne'],
        bill_id:                            row['BillId'],
        bill_item_id:                       row['BillItemId'],
        bill_status:                        row['BillStatus'],
        bill_paid_date:                     row['BillPaidDate'],
        bill_item_name:                     row['BillItemName'],
        bill_item_original_price_per_one:   row['BillItemOriginalPricePerOne'],
        bill_item_price_per_one:            row['BillItemPricePerOne'],
        quantity:                           row['Quantity'],
        payment_instrument_id:              row['PaymentInstrumentId'],
        medical_record_treatment_program_id: row['MedicalRecordTreatmentProgramId'],
        user_id_initiator:                  row['UserIdInitiator'],
        schedule_item_id:                   row['ScheduleItemId'],
        user_id_complete:                   row['UserIdComplete'],
        first_name:                         row['FirstName'],
        last_name:                          row['LastName'],
        middle_name:                        row['MiddleName'],
        bill_item_original_price_per_one_mrtp: row['BillItemOriginalPricePerOneMRTP'],
        bill_item_price_per_one_mrtp:       row['BillItemPricePerOneMRTP'],
        date_complete_mrtp:                 row['DateCompleteMRTP']
      )
      count += 1
    end

    client.close
    puts "Exported #{count} rows successfully."
  end
end