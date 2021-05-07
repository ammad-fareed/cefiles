Rake::Task["db:seed:countries"].invoke
Rake::Task["db:seed:product_categories"].invoke
Rake::Task["db:seed:industries"].invoke

# Users and companies
tfg = Company.approved.where(name: 'The Frontier Group').first_or_create!(email: 'admin@example.com', phone_number: '+61 8 9322 3055', industry_id: 10, address_attributes: { address_line_1: 'Level 3, 72 Kings Park Road', city: 'West Perth', state: 'WA',postal_code:'234234', country_id: Country.find_by_name('Australia').id })
pp = Company.approved.where(name: 'Product Presence').first_or_create!(email: 'admin@cefiles.com', phone_number: '12345678', industry_id: 10, address_attributes: { address_line_1: 'Level 3, 72 Kings Park Road', city: 'West Perth', state: 'WA',postal_code:'234234', country_id: Country.find_by_name('Australia').id })
pp.update_attribute(:admin, true) # Any users part of the Product Presence company are automatically admins

User.approved.first_or_create!([
                                   { given_name: 'Ross', family_name: 'Andrews', email: 'ross@cefiles.com', password: 'Password@123', password_confirmation: 'Password@123', company_id: pp.id, confirmed_at: Time.now, approved: true,accepted_privacy:true },
                                   { given_name: 'Matt', family_name: 'Lambie', email: 'mlambie@example.com', password: 'Password@123', password_confirmation: 'Password@123', company_id: tfg.id, confirmed_at: Time.now, approved: true,accepted_privacy:true },
                                   { given_name: 'Rebecca', family_name: 'Skinner', email: 'becky@example.com', password: 'Password@123', password_confirmation: 'Password@123', company_id: tfg.id, confirmed_at: Time.now, approved: true,accepted_privacy:true }
                               ])

# CE Categories
Rake::Task["db:seed:ce_categories"].invoke

# Directives
Directive.create!([
                      { code: 'Directive 2008/57/EC', url: 'http://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=CELEX:32008L0057:en:NOT', start_date: '2008/07/18', ce_category_id: 28 },
                      { code: 'Council Directive 90/385/EEC', url: 'http://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=CELEX:31990L0385:en:NOT', start_date: '1990/06/20', ce_category_id: 17 },
                      { code: 'Directive 2009/142/EC', url: 'http://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=CELEX:32009L0142:en:NOT', start_date: '2009/11/30', ce_category_id: 23 },
                      { code: 'Directive 94/9/EC', url: 'http://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=CELEX:31994L0009:en:NOT', start_date: '1994/03/24', ce_category_id: 13 },
                      { code: 'European Parliament and Council Directive 2000/9/EC', url: 'http://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=CELEX:32000L0009:en:NOT', start_date: '2000/05/03', ce_category_id: 22 },
                      { code: 'Regulation (EC) No 1907/2006', url: 'http://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=CELEX:32006R1907:EN:NOT', start_date: '2006/12/18', ce_category_id: 1 },
                      { code: 'Council Directive 89/106/EEC', url: 'http://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=CELEX:31989L0106:en:NOT', start_date: '1988/12/21', ce_category_id: 6 },
                      { code: 'Regulation (EU) No 305/2011', url: 'http://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=CELEX:32011R0305:en:NOT', start_date: '2011/03/09', ce_category_id: 6 },
                      { code: 'Regulation (EC) No 1223/2009', url: 'http://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=CELEX:32009R1223:en:NOT', start_date: '2009/11/30', ce_category_id: 7 },
                      { code: 'Directive 2009/125/EC', url: 'http://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=CELEX:32009L0125:en:NOT', start_date: '2009/10/21', ce_category_id: 11 },
                      { code: 'Directive 2010/30/EU', url: 'http://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=CELEX:32010L0030:en:NOT', start_date: '2010/05/19', ce_category_id: 11 },
                      { code: 'Directive 2004/108/EC', url: 'http://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=CELEX:32004L0108:en:NOT', start_date: '2004/12/31', ce_category_id: 12 },
                      { code: 'Council Directive 93/15/EEC', url: 'http://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=CELEX:31993L0015:en:NOT', start_date: '1993/04/05', ce_category_id: 2 },
                      { code: 'Directive 2001/95/EC', url: 'http://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=CELEX:32001L0095:en:NOT', start_date: '2001/12/03', ce_category_id: 8 },
                      { code: 'Directive 98/79/EC', url: 'http://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=CELEX:31998L0079:en:NOT', start_date: '1998/10/27', ce_category_id: 18 },
                      { code: 'Directive 95/16/EC', url: 'http://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=CELEX:31995L0016:en:NOT', start_date: '1995/06/20', ce_category_id: 24 },
                      { code: 'Directive 2006/95/EC', url: 'http://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=CELEX:32006L0095:en:NOT', start_date: '2006/12/12', ce_category_id: 14 },
                      { code: 'Directive 2006/42/EC', url: 'http://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=CELEX:32006L0042:en:NOT', start_date: '2006/05/17', ce_category_id: 25 },
                      { code: 'Directive 2004/22/EC', url: 'http://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=CELEX:32004L0022:en:NOT', start_date: '2004/03/31', ce_category_id: 20 },
                      { code: 'Council Directive 93/42/EEC', url: 'http://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=CELEX:31993L0042:en:NOT', start_date: '1993/06/14', ce_category_id: 19 },
                      { code: 'Regulation (EC) No 765/2008', url: 'http://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=CELEX:32008R0765:en:NOT', start_date: '2008/07/09', ce_category_id: 5 },
                      { code: 'Decision No 768/2008/EC', url: 'http://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=CELEX:32008D0768:en:NOT', start_date: '2008/07/09', ce_category_id: 5 },
                      { code: 'Regulation (EC) No 1221/2009', url: 'http://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=CELEX:32009R1221:en:NOT', start_date: '2009/11/25', ce_category_id: 5 },
                      { code: 'Directive 94/62/EC', url: 'http://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=CELEX:31994L0062:en:NOT', start_date: '1994/12/20', ce_category_id: 31 },
                      { code: 'Council Directive 89/686/EEC', url: 'http://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=CELEX:31989L0686:en:NOT', start_date: '1989/12/21', ce_category_id: 9 },
                      { code: 'Directive 97/67/EC', url: 'http://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=CELEX:31997L0067:en:NOT', start_date: '1997/12/15', ce_category_id: 30 },
                      { code: 'Directive 97/23/EC', url: 'http://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=CELEX:31997L0023:en:NOT', start_date: '1997/05/29', ce_category_id: 26 },
                      { code: 'Directive 2007/23/EC', url: 'http://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=CELEX:32007L0023:en:NOT', start_date: '2007/05/23', ce_category_id: 3 },
                      { code: 'Directive 94/25/EC', url: 'http://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=CELEX:31994L0025:en:NOT', start_date: '1994/06/16', ce_category_id: 27 },
                      { code: 'Directive 2011/65/EU', url: 'http://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=CELEX:32011L0065:en:NOT', start_date: '2011/06/08', ce_category_id: 16 },
                      { code: 'Directive of 9 March 1999', url: 'http://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=CELEX:31999L0005:en:NOT', start_date: '1999/03/09', ce_category_id: 15 },
                      { code: 'Directive 2009/105/EC', url: 'http://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=CELEX:32009L0105:en:NOT', start_date: '2009/09/16', ce_category_id: 29 },
                      { code: 'Directive 2009/48/EC', url: 'http://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=CELEX:32009L0048:en:NOT', start_date: '2009/06/18', ce_category_id: 10 },
                      { code: 'Directive 2009/23/EC', url: 'http://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=CELEX:32009L0023:en:NOT', start_date: '2009/04/23', ce_category_id: 21 },
                  ])
