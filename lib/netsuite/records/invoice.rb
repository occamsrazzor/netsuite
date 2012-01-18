module NetSuite
  module Records
    class Invoice
      include Support::Fields
      include Support::RecordRefs
      include Support::Records
      include Namespaces::TranSales

      fields :alt_handling_cost, :alt_shipping_cost, :balance, :bill_address,
        :billing_schedule, :contrib_pct, :created_date, :created_from, :currency_name, :custom_field_list,
        :deferred_revenue, :department, :discount_amount, :discount_date, :discount_item, :discount_rate,
        :due_date, :email, :end_date, :est_gross_profit, :est_gross_profit_percent, :exchange_rate,
        :exclude_commission, :exp_cost_disc_amount, :exp_cost_disc_print, :exp_cost_disc_rate, :exp_cost_disc_tax_1_amt,
        :exp_cost_disc_taxable, :exp_cost_discount, :exp_cost_list, :exp_cost_tax_code, :exp_cost_tax_rate_1,
        :exp_cost_tax_rate_2, :fax, :fob, :gift_cert_applied, :gift_cert_redemption_list, :handling_cost, :handling_tax_1_rate,
        :handling_tax_2_rate, :handling_tax_code, :is_taxable, :item_cost_disc_amount, :item_cost_disc_print,
        :item_cost_disc_rate, :item_cost_disc_tax_1_amt, :item_cost_disc_taxable, :item_cost_discount, :item_cost_list,
        :item_cost_tax_code, :item_cost_tax_rate_1, :item_cost_tax_rate_2, :item_list, :job, :last_modified_date,
        :lead_source, :linked_tracking_numbers, :location, :memo, :message, :message_sel, :on_credit_hold, :opportunity,
        :other_ref_name, :partner, :partners_list, :promo_code, :rev_rec_end_date,
        :rev_rec_on_rev_commitment, :rev_rec_schedule, :rev_rec_start_date, :revenue_status, :sales_effective_date,
        :sales_group, :sales_rep, :sales_team_list, :ship_address, :ship_date, :ship_group_list,
        :ship_method, :shipping_cost, :shipping_tax_1_rate, :shipping_tax_2_rate, :shipping_tax_code, :source, :start_date,
        :status, :subsidiary, :sync_partner_teams, :sync_sales_teams, :tax_2_total, :tax_item, :tax_rate,
        :tax_total, :terms, :time_disc_amount, :time_disc_print, :time_disc_rate, :time_disc_tax_1_amt, :time_disc_taxable,
        :time_discount, :time_list, :time_tax_code, :time_tax_rate_1, :time_tax_rate_2, :to_be_emailed, :to_be_faxed,
        :to_be_printed, :total_cost_estimate, :tracking_numbers, :tran_date, :tran_id, :tran_is_vsoe_bundle,
        :transaction_bill_address, :transaction_ship_address, :vat_reg_num, :vsoe_auto_calc

      read_only_fields :sub_total, :discount_total, :total, :recognized_revenue, :amount_remaining, :amount_paid

      record_refs :account, :bill_address_list, :custom_form, :entity, :klass, :posting_period, :ship_address_list

      attr_reader   :internal_id
      attr_accessor :external_id

      def initialize(attributes = {})
        @internal_id = attributes.delete(:internal_id) || attributes.delete(:@internal_id)
        @external_id = attributes.delete(:external_id) || attributes.delete(:@external_id)
        initialize_from_attributes_hash(attributes)
      end

      def transaction_bill_address=(attrs)
        attributes[:transaction_bill_address] = attrs.kind_of?(BillAddress) ? attrs : BillAddress.new(attrs)
      end

      def transaction_bill_address
        attributes[:transaction_bill_address] ||= BillAddress.new
      end

      def transaction_ship_address=(attrs)
        attributes[:transaction_ship_address] = attrs.kind_of?(ShipAddress) ? attrs : ShipAddress.new(attrs)
      end

      def transaction_ship_address
        attributes[:transaction_ship_address] ||= ShipAddress.new
      end

      def item_list
        attributes[:item_list] ||= InvoiceItemList.new
      end

      def item_list=(attrs)
        attributes[:item_list] = InvoiceItemList.new(attrs)
      end

      def custom_field_list
        attributes[:custom_field_list] ||= CustomFieldList.new
      end

      def custom_field_list=(attrs)
        attributes[:custom_field_list] = attrs.kind_of?(CustomFieldList) ? attrs : CustomFieldList.new(attrs)
      end

      def self.get(options = {})
        response = Actions::Get.call(self, options)
        if response.success?
          new(response.body)
        else
          raise RecordNotFound, "#{self} with OPTIONS=#{options.inspect} could not be found"
        end
      end

      def self.initialize(customer)
        response = Actions::Initialize.call(customer)
        if response.success?
          new(response.body)
        else
          raise InitializationError, "#{self}.initialize with #{customer} failed."
        end
      end

      def add
        response = Actions::Add.call(self)
        response.success?
      end

    end
  end
end
